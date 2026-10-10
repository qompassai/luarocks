-- #################################################################
-- /qompassai/diver/tests/security/guard.lua
-- Qompass AI Diver sensitive-file guard tests
-- Copyright (C) 2026 Qompass AI, All rights reserved
-- SPDX-License-Identifier: Apache-2.0
-- #################################################################
-- Run from the config root:
--   nvim --headless -u NONE -i NONE -l tests/security/guard.lua
--
-- Covers security.guard: pattern matching (is_sensitive), the BufReadPre
-- wipe behavior, and the GuardToggle command. Half validation,
-- half adversarial.
local api, fn = vim.api, vim.fn
local bundle = fn.getcwd()
vim.opt.runtimepath:prepend(bundle)

local failures = 0
local count = 0
local function check(value, label)
    count = count + 1
    if value then
        print('PASS: ' .. label)
    else
        print('FAIL: ' .. label)
        failures = failures + 1
    end
end

local notices = {}
vim.notify = function(msg, _)
    notices[#notices + 1] = msg
end

local ok, guard = pcall(require, 'security.guard')
check(ok and guard ~= nil, 'require(security.guard) loads')
if not ok then
    print(('guard: %d checks, %d failures'):format(count, failures))
    os.exit(1)
end

guard.setup()

-- Validation: known-sensitive paths are caught.
local home = fn.expand('~')
check(guard.is_sensitive(home .. '/.ssh/id_ed25519'), 'catches ~/.ssh/id_ed25519')
check(guard.is_sensitive(home .. '/.ssh/config'), 'catches ~/.ssh/config')
check(guard.is_sensitive(home .. '/.aws/credentials'), 'catches ~/.aws/credentials')
check(guard.is_sensitive(home .. '/.gnupg/secring.gpg'), 'catches ~/.gnupg files')
check(guard.is_sensitive('/tmp/deploy/server.pem'), 'catches *.pem')
check(guard.is_sensitive('/tmp/deploy/server.key'), 'catches *.key')
check(guard.is_sensitive('/tmp/app/.env'), 'catches .env')
check(guard.is_sensitive('/tmp/app/.env.production'), 'catches .env.*')
check(guard.is_sensitive('/tmp/x/my-secret-notes.txt'), 'catches *secret*')
check(guard.is_sensitive('/tmp/x/api-token.txt'), 'catches *token*')

-- Adversarial: ordinary files are NOT flagged.
check(not guard.is_sensitive('/tmp/notes.txt'), 'plain file not flagged')
check(not guard.is_sensitive(home .. '/code/main.lua'), 'source file not flagged')
check(not guard.is_sensitive(''), 'empty path not flagged')
-- Known tradeoff (documented in the module): broad *token* also matches
-- names like tokenizer.py. Strict mode prefers the false positive.
check(guard.is_sensitive('/tmp/tokenizer.py'), '*token* is intentionally broad (strict mode)')

-- Adversarial: wrong types assert instead of silently passing.
local assert_ok = pcall(guard.is_sensitive, nil)
check(not assert_ok, 'nil path raises (contract enforced)')
assert_ok = pcall(guard.is_sensitive, 42)
check(not assert_ok, 'numeric path raises (contract enforced)')

-- Integration: opening a sensitive file wipes the buffer (real :edit path).
-- The guard marks in BufReadPre and wipes in BufReadPost, before FileType
-- (and therefore LSP/AI) ever runs. Vim forbids buf_delete in *ReadPre
-- (E201), so this two-phase design is load-bearing, not incidental.
local tmpdir = fn.tempname()
fn.mkdir(tmpdir, 'p')
local secret_file = tmpdir .. '/my-secret-data.txt'
local f = io.open(secret_file, 'w')
f:write('TOPSECRET')
f:close()
local notices_before = #notices
vim.cmd('edit ' .. fn.fnameescape(secret_file))
local leaked = false
for _, b in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_valid(b) then
        for _, line in ipairs(api.nvim_buf_get_lines(b, 0, -1, false)) do
            if line:find('TOPSECRET', 1, true) then
                leaked = true
            end
        end
    end
end
check(not leaked, 'sensitive content never present in any buffer')
check(#notices > notices_before, 'user notified about the wipe')
check(fn.filereadable(secret_file) == 1, 'file on disk untouched (guard is not deletion)')

-- Integration: ordinary file opens untouched (real :edit path).
local tmp2 = tmpdir .. '/notes.txt'
local f2 = io.open(tmp2, 'w')
f2:write('hello')
f2:close()
vim.cmd('edit ' .. fn.fnameescape(tmp2))
local found_hello = false
for _, b in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_valid(b) then
        for _, line in ipairs(api.nvim_buf_get_lines(b, 0, -1, false)) do
            if line == 'hello' then
                found_hello = true
            end
        end
    end
end
check(found_hello, 'ordinary file content loads normally')

-- Toggle disables the guard: sensitive file now opens.
local cmds = api.nvim_get_commands({})
check(cmds['GuardToggle'] ~= nil, ':GuardToggle registered')
vim.cmd('GuardToggle')
check(guard.enabled == false, ':GuardToggle disables')
local secret_file2 = tmpdir .. '/other-token.txt'
local f3 = io.open(secret_file2, 'w')
f3:write('TOKEN123')
f3:close()
vim.cmd('edit ' .. fn.fnameescape(secret_file2))
local found_token = false
for _, b in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_valid(b) then
        for _, line in ipairs(api.nvim_buf_get_lines(b, 0, -1, false)) do
            if line == 'TOKEN123' then
                found_token = true
            end
        end
    end
end
check(found_token, 'disabled guard lets sensitive file open')
vim.cmd('GuardToggle') -- re-enable
check(guard.enabled == true, 'guard re-enabled after test')

print(('guard: %d checks, %d failures'):format(count, failures))
os.exit(failures == 0 and 0 or 1)
