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
    -- Toggle Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Toggle"
    self.Container.Size = UDim2.new(1, -10, 0, 50)
    self.Container.Position = UDim2.new(0, 5, 0, 0)
    self.Container.BackgroundColor3 = Color3.fromRGB(40, 46, 54)
    self.Container.BorderSizePixel = 0
    self.Container.Parent = parentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.Container

    -- Invisible button covering the whole toggle for interaction
    self.InvisibleButton = Instance.new("TextButton")
    self.InvisibleButton.Name = "InvisibleButton"
    self.InvisibleButton.Size = UDim2.new(1, 0, 1, 0)
    self.InvisibleButton.Position = UDim2.new(0, 0, 0, 0)
    self.InvisibleButton.BackgroundTransparency = 1
    self.InvisibleButton.Text = ""
    self.InvisibleButton.AutoButtonColor = false
    self.InvisibleButton.Parent = self.Container
    self.InvisibleButton.ZIndex = 100

    -- Text Container
    local textContainer = Instance.new("Frame")
    textContainer.Name = "TextContainer"
    textContainer.Size = UDim2.new(0.7, 0, 1, 0)
    textContainer.Position = UDim2.new(0, 10, 0, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = self.Container

    -- Name
    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    self.NameLabel.Position = UDim2.new(0, 0, 0, 0)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.NameLabel.TextSize = 14
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Font = Enum.Font.GothamBold
    self.NameLabel.Parent = textContainer

    -- Description
    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Desc"
    self.DescLabel.Size = UDim2.new(1, 0, 0.4, 0)
    self.DescLabel.Position = UDim2.new(0, 0, 0.6, 0)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = self.Desc
    self.DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    self.DescLabel.TextSize = 12
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.Parent = textContainer

    -- Switch visual (all with Frames)
    self.SwitchContainer = Instance.new("Frame")
    self.SwitchContainer.Name = "SwitchContainer"
    self.SwitchContainer.Size = UDim2.new(0, 50, 0, 25)
    self.SwitchContainer.Position = UDim2.new(1, -60, 0.5, -12.5)
    self.SwitchContainer.AnchorPoint = Vector2.new(1, 0.5)
    self.SwitchContainer.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
    self.SwitchContainer.BorderSizePixel = 0
    self.SwitchContainer.Parent = self.Container

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 12)
    switchCorner.Parent = self.SwitchContainer

    self.SwitchKnob = Instance.new("Frame")
    self.SwitchKnob.Name = "SwitchKnob"
    self.SwitchKnob.Size = UDim2.new(0, 21, 0, 21)
    self.SwitchKnob.Position = UDim2.new(0, 2, 0.5, -10.5)
    self.SwitchKnob.AnchorPoint = Vector2.new(0, 0.5)
    self.SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.SwitchKnob.BorderSizePixel = 0
    self.SwitchKnob.Parent = self.SwitchContainer

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 10)
    knobCorner.Parent = self.SwitchKnob

    -- Icon (quando ativo)
    self.IconLabel = Instance.new("ImageLabel")
    self.IconLabel.Name = "Icon"
    self.IconLabel.Size = UDim2.new(0, 12, 0, 12)
    self.IconLabel.Position = UDim2.new(0.5, -6, 0.5, -6)
    self.IconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    self.IconLabel.BackgroundTransparency = 1
    self.IconLabel.Image = self.Icon or ""
    self.IconLabel.Visible = false
    self.IconLabel.Parent = self.SwitchKnob

    -- Set initial state
    self:SetValue(self.Default)

    -- Click event for invisible button
    self.InvisibleButton.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)
end

function Toggle:SetValue(value)
    self.Value = value
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    if value then
        -- Ativo
        tweenService:Create(self.SwitchKnob, tweenInfo, {
            Position = UDim2.new(1, -23, 0.5, -10.5),
            BackgroundColor3 = Color3.fromRGB(33, 139, 255)
        }):Play()
        tweenService:Create(self.SwitchContainer, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(33, 139, 255)
        }):Play()
        self.IconLabel.Visible = (self.Icon ~= nil)
    else
        -- Inativo
        tweenService:Create(self.SwitchKnob, tweenInfo, {
            Position = UDim2.new(0, 2, 0.5, -10.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        tweenService:Create(self.SwitchContainer, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(48, 54, 61)
        }):Play()
        self.IconLabel.Visible = false
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
    self.IconLabel.Image = icon
    if self.Value then
        self.IconLabel.Visible = true
    end
end

return Toggle
