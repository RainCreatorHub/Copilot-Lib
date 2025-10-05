-- Paragraph.lua
-- Texto multilinha rico

--[[
  local P = Tab:Paragraph({
    Name
    Desc
    Icon
    Locked
  })

  P:SetName("Hi")
  P:SetDesc("No")
  P:SetIcon(91911919)
  P:SetLocked(true)
]]

local Themes = require(script.Parent.Parent.Utils.Themes)

local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(text, themeName)
    local theme = Themes:Get(themeName or "Default")
    local self = setmetatable({}, Paragraph)
    self.TextLabel = Instance.new("TextLabel")
    self.TextLabel.Text = text
    self.TextLabel.Font = Enum.Font.Gotham
    self.TextLabel.TextSize = 14
    self.TextLabel.TextColor3 = theme.SubText
    self.TextLabel.BackgroundTransparency = 1
    self.TextLabel.Size = UDim2.new(1, 0, 0, 40)
    self.TextLabel.TextWrapped = true
    self.TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    return self
end

return Paragraph
