-- tests/busted/unit/dispatch_spec.lua
-- Busted unit specs for ai.harness tool dispatch (Tiger Style).
-- 8 validation + 12 adversarial. Deterministic, no network.
-- Run from repo root: busted --run=unit tests/busted/unit/dispatch_spec.lua

local events = require('ai.harness.events')
local harness = require('ai.harness')
local policy = require('ai.harness.policy')
local registry = require('ai.harness.registry')
local supervisor = require('ai.harness.supervisor')

local function fake_tool(calls, extra)
    local def = {
        description = 'fake tool',
        input_schema = {
            path = { required = true, type = 'string' },
            timeout_ms = { required = false, type = 'integer' },
        },
        run = function(args)
            calls[#calls + 1] = args
            return { echoed_path = args.path, echoed_timeout_ms = args.timeout_ms }
        end,
    }
    if extra then
        for k, v in pairs(extra) do
            def[k] = v
        end
    end
    return def
end

local function new_sup(policy_config)
    local sink = events.new_sink()
    local reg = registry.new()
    local pol = nil
    if policy_config ~= nil then
        pol = assert(policy.new(policy_config))
    end
    local sup, err = supervisor.new({ policy = pol, registry = reg, sink = sink })
    assert(sup ~= nil, err)
    return sup, reg
end

local function allow_all()
    return { rules = { { decision = 'allow', risk = 'process' } } }
end

describe('ai.harness.supervisor tool dispatch validation', function()
    it('runs a registered tool end-to-end under an allow rule', function()
        local calls = {}
        local sup, reg = new_sup(allow_all())
        assert.is_true(registry.register_tool(reg, 'fake_tool', fake_tool(calls)))
        local result, err = supervisor.dispatch_tool(sup, 'fake_tool', { path = '/tmp/x', timeout_ms = 5000 })
        assert.is_nil(err)
        assert.are.equal('/tmp/x', result.echoed_path)
        assert.are.equal(5000, result.echoed_timeout_ms)
        assert.are.equal(1, #calls)
    end)

    it('passes args through and honors an omitted optional arg', function()
        local calls = {}
        local sup, reg = new_sup(allow_all())
        assert.is_true(registry.register_tool(reg, 'fake_tool', fake_tool(calls)))
        local result, err = supervisor.dispatch_tool(sup, 'fake_tool', { path = '/tmp/y' })
        assert.is_nil(err)
        assert.are.equal('/tmp/y', result.echoed_path)
        assert.is_nil(result.echoed_timeout_ms)
        assert.are.equal(1, #calls)
    end)

    it('lists tools in sorted order', function()
        local sup, reg = new_sup(allow_all())
        assert.is_true(registry.register_tool(reg, 'zeta_tool', fake_tool({})))
        assert.is_true(registry.register_tool(reg, 'alpha_tool', fake_tool({})))
        assert.are.same({ 'alpha_tool', 'zeta_tool' }, supervisor.list_tools(sup))
    end)

    it('dispatches under a default-allow policy with no rules', function()
        local calls = {}
        local sup, reg = new_sup({ default = 'allow' })
        assert.is_true(registry.register_tool(reg, 'fake_tool', fake_tool(calls)))
        local result, err = supervisor.dispatch_tool(sup, 'fake_tool', { path = '/tmp/z' })
        assert.is_nil(err)
        assert.are.equal('/tmp/z', result.echoed_path)
        assert.are.equal(1, #calls)
    end)

    it('passes a tool (nil, err) result through unchanged', function()
        local sup, reg = new_sup(allow_all())
        local def = fake_tool({}, {
            run = function()
                return nil, 'tool-level failure'
            end,
        })
        assert.is_true(registry.register_tool(reg, 'failing_tool', def))
        local result, err = supervisor.dispatch_tool(sup, 'failing_tool', { path = '/tmp/x' })
        assert.is_nil(result)
        assert.are.equal('tool-level failure', err)
    end)

    it('dispatches with no args table when every field is optional', function()
        local calls = {}
        local sup, reg = new_sup(allow_all())
        local def = fake_tool(calls, {
            input_schema = { verbose = { required = false, type = 'boolean' } },
            run = function(args)
                calls[#calls + 1] = args
                return { argc = 0 }
            end,
        })
        assert.is_true(registry.register_tool(reg, 'noargs_tool', def))
        local result, err = supervisor.dispatch_tool(sup, 'noargs_tool')
        assert.is_nil(err)
        assert.are.equal(0, result.argc)
        assert.are.equal(1, #calls)
    end)

    it('harness API registers and lists through the shared state', function()
        assert.is_true(harness.setup())
        assert.is_true(harness.register_tool('api_fake', fake_tool({})))
        local found = false
        for _, name in ipairs(harness.list_tools()) do
            if name == 'api_fake' then
                found = true
            end
        end
        assert.is_true(found)
    end)

    it('dispatches a builtin tool registered through the builtin mechanism', function()
        local calls = {}
        local sup, reg = new_sup(allow_all())
        package.loaded['ai.harness.tools.stub_echo'] = fake_tool(calls)
        local ok, err = registry.register_builtin_tools(reg, { 'stub_echo' })
        package.loaded['ai.harness.tools.stub_echo'] = nil
        assert.is_true(ok, err)
        local result, derr = supervisor.dispatch_tool(sup, 'stub_echo', { path = '/tmp/builtin' })
        assert.is_nil(derr)
        assert.are.equal('/tmp/builtin', result.echoed_path)
        assert.are.equal(1, #calls)
    end)
end)

describe('ai.harness.supervisor tool dispatch adversarial', function()
    it('denies when no policy is configured and never invokes the tool', function()
        local calls = {}
        local sup, reg = new_sup()
        assert.is_true(registry.register_tool(reg, 'fake_tool', fake_tool(calls)))
        local result, err = supervisor.dispatch_tool(sup, 'fake_tool', { path = '/tmp/x' })
        assert.is_nil(result)
        assert.is_truthy(err:find('denied by policy'))
        assert.are.equal(0, #calls)
    end)

    it('denies under an explicit deny rule and never invokes the tool', function()
        local calls = {}
        local sup, reg = new_sup({ rules = { { decision = 'deny', risk = 'process' } } })
        assert.is_true(registry.register_tool(reg, 'fake_tool', fake_tool(calls)))
        local result, err = supervisor.dispatch_tool(sup, 'fake_tool', { path = '/tmp/x' })
        assert.is_nil(result)
        assert.is_truthy(err:find('denied by policy'))
        assert.are.equal(0, #calls)
    end)

    it('treats an approval decision as not-invoked with a structured error', function()
        local calls = {}
        local sup, reg = new_sup({ rules = { { decision = 'approval', risk = 'process' } } })
        assert.is_true(registry.register_tool(reg, 'fake_tool', fake_tool(calls)))
        local result, err = supervisor.dispatch_tool(sup, 'fake_tool', { path = '/tmp/x' })
        assert.is_nil(result)
        assert.is_truthy(err:find('requires approval'))
        assert.are.equal(0, #calls)
    end)

    it('rejects an unknown tool name', function()
        local sup = new_sup(allow_all())
        local result, err = supervisor.dispatch_tool(sup, 'nope', {})
        assert.is_nil(result)
        assert.is_truthy(err:find('unknown tool'))
    end)

    it('rejects a missing required argument and never invokes the tool', function()
        local calls = {}
        local sup, reg = new_sup(allow_all())
        assert.is_true(registry.register_tool(reg, 'fake_tool', fake_tool(calls)))
        local result, err = supervisor.dispatch_tool(sup, 'fake_tool', { timeout_ms = 5 })
        assert.is_nil(result)
        assert.is_truthy(err:find('missing required argument: path'))
        assert.are.equal(0, #calls)
    end)

    it('rejects wrongly typed arguments and never invokes the tool', function()
        local sup, reg = new_sup(allow_all())
        assert.is_true(registry.register_tool(reg, 'fake_tool', fake_tool({})))
        local bad_args = {
            { path = 42 },
            { path = '/tmp/x', timeout_ms = 'soon' },
            { path = '/tmp/x', timeout_ms = 1.5 },
        }
        for _, args in ipairs(bad_args) do
            local calls = {}
            local def = registry.get_tool(reg, 'fake_tool')
            def.run = function(a)
                calls[#calls + 1] = a
                return {}
            end
            local result, err = supervisor.dispatch_tool(sup, 'fake_tool', args)
            assert.is_nil(result)
            assert.is_truthy(err:find('must be a'))
            assert.are.equal(0, #calls)
        end
    end)

    it('rejects unknown extra arguments and never invokes the tool', function()
        local calls = {}
        local sup, reg = new_sup(allow_all())
        assert.is_true(registry.register_tool(reg, 'fake_tool', fake_tool(calls)))
        local result, err = supervisor.dispatch_tool(sup, 'fake_tool', { path = '/tmp/x', timout_ms = 5 })
        assert.is_nil(result)
        assert.is_truthy(err:find('unknown argument: timout_ms'))
        assert.are.equal(0, #calls)
    end)

    it('converts a throwing tool run into a structured error', function()
        local sup, reg = new_sup(allow_all())
        local def = fake_tool({}, {
            run = function()
                error('boom')
            end,
        })
        assert.is_true(registry.register_tool(reg, 'throwing_tool', def))
        local result, err = supervisor.dispatch_tool(sup, 'throwing_tool', { path = '/tmp/x' })
        assert.is_nil(result)
        assert.is_truthy(err:find('tool run failed'))
        assert.is_truthy(err:find('boom'))
    end)

    it('fails closed on a malformed input_schema entry', function()
        local calls = {}
        local sup, reg = new_sup(allow_all())
        local def = fake_tool(calls, { input_schema = { path = 'string' } })
        assert.is_true(registry.register_tool(reg, 'malformed_tool', def))
        local result, err = supervisor.dispatch_tool(sup, 'malformed_tool', { path = '/tmp/x' })
        assert.is_nil(result)
        assert.is_truthy(err:find('malformed input_schema'))
        assert.are.equal(0, #calls)
    end)

    it('harness API before setup returns the not-set-up error', function()
        local saved = harness._state
        harness._state = nil
        local ok_reg, err_reg = harness.register_tool('too_early', fake_tool({}))
        local names, err_list = harness.list_tools()
        local result, err_disp = harness.dispatch_tool('too_early', {})
        harness._state = saved
        assert.is_nil(ok_reg)
        assert.is_truthy(err_reg:find('harness not set up'))
        assert.is_nil(names)
        assert.is_truthy(err_list:find('harness not set up'))
        assert.is_nil(result)
        assert.is_truthy(err_disp:find('harness not set up'))
    end)

    it('harness API dispatch under the default policy denies and never invokes', function()
        local calls = {}
        assert.is_true(harness.setup())
        assert.is_true(harness.register_tool('api_fake2', fake_tool(calls)))
        local result, err = harness.dispatch_tool('api_fake2', { path = '/tmp/x' })
        assert.is_nil(result)
        assert.is_truthy(err:find('denied by policy'))
        assert.are.equal(0, #calls)
    end)

    it('never invokes a builtin tool denied by policy', function()
        local calls = {}
        local sup, reg = new_sup({ rules = { { decision = 'deny', risk = 'process' } } })
        package.loaded['ai.harness.tools.stub_echo'] = fake_tool(calls)
        local ok, err = registry.register_builtin_tools(reg, { 'stub_echo' })
        package.loaded['ai.harness.tools.stub_echo'] = nil
        assert.is_true(ok, err)
        local result, derr = supervisor.dispatch_tool(sup, 'stub_echo', { path = '/tmp/x' })
        assert.is_nil(result)
        assert.is_truthy(derr:find('denied by policy'))
        assert.are.equal(0, #calls)
    end)
end)
