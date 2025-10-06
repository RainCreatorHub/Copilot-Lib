local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Icons.lua"))()
local function ResolveIcon(icon)
    if type(icon) == "number" then
        return "rbxassetid://" .. icon
    elseif type(icon) == "string" then
        if icon:sub(1, 13) == "rbxassetid://" then
            return icon
        elseif Icons[icon] then
            return "rbxassetid://" .. Icons[icon]
        end
    end
    return nil
end

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(config, parentFrame)
    local self = setmetatable({}, Toggle)
    self.Name = config.Name or "Toggle"
    self.Desc = config.Desc or ""
    self.Icon = config.Icon
    self.Default = config.Default or false
    self.Callback = config.Callback or function() end
    self.Value = self.Default
    self:_Create(parentFrame)
    return self
end

function Toggle:_Create(parentFrame)
    self.Container = Instance.new("Frame")
    self.Container.Name = "Toggle"
    self.Container.Size = UDim2.new(1, -10, 0, 48)
    self.Container.Position = UDim2.new(0, 5, 0, 0)
    self.Container.BackgroundColor3 = Color3.fromRGB(40, 46, 54)
    self.Container.BorderSizePixel = 0
    self.Container.Parent = parentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.Container

    self.InvisibleButton = Instance.new("TextButton")
    self.InvisibleButton.Name = "InvisibleButton"
    self.InvisibleButton.Size = UDim2.new(1, 0, 1, 0)
    self.InvisibleButton.Position = UDim2.new(0, 0, 0, 0)
    self.InvisibleButton.BackgroundTransparency = 1
    self.InvisibleButton.Text = ""
    self.InvisibleButton.AutoButtonColor = false
    self.InvisibleButton.Parent = self.Container
    self.InvisibleButton.ZIndex = 100

    local textContainer = Instance.new("Frame")
    textContainer.Name = "TextContainer"
    textContainer.AnchorPoint = Vector2.new(0, 0.5)
    textContainer.Position = UDim2.new(0, 16, 0.5, 0)
    textContainer.Size = UDim2.new(1, -120, 1, -8)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = self.Container

    if self.Icon then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 16, 0, 16)
        self.IconLabel.Position = UDim2.new(0, -20, 0.5, -8)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = ResolveIcon(self.Icon)
        self.IconLabel.Parent = textContainer
    end

    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, 0, 0, 20)
    self.NameLabel.Position = UDim2.new(0, 0, 0, 0)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.NameLabel.TextSize = 14
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.NameLabel.Font = Enum.Font.GothamBold
    self.NameLabel.Parent = textContainer

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Desc"
    self.DescLabel.Size = UDim2.new(1, 0, 0, 16)
    self.DescLabel.Position = UDim2.new(0, 0, 0, 22)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = self.Desc
    self.DescLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    self.DescLabel.TextSize = 12
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.Parent = textContainer

    self.SwitchContainer = Instance.new("Frame")
    self.SwitchContainer.Name = "SwitchContainer"
    self.SwitchContainer.Size = UDim2.new(0, 44, 0, 22)
    self.SwitchContainer.AnchorPoint = Vector2.new(1, 0.5)
    self.SwitchContainer.Position = UDim2.new(1, -16, 0.5, 0)
    self.SwitchContainer.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
    self.SwitchContainer.BorderSizePixel = 0
    self.SwitchContainer.Parent = self.Container

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = self.SwitchContainer

    self.SwitchKnob = Instance.new("Frame")
    self.SwitchKnob.Name = "SwitchKnob"
    self.SwitchKnob.Size = UDim2.new(0, 20, 0, 20)
    self.SwitchKnob.AnchorPoint = Vector2.new(0, 0.5)
    self.SwitchKnob.Position = UDim2.new(0, 1, 0.5, -0.5)
    self.SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.SwitchKnob.BorderSizePixel = 0.5
    self.SwitchKnob.Parent = self.SwitchContainer

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = self.SwitchKnob

    self.IconKnobLabel = Instance.new("ImageLabel")
    self.IconKnobLabel.Name = "Icon"
    self.IconKnobLabel.Size = UDim2.new(0, 12, 0, 12)
    self.IconKnobLabel.Position = UDim2.new(0.5, -6, 0.5, -6)
    self.IconKnobLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    self.IconKnobLabel.BackgroundTransparency = 1
    self.IconKnobLabel.Visible = false
    self.IconKnobLabel.Parent = self.SwitchKnob

    self:SetValue(self.Default)

    self.InvisibleButton.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)
end

function Toggle:SetValue(value)
    self.Value = value
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local accent = Color3.fromRGB(33, 139, 255)
    if value then
        tweenService:Create(self.SwitchKnob, tweenInfo, {
            Position = UDim2.new(1, -21, 0.5, -0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        tweenService:Create(self.SwitchContainer, tweenInfo, {
            BackgroundColor3 = accent:Lerp(Color3.new(1,1,1), 0.2)
        }):Play()
        if self.Icon then
            self.IconKnobLabel.Image = ResolveIcon(self.Icon)
            self.IconKnobLabel.Visible = true
        end
    else
        tweenService:Create(self.SwitchKnob, tweenInfo, {
            Position = UDim2.new(0, 1, 0.5, -0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        tweenService:Create(self.SwitchContainer, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(48, 54, 61)
        }):Play()
        self.IconKnobLabel.Visible = false
    end
    self.Callback(self.Value)
end

function Toggle:SetName(newName)
    self.Name = newName
    self.NameLabel.Text = newName
end

function Toggle:SetDesc(newDesc)
    self.Desc = newDesc
    self.DescLabel.Text = newDesc
end

function Toggle:SetIcon(icon)
    self.Icon = icon
    if self.IconLabel then
        self.IconLabel.Image = ResolveIcon(icon)
    end
end

return Toggle
