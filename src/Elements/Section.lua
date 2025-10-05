-- Section.lua
-- Seção de conteúdo agrupado

local Themes = require(script.Parent.Parent.Utils.Themes)

local Section = {}
Section.__index = Section

function Section.new(title, themeName)
    local theme = Themes:Get(themeName or "Default")
    local self = setmetatable({}, Section)
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, 0, 0, 100)
    self.Frame.BackgroundColor3 = theme.Section
    self.Frame.BorderSizePixel = 0

    local label = Instance.new("TextLabel")
    label.Text = title
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextColor3 = theme.Text
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -16, 0, 22)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.Parent = self.Frame

    return self
end

return Section
