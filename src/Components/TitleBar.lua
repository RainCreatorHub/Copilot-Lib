local TitleBar = {}
TitleBar.__index = TitleBar

function TitleBar.new(config)
    local self = setmetatable({}, TitleBar)
    
    self.Title = config.Title or "Title"
    self.SubTitle = config.SubTitle or ""
    self.Parent = config.Parent
    
    self:_Create()
    
    return self
end

function TitleBar:_Create()
    -- Title bar container
    self.Container = Instance.new("Frame")
    self.Container.Name = "TitleBar"
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.Position = UDim2.new(0, 0, 0, 0)
    self.Container.BackgroundColor3 = Color3.fromRGB(22, 27, 34) -- GitHub header dark
    self.Container.BorderSizePixel = 0
    self.Container.Parent = self.Parent
    
    -- Bottom border
    local border = Instance.new("Frame")
    border.Name = "BottomBorder"
    border.Size = UDim2.new(1, 0, 0, 1)
    border.Position = UDim2.new(0, 0, 1, -1)
    border.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
    border.BorderSizePixel = 0
    border.Parent = self.Container
    
    -- Main title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -20, 0, 24)
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 10)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = Color3.fromRGB(248, 250, 252) -- GitHub light text
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Parent = self.Container
    
    -- Subtitle
    self.SubTitleLabel = Instance.new("TextLabel")
    self.SubTitleLabel.Name = "SubTitle"
    self.SubTitleLabel.Size = UDim2.new(1, -20, 0, 16)
    self.SubTitleLabel.Position = UDim2.new(0, 10, 0, 34)
    self.SubTitleLabel.BackgroundTransparency = 1
    self.SubTitleLabel.Text = self.SubTitle
    self.SubTitleLabel.TextColor3 = Color3.fromRGB(139, 148, 160) -- GitHub gray text
    self.SubTitleLabel.TextSize = 14
    self.SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.SubTitleLabel.Font = Enum.Font.Gotham
    self.SubTitleLabel.Parent = self.Container
end

function TitleBar:UpdateTitle(newTitle)
    self.Title = newTitle
    self.TitleLabel.Text = newTitle
end

function TitleBar:UpdateSubTitle(newSubTitle)
    self.SubTitle = newSubTitle
    self.SubTitleLabel.Text = newSubTitle
end

return TitleBar
