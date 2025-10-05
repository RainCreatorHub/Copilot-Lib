-- TitleBar.lua
-- Barra de título para janelas

local Themes = require(script.Parent.Parent.Utils.Themes)

local TitleBar = {}
TitleBar.__index = TitleBar

function TitleBar.new(title, subTitle, icon, theme)
    local self = setmetatable({}, TitleBar)
    theme = theme or Themes:Get("Default")

    self.Frame = Instance.new("Frame")
    self.Frame.Name = "TitleBar"
    self.Frame.Size = UDim2.new(1, 0, 0, subTitle and 54 or 36)
    self.Frame.BackgroundColor3 = theme.Accent
    self.Frame.BorderSizePixel = 0

    if icon then
        local iconImg = Instance.new("ImageLabel")
        iconImg.Image = icon
        iconImg.Size = UDim2.new(0, 28, 0, 28)
        iconImg.Position = UDim2.new(0, 6, 0, 4)
        iconImg.BackgroundTransparency = 1
        iconImg.Parent = self.Frame
    end

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title or ""
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = theme.Text
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -40, 0, 22)
    titleLabel.Position = UDim2.new(0, icon and 40 or 10, 0, 4)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.Frame

    if subTitle then
        local subLabel = Instance.new("TextLabel")
        subLabel.Text = subTitle
        subLabel.Font = Enum.Font.Gotham
        subLabel.TextSize = 14
        subLabel.TextColor3 = theme.SubText
        subLabel.BackgroundTransparency = 1
        subLabel.Size = UDim2.new(1, -40, 0, 16)
        subLabel.Position = UDim2.new(0, icon and 40 or 10, 0, 26)
        subLabel.TextXAlignment = Enum.TextXAlignment.Left
        subLabel.Parent = self.Frame
    end

    return self
end

return TitleBar
