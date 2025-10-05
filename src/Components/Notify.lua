local Notify = {}
Notify.__index = Notify

local DEFAULT_CONFIG = {
    Title = "Notification",
    Desc = "",
    TimeE = true,
    Time = 5,
    Icon = nil,
    Options = {}
}

function Notify.new(config, parentWindow)
    local self = setmetatable({}, Notify)
    
    self.Config = setmetatable(config or {}, { __index = DEFAULT_CONFIG })
    self.ParentWindow = parentWindow
    self.Gui = nil
    self.Active = false
    
    self:_Create()
    self:Show()
    
    return self
end

function Notify:_Create()
    if not self.ParentWindow or not self.ParentWindow.ScreenGui then
        warn("Notify: Parent window GUI not found")
        return
    end
    
    self.Gui = Instance.new("Frame")
    self.Gui.Name = "Notification"
    self.Gui.Size = UDim2.new(0, 300, 0, 120)
    self.Gui.Position = UDim2.new(1, -320, 1, -150)
    self.Gui.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.Gui.BorderSizePixel = 0
    self.Gui.Visible = false
    self.Gui.Parent = self.ParentWindow.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.Gui
    
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
    shadow.ZIndex = 0
    
    if self.Config.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0, 10, 0, 10)
        icon.BackgroundTransparency = 1
        icon.Image = self.Config.Icon
        icon.Parent = self.Gui
    end
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, self.Config.Icon and -40 or -20, 0, 20)
    title.Position = UDim2.new(0, self.Config.Icon and 40 or 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = self.Config.Title
    title.TextColor3 = Color3.fromRGB(248, 250, 252)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = self.Gui
    
    local desc = Instance.new("TextLabel")
    desc.Name = "Desc"
    desc.Size = UDim2.new(1, -20, 0, 40)
    desc.Position = UDim2.new(0, 10, 0, 35)
    desc.BackgroundTransparency = 1
    desc.Text = self.Config.Desc
    desc.TextColor3 = Color3.fromRGB(139, 148, 160)
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextWrapped = true
    desc.Font = Enum.Font.Gotham
    desc.Parent = self.Gui
    
    if #self.Config.Options > 0 then
        self:_CreateOptions()
    end
    
    if self.Config.TimeE then
        self:_CreateProgressBar()
    end
end

function Notify:_CreateOptions()
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "Options"
    optionsContainer.Size = UDim2.new(1, -10, 0, 25)
    optionsContainer.Position = UDim2.new(0, 5, 1, -30)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.Parent = self.Gui
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = optionsContainer
    
    for i, option in ipairs(self.Config.Options) do
        self:_CreateOptionButton(option, optionsContainer, i)
    end
end

function Notify:_CreateOptionButton(option, parent, index)
    local button = Instance.new("TextButton")
    button.Name = "Option_" .. index
    button.Size = UDim2.new(0, 70, 0, 22)
    button.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
    button.BorderSizePixel = 0
    button.Text = option.Title
    button.TextColor3 = Color3.fromRGB(248, 250, 252)
    button.TextSize = 11
    button.Font = Enum.Font.Gotham
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if option.Callback and type(option.Callback) == "function" then
            option.Callback()
        end
        self:Dismiss()
    end)
    
    button.Parent = parent
end

function Notify:_CreateProgressBar()
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = self.Gui
    
    local progressFill = Instance.new("Frame")
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(33, 139, 255)
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 2)
    corner.Parent = progressFill
    
    self.ProgressFill = progressFill
end

function Notify:Show()
    if not self.Gui then return end
    
    self.Active = true
    self.Gui.Visible = true
    
    self.Gui.Position = UDim2.new(1, -320, 1, 100)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = game:GetService("TweenService"):Create(self.Gui, tweenInfo, {Position = UDim2.new(1, -320, 1, -150)})
    tween:Play()
    
    if self.Config.TimeE then
        self:_StartDismissTimer()
    end
end

function Notify:_StartDismissTimer()
    if not self.Config.Time then return end
    
    if self.ProgressFill then
        local tweenInfo = TweenInfo.new(self.Config.Time, Enum.EasingStyle.Linear)
        local tween = game:GetService("TweenService"):Create(self.ProgressFill, tweenInfo, {Size = UDim2.new(0, 0, 1, 0)})
        tween:Play()
    end
    
    task.delay(self.Config.Time, function()
        if self.Active then
            self:Dismiss()
        end
    end)
end

function Notify:Dismiss()
    if not self.Active or not self.Gui then return end
    
    self.Active = false
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    local tween = game:GetService("TweenService"):Create(self.Gui, tweenInfo, {Position = UDim2.new(1, -320, 1, 100)})
    tween:Play()
    
    tween.Completed:Connect(function()
        if self.Gui then
            self.Gui:Destroy()
            self.Gui = nil
        end
    end)
end

return Notify
