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

local NOTIFY_STACK = {}

local NOTIFY_MARGIN = 14
local NOTIFY_WIDTH = 340
local BUTTONS_HEIGHT = 36 -- altura do frame dos botões
local PADDING_TOP = 16
local PADDING_BOTTOM = 16
local PADDING_SIDES = 18
local TITLE_HEIGHT = 20
local TITLE_SPACING = 8
local BUTTONS_SPACING = 12 -- espaço entre os buttons e o texto abaixo

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

    -- Frame principal do Notify
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

    -- Container vertical para Title, Buttons, Texto
    local mainList = Instance.new("UIListLayout")
    mainList.Parent = self.Gui
    mainList.FillDirection = Enum.FillDirection.Vertical
    mainList.SortOrder = Enum.SortOrder.LayoutOrder
    mainList.Padding = UDim.new(0, 0)

    -- Padding geral
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, PADDING_TOP)
    padding.PaddingBottom = UDim.new(0, PADDING_BOTTOM)
    padding.PaddingLeft = UDim.new(0, PADDING_SIDES)
    padding.PaddingRight = UDim.new(0, PADDING_SIDES)
    padding.Parent = self.Gui

    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, TITLE_HEIGHT)
    title.BackgroundTransparency = 1
    title.Text = self.Config.Title
    title.TextColor3 = Color3.fromRGB(248, 250, 252)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Top
    title.Font = Enum.Font.GothamBold
    title.AutomaticSize = Enum.AutomaticSize.Y
    title.LayoutOrder = 1
    title.Parent = self.Gui
    title.ClipsDescendants = true

    -- Botões (sempre acima do texto)
    local buttonsFrame = Instance.new("Frame")
    buttonsFrame.Name = "ButtonsFrame"
    buttonsFrame.Size = UDim2.new(1, 0, 0, 0)
    buttonsFrame.BackgroundTransparency = 1
    buttonsFrame.AutomaticSize = Enum.AutomaticSize.Y
    buttonsFrame.LayoutOrder = 2
    buttonsFrame.Parent = self.Gui

    local buttonsList = Instance.new("UIListLayout")
    buttonsList.FillDirection = Enum.FillDirection.Horizontal
    buttonsList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    buttonsList.VerticalAlignment = Enum.VerticalAlignment.Center
    buttonsList.Padding = UDim.new(0, 6)
    buttonsList.Parent = buttonsFrame

    -- Adiciona botões se houver
    if #self.Config.Options > 0 then
        for i, option in ipairs(self.Config.Options) do
            local button = Instance.new("TextButton")
            button.Name = "Option_" .. i
            button.Size = UDim2.new(0, 90, 0, 28)
            button.BackgroundColor3 = Color3.fromRGB(33, 139, 255)
            button.BorderSizePixel = 0
            button.Text = option.Title
            button.TextColor3 = Color3.fromRGB(248, 250, 252)
            button.TextSize = 12
            button.Font = Enum.Font.Gotham
            button.AutoButtonColor = true
            button.LayoutOrder = i
            button.Parent = buttonsFrame
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = button

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
        end
        -- Espaço entre os botões e o texto
        local spacer = Instance.new("Frame")
        spacer.Size = UDim2.new(1, 0, 0, BUTTONS_SPACING)
        spacer.BackgroundTransparency = 1
        spacer.LayoutOrder = #self.Config.Options + 1
        spacer.Parent = self.Gui
    end

    -- Texto principal (autosize, nunca vaza, padding inferior)
    local desc = Instance.new("TextLabel")
    desc.Name = "Desc"
    desc.Size = UDim2.new(1, 0, 0, 0)
    desc.BackgroundTransparency = 1
    desc.Text = self.Config.Desc
    desc.TextColor3 = Color3.fromRGB(180, 188, 200)
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextWrapped = true
    desc.Font = Enum.Font.Gotham
    desc.AutomaticSize = Enum.AutomaticSize.Y
    desc.RichText = true
    desc.LayoutOrder = 10
    desc.Parent = self.Gui
    desc.ClipsDescendants = true

    if self.Config.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 22, 0, 22)
        icon.Position = UDim2.new(0, 0, 0, 0)
        icon.BackgroundTransparency = 1
        icon.Image = self.Config.Icon
        icon.Parent = self.Gui
        icon.ZIndex = 2
    end

    if self.Config.TimeE then
        self:_CreateProgressBar()
    end

    table.insert(NOTIFY_STACK, self)
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

function Notify:Show()
    if not self.Gui then return end

    self.Active = true
    self.Gui.Visible = true

    -- Organiza pilha
    self:_UpdateStackPositions(true)

    -- Animação para aparecer
    local y = self.Gui.Position.Y.Offset
    self.Gui.Position = self.Gui.Position + UDim2.new(0, 80, 0, 40)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    game:GetService("TweenService"):Create(self.Gui, tweenInfo, {Position = UDim2.new(1, -(NOTIFY_WIDTH + NOTIFY_MARGIN), 1, y)}):Play()

    if self.Config.TimeE then
        self:_StartDismissTimer()
    end
end

function Notify:_StartDismissTimer()
    if not self.Config.Time then return end
    if self.ProgressFill then
        local tweenInfo = TweenInfo.new(self.Config.Time, Enum.EasingStyle.Linear)
        game:GetService("TweenService"):Create(self.ProgressFill, tweenInfo, {Size = UDim2.new(0, 0, 1, 0)}):Play()
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
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    local tween = game:GetService("TweenService"):Create(self.Gui, tweenInfo, {Position = self.Gui.Position + UDim2.new(0, 80, 0, 20), BackgroundTransparency = 1})
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
