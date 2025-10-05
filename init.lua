local Deep_Lib = {}

-- Módulos já carregados (cache)
Deep_Lib._LoadedModules = {}

-- Função personalizada para carregar um módulo de uma URL do GitHub
function Deep_Lib._loadModule(moduleName, modulePath)
    -- Verifica se o módulo já está em cache
    if Deep_Lib._LoadedModules[moduleName] then
        return Deep_Lib._LoadedModules[moduleName]
    end
    
    -- Constrói a URL completa para o arquivo raw no GitHub
    local baseUrl = "https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/"
    local fullUrl = baseUrl .. modulePath .. ".lua"
    
    -- Faz a requisição HTTP e carrega o módulo
    local success, moduleScript = pcall(function()
        local httpContent = game:HttpGet(fullUrl)
        return loadstring(httpContent)()
    end)
    
    if not success then
        error("Falha ao carregar o módulo: " .. moduleName .. " de: " .. fullUrl)
    end
    
    -- Armazena no cache e retorna
    Deep_Lib._LoadedModules[moduleName] = moduleScript
    return moduleScript
end

-- Agora carrega cada componente usando a função personalizada
function Deep_Lib:Window(config)
    local WindowModule = self._loadModule("Window", "src/Components/Window")
    return WindowModule.new(config)
end

function Deep_Lib:Notify(config)
    local NotifyModule = self._loadModule("Notify", "src/Components/Notify")
    return NotifyModule.new(config)
end

-- Continue adicionando outras funções para Tab, TitleBar, etc.

return Deep_Lib
