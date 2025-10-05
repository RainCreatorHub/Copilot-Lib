local Deep_Lib = {}
Deep_Lib.Components = {}
Deep_Lib.Elements = {}

-- Import components
Deep_Lib.Components.Window = require(script.src.Components.Window)
Deep_Lib.Components.Tab = require(script.src.Components.Tab)
Deep_Lib.Components.TitleBar = require(script.src.Components.TitleBar)

function Deep_Lib:Window(config)
    return self.Components.Window.new(config)
end

return Deep_Lib
