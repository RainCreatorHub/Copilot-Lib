local Button = {}
Button.__index = Button

function Button.new(config, parent)
    local self = setmetatable({}, Button)
    
    self.Name = config.Name or "Button"
    self.Desc = config.Desc or ""
    self.Callback = config.Callback or function() end
    self.Parent = parent
    
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
    
    -- Button background
    self.ButtonFrame = Instance.new("TextButton")
    self.ButtonFrame.Name = "Button"
    self.ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
    self.ButtonFrame.Position = UDim2.new(0, 0, 0, 0)
    self.ButtonFrame.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.ButtonFrame.BorderSizePixel = 0
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
    self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
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
    self.DescLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
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
                {BackgroundColor3 = Color3.fromRGB(40, 46, 55)}
            ):Play()
        end
    end)
    
    self.ButtonFrame.MouseLeave:Connect(function()
        if not self.Locked then
            game:GetService("TweenService"):Create(
                self.ButtonFrame, 
                TweenInfo.new(0.2), 
                {BackgroundColor3 = Color3.fromRGB(33, 38, 45)}
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
                {BackgroundColor3 = Color3.fromRGB(33, 139, 255)}
            ):Play()
            
            wait(0.1)
            
            game:GetService("TweenService"):Create(
                self.ButtonFrame, 
                TweenInfo.new(0.1), 
                {BackgroundColor3 = Color3.fromRGB(33, 38, 45)}
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
        self.ButtonFrame.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
        self.NameLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    else
        self.ButtonFrame.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
        self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    end
end

return Button
