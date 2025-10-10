-- Notify.lua
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
    Icon = nil,
    Options = {}
}

local NOTIFY_STACK = {}
local NOTIFY_MARGIN = 10
local NOTIFY_WIDTH = 300
local NOTIFY_HEIGHT = 90

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

    -- Frame principal da notificação
    self.Gui = Instance.new("Frame")
    self.Gui.Name = "Notification"
    self.Gui.Size = UDim2.new(0, NOTIFY_WIDTH, 0, NOTIFY_HEIGHT)
    self.Gui.Position = UDim2.new(1, -(NOTIFY_WIDTH + NOTIFY_MARGIN), 1, -(NOTIFY_HEIGHT + NOTIFY_MARGIN))
    self.Gui.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.Gui.BorderSizePixel = 0
    self.Gui.Visible = false
    self.Gui.ClipsDescendants = false
    self.Gui.ZIndex = 1000
    self.Gui.Parent = self.ParentWindow.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.Gui

    -- Borda elegante
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(48, 54, 61)
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = self.Gui

    -- Sombra sutil
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.85
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = 999
    shadow.Parent = self.Gui

    -- Barra de acento no topo
    local accentBar = Instance.new("Frame")
    accentBar.Name = "AccentBar"
    accentBar.Size = UDim2.new(1, 0, 0, 3)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = Color3.fromRGB(33, 139, 255)
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 1001
    accentBar.Parent = self.Gui

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 8)
    accentCorner.Parent = accentBar

    -- Ícone (se fornecido)
    local contentStartX = 12
    if self.Config.Icon then
        local iconContainer = Instance.new("Frame")
        iconContainer.Name = "IconContainer"
        iconContainer.Size = UDim2.new(0, 32, 0, 32)
        iconContainer.Position = UDim2.new(0, 12, 0, 16)
        iconContainer.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
        iconContainer.BorderSizePixel = 0
        iconContainer.ZIndex = 1001
        iconContainer.Parent = self.Gui

        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(0, 6)
        iconCorner.Parent = iconContainer

        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0.5, 0, 0.5, 0)
        icon.AnchorPoint = Vector2.new(0.5, 0.5)
        icon.BackgroundTransparency = 1
        icon.Image = ResolveIcon(self.Config.Icon)
        icon.ImageColor3 = Color3.fromRGB(100, 200, 255)
        icon.ZIndex = 1002
        icon.Parent = iconContainer

        contentStartX = 52
    end

    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -(contentStartX + 12), 0, 18)
    title.Position = UDim2.new(0, contentStartX, 0, 14)
    title.BackgroundTransparency = 1
    title.Text = self.Config.Title
    title.TextColor3 = Color3.fromRGB(248, 250, 252)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.ZIndex = 1001
    title.Parent = self.Gui

    -- Descrição
    local desc = Instance.new("TextLabel")
    desc.Name = "Desc"
    desc.Size = UDim2.new(1, -(contentStartX + 12), 0, 32)
    desc.Position = UDim2.new(0, contentStartX, 0, 34)
    desc.BackgroundTransparency = 1
    desc.Text = self.Config.Desc
    desc.TextColor3 = Color3.fromRGB(139, 148, 160)
    desc.TextSize = 11
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextWrapped = true
    desc.Font = Enum.Font.Gotham
    desc.ZIndex = 1001
    desc.Parent = self.Gui

    -- Botões de opções (se fornecidos)
    if #self.Config.Options > 0 then
        local optionsContainer = Instance.new("Frame")
        optionsContainer.Name = "Options"
        optionsContainer.Size = UDim2.new(1, -16, 0, 24)
        optionsContainer.Position = UDim2.new(0, 8, 0, 60)
        optionsContainer.BackgroundTransparency = 1
        optionsContainer.ZIndex = 1001
        optionsContainer.Parent = self.Gui

        local listLayout = Instance.new("UIListLayout")
        listLayout.FillDirection = Enum.FillDirection.Horizontal
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        listLayout.Padding = UDim.new(0, 6)
        listLayout.Parent = optionsContainer

        for i, option in ipairs(self.Config.Options) do
            local button = Instance.new("TextButton")
            button.Name = "Option_" .. i
            button.Size = UDim2.new(0, 65, 0, 24)
            button.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
            button.BorderSizePixel = 0
            button.Text = option.Title
            button.TextColor3 = Color3.fromRGB(248, 250, 252)
            button.TextSize = 11
            button.Font = Enum.Font.GothamBold
            button.AutoButtonColor = false
            button.ZIndex = 1002
            button.Parent = optionsContainer

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = button

            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Color3.fromRGB(100, 200, 255)
            btnStroke.Thickness = 1
            btnStroke.Transparency = 0.7
            btnStroke.Parent = button

            -- Animações do botão
            local TweenService = game:GetService("TweenService")
            
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 200, 255)}):Play()
                TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(10, 10, 15)}):Play()
                TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
            end)

            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(48, 54, 61)}):Play()
                TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(248, 250, 252)}):Play()
                TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
            end)

            button.MouseButton1Click:Connect(function()
                if option.Callback and type(option.Callback) == "function" then
                    option.Callback()
                end
                self:Dismiss()
            end)
        end

        -- Ajusta altura se tiver botões
        self.Gui.Size = UDim2.new(0, NOTIFY_WIDTH, 0, 94)
    end

    table.insert(NOTIFY_STACK, self)
end

function Notify:Show()
    if not self.Gui then return end
    
    self.Active = true
    self.Gui.Visible = true
    
    local TweenService = game:GetService("TweenService")
    
    -- Animação de entrada elegante
    self.Gui.Position = UDim2.new(1, 20, 1, -(self.Gui.Size.Y.Offset + NOTIFY_MARGIN))
    self.Gui.BackgroundTransparency = 1
    
    for _, child in pairs(self.Gui:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            child.TextTransparency = 1
        elseif child:IsA("ImageLabel") and child.Name ~= "Shadow" then
            child.ImageTransparency = 1
        elseif child:IsA("Frame") and child.Name ~= "Shadow" then
            child.BackgroundTransparency = 1
        end
    end
    
    -- Tween de entrada
    TweenService:Create(
        self.Gui,
        TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -(NOTIFY_WIDTH + NOTIFY_MARGIN), 1, -(self.Gui.Size.Y.Offset + NOTIFY_MARGIN))}
    ):Play()
    
    TweenService:Create(
        self.Gui,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0}
    ):Play()
    
    task.wait(0.1)
    
    for _, child in pairs(self.Gui:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        elseif child:IsA("ImageLabel") and child.Name ~= "Shadow" then
            TweenService:Create(child, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
        elseif child:IsA("Frame") and child.Name ~= "Shadow" then
            TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        end
    end
end

function Notify:Dismiss()
    if not self.Active or not self.Gui then return end
    
    self.Active = false
    local TweenService = game:GetService("TweenService")
    
    -- Animação de saída
    TweenService:Create(
        self.Gui,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(1, 20, 1, -(self.Gui.Size.Y.Offset + NOTIFY_MARGIN))}
    ):Play()
    
    TweenService:Create(
        self.Gui,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {BackgroundTransparency = 1}
    ):Play()
    
    task.wait(0.3)
    
    -- Remove do stack
    for i, notify in ipairs(NOTIFY_STACK) do
        if notify == self then
            table.remove(NOTIFY_STACK, i)
            break
        end
    end
    
    if self.Gui then
        self.Gui:Destroy()
        self.Gui = nil
    end
end

return Notify
