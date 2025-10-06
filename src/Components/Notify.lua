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

local NOTIFY_STACK = {}

local NOTIFY_MARGIN = 14
local NOTIFY_WIDTH = 340

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
    self.Gui.Size = UDim2.new(0, NOTIFY_WIDTH, 0, 120)
    self.Gui.Position = UDim2.new(1, -(NOTIFY_WIDTH + NOTIFY_MARGIN), 1, -120 - NOTIFY_MARGIN)
    self.Gui.BackgroundColor3 = Color3.fromRGB(38, 43, 51)
    self.Gui.BorderSizePixel = 0
    self.Gui.Visible = false
    self.Gui.Parent = self.ParentWindow.ScreenGui
    self.Gui.ClipsDescendants = true
    self.Gui.AutomaticSize = Enum.AutomaticSize.Y
    self.Gui.ZIndex = 1000

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = self.Gui

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.82
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 28, 1, 28)
    shadow.Position = UDim2.new(0, -14, 0, -14)
    shadow.BackgroundTransparency = 1
    shadow.Parent = self.Gui
    shadow.ZIndex = 0

    if self.Config.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 22, 0, 22)
        icon.Position = UDim2.new(0, 14, 0, 14)
        icon.BackgroundTransparency = 1
        icon.Image = ResolveIcon(self.Config.Icon)
        icon.Parent = self.Gui
        icon.ZIndex = 2
    end

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, self.Config.Icon and -58 or -28, 0, 20)
    title.Position = UDim2.new(0, self.Config.Icon and 44 or 14, 0, 14)
    title.BackgroundTransparency = 1
    title.Text = self.Config.Title
    title.TextColor3 = Color3.fromRGB(248, 250, 252)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 2
    title.Parent = self.Gui

    local desc = Instance.new("TextLabel")
    desc.Name = "Desc"
    desc.Size = UDim2.new(1, self.Config.Icon and -58 or -28, 0, 40)
    desc.Position = UDim2.new(0, self.Config.Icon and 44 or 14, 0, 36)
    desc.BackgroundTransparency = 1
    desc.Text = self.Config.Desc
    desc.TextColor3 = Color3.fromRGB(139, 148, 160)
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextWrapped = true
    desc.Font = Enum.Font.Gotham
    desc.ZIndex = 2
    desc.Parent = self.Gui

    if #self.Config.Options > 0 then
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
            local button = Instance.new("TextButton")
            button.Name = "Option_" .. i
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
            button.Parent = optionsContainer
        end
    end
    table.insert(NOTIFY_STACK, self)
end

function Notify:Show()
    if not self.Gui then return end
    self.Active = true
    self.Gui.Visible = true
end

function Notify:Dismiss()
    if not self.Active or not self.Gui then return end
    self.Active = false
    self.Gui:Destroy()
    self.Gui = nil
end

return Notify
