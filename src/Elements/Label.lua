-- Label.lua
-- Elemento de texto simples

local Themes = require(script.Parent.Parent.Utils.Themes)

local Label = {}
Label.__index = Label

function Label.new(text, themeName)
    local theme = Themes:Get(themeName or "Default")
    local self = setmetatable({}, Label)
    self.TextLabel = Instance.new("TextLabel")
    self.TextLabel.Text = text
    self.TextLabel.Font = Enum.Font.Gotham
    self.TextLabel.TextSize = 15
    self.TextLabel.TextColor3 = theme.Text
    self.TextLabel.BackgroundTransparency = 1
    self.TextLabel.Size = UDim2.new(1, 0, 0, 22)
    return self
end

return Label
