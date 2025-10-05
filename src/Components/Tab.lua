local Themes = require(script.Parent.Parent.Utils.Themes)
local Paragraph = require(script.Parent.Parent.Elements.Paragraph)

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

    -- Container de elementos dentro do Tab, se desejar
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "TabContent"
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Size = UDim2.new(1, 0, 1, 0)

    return self
end

-- Método para criar e adicionar Paragraphs no Tab
function Tab:Paragraph(props)
    local paragraph = Paragraph.new(props)
    paragraph.Frame.Parent = self.ContentFrame
    return paragraph
end

return Tab
