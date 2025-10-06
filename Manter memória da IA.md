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

# src/Components/Themes/Light.lua
```lua
local Light = {
    Background = Color3.fromRGB(255, 255, 255),
    BackgroundSecondary = Color3.fromRGB(248, 249, 250),
    BackgroundTertiary = Color3.fromRGB(241, 243, 245),
    Text = Color3.fromRGB(33, 37, 41),
    TextSecondary = Color3.fromRGB(108, 117, 125),
    Accent = Color3.fromRGB(33, 139, 255),
    Border = Color3.fromRGB(222, 226, 230),
    Shadow = Color3.new(0, 0, 0),
    Error = Color3.fromRGB(220, 53, 69),
    Success = Color3.fromRGB(40, 167, 69),
    Warning = Color3.fromRGB(255, 193, 7)
}

return Light
```

# src/Components/Themes/Dark.lua
```lua
local Dark = {
    Background = Color3.fromRGB(33, 38, 45),
    BackgroundSecondary = Color3.fromRGB(25, 30, 35),
    BackgroundTertiary = Color3.fromRGB(22, 27, 34),
    Text = Color3.fromRGB(248, 250, 252),
    TextSecondary = Color3.fromRGB(139, 148, 160),
    Accent = Color3.fromRGB(33, 139, 255),
    Border = Color3.fromRGB(48, 54, 61),
    Shadow = Color3.new(0, 0, 0),
    Error = Color3.fromRGB(220, 53, 69),
    Success = Color3.fromRGB(40, 167, 69),
    Warning = Color3.fromRGB(255, 193, 7)
}

return Dark
```
