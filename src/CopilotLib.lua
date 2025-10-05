-- CopilotLib.lua
-- Módulo principal que integra tudo

local Window = require(script.Components.Window)

local Lib = {}

function Lib:MakeWindow(props)
    return Window.new(props)
end

return Lib
