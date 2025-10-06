local Section = {}
Section.__index = Section

function Section.new(config, parent)
    local self = setmetatable({}, Section)
    
    self.Name = config.Name or "Section"
    self.Icon = config.Icon or nil
    self.Opened = config.Opened or true
    self.Locked = config.Locked or false
    self.Parent = parent
    self.Elements = {}
    
    self:_Create()
    
    return self
end

function Section:_Create()
    -- Section container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Section_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.BackgroundTransparency = 1
    self.Container.LayoutOrder = 999
    self.Container.Parent = self.Parent
    
    -- Section header (clickable to toggle)
    self.Header = Instance.new("TextButton")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 30)
    self.Header.Position = UDim2.new(0, 0, 0, 0)
    self.Header.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.Header.BorderSizePixel = 1
    self.Header.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.Header.Text = ""
    self.Header.Parent = self.Container
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 4)
    headerCorner.Parent = self.Header
    
    -- Icon (if provided)
    if self.Icon then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 16, 0, 16)
        self.IconLabel.Position = UDim2.new(0, 8, 0.5, -8)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = self.Icon
        self.IconLabel.Parent = self.Header
    end
    
    -- Section name
    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, self.Icon and -30 or -15, 1, 0)
    self.NameLabel.Position = UDim2.new(0, self.Icon and 30 or 10, 0, 0)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.NameLabel.TextSize = 14
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Font = Enum.Font.Gotham
    self.NameLabel.Parent = self.Header
    
    -- Expand/collapse icon
    self.ExpandIcon = Instance.new("ImageLabel")
    self.ExpandIcon.Name = "ExpandIcon"
    self.ExpandIcon.Size = UDim2.new(0, 12, 0, 12)
    self.ExpandIcon.Position = UDim2.new(1, -20, 0.5, -6)
    self.ExpandIcon.BackgroundTransparency = 1
    self.ExpandIcon.Image = "rbxassetid://120403632100739"
    self.ExpandIcon.Parent = self.Header
    
    -- Content area
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -10, 0, 0)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 35)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Visible = self.Opened
    self.ContentFrame.Parent = self.Container
    
    -- UIListLayout for content
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.ContentFrame
    
    -- Update visual state
    self:_UpdateVisualState()
    
    -- Toggle on click with animation
    self.Header.MouseButton1Click:Connect(function()
        if not self.Locked then
            self:SetOpened(not self.Opened)
        end
    end)
end

function Section:_UpdateVisualState()
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if self.Opened then
        self.ExpandIcon.Image = "rbxassetid://120403632100739"
        tweenService:Create(self.ExpandIcon, tweenInfo, {Rotation = 0}):Play()
        
        -- Animate content frame appearance
        self.ContentFrame.Visible = true
        tweenService:Create(self.ContentFrame, tweenInfo, {Size = UDim2.new(1, -10, 0, self.ContentFrame.UIListLayout.AbsoluteContentSize.Y)}):Play()
    else
        self.ExpandIcon.Image = "rbxassetid://120403632100739"
        tweenService:Create(self.ExpandIcon, tweenInfo, {Rotation = -90}):Play()
        
        -- Animate content frame disappearance
        tweenService:Create(self.ContentFrame, tweenInfo, {Size = UDim2.new(1, -10, 0, 0)}):Play()
        wait(0.2)
        self.ContentFrame.Visible = false
    end
    
    -- Update locked appearance
    if self.Locked then
        self.Header.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
        self.NameLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    else
        self.Header.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
        self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    end
end

-- Public Methods
function Section:SetName(newName)
    self.Name = newName
    if self.NameLabel then
        self.NameLabel.Text = newName
    end
end

function Section:SetIcon(newIcon)
    self.Icon = newIcon
    if self.IconLabel then
        self.IconLabel.Image = newIcon
    elseif newIcon and self.Header then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 16, 0, 16)
        self.IconLabel.Position = UDim2.new(0, 8, 0.5, -8)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = newIcon
        self.IconLabel.Parent = self.Header
        
        if self.NameLabel then
            self.NameLabel.Position = UDim2.new(0, 30, 0, 0)
            self.NameLabel.Size = UDim2.new(1, -35, 1, 0)
        end
    end
end

function Section:SetOpened(isOpened)
    self.Opened = isOpened
    self:_UpdateVisualState()
end

function Section:SetLocked(isLocked)
    self.Locked = isLocked
    self:_UpdateVisualState()
end

-- Element Methods
function Section:Paragraph(paragraphConfig)
    local ParagraphModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Paragraph.lua"))()
    local newParagraph = ParagraphModule.new(paragraphConfig, self.ContentFrame)
    table.insert(self.Elements, newParagraph)
    return newParagraph
end

function Section:Button(buttonConfig)
    local ButtonModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Button.lua"))()
    local newButton = ButtonModule.new(buttonConfig, self.ContentFrame)
    table.insert(self.Elements, newButton)
    return newButton
end

function Section:Toggle(toggleConfig)
    local ToggleModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Toggle.lua"))()
    local newToggle = ToggleModule.new(toggleConfig, self.ContentFrame)
    return newToggle
end

return Section
