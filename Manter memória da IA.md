Ola deep seek, aqui está a estrutura completa do que estamos fazendo:
```lua
init.lua
src/
  Components/
    Themes/
      Dark.lua
      Light.lua
    Dialog.lua
    Tab.lua
    TitleBar.lua
    Window.lua
  Elements/
    Toggle.lua
    Button.lua
    Paragraph.lua
    Section.lua
```

Agora o código de cada coisa.

# init.lua
```lua
local Deep_Lib = {}

-- Cache para módulos já carregados
Deep_Lib._LoadedModules = {}
Deep_Lib._BaseUrl = "https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/"

-- Função personalizada para carregar módulos do GitHub
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

-- Função principal para criar janelas
function Deep_Lib:Window(config)
    local WindowModule = self._loadModule("src/Components/Window.lua")
    return WindowModule.new(config)
end

-- Função auxiliar para carregar componentes internos
function Deep_Lib._loadComponent(componentName)
    return Deep_Lib._loadModule("src/Components/" .. componentName .. ".lua")
end

return Deep_Lib
```
