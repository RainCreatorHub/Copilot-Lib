local Tab = {}
Tab.__index = Tab

function Tab.new(config, parent)
    local self = setmetatable({}, Tab)
    
    self.Name = config.Name or "New Tab"
    self.Icon = config.Icon or nil
    self.Locked = config.Locked or false
    self.Parent = parent
    self.Visible = false
    self.Elements = {}
    
    self:_Create()
    
    return self
end

function Tab:_Create()
    -- Main tab container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Tab_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.Position = UDim2.new(0, 0, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.Visible = false
    self.Container.Parent = self.Parent
    
    -- Tab header (for when you implement tab switching UI)
    self.Header = Instance.new("TextButton")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(0, 120, 0, 30)
    self.Header.Position = UDim2.new(0, 0, 0, 0)
    self.Header.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.Header.BorderSizePixel = 0
    self.Header.Text = ""
    
    -- Icon (if provided)
    if self.Icon then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 16, 0, 16)
        self.IconLabel.Position = UDim2.new(0, 5, 0.5, -8)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = self.Icon
        self.IconLabel.Parent = self.Header
    end
    
    -- Tab name label
    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, self.Icon and -25 or -10, 1, 0)
    self.NameLabel.Position = UDim2.new(0, self.Icon and 25 or 5, 0, 0)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.NameLabel.TextSize = 12
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Font = Enum.Font.Gotham
    self.NameLabel.Parent = self.Header
    
    -- Lock icon (shown when tab is locked)
    self.LockIcon = Instance.new("ImageLabel")
    self.LockIcon.Name = "LockIcon"
    self.LockIcon.Size = UDim2.new(0, 12, 0, 12)
    self.LockIcon.Position = UDim2.new(1, -15, 0.5, -6)
    self.LockIcon.BackgroundTransparency = 1
    self.LockIcon.Image = "rbxassetid://123456789" -- Use a lock icon asset ID
    self.LockIcon.Visible = self.Locked
    self.LockIcon.Parent = self.Header
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = self.Header
    
    -- Update locked visual state
    self:_UpdateLockedAppearance()
    
    -- Content area
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 0)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.Container
    
    -- Content label (placeholder)
    self.ContentLabel = Instance.new("TextLabel")
    self.ContentLabel.Name = "ContentLabel"
    self.ContentLabel.Size = UDim2.new(1, -20, 1, -20)
    self.ContentLabel.Position = UDim2.new(0, 10, 0, 10)
    self.ContentLabel.BackgroundTransparency = 1
    self.ContentLabel.Text = self.Name .. " Content" .. (self.Locked and " (Locked)" or "")
    self.ContentLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.ContentLabel.TextSize = 14
    self.ContentLabel.Font = Enum.Font.Gotham
    self.ContentLabel.Parent = self.ContentFrame
end

function Tab:_UpdateLockedAppearance()
    if self.Locked then
        -- Visual feedback for locked state
        self.Header.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
        if self.LockIcon then
            self.LockIcon.Visible = true
        end
        if self.ContentLabel then
            self.ContentLabel.Text = self.Name .. " Content (Locked)"
        end
    else
        self.Header.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
        if self.LockIcon then
            self.LockIcon.Visible = false
        end
        if self.ContentLabel then
            self.ContentLabel.Text = self.Name .. " Content"
        end
    end
end

-- Public Methods
function Tab:SetName(newName)
    self.Name = newName
    if self.NameLabel then
        self.NameLabel.Text = newName
    end
    if self.ContentLabel then
        self.ContentLabel.Text = newName .. " Content" .. (self.Locked and " (Locked)" or "")
    end
end

function Tab:SetIcon(newIcon)
    self.Icon = newIcon
    if self.IconLabel then
        self.IconLabel.Image = newIcon
    elseif newIcon and self.Header then
        -- Create icon if it doesn't exist but is now provided
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 16, 0, 16)
        self.IconLabel.Position = UDim2.new(0, 5, 0.5, -8)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = newIcon
        self.IconLabel.Parent = self.Header
        
        -- Adjust name label position
        if self.NameLabel then
            self.NameLabel.Position = UDim2.new(0, 25, 0, 0)
            self.NameLabel.Size = UDim2.new(1, -30, 1, 0)
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

function Tab:AddButton(config)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. config.Title
    button.Size = UDim2.new(0, 120, 0, 35)
    button.Position = UDim2.new(0, 10, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(33, 139, 255)
    button.BorderSizePixel = 0
    button.Text = config.Title or "Button"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if config.Callback and not self.Locked then
            config.Callback()
        end
    end)
    
    button.Parent = self.ContentFrame
end

function Tab:AddLabel(config)
    local label = Instance.new("TextLabel")
    label.Name = "Label_" .. config.Text
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = config.Text or "Label"
    label.TextColor3 = Color3.fromRGB(248, 250, 252)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = self.ContentFrame
end

return Tab
