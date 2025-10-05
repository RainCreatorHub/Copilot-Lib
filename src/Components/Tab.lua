-- Tab.lua
-- Componente de abas

local Themes = require(script.Parent.Parent.Utils.Themes)

local Tab = {}
Tab.__index = Tab

function Tab.new(name, themeName)
    local theme = Themes:Get(themeName or "Default")
    local self = setmetatable({}, Tab)
    self.Button = Instance.new("TextButton")
    self.Button.Text = name
    self.Button.Font = Enum.Font.GothamBold
    self.Button.TextSize = 16
    self.Button.BackgroundColor3 = theme.Section
    self.Button.TextColor3 = theme.Text
    self.Button.Size = UDim2.new(0, 110, 0, 32)
    self.Button.AutoButtonColor = true
    self.Button.BorderSizePixel = 0
    return self
end

return Tab
