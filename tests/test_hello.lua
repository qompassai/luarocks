-- Smoke test: run with `lua tests/test_hello.lua`.
local h = io.popen("lua src/00_hello.lua")
local out = h:read("*a")
assert(h:close() and out:find("Hello"), "hello-world failed")
print("ok - hello runs")
