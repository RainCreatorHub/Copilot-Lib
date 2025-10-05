local Button = {}
Button.__index = Button

function Button.new(config, parent, theme)
    local self = setmetatable({}, Button)
    
    self.Name = config.Name or "Button"
    self.Desc = config.Desc or ""
    self.Callback = config.Callback or function() end
    self.Parent = parent
    self.Theme = theme or {
        Background = Color3.fromRGB(33, 38, 45),
        BackgroundSecondary = Color3.fromRGB(25, 30, 35),
        Text = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(139, 148, 160),
        Accent = Color3.fromRGB(33, 139, 255),
        Border = Color3.fromRGB(48, 54, 61)
    }
    self.Locked = false
    
    self:_Create()
    
    return self
end

function Button:_Create()
    -- Button container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Button_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 0, 50)
    self.Container.BackgroundTransparency = 1
    self.Container.LayoutOrder = 999
    self.Container.Parent = self.Parent
    
    -- Button background (COM BORDA)
    self.ButtonFrame = Instance.new("TextButton")
    self.ButtonFrame.Name = "Button"
    self.ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
    self.ButtonFrame.Position = UDim2.new(0, 0, 0, 0)
    self.ButtonFrame.BackgroundColor3 = self.Theme.Background
    self.ButtonFrame.BorderSizePixel = 1
    self.ButtonFrame.BorderColor3 = self.Theme.Border
    self.ButtonFrame.Text = ""
    self.ButtonFrame.Parent = self.Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.ButtonFrame
    
    -- Button name
    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, -20, 0, 20)
    self.NameLabel.Position = UDim2.new(0, 10, 0, 5)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = self.Theme.Text
    self.NameLabel.TextSize = 14
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Font = Enum.Font.GothamBold
    self.NameLabel.Parent = self.ButtonFrame
    
    -- Button description
    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Desc"
    self.DescLabel.Size = UDim2.new(1, -20, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 10, 0, 25)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = self.Desc
    self.DescLabel.TextColor3 = self.Theme.TextSecondary
    self.DescLabel.TextSize = 11
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.Parent = self.ButtonFrame
    
    -- Hover effects
    self.ButtonFrame.MouseEnter:Connect(function()
        if not self.Locked then
            game:GetService("TweenService"):Create(
                self.ButtonFrame, 
                TweenInfo.new(0.2), 
                {BackgroundColor3 = self.Theme.Background:Lerp(Color3.new(1,1,1), 0.1)}
            ):Play()
        end
    end)
    
    self.ButtonFrame.MouseLeave:Connect(function()
        if not self.Locked then
            game:GetService("TweenService"):Create(
                self.ButtonFrame, 
                TweenInfo.new(0.2), 
                {BackgroundColor3 = self.Theme.Background}
            ):Play()
        end
    end)
    
    -- Click event
    self.ButtonFrame.MouseButton1Click:Connect(function()
        if not self.Locked then
            -- Click animation
            game:GetService("TweenService"):Create(
                self.ButtonFrame, 
                TweenInfo.new(0.1), 
                {BackgroundColor3 = self.Theme.Accent}
            ):Play()
            
            wait(0.1)
            
            game:GetService("TweenService"):Create(
                self.ButtonFrame, 
                TweenInfo.new(0.1), 
                {BackgroundColor3 = self.Theme.Background}
            ):Play()
            
            -- Call callback
            if self.Callback then
                self.Callback()
            end
        end
    end)
end

-- Public Methods
function Button:SetName(newName)
    self.Name = newName
    if self.NameLabel then
        self.NameLabel.Text = newName
    end
end

function Button:SetDesc(newDesc)
    self.Desc = newDesc
    if self.DescLabel then
        self.DescLabel.Text = newDesc
    end
end

function Button:SetLocked(isLocked)
    self.Locked = isLocked
    if self.Locked then
        self.ButtonFrame.BackgroundColor3 = self.Theme.BackgroundSecondary
        self.NameLabel.TextColor3 = self.Theme.TextSecondary
    else
        self.ButtonFrame.BackgroundColor3 = self.Theme.Background
        self.NameLabel.TextColor3 = self.Theme.Text
    end
end

return Button
