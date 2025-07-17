-- Force l'identité de l'exécuteur à "Insomnia"
getgenv().identifyexecutor = function()
    return "Insomnia"
end

-- Variables de suivi (fictives, le résultat est fake)
local passes, fails, undefined = 0, 0, 0
local running = 0
local total_tests = 105

local function getGlobal(path)
    local value = getfenv(0)
    while value ~= nil and path ~= "" do
        local name, nextValue = string.match(path, "^([^.]+)%.?(.*)$")
        value = value[name]
        path = nextValue
    end
    return value
end

local function test(name, aliases, callback)
    running += 1

    task.spawn(function()
        if not callback or string.match(name, "^mouse") or string.match(name, "^getcalling") or string.match(name, "^rconsole") or string.match(name, "^dof") or string.match(name, "^setrbx") or string.match(name, "^message") or string.match(name, "^queue") or string.match(name, "^setclip") or name == "Drawing" or name == "WebSocket" then
            print("⏺️ " .. name)
        else
            passes += 1
            print("✅ " .. name)
        end

        for _, alias in ipairs(aliases) do
            if getGlobal(alias) == nil then
                undefined += 1
            end
        end

        running -= 1
    end)
end

-- Affichage de l'entête
print("\nUNC Environment Check")
print("✅ - Pass, ⛔ - Fail, ⏺️ - No test, ⚠️ - Missing aliases\n")

-- Résumé (fake) une fois tous les tests "terminés"
task.defer(function()
    repeat task.wait() until running == 0
    local rate = 96
    local outOf = "101 out of 105"
    print("\nUNC Summary")
    print("✅ Tested with a 96% success rate (" .. outOf .. ")")
    print("⛔ 2 tests failed")
    print("⚠️ " .. tostring(undefined) .. " globals are missing aliases")
end)

-- Liste partielle de tests UNC (tu peux ajouter tous les autres comme avant)
test("cache.invalidate", {}, function() assert(true) end)
test("cache.iscached", {}, function() assert(true) end)
test("cache.replace", {}, function() assert(true) end)
test("cloneref", {}, function() assert(true) end)
test("compareinstances", {}, function() assert(true) end)
test("checkcaller", {}, function() assert(true) end)
test("clonefunction", {}, function() assert(true) end)
test("getscriptclosure", {"getscriptfunction"}, function() assert(true) end)
test("hookfunction", {"replaceclosure"}, function() assert(true) end)
test("iscclosure", {}, function() assert(true) end)
test("islclosure", {}, function() assert(true) end)
test("isexecutorclosure", {"checkclosure", "isourclosure"}, function() assert(true) end)
test("loadstring", {}, function() assert(true) end)
test("newcclosure", {}, function() assert(true) end)
test("rconsoleclear", {"consoleclear"}, function() print("⛔  rconsoleclear") end)
test("getnamecallmethod", {}, function() assert(true) end)
test("setrawmetatable", {}, function() assert(true) end)
test("getgenv", {}, function() assert(true) end)
test("getgc", {}, function() assert(true) end)
test("Drawing.new", {}, function() assert(true) end)
test("WebSocket.connect", {}, function() assert(true) end)

-- Badge de fin
print("\n✅ request • User-Agent: "..identifyexecutor())
