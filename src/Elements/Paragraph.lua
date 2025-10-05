local Themes = require(script.Parent.Parent.Utils.Themes)

local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(props)
    local theme = Themes:Get("Default")
    local self = setmetatable({}, Paragraph)

    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, 0, 0, 60)
    self.Frame.BackgroundTransparency = 1

    self.Icon = Instance.new("ImageLabel")
    self.Icon.Size = UDim2.new(0, 24, 0, 24)
    self.Icon.Position = UDim2.new(0, 6, 0, 6)
    self.Icon.BackgroundTransparency = 1
    self.Icon.Visible = props and props.Icon ~= nil
    if props and props.Icon then
        if type(props.Icon) == "number" then
            self.Icon.Image = "rbxassetid://"..tostring(props.Icon)
        else
            self.Icon.Image = tostring(props.Icon)
        end
    end
    self.Icon.Parent = self.Frame

    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Text = props and props.Name or ""
    self.NameLabel.Font = Enum.Font.GothamBold
    self.NameLabel.TextSize = 16
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.TextColor3 = theme.Text
    self.NameLabel.Position = UDim2.new(0, 36, 0, 6)
    self.NameLabel.Size = UDim2.new(1, -42, 0, 20)
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Parent = self.Frame

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Text = props and props.Desc or ""
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.TextSize = 14
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.TextColor3 = theme.SubText
    self.DescLabel.Position = UDim2.new(0, 36, 0, 28)
    self.DescLabel.Size = UDim2.new(1, -42, 0, 24)
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.DescLabel.TextWrapped = true
    self.DescLabel.Parent = self.Frame

    self.Locked = props and props.Locked or false
    self:SetLocked(self.Locked)

    return self
end

function Paragraph:SetName(name)
    self.NameLabel.Text = name or ""
end

function Paragraph:SetDesc(desc)
    self.DescLabel.Text = desc or ""
end

function Paragraph:SetIcon(icon)
    if icon then
        self.Icon.Visible = true
        if type(icon) == "number" then
            self.Icon.Image = "rbxassetid://"..tostring(icon)
        else
            self.Icon.Image = tostring(icon)
        end
    else
        self.Icon.Visible = false
    end
end

function Paragraph:SetLocked(locked)
    self.Locked = locked
    if locked then
        self.Frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        self.Frame.BackgroundTransparency = 0.2
        self.NameLabel.TextTransparency = 0.4
        self.DescLabel.TextTransparency = 0.4
        self.Icon.ImageTransparency = 0.4
    else
        self.Frame.BackgroundTransparency = 1
        self.NameLabel.TextTransparency = 0
        self.DescLabel.TextTransparency = 0
        self.Icon.ImageTransparency = 0
    end
end

return Paragraph
