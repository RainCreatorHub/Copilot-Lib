local Notify = {}
Notify.__index = Notify

local DEFAULT_CONFIG = {
    Title = "Notification",
    Desc = "",
    TimeE = true, -- Time Enabled
    Time = 5,
    Icon = nil,
    Options = {}
}

local NOTIFY_STACK = {} -- Mantém referências para organizar as notificações na pilha

local NOTIFY_MARGIN = 14
local NOTIFY_WIDTH = 320
local NOTIFY_MAX_HEIGHT = 200
local NOTIFY_MIN_HEIGHT = 64

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

-- Calcula posição da notificação na pilha
local function getNotifyStackY(index, height)
    local y = -NOTIFY_MARGIN
    for i = 1, index - 1 do
        local prev = NOTIFY_STACK[i]
        if prev and prev.Gui and prev.Gui.Visible then
            y = y - prev.Gui.AbsoluteSize.Y - NOTIFY_MARGIN
        end
    end
    return y - height
end

function Notify:_Create()
    if not self.ParentWindow or not self.ParentWindow.ScreenGui then
        warn("Notify: Parent window GUI not found")
        return
    end

    -- Calcula altura baseada no texto (ajustável)
    local tempText = Instance.new("TextLabel")
    tempText.Size = UDim2.new(1, -28, 0, 0)
    tempText.Text = self.Config.Desc
    tempText.TextWrapped = true
    tempText.TextSize = 12
    tempText.Font = Enum.Font.Gotham
    tempText.BackgroundTransparency = 1
    tempText.Parent = self.ParentWindow.ScreenGui
    tempText.AutomaticSize = Enum.AutomaticSize.Y
    tempText.Visible = false
    tempText.RichText = true

    -- Força cálculo
    wait()
    local descH = math.clamp(tempText.TextBounds.Y, 24, 96)
    tempText:Destroy()

    local height = math.clamp(50 + descH, NOTIFY_MIN_HEIGHT, NOTIFY_MAX_HEIGHT)

    self.Gui = Instance.new("Frame")
    self.Gui.Name = "Notification"
    self.Gui.Size = UDim2.new(0, NOTIFY_WIDTH, 0, height)
    self.Gui.Position = UDim2.new(1, -(NOTIFY_WIDTH + NOTIFY_MARGIN), 1, 100)
    self.Gui.BackgroundColor3 = Color3.fromRGB(38, 43, 51)
    self.Gui.BorderSizePixel = 0
    self.Gui.Visible = false
    self.Gui.Parent = self.ParentWindow.ScreenGui
    self.Gui.AutomaticSize = Enum.AutomaticSize.None
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
        icon.Image = self.Config.Icon
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
    desc.Size = UDim2.new(1, self.Config.Icon and -58 or -28, 0, descH)
    desc.Position = UDim2.new(0, self.Config.Icon and 44 or 14, 0, 36)
    desc.BackgroundTransparency = 1
    desc.Text = self.Config.Desc
    desc.TextColor3 = Color3.fromRGB(180, 188, 200)
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextWrapped = true
    desc.Font = Enum.Font.Gotham
    desc.ZIndex = 2
    desc.RichText = true
    desc.Parent = self.Gui

    if #self.Config.Options > 0 then
        self:_CreateOptions()
    end

    if self.Config.TimeE then
        self:_CreateProgressBar()
    end

    table.insert(NOTIFY_STACK, self)
end

function Notify:_CreateOptions()
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "Options"
    optionsContainer.Size = UDim2.new(1, -20, 0, 28)
    optionsContainer.Position = UDim2.new(0, 10, 1, -38)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.Parent = self.Gui

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = optionsContainer

    for i, option in ipairs(self.Config.Options) do
        self:_CreateOptionButton(option, optionsContainer, i)
    end
end

function Notify:_CreateOptionButton(option, parent, index)
    local button = Instance.new("TextButton")
    button.Name = "Option_" .. index
    button.Size = UDim2.new(0, 80, 0, 22)
    button.BackgroundColor3 = Color3.fromRGB(33, 139, 255)
    button.BorderSizePixel = 0
    button.Text = option.Title
    button.TextColor3 = Color3.fromRGB(248, 250, 252)
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.ZIndex = 2

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button

    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.18),
            {BackgroundColor3 = Color3.fromRGB(66, 153, 225)}
        ):Play()
    end)

    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.18),
            {BackgroundColor3 = Color3.fromRGB(33, 139, 255)}
        ):Play()
    end)

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

function Notify:_UpdateStackPositions(animate)
    local y = -NOTIFY_MARGIN
    for i, notify in ipairs(NOTIFY_STACK) do
        if notify and notify.Gui and notify.Gui.Visible then
            local height = notify.Gui.AbsoluteSize.Y
            local pos = UDim2.new(1, -(NOTIFY_WIDTH + NOTIFY_MARGIN), 1, y - height)
            if animate then
                game:GetService("TweenService"):Create(notify.Gui, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = pos}):Play()
            else
                notify.Gui.Position = pos
            end
            y = y - height - NOTIFY_MARGIN
        end
    end
end

function Notify:_StackIndex()
    for i, v in ipairs(NOTIFY_STACK) do
        if v == self then return i end
    end
    return #NOTIFY_STACK
end

function Notify:Show()
    if not self.Gui then return end

    self.Active = true
    self.Gui.Visible = true

    -- Se há uma notificação ativa (antiga) na base, deslize ela para direita para sair!
    for i, notify in ipairs(NOTIFY_STACK) do
        if notify ~= self and notify.Active and notify.Gui then
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            -- Move para fora para a direita
            game:GetService("TweenService"):Create(
                notify.Gui,
                tweenInfo,
                {Position = notify.Gui.Position + UDim2.new(0, NOTIFY_WIDTH + 60, 0, 0), BackgroundTransparency = 1}
            ):Play()
            -- Ao fim, destrói
            task.spawn(function()
                wait(0.31)
                if notify.Gui then
                    notify.Gui:Destroy()
                    notify.Gui = nil
                    notify.Active = false
                end
            end)
        end
    end

    -- Organiza pilha, nova aparece embaixo
    self:_UpdateStackPositions(true)

    -- Animação para aparecer
    local endY = getNotifyStackY(self:_StackIndex(), self.Gui.AbsoluteSize.Y)
    self.Gui.Position = UDim2.new(1, -(NOTIFY_WIDTH + NOTIFY_MARGIN), 1, endY + 40)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = game:GetService("TweenService"):Create(self.Gui, tweenInfo, {Position = UDim2.new(1, -(NOTIFY_WIDTH + NOTIFY_MARGIN), 1, endY)})
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

    -- Animação para sair
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    local tween = game:GetService("TweenService"):Create(self.Gui, tweenInfo, {Position = self.Gui.Position + UDim2.new(0, NOTIFY_WIDTH + 60, 0, 0), BackgroundTransparency = 1})
    tween:Play()

    tween.Completed:Connect(function()
        if self.Gui then
            self.Gui:Destroy()
            self.Gui = nil
            self:_UpdateStackPositions(true)
        end
    end)
end

return Notify
