local Deep_Lib = {}

Deep_Lib._LoadedModules = {}
Deep_Lib._BaseUrl = "https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/"

function Deep_Lib._loadModule(modulePath)
    if Deep_Lib._LoadedModules[modulePath] then
        return Deep_Lib._LoadedModules[modulePath]
    end
    
    local fullUrl = Deep_Lib._BaseUrl .. modulePath
    local success, result = pcall(function()
        local response = game:HttpGet(fullUrl, true)
        return loadstring(response)()
    end)
    
    if not success then
        error("[Deep_Lib] Failed to load module: " .. modulePath .. " | Error: " .. tostring(result))
    end
    
    Deep_Lib._LoadedModules[modulePath] = result
    return result
end

function Deep_Lib:Window(config)
    local WindowModule = self._loadModule("src/Components/Window.lua")
    return WindowModule.new(config)
end

return Deep_Lib
