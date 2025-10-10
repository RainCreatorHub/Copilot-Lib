local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Icons.lua"))()
local function ResolveIcon(icon)
    if type(icon) == "number" then
        return "rbxassetid://" .. icon
    elseif type(icon) == "string" then
        if icon:sub(1, 13) == "rbxassetid://" then
            return icon
        elseif Icons[icon] then
            return "rbxassetid://" .. Icons[icon]
        end
    end
    return nil
end

local Dialog = {}
Dialog.__index = Dialog

function Dialog.new(config, parentWindow)
    local self = setmetatable({}, Dialog)
    self.Title = config.Title or "Dialog"
    self.Desc = config.Desc or ""
    self.Icon = config.Icon
    self.Options = config.Options or {}
    self.ParentWindow = parentWindow
    self.Gui = nil
    self:_Create()
    return self
end

function Dialog:_Create()
    if not self.ParentWindow or not self.ParentWindow.MainFrame then
        warn("Dialog: Parent window MainFrame not found")
        return
    end
    self.Background = Instance.new("Frame")
    self.Background.Name = "DialogBackground"
    self.Background.Size = UDim2.new(1, 0, 1, 0)
    self.Background.Position = UDim2.new(0, 0, 0, 0)
    self.Background.BackgroundColor3 = Color3.new(0, 0, 0)
    self.Background.BackgroundTransparency = 0.7
    self.Background.BorderSizePixel = 0
    self.Background.ZIndex = 15
    self.Background.Visible = false
    self.Background.Parent = self.ParentWindow.MainFrame

    self.Gui = Instance.new("Frame")
    self.Gui.Name = "Dialog"
    self.Gui.Size = UDim2.new(0, 300, 0, 200)
    self.Gui.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Gui.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Gui.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.Gui.BorderSizePixel = 1
    self.Gui.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.Gui.ZIndex = 21
    self.Gui.Visible = false
    self.Gui.Parent = self.Background

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.Gui

    if self.Icon then
        local iconLabel = Instance.new("ImageLabel")
        iconLabel.Name = "DialogIcon"
        iconLabel.Size = UDim2.new(0, 24, 0, 24)
        iconLabel.Position = UDim2.new(0, 12, 0, 8)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = ResolveIcon(self.Icon)
        iconLabel.Parent = self.Gui
    end

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 15, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = self.Title
    title.TextColor3 = Color3.fromRGB(248, 250, 252)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 18
    title.Parent = self.Gui

    local desc = Instance.new("TextLabel")
    desc.Name = "Desc"
    desc.Size = UDim2.new(1, -20, 0, 70)
    desc.Position = UDim2.new(0, 10, 0, 46)
    desc.BackgroundTransparency = 1
    desc.Text = self.Desc
    desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextWrapped = true
    desc.Font = Enum.Font.Gotham
    desc.ZIndex = 17
    desc.Parent = self.Gui

    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "Options"
    optionsContainer.Size = UDim2.new(1, -20, 0, 40)
    optionsContainer.Position = UDim2.new(0, 10, 1, -50)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.ZIndex = 17
    optionsContainer.Parent = self.Gui

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = optionsContainer

    for i, option in ipairs(self.Options) do
        local button = Instance.new("TextButton")
        button.Name = "Option_" .. i
        button.Size = UDim2.new(0, 80, 0, 32)
        button.BackgroundColor3 = Color3.fromRGB(33, 139, 255)
        button.BorderSizePixel = 0
        button.Text = option.Title
        button.TextColor3 = Color3.fromRGB(248, 250, 252)
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.ZIndex = 18
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
        button.MouseButton1Click:Connect(function()
            if option.Callback and type(option.Callback) == "function" then
                option.Callback()
            end
            self:Destroy()
        end)
        button.Parent = optionsContainer
    end
end

function Dialog:Show()
    if self.Gui and not self.Background.Visible then
        self.Background.Visible = true
        self.Gui.Visible = true
    end
end

function Dialog:Destroy()
    if self.Background then
        self.Background:Destroy()
        self.Background = nil
        if self.ParentWindow and self.ParentWindow.ClearActiveDialog then
            self.ParentWindow:ClearActiveDialog()
        end
    end
    self.Gui = nil
end

return Dialog
