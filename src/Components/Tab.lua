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
    -- Main tab container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Tab_" .. self.Name
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.Position = UDim2.new(0, 0, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.Visible = false
    self.Container.Parent = self.Parent
    
    -- You can add tab-specific content here
    -- For now, just a placeholder label
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
    -- This would create a button element in the tab
    -- Implementation for button creation would go here
    print("Adding button to tab:", self.Name)
end

function Tab:AddLabel(config)
    -- This would create a label element in the tab
    print("Adding label to tab:", self.Name)
end

-- Add more element methods as needed

return Tab
