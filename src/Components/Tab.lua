local Tab = {}
Tab.__index = Tab

function Tab.new(config, parent)
    local self = setmetatable({}, Tab)
    
    self.Name = config.Name or "New Tab"
    self.Parent = parent
    self.Visible = false
    self.Elements = {}
    
    self:_Create()
    
    return self
end

function Tab:_Create()
    self.Container = Instance.new("Frame")
    self.Container.Name = "Tab_" .. self.Name
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.Position = UDim2.new(0, 0, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.Visible = false
    self.Container.Parent = self.Parent
    
    self.ContentLabel = Instance.new("TextLabel")
    self.ContentLabel.Name = "ContentLabel"
    self.ContentLabel.Size = UDim2.new(1, 0, 1, 0)
    self.ContentLabel.Position = UDim2.new(0, 0, 0, 0)
    self.ContentLabel.BackgroundTransparency = 1
    self.ContentLabel.Text = self.Name .. " Content"
    self.ContentLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.ContentLabel.TextSize = 14
    self.ContentLabel.Font = Enum.Font.Gotham
    self.ContentLabel.Parent = self.Container
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
        if config.Callback then
            config.Callback()
        end
    end)
    
    button.Parent = self.Container
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
    label.Parent = self.Container
end

return Tab
