local Tab = {}
Tab.__index = Tab

function Tab.new(config, contentParent, tabButtonsParent, window)
    local self = setmetatable({}, Tab)
    
    self.Name = config.Name or "New Tab"
    self.Icon = config.Icon or nil
    self.Locked = config.Locked or false
    self.ContentParent = contentParent
    self.TabButtonsParent = tabButtonsParent
    self.Window = window
    self.Visible = false
    self.Active = false
    self.Sections = {}
    self.Elements = {}
    
    self:_Create()
    
    return self
end

function Tab:_Create()
    -- Tab Content Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Tab_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.Position = UDim2.new(0, 0, 0, 0)
    self.Container.BackgroundColor3 = Color3.fromRGB(25, 30, 35)
    self.Container.BorderSizePixel = 1
    self.Container.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.Container.Visible = false
    self.Container.Parent = self.ContentParent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.Container
    
    -- Content area
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -10, 1, -10)
    self.ContentFrame.Position = UDim2.new(0, 5, 0, 5)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.Container
    
    -- UIListLayout para organizar elementos verticalmente
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.ContentFrame
    
    -- Tab Button (na barra lateral)
    self:_CreateTabButton()
end

function Tab:_CreateTabButton()
    self.TabButton = Instance.new("TextButton")
    self.TabButton.Name = "TabButton_" .. string.gsub(self.Name, " ", "_")
    self.TabButton.Size = UDim2.new(1, 0, 0, 35)
    self.TabButton.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.TabButton.BorderSizePixel = 1
    self.TabButton.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.TabButton.Text = ""
    self.TabButton.LayoutOrder = #self.TabButtonsParent:GetChildren()
    self.TabButton.Parent = self.TabButtonsParent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = self.TabButton
    
    -- Icon (se fornecido)
    if self.Icon then
        self.TabIcon = Instance.new("ImageLabel")
        self.TabIcon.Name = "Icon"
        self.TabIcon.Size = UDim2.new(0, 20, 0, 20)
        self.TabIcon.Position = UDim2.new(0, 8, 0.5, -10)
        self.TabIcon.BackgroundTransparency = 1
        self.TabIcon.Image = self.Icon
        self.TabIcon.Parent = self.TabButton
    end
    
    -- Tab name
    self.TabNameLabel = Instance.new("TextLabel")
    self.TabNameLabel.Name = "Name"
    self.TabNameLabel.Size = UDim2.new(1, self.Icon and -30 or -10, 1, 0)
    self.TabNameLabel.Position = UDim2.new(0, self.Icon and 30 or 8, 0, 0)
    self.TabNameLabel.BackgroundTransparency = 1
    self.TabNameLabel.Text = self.Name
    self.TabNameLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    self.TabNameLabel.TextSize = 12
    self.TabNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TabNameLabel.Font = Enum.Font.Gotham
    self.TabNameLabel.Parent = self.TabButton
    
    -- Lock icon (se bloqueada)
    if self.Locked then
        self.LockIcon = Instance.new("ImageLabel")
        self.LockIcon.Name = "LockIcon"
        self.LockIcon.Size = UDim2.new(0, 12, 0, 12)
        self.LockIcon.Position = UDim2.new(1, -15, 0.5, -6)
        self.LockIcon.BackgroundTransparency = 1
        self.LockIcon.Image = "rbxassetid://140204577989343"
        self.LockIcon.Visible = self.Locked
        self.LockIcon.Parent = self.TabButton
    end
    
    -- Hover and click effects
    self:_SetupTabButtonAnimations()
end

function Tab:_SetupTabButtonAnimations()
    local tweenService = game:GetService("TweenService")
    
    self.TabButton.MouseEnter:Connect(function()
        if not self.Active and not self.Locked then
            tweenService:Create(
                self.TabButton,
                TweenInfo.new(0.2),
                {BackgroundColor3 = Color3.fromRGB(40, 46, 55)}
            ):Play()
            tweenService:Create(
                self.TabNameLabel,
                TweenInfo.new(0.2),
                {TextColor3 = Color3.fromRGB(248, 250, 252)}
            ):Play()
        end
    end)
    
    self.TabButton.MouseLeave:Connect(function()
        if not self.Active and not self.Locked then
            tweenService:Create(
                self.TabButton,
                TweenInfo.new(0.2),
                {BackgroundColor3 = Color3.fromRGB(33, 38, 45)}
            ):Play()
            tweenService:Create(
                self.TabNameLabel,
                TweenInfo.new(0.2),
                {TextColor3 = Color3.fromRGB(139, 148, 160)}
            ):Play()
        end
    end)
    
    self.TabButton.MouseButton1Click:Connect(function()
        if not self.Locked then
            self.Window:SwitchToTab(self)
        end
    end)
end

function Tab:_UpdateActiveAppearance()
    local tweenService = game:GetService("TweenService")
    
    if self.Active then
        tweenService:Create(
            self.TabButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(33, 139, 255)}
        ):Play()
        tweenService:Create(
            self.TabNameLabel,
            TweenInfo.new(0.2),
            {TextColor3 = Color3.fromRGB(248, 250, 252)}
        ):Play()
    else
        tweenService:Create(
            self.TabButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(33, 38, 45)}
        ):Play()
        tweenService:Create(
            self.TabNameLabel,
            TweenInfo.new(0.2),
            {TextColor3 = Color3.fromRGB(139, 148, 160)}
        ):Play()
    end
end

function Tab:_UpdateLockedAppearance()
    if self.Locked then
        if self.LockIcon then
            self.LockIcon.Visible = true
        end
        self.TabButton.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
        self.TabNameLabel.TextColor3 = Color3.fromRGB(108, 117, 125)
    else
        if self.LockIcon then
            self.LockIcon.Visible = false
        end
        self:_UpdateActiveAppearance()
    end
end

-- Public Methods
function Tab:SetName(newName)
    self.Name = newName
    if self.TabNameLabel then
        self.TabNameLabel.Text = newName
    end
end

function Tab:SetIcon(newIcon)
    self.Icon = newIcon
    if self.TabIcon then
        self.TabIcon.Image = newIcon
    elseif newIcon and self.TabButton then
        self.TabIcon = Instance.new("ImageLabel")
        self.TabIcon.Name = "Icon"
        self.TabIcon.Size = UDim2.new(0, 20, 0, 20)
        self.TabIcon.Position = UDim2.new(0, 8, 0.5, -10)
        self.TabIcon.BackgroundTransparency = 1
        self.TabIcon.Image = newIcon
        self.TabIcon.Parent = self.TabButton
        
        if self.TabNameLabel then
            self.TabNameLabel.Position = UDim2.new(0, 30, 0, 0)
            self.TabNameLabel.Size = UDim2.new(1, -35, 1, 0)
        end
    end
end

function Tab:SetLocked(isLocked)
    self.Locked = isLocked
    self:_UpdateLockedAppearance()
end

function Tab:SetVisible(visible)
    self.Visible = visible
    self.Container.Visible = visible
end

function Tab:SetActive(active)
    self.Active = active
    self:_UpdateActiveAppearance()
end

-- Section Methods
function Tab:Section(sectionConfig)
    local SectionModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Section.lua"))()
    local newSection = SectionModule.new(sectionConfig, self.ContentFrame)
    table.insert(self.Sections, newSection)
    return newSection
end

-- Paragraph Methods
function Tab:Paragraph(paragraphConfig)
    local ParagraphModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Paragraph.lua"))()
    local newParagraph = ParagraphModule.new(paragraphConfig, self.ContentFrame)
    table.insert(self.Elements, newParagraph)
    return newParagraph
end

-- Button Methods
function Tab:Button(buttonConfig)
    local ButtonModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Button.lua"))()
    local newButton = ButtonModule.new(buttonConfig, self.ContentFrame)
    table.insert(self.Elements, newButton)
    return newButton
end

return Tab
