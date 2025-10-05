local Dialog = {}
Dialog.__index = Dialog

function Dialog.new(config, parentWindow)
    local self = setmetatable({}, Dialog)
    
    self.Title = config.Title or "Dialog"
    self.Desc = config.Desc or ""
    self.Icon = config.Icon or nil
    self.Options = config.Options or {}
    self.ParentWindow = parentWindow
    self.Gui = nil
    
    self:_Create()
    
    return self
end

function Dialog:_Create()
    if not self.ParentWindow or not self.ParentWindow.ScreenGui then
        warn("Dialog: Parent window GUI not found")
        return
    end
    
    -- Create dialog background (full screen transparent background)
    self.Background = Instance.new("TextButton")
    self.Background.Name = "DialogBackground"
    self.Background.Size = UDim2.new(1, 0, 1, 0)
    self.Background.Position = UDim2.new(0, 0, 0, 0)
    self.Background.BackgroundColor3 = Color3.new(0, 0, 0)
    self.Background.BackgroundTransparency = 0.5
    self.Background.BorderSizePixel = 0
    self.Background.Text = ""
    self.Background.AutoButtonColor = false
    self.Background.Parent = self.ParentWindow.ScreenGui
    self.Background.ZIndex = 20
    
    -- Main dialog container
    self.Gui = Instance.new("Frame")
    self.Gui.Name = "Dialog"
    self.Gui.Size = UDim2.new(0, 400, 0, 200)
    self.Gui.Position = UDim2.new(0.5, -200, 0.5, -100)
    self.Gui.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Gui.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.Gui.BorderSizePixel = 0
    self.Gui.Parent = self.Background
    self.Gui.ZIndex = 21
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.Gui
    
    -- Shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Parent = self.Gui
    shadow.ZIndex = 20
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = self.Title
    title.TextColor3 = Color3.fromRGB(248, 250, 252)
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = self.Gui
    title.ZIndex = 21
    
    -- Description
    local desc = Instance.new("TextLabel")
    desc.Name = "Desc"
    desc.Size = UDim2.new(1, -20, 1, -80)
    desc.Position = UDim2.new(0, 10, 0, 50)
    desc.BackgroundTransparency = 1
    desc.Text = self.Desc
    desc.TextColor3 = Color3.fromRGB(139, 148, 160)
    desc.TextSize = 14
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextWrapped = true
    desc.Font = Enum.Font.Gotham
    desc.Parent = self.Gui
    desc.ZIndex = 21
    
    -- Options container
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "Options"
    optionsContainer.Size = UDim2.new(1, -20, 0, 40)
    optionsContainer.Position = UDim2.new(0, 10, 1, -50)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.Parent = self.Gui
    optionsContainer.ZIndex = 21
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = optionsContainer
    
    -- Create option buttons
    for i, option in ipairs(self.Options) do
        self:_CreateOptionButton(option, optionsContainer, i)
    end
end

function Dialog:_CreateOptionButton(option, parent, index)
    local button = Instance.new("TextButton")
    button.Name = "Option_" .. index
    button.Size = UDim2.new(0, 80, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(33, 139, 255)
    button.BorderSizePixel = 0
    button.Text = option.Title
    button.TextColor3 = Color3.fromRGB(248, 250, 252)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if option.Callback and type(option.Callback) == "function" then
            option.Callback()
        end
        self:Destroy()
    end)
    
    button.Parent = parent
end

function Dialog:Show()
    if self.Gui then
        self.Background.Visible = true
        self.Gui.Visible = true
    end
end

function Dialog:Destroy()
    if self.Background then
        self.Background:Destroy()
        self.Background = nil
    end
    self.Gui = nil
end

return Dialog
