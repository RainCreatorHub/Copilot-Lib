Ola deep seek, aqui está a estrutura completa do que estamos fazendo:
```lua
init.lua
src/
  Components/
    Themes/
      Dark.lua
      Light.lua
    Dialog.lua
    Notify.lua
    Tab.lua
    TitleBar.lua
    Window.lua
  Elements/
    Toggle.lua
    Button.lua
    Paragraph.lua
    Section.lua
```

Agora o código de cada coisa.

# init.lua
```lua
local Deep_Lib = {}

-- Cache para módulos já carregados
Deep_Lib._LoadedModules = {}
Deep_Lib._BaseUrl = "https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/"

-- Função personalizada para carregar módulos do GitHub
function Deep_Lib._loadModule(modulePath)
    if Deep_Lib._LoadedModules[modulePath] then
        return Deep_Lib._LoadedModules[modulePath]
    end
    
    local fullUrl = Deep_Lib._BaseUrl .. modulePath
    local success, result = pcall(function()
        local response = game:HttpGet(fullUrl, true)
        return loadstring(response)()
    end)
    
    if not success then
        error("[Deep_Lib] Failed to load module: " .. modulePath .. " | Error: " .. tostring(result))
    end
    
    Deep_Lib._LoadedModules[modulePath] = result
    return result
end

-- Função principal para criar janelas
function Deep_Lib:Window(config)
    local WindowModule = self._loadModule("src/Components/Window.lua")
    return WindowModule.new(config)
end

-- Função auxiliar para carregar componentes internos
function Deep_Lib._loadComponent(componentName)
    return Deep_Lib._loadModule("src/Components/" .. componentName .. ".lua")
end

return Deep_Lib
```

# src/Components/Themes/Light.lua
```lua
local Light = {
    Background = Color3.fromRGB(255, 255, 255),
    BackgroundSecondary = Color3.fromRGB(248, 249, 250),
    BackgroundTertiary = Color3.fromRGB(241, 243, 245),
    Text = Color3.fromRGB(33, 37, 41),
    TextSecondary = Color3.fromRGB(108, 117, 125),
    Accent = Color3.fromRGB(33, 139, 255),
    Border = Color3.fromRGB(222, 226, 230),
    Shadow = Color3.new(0, 0, 0),
    Error = Color3.fromRGB(220, 53, 69),
    Success = Color3.fromRGB(40, 167, 69),
    Warning = Color3.fromRGB(255, 193, 7)
}

return Light
```

# src/Components/Themes/Dark.lua
```lua
local Dark = {
    Background = Color3.fromRGB(33, 38, 45),
    BackgroundSecondary = Color3.fromRGB(25, 30, 35),
    BackgroundTertiary = Color3.fromRGB(22, 27, 34),
    Text = Color3.fromRGB(248, 250, 252),
    TextSecondary = Color3.fromRGB(139, 148, 160),
    Accent = Color3.fromRGB(33, 139, 255),
    Border = Color3.fromRGB(48, 54, 61),
    Shadow = Color3.new(0, 0, 0),
    Error = Color3.fromRGB(220, 53, 69),
    Success = Color3.fromRGB(40, 167, 69),
    Warning = Color3.fromRGB(255, 193, 7)
}

return Dark
```

# src/Components/Dialog.lua
```lua
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
    if not self.ParentWindow or not self.ParentWindow.MainFrame then
        warn("Dialog: Parent window MainFrame not found")
        return
    end
    
    -- Create dialog background (overlay escuro) DENTRO do MainFrame
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
    
    -- Main dialog container - Tamanho 300x270, CENTRALIZADO no MainFrame
    self.Gui = Instance.new("Frame")
    self.Gui.Name = "Dialog"
    self.Gui.Size = UDim2.new(0, 300, 0, 200) -- Altura reduzida
    self.Gui.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.Gui.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Gui.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.Gui.BorderSizePixel = 1
    self.Gui.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.Gui.ZIndex = 16
    self.Gui.Visible = false
    self.Gui.Parent = self.Background
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.Gui
    
    -- Glow effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Image = "rbxassetid://8992230675"
    glow.ImageColor3 = Color3.fromRGB(33, 139, 255)
    glow.ImageTransparency = 0.6
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(23, 23, 277, 277)
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.ZIndex = 15
    glow.Parent = self.Gui
    
    -- Header com gradiente - ALTURA REDUZIDA
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 30) -- Altura reduzida de 40 para 30
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
    header.BorderSizePixel = 0
    header.ZIndex = 16
    header.Parent = self.Gui
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(33, 139, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(29, 112, 214))
    })
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    -- Corner apenas no topo do header
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- Ajustar corner do header para não afetar os cantos inferiores
    local mask = Instance.new("Frame")
    mask.Name = "Mask"
    mask.Size = UDim2.new(1, 0, 1, 12)
    mask.Position = UDim2.new(0, 0, 0, 0)
    mask.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
    mask.BorderSizePixel = 0
    mask.ZIndex = 16
    mask.Parent = header
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = self.Title
    title.TextColor3 = Color3.fromRGB(248, 250, 252)
    title.TextSize = 14 -- Texto menor
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 17
    title.Parent = header
    
    -- Descrição ABAIXO DO TÍTULO
    local descContainer = Instance.new("Frame")
    descContainer.Name = "DescContainer"
    descContainer.Size = UDim2.new(1, -20, 0, 100) -- Altura ajustada
    descContainer.Position = UDim2.new(0, 10, 0, 35) -- POSICIONADA ABAIXO DO HEADER
    descContainer.BackgroundTransparency = 1
    descContainer.ZIndex = 16
    descContainer.Parent = self.Gui
    
    -- ScrollingFrame para descrição
    local descScroll = Instance.new("ScrollingFrame")
    descScroll.Name = "DescScroll"
    descScroll.Size = UDim2.new(1, 0, 1, 0)
    descScroll.Position = UDim2.new(0, 0, 0, 0)
    descScroll.BackgroundTransparency = 1
    descScroll.BorderSizePixel = 0
    descScroll.ScrollBarThickness = 4
    descScroll.ScrollBarImageColor3 = Color3.fromRGB(48, 54, 61)
    descScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    descScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    descScroll.ZIndex = 16
    descScroll.Parent = descContainer
    
    -- Descrição VISÍVEL
    local desc = Instance.new("TextLabel")
    desc.Name = "Desc"
    desc.Size = UDim2.new(1, 0, 0, 0)
    desc.Position = UDim2.new(0, 0, 0, 0)
    desc.BackgroundTransparency = 1
    desc.Text = self.Desc
    desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    desc.TextSize = 12 -- Texto menor
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextWrapped = true
    desc.Font = Enum.Font.Gotham
    desc.ZIndex = 16
    desc.AutomaticSize = Enum.AutomaticSize.Y
    desc.Parent = descScroll
    
    -- Atualizar CanvasSize quando o texto mudar
    desc:GetPropertyChangedSignal("TextBounds"):Connect(function()
        descScroll.CanvasSize = UDim2.new(0, 0, 0, desc.TextBounds.Y + 10)
    end)
    
    -- Inicializar CanvasSize
    task.spawn(function()
        wait(0.1)
        descScroll.CanvasSize = UDim2.new(0, 0, 0, desc.TextBounds.Y + 10)
    end)
    
    -- Options container - POSIÇÃO FIXA NA PARTE INFERIOR
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "Options"
    optionsContainer.Size = UDim2.new(1, -20, 0, 40)
    optionsContainer.Position = UDim2.new(0, 10, 1, -50)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.ZIndex = 16
    optionsContainer.Parent = self.Gui
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = optionsContainer
    
    -- Create option buttons
    for i, option in ipairs(self.Options) do
        self:_CreateOptionButton(option, optionsContainer, i)
    end
end

function Dialog:_CreateOptionButton(option, parent, index)
    local button = Instance.new("TextButton")
    button.Name = "Option_" .. index
    button.Size = UDim2.new(0, 80, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(33, 139, 255)
    button.BorderSizePixel = 0
    button.Text = option.Title
    button.TextColor3 = Color3.fromRGB(248, 250, 252)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.ZIndex = 17
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(66, 153, 225)}
        ):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(33, 139, 255)}
        ):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        if option.Callback and type(option.Callback) == "function" then
            option.Callback()
        end
        self:Destroy()
    end)
    
    button.Parent = parent
end

function Dialog:Show()
    if self.Gui and not self.Background.Visible then
        self.Background.Visible = true
        self.Gui.Visible = true
        
        -- Animação de entrada
        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        self.Gui.Size = UDim2.new(0, 0, 0, 0)
        self.Gui.BackgroundTransparency = 1
        self.Background.BackgroundTransparency = 0.7
        
        tweenService:Create(self.Gui, tweenInfo, {
            Size = UDim2.new(0, 300, 0, 200),
            BackgroundTransparency = 0
        }):Play()
    end
end

function Dialog:Destroy()
    if self.Background then
        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        -- Animação de saída
        tweenService:Create(self.Gui, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        tweenService:Create(self.Background, tweenInfo, {
            BackgroundTransparency = 1
        }):Play()
        
        -- Limpar após animação
        wait(0.25)
        self.Background:Destroy()
        self.Background = nil
        
        -- Limpar referência no Window
        if self.ParentWindow and self.ParentWindow.ClearActiveDialog then
            self.ParentWindow:ClearActiveDialog()
        end
    end
    self.Gui = nil
end

return Dialog
```

# src/Components/Notify.lua
```lua
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
```

# src/Components/Tab.lua
```lua
local Tab = {}
Tab.__index = Tab

function Tab.new(config, contentParent, tabButtonsParent, window, theme)
    local self = setmetatable({}, Tab)
    
    self.Name = config.Name or "New Tab"
    self.Icon = config.Icon or nil
    self.Locked = config.Locked or false
    self.ContentParent = contentParent
    self.TabButtonsParent = tabButtonsParent
    self.Window = window
    self.Theme = theme or {
        Background = Color3.fromRGB(33, 38, 45),
        BackgroundSecondary = Color3.fromRGB(25, 30, 35),
        BackgroundTertiary = Color3.fromRGB(22, 27, 34),
        Text = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(139, 148, 160),
        Accent = Color3.fromRGB(33, 139, 255),
        Border = Color3.fromRGB(48, 54, 61)
    }
    self.Visible = false
    self.Active = false
    self.Sections = {}
    self.Elements = {}
    
    self:_Create()
    
    return self
end

function Tab:_Create()
    -- Tab Content Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Tab_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.Position = UDim2.new(0, 0, 0, 0)
    self.Container.BackgroundColor3 = self.Theme.BackgroundSecondary
    self.Container.BorderSizePixel = 1
    self.Container.BorderColor3 = self.Theme.Border
    self.Container.Visible = false
    self.Container.Parent = self.ContentParent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.Container
    
    -- Content area
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -10, 1, -10)
    self.ContentFrame.Position = UDim2.new(0, 5, 0, 5)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.Container
    
    -- UIListLayout para organizar elementos verticalmente
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.ContentFrame
    
    -- Tab Button (na barra lateral)
    self:_CreateTabButton()
end

function Tab:_CreateTabButton()
    self.TabButton = Instance.new("TextButton")
    self.TabButton.Name = "TabButton_" .. string.gsub(self.Name, " ", "_")
    self.TabButton.Size = UDim2.new(1, 0, 0, 35)
    self.TabButton.BackgroundColor3 = self.Theme.Background
    self.TabButton.BorderSizePixel = 1
    self.TabButton.BorderColor3 = self.Theme.Border
    self.TabButton.Text = ""
    self.TabButton.LayoutOrder = #self.TabButtonsParent:GetChildren()
    self.TabButton.Parent = self.TabButtonsParent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = self.TabButton
    
    -- Icon (se fornecido)
    if self.Icon then
        self.TabIcon = Instance.new("ImageLabel")
        self.TabIcon.Name = "Icon"
        self.TabIcon.Size = UDim2.new(0, 20, 0, 20)
        self.TabIcon.Position = UDim2.new(0, 8, 0.5, -10)
        self.TabIcon.BackgroundTransparency = 1
        self.TabIcon.Image = self.Icon
        self.TabIcon.Parent = self.TabButton
    end
    
    -- Tab name
    self.TabNameLabel = Instance.new("TextLabel")
    self.TabNameLabel.Name = "Name"
    self.TabNameLabel.Size = UDim2.new(1, self.Icon and -30 or -10, 1, 0)
    self.TabNameLabel.Position = UDim2.new(0, self.Icon and 30 or 8, 0, 0)
    self.TabNameLabel.BackgroundTransparency = 1
    self.TabNameLabel.Text = self.Name
    self.TabNameLabel.TextColor3 = self.Theme.TextSecondary
    self.TabNameLabel.TextSize = 12
    self.TabNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TabNameLabel.Font = Enum.Font.Gotham
    self.TabNameLabel.Parent = self.TabButton
    
    -- Lock icon (se bloqueada)
    if self.Locked then
        self.LockIcon = Instance.new("ImageLabel")
        self.LockIcon.Name = "LockIcon"
        self.LockIcon.Size = UDim2.new(0, 12, 0, 12)
        self.LockIcon.Position = UDim2.new(1, -15, 0.5, -6)
        self.LockIcon.BackgroundTransparency = 1
        self.LockIcon.Image = "rbxassetid://140204577989343"
        self.LockIcon.Visible = self.Locked
        self.LockIcon.Parent = self.TabButton
    end
    
    -- Hover and click effects
    self:_SetupTabButtonAnimations()
end

function Tab:_SetupTabButtonAnimations()
    local tweenService = game:GetService("TweenService")
    
    self.TabButton.MouseEnter:Connect(function()
        if not self.Active and not self.Locked then
            tweenService:Create(
                self.TabButton,
                TweenInfo.new(0.2),
                {BackgroundColor3 = self.Theme.Background:Lerp(Color3.new(1,1,1), 0.1)}
            ):Play()
            tweenService:Create(
                self.TabNameLabel,
                TweenInfo.new(0.2),
                {TextColor3 = self.Theme.Text}
            ):Play()
        end
    end)
    
    self.TabButton.MouseLeave:Connect(function()
        if not self.Active and not self.Locked then
            tweenService:Create(
                self.TabButton,
                TweenInfo.new(0.2),
                {BackgroundColor3 = self.Theme.Background}
            ):Play()
            tweenService:Create(
                self.TabNameLabel,
                TweenInfo.new(0.2),
                {TextColor3 = self.Theme.TextSecondary}
            ):Play()
        end
    end)
    
    self.TabButton.MouseButton1Click:Connect(function()
        if not self.Locked then
            self.Window:SwitchToTab(self)
        end
    end)
end

function Tab:_UpdateActiveAppearance()
    local tweenService = game:GetService("TweenService")
    
    if self.Active then
        tweenService:Create(
            self.TabButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = self.Theme.Accent}
        ):Play()
        tweenService:Create(
            self.TabNameLabel,
            TweenInfo.new(0.2),
            {TextColor3 = self.Theme.Text}
        ):Play()
    else
        tweenService:Create(
            self.TabButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = self.Theme.Background}
        ):Play()
        tweenService:Create(
            self.TabNameLabel,
            TweenInfo.new(0.2),
            {TextColor3 = self.Theme.TextSecondary}
        ):Play()
    end
end

function Tab:_UpdateLockedAppearance()
    if self.Locked then
        if self.LockIcon then
            self.LockIcon.Visible = true
        end
        self.TabButton.BackgroundColor3 = self.Theme.BackgroundTertiary
        self.TabNameLabel.TextColor3 = self.Theme.TextSecondary:Lerp(Color3.new(0,0,0), 0.5)
    else
        if self.LockIcon then
            self.LockIcon.Visible = false
        end
        self:_UpdateActiveAppearance()
    end
end

-- Public Methods
function Tab:SetName(newName)
    self.Name = newName
    if self.TabNameLabel then
        self.TabNameLabel.Text = newName
    end
end

function Tab:SetIcon(newIcon)
    self.Icon = newIcon
    if self.TabIcon then
        self.TabIcon.Image = newIcon
    elseif newIcon and self.TabButton then
        self.TabIcon = Instance.new("ImageLabel")
        self.TabIcon.Name = "Icon"
        self.TabIcon.Size = UDim2.new(0, 20, 0, 20)
        self.TabIcon.Position = UDim2.new(0, 8, 0.5, -10)
        self.TabIcon.BackgroundTransparency = 1
        self.TabIcon.Image = newIcon
        self.TabIcon.Parent = self.TabButton
        
        if self.TabNameLabel then
            self.TabNameLabel.Position = UDim2.new(0, 30, 0, 0)
            self.TabNameLabel.Size = UDim2.new(1, -35, 1, 0)
        end
    end
end

function Tab:SetLocked(isLocked)
    self.Locked = isLocked
    self:_UpdateLockedAppearance()
end

function Tab:SetVisible(visible)
    self.Visible = visible
    self.Container.Visible = visible
end

function Tab:SetActive(active)
    self.Active = active
    self:_UpdateActiveAppearance()
end

-- Section Methods
function Tab:Section(sectionConfig)
    local SectionModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Section.lua"))()
    local newSection = SectionModule.new(sectionConfig, self.ContentFrame, self.Theme)
    table.insert(self.Sections, newSection)
    return newSection
end

-- Paragraph Methods
function Tab:Paragraph(paragraphConfig)
    local ParagraphModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Paragraph.lua"))()
    local newParagraph = ParagraphModule.new(paragraphConfig, self.ContentFrame, self.Theme)
    table.insert(self.Elements, newParagraph)
    return newParagraph
end

-- Button Methods
function Tab:Button(buttonConfig)
    local ButtonModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Button.lua"))()
    local newButton = ButtonModule.new(buttonConfig, self.ContentFrame, self.Theme)
    table.insert(self.Elements, newButton)
    return newButton
end

return Tab
```

# src/Components/TitleBar.lua
```lua
local TitleBar = {}
TitleBar.__index = TitleBar

function TitleBar.new(config)
    local self = setmetatable({}, TitleBar)
    
    self.Title = config.Title or "Title"
    self.SubTitle = config.SubTitle or ""
    self.Parent = config.Parent
    self.OnClose = config.OnClose or function() end
    self.OnMinimize = config.OnMinimize or function() end
    self.Theme = config.Theme or {
        BackgroundTertiary = Color3.fromRGB(22, 27, 34),
        Text = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(139, 148, 160),
        Accent = Color3.fromRGB(33, 139, 255),
        Border = Color3.fromRGB(48, 54, 61),
        Error = Color3.fromRGB(220, 53, 69)
    }
    
    self:_Create()
    
    return self
end

function TitleBar:_Create()
    -- Title bar container
    self.Container = Instance.new("Frame")
    self.Container.Name = "TitleBar"
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.Position = UDim2.new(0, 0, 0, 0)
    self.Container.BackgroundColor3 = self.Theme.BackgroundTertiary
    self.Container.BorderSizePixel = 0
    self.Container.Parent = self.Parent
    
    -- Gradient effect
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Theme.BackgroundTertiary),
        ColorSequenceKeypoint.new(1, self.Theme.BackgroundTertiary:Lerp(Color3.new(1,1,1), 0.1))
    })
    gradient.Rotation = 90
    gradient.Parent = self.Container
    
    -- Bottom border
    local border = Instance.new("Frame")
    border.Name = "BottomBorder"
    border.Size = UDim2.new(1, 0, 0, 1)
    border.Position = UDim2.new(0, 0, 1, -1)
    border.BackgroundColor3 = self.Theme.Accent
    border.BorderSizePixel = 0
    border.Parent = self.Container
    
    -- Main title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -80, 0, 24)
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Parent = self.Container
    
    -- Subtitle
    self.SubTitleLabel = Instance.new("TextLabel")
    self.SubTitleLabel.Name = "SubTitle"
    self.SubTitleLabel.Size = UDim2.new(1, -80, 0, 16)
    self.SubTitleLabel.Position = UDim2.new(0, 15, 0, 34)
    self.SubTitleLabel.BackgroundTransparency = 1
    self.SubTitleLabel.Text = self.SubTitle
    self.SubTitleLabel.TextColor3 = self.Theme.TextSecondary
    self.SubTitleLabel.TextSize = 14
    self.SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.SubTitleLabel.Font = Enum.Font.Gotham
    self.SubTitleLabel.Parent = self.Container
    
    -- Button Container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(0, 60, 1, 0)
    buttonContainer.Position = UDim2.new(1, -65, 0, 0)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = self.Container
    
    -- Minimize Button (-)
    self.MinimizeButton = Instance.new("TextButton")
    self.MinimizeButton.Name = "MinimizeButton"
    self.MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    self.MinimizeButton.Position = UDim2.new(0, 0, 0.5, -12)
    self.MinimizeButton.AnchorPoint = Vector2.new(0, 0.5)
    self.MinimizeButton.BackgroundColor3 = self.Theme.Accent
    self.MinimizeButton.BorderSizePixel = 1
    self.MinimizeButton.BorderColor3 = self.Theme.Border
    self.MinimizeButton.Text = "–"
    self.MinimizeButton.TextColor3 = self.Theme.Text
    self.MinimizeButton.TextSize = 16
    self.MinimizeButton.Font = Enum.Font.GothamBold
    self.MinimizeButton.Parent = buttonContainer
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    minimizeCorner.Parent = self.MinimizeButton
    
    -- Close Button (X)
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 25, 0, 25)
    self.CloseButton.Position = UDim2.new(0, 30, 0.5, -12)
    self.CloseButton.AnchorPoint = Vector2.new(0, 0.5)
    self.CloseButton.BackgroundColor3 = self.Theme.Accent
    self.CloseButton.BorderSizePixel = 1
    self.CloseButton.BorderColor3 = self.Theme.Border
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = self.Theme.Text
    self.CloseButton.TextSize = 18
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = buttonContainer
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = self.CloseButton
    
    -- Animações dos botões
    self:_SetupButtonAnimations()
end

function TitleBar:_SetupButtonAnimations()
    local tweenService = game:GetService("TweenService")
    
    -- Animações do botão Minimizar
    self.MinimizeButton.MouseEnter:Connect(function()
        tweenService:Create(
            self.MinimizeButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = self.Theme.Accent:Lerp(Color3.new(1,1,1), 0.2)}
        ):Play()
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        tweenService:Create(
            self.MinimizeButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = self.Theme.Accent}
        ):Play()
    end)
    
    self.MinimizeButton.MouseButton1Down:Connect(function()
        tweenService:Create(
            self.MinimizeButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = self.Theme.Accent:Lerp(Color3.new(0,0,0), 0.2)}
        ):Play()
    end)
    
    self.MinimizeButton.MouseButton1Up:Connect(function()
        tweenService:Create(
            self.MinimizeButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = self.Theme.Accent:Lerp(Color3.new(1,1,1), 0.2)}
        ):Play()
    end)
    
    -- Animações do botão Fechar
    self.CloseButton.MouseEnter:Connect(function()
        tweenService:Create(
            self.CloseButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = self.Theme.Error}
        ):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        tweenService:Create(
            self.CloseButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = self.Theme.Accent}
        ):Play()
    end)
    
    self.CloseButton.MouseButton1Down:Connect(function()
        tweenService:Create(
            self.CloseButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = self.Theme.Error:Lerp(Color3.new(0,0,0), 0.2)}
        ):Play()
    end)
    
    self.CloseButton.MouseButton1Up:Connect(function()
        tweenService:Create(
            self.CloseButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = self.Theme.Error}
        ):Play()
    end)
    
    -- Conectar eventos dos botões
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self.OnMinimize()
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self.OnClose()
    end)
end

function TitleBar:UpdateTitle(newTitle)
    self.Title = newTitle
    self.TitleLabel.Text = newTitle
end

function TitleBar:UpdateSubTitle(newSubTitle)
    self.SubTitle = newSubTitle
    self.SubTitleLabel.Text = newSubTitle
end

function TitleBar:SetMinimizeState(isMinimized)
    if isMinimized then
        self.MinimizeButton.Text = "+"
    else
        self.MinimizeButton.Text = "–"
    end
end

return TitleBar
```

# src/Components/Window.lua
```lua
local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    self.Title = config.Title or "Window"
    self.SubTitle = config.SubTitle or ""
    self.Resizable = config.Resizable or false
    self.Icon = config.Icon or nil
    self.Theme = config.Theme or "Dark"
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsOpen = true
    self.IsMinimized = false
    self.ActiveDialog = nil -- Controla diálogo ativo
    
    self:_CreateGUI()
    self:_CreateTitleBar()
    self:_CreateTabBar()
    
    -- 🔒 CORREÇÃO: Setup drag só depois do TitleBar estar criado
    self:_SetupDrag()
    
    return self
end

function Window:_CreateGUI()
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "DeepLibWindow"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Window Container - Tamanho fixo 470x340
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainWindow"
    self.MainFrame.Size = UDim2.new(0, 470, 0, 340)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.MainFrame.BorderSizePixel = 1
    self.MainFrame.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.MainFrame
    
    -- Glow effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Image = "rbxassetid://8992230675"
    glow.ImageColor3 = Color3.fromRGB(33, 139, 255)
    glow.ImageTransparency = 0.8
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(23, 23, 277, 277)
    glow.Size = UDim2.new(1, 24, 1, 24)
    glow.Position = UDim2.new(0, -12, 0, -12)
    glow.BackgroundTransparency = 1
    glow.Parent = self.MainFrame
    glow.ZIndex = 0
    
    -- Content area com scroll
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -150, 1, -70)
    self.ContentFrame.Position = UDim2.new(0, 140, 0, 60)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(48, 54, 61)
    self.ContentFrame.ScrollBarThickness = 4
    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ContentFrame.Parent = self.MainFrame
    
    -- UIListLayout para conteúdo com scroll
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.ContentFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.Parent = self.ContentFrame
    
    -- 🔥 CORREÇÃO: Container para diálogos usando o mesmo método do window
    self.DialogContainer = Instance.new("Frame")
    self.DialogContainer.Name = "DialogContainer"
    self.DialogContainer.Size = UDim2.new(1, 0, 1, 0)
    self.DialogContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    self.DialogContainer.Position = UDim2.new(0, 0, 0, 0)
    self.DialogContainer.BackgroundTransparency = 1
    self.DialogContainer.Visible = false
    self.DialogContainer.ZIndex = 20
    self.DialogContainer.Parent = self.MainFrame
    
    -- Overlay escuro para diálogos (mesmo estilo do window)
    self.DialogOverlay = Instance.new("Frame")
    self.DialogOverlay.Name = "DialogOverlay"
    self.DialogOverlay.Size = UDim2.new(1, 0, 1, 0)
    self.DialogOverlay.Position = UDim2.new(0, 0, 0, 0)
    self.DialogOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.DialogOverlay.BackgroundTransparency = 0.5
    self.DialogOverlay.BorderSizePixel = 0
    self.DialogOverlay.ZIndex = 19
    self.DialogOverlay.Visible = false
    self.DialogOverlay.Parent = self.MainFrame
    
    local overlayCorner = Instance.new("UICorner")
    overlayCorner.CornerRadius = UDim.new(0, 12)
    overlayCorner.Parent = self.DialogOverlay
end

function Window:_SetupDrag()
    -- 🔒 CORREÇÃO: Verificação de segurança
    if not self.TitleBar or not self.TitleBar.Container then
        warn("⚠️ TitleBar não está pronto para drag")
        return
    end
    
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    -- Input Began no titlebar
    self.TitleBar.Container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    -- Input Changed
    self.TitleBar.Container.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    -- Update durante o drag
    RunService.Heartbeat:Connect(function()
        if dragging and dragInput then
            update(dragInput)
        end
    end)
end

function Window:_CreateTitleBar()
    local TitleBarModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/TitleBar.lua"))()
    self.TitleBar = TitleBarModule.new({
        Title = self.Title,
        SubTitle = self.SubTitle,
        Parent = self.MainFrame,
        OnClose = function()
            self:CloseDialog()
        end,
        OnMinimize = function()
            self:Minimize()
        end
    })
end

function Window:_CreateTabBar()
    -- Tab Bar Container (lateral esquerdo)
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(0, 130, 1, -60)
    self.TabBar.Position = UDim2.new(0, 0, 0, 60)
    self.TabBar.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Parent = self.MainFrame
    
    -- Gradiente na tab bar
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 27, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 33, 40))
    })
    gradient.Rotation = 90
    gradient.Parent = self.TabBar
    
    -- Container para os botões das tabs
    self.TabButtonsContainer = Instance.new("Frame")
    self.TabButtonsContainer.Name = "TabButtons"
    self.TabButtonsContainer.Size = UDim2.new(1, -10, 1, -15)
    self.TabButtonsContainer.Position = UDim2.new(0, 5, 0, 5)
    self.TabButtonsContainer.BackgroundTransparency = 1
    self.TabButtonsContainer.Parent = self.TabBar
    
    -- ScrollingFrame para as tabs
    self.TabScroll = Instance.new("ScrollingFrame")
    self.TabScroll.Name = "TabScroll"
    self.TabScroll.Size = UDim2.new(1, 0, 1, 0)
    self.TabScroll.BackgroundTransparency = 1
    self.TabScroll.ScrollBarThickness = 3
    self.TabScroll.ScrollBarImageColor3 = Color3.fromRGB(48, 54, 61)
    self.TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.TabScroll.Parent = self.TabButtonsContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.TabScroll
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 2)
    padding.PaddingLeft = UDim.new(0, 2)
    padding.PaddingRight = UDim.new(0, 2)
    padding.Parent = self.TabScroll
end

function Window:CloseDialog()
    -- Verifica se já existe um diálogo ativo
    if self.ActiveDialog then
        return
    end
    
    local DialogModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Dialog.lua"))()
    local closeDialog = DialogModule.new({
        Title = "Warn!",
        Desc = "Are you sure you want to close the hub?",
        Icon = nil,
        Options = {
            {
                Title = "Confirm",
                Icon = nil,
                Callback = function()
                    self:Destroy()
                end
            },
            {
                Title = "Cancel",
                Icon = nil,
                Callback = function()
                    self:Notify({
                        Title = "Canceled.",
                        Desc = "Operation was canceled.",
                        TimeE = true,
                        Time = 3
                    })
                end
            }
        }
    }, self)
    
    self.ActiveDialog = closeDialog
    closeDialog:Show()
end

function Window:Minimize()
    local tweenService = game:GetService("TweenService")
    
    if self.IsMinimized then
        -- Restaurar janela
        self.IsMinimized = false
        self.TitleBar:SetMinimizeState(false)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local sizeTween = tweenService:Create(self.MainFrame, tweenInfo, {Size = UDim2.new(0, 470, 0, 340)})
        
        sizeTween:Play()
        self.ContentFrame.Visible = true
        self.TabBar.Visible = true
        
    else
        -- Minimizar janela
        self.IsMinimized = true
        self.TitleBar:SetMinimizeState(true)
        
        self.ContentFrame.Visible = false
        self.TabBar.Visible = false
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local sizeTween = tweenService:Create(self.MainFrame, tweenInfo, {Size = UDim2.new(0, 470, 0, 60)})
        sizeTween:Play()
    end
end

-- 🔥 CORREÇÃO: Método para obter o container de diálogos
function Window:GetDialogContainer()
    return self.DialogContainer
end

-- 🔥 CORREÇÃO: Método para mostrar/ocultar container de diálogos
function Window:SetDialogContainerVisible(visible)
    if self.DialogContainer and self.DialogOverlay then
        self.DialogContainer.Visible = visible
        self.DialogOverlay.Visible = visible
        
        if visible then
            -- Garante que o container de diálogo fique acima de tudo
            self.DialogContainer.ZIndex = 20
            self.DialogOverlay.ZIndex = 19
        end
    end
end

-- Public Methods
function Window:SetTitle(newTitle)
    self.Title = newTitle
    if self.TitleBar and self.TitleBar.UpdateTitle then
        self.TitleBar:UpdateTitle(newTitle)
    end
end

function Window:SetSubTitle(newSubTitle)
    self.SubTitle = newSubTitle
    if self.TitleBar and self.TitleBar.UpdateSubTitle then
        self.TitleBar:UpdateSubTitle(newSubTitle)
    end
end

function Window:SetPos(positionTable)
    if self.MainFrame and type(positionTable) == "table" and #positionTable >= 4 then
        local newPos = UDim2.new(
            positionTable[1] or 0, positionTable[2] or 0,
            positionTable[3] or 0, positionTable[4] or 0
        )
        
        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = tweenService:Create(self.MainFrame, tweenInfo, {Position = newPos})
        tween:Play()
    end
end

function Window:SetSize(sizeTable)
    if self.MainFrame and type(sizeTable) == "table" and #sizeTable >= 2 then
        local newSize = UDim2.new(0, sizeTable[1] or 470, 0, sizeTable[2] or 340)
        
        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = tweenService:Create(self.MainFrame, tweenInfo, {Size = newSize})
        tween:Play()
    end
end

function Window:Destroy()
    if self.ScreenGui then
        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        tweenService:Create(self.MainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        wait(0.25)
        self.ScreenGui:Destroy()
        self.ScreenGui = nil
    end
    self.IsOpen = false
end

function Window:Close()
    if self.ScreenGui then
        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        tweenService:Create(self.MainFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
        tweenService:Create(self.MainFrame.Glow, tweenInfo, {ImageTransparency = 1}):Play()
        
        wait(0.25)
        self.ScreenGui.Enabled = false
        self.IsOpen = false
    end
end

function Window:Open()
    if self.ScreenGui then
        self.ScreenGui.Enabled = true
        
        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        self.MainFrame.BackgroundTransparency = 0
        self.MainFrame.Glow.ImageTransparency = 0.8
        
        -- Animação de entrada
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
        self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
        
        tweenService:Create(self.MainFrame, tweenInfo, {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 470, 0, 340)
        }):Play()
        
        self.IsOpen = true
    end
end

function Window:Tab(tabConfig)
    local TabModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Tab.lua"))()
    local newTab = TabModule.new(tabConfig, self.ContentFrame, self.TabScroll, self)
    table.insert(self.Tabs, newTab)
    
    if not self.CurrentTab then
        self.CurrentTab = newTab
        newTab:SetVisible(true)
        newTab:SetActive(true)
    else
        newTab:SetVisible(false)
        newTab:SetActive(false)
    end
    
    return newTab
end

function Window:Notify(notifyConfig)
    local NotifyModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Notify.lua"))()
    return NotifyModule.new(notifyConfig, self)
end

function Window:Dialog(dialogConfig)
    -- Verifica se já existe um diálogo ativo
    if self.ActiveDialog then
        return self.ActiveDialog
    end
    
    local DialogModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Dialog.lua"))()
    
    -- 🔥 CORREÇÃO: Mostra o container de diálogos antes de criar o diálogo
    self:SetDialogContainerVisible(true)
    
    -- 🔥 CORREÇÃO: Passa o container de diálogos para centralizar no window
    local newDialog = DialogModule.new(dialogConfig, self, self.DialogContainer)
    self.ActiveDialog = newDialog
    
    -- 🔥 CORREÇÃO: Quando o diálogo fechar, esconde o container
    if newDialog and newDialog.Close then
        local originalClose = newDialog.Close
        newDialog.Close = function(...)
            self:SetDialogContainerVisible(false)
            self.ActiveDialog = nil
            return originalClose(...)
        end
    end
    
    return newDialog
end

-- Método para limpar diálogo ativo
function Window:ClearActiveDialog()
    self.ActiveDialog = nil
    self:SetDialogContainerVisible(false)
end

-- Método para mudar de tab
function Window:SwitchToTab(tab)
    if self.CurrentTab then
        self.CurrentTab:SetVisible(false)
        self.CurrentTab:SetActive(false)
    end
    
    self.CurrentTab = tab
    tab:SetVisible(true)
    tab:SetActive(true)
end

return Window
```

# src/Elements/Toggle.lua
```lua
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(config, parentFrame)
    local self = setmetatable({}, Toggle)
    
    self.Name = config.Name or "Toggle"
    self.Desc = config.Desc or ""
    self.Icon = config.Icon
    self.Default = config.Default or false
    self.Callback = config.Callback or function() end
    self.Value = self.Default
    
    self:_Create(parentFrame)
    
    return self
end

function Toggle:_Create(parentFrame)
    -- Toggle Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Toggle"
    self.Container.Size = UDim2.new(1, -10, 0, 50)
    self.Container.Position = UDim2.new(0, 5, 0, 0)
    self.Container.BackgroundColor3 = Color3.fromRGB(40, 46, 54)
    self.Container.BorderSizePixel = 0
    self.Container.Parent = parentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.Container
    
    -- Text Container
    local textContainer = Instance.new("Frame")
    textContainer.Name = "TextContainer"
    textContainer.Size = UDim2.new(0.7, 0, 1, 0)
    textContainer.Position = UDim2.new(0, 10, 0, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = self.Container
    
    -- Name
    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    self.NameLabel.Position = UDim2.new(0, 0, 0, 0)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.NameLabel.TextSize = 14
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Font = Enum.Font.GothamBold
    self.NameLabel.Parent = textContainer
    
    -- Description
    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Desc"
    self.DescLabel.Size = UDim2.new(1, 0, 0.4, 0)
    self.DescLabel.Position = UDim2.new(0, 0, 0.6, 0)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = self.Desc
    self.DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    self.DescLabel.TextSize = 12
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.Parent = textContainer
    
    -- Toggle Switch
    self.SwitchContainer = Instance.new("Frame")
    self.SwitchContainer.Name = "SwitchContainer"
    self.SwitchContainer.Size = UDim2.new(0, 50, 0, 25)
    self.SwitchContainer.Position = UDim2.new(1, -60, 0.5, -12.5)
    self.SwitchContainer.AnchorPoint = Vector2.new(1, 0.5)
    self.SwitchContainer.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
    self.SwitchContainer.BorderSizePixel = 0
    self.SwitchContainer.Parent = self.Container
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 12)
    switchCorner.Parent = self.SwitchContainer
    
    -- Toggle Button
    self.SwitchButton = Instance.new("TextButton")
    self.SwitchButton.Name = "SwitchButton"
    self.SwitchButton.Size = UDim2.new(0, 21, 0, 21)
    self.SwitchButton.Position = UDim2.new(0, 2, 0.5, -10.5)
    self.SwitchButton.AnchorPoint = Vector2.new(0, 0.5)
    self.SwitchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.SwitchButton.BorderSizePixel = 0
    self.SwitchButton.Text = ""
    self.SwitchButton.Parent = self.SwitchContainer
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = self.SwitchButton
    
    -- Icon (quando ativo)
    self.IconLabel = Instance.new("ImageLabel")
    self.IconLabel.Name = "Icon"
    self.IconLabel.Size = UDim2.new(0, 12, 0, 12)
    self.IconLabel.Position = UDim2.new(0.5, -6, 0.5, -6)
    self.IconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    self.IconLabel.BackgroundTransparency = 1
    self.IconLabel.Image = self.Icon or ""
    self.IconLabel.Visible = false
    self.IconLabel.Parent = self.SwitchButton
    
    -- Set initial state
    self:SetValue(self.Default)
    
    -- Click event
    self.SwitchButton.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)
end

function Toggle:SetValue(value)
    self.Value = value
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if value then
        -- Ativo
        tweenService:Create(self.SwitchButton, tweenInfo, {
            Position = UDim2.new(1, -23, 0.5, -10.5),
            BackgroundColor3 = Color3.fromRGB(33, 139, 255)
        }):Play()
        tweenService:Create(self.SwitchContainer, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(33, 139, 255)
        }):Play()
        self.IconLabel.Visible = (self.Icon ~= nil)
    else
        -- Inativo
        tweenService:Create(self.SwitchButton, tweenInfo, {
            Position = UDim2.new(0, 2, 0.5, -10.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        tweenService:Create(self.SwitchContainer, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(48, 54, 61)
        }):Play()
        self.IconLabel.Visible = false
    end
    
    self.Callback(self.Value)
end

function Toggle:SetName(newName)
    self.Name = newName
    self.NameLabel.Text = newName
end

function Toggle:SetDesc(newDesc)
    self.Desc = newDesc
    self.DescLabel.Text = newDesc
end

function Toggle:SetIcon(icon)
    self.Icon = icon
    self.IconLabel.Image = icon
    if self.Value then
        self.IconLabel.Visible = true
    end
end

return Toggle
```

# src/Elements/Button.lua
```lua
local Button = {}
Button.__index = Button

function Button.new(config, parent, theme)
    local self = setmetatable({}, Button)
    
    self.Name = config.Name or "Button"
    self.Desc = config.Desc or ""
    self.Callback = config.Callback or function() end
    self.Parent = parent
    self.Theme = theme or {
        Background = Color3.fromRGB(33, 38, 45),
        BackgroundSecondary = Color3.fromRGB(25, 30, 35),
        Text = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(139, 148, 160),
        Accent = Color3.fromRGB(33, 139, 255),
        Border = Color3.fromRGB(48, 54, 61)
    }
    self.Locked = false
    
    self:_Create()
    
    return self
end

function Button:_Create()
    -- Button container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Button_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 0, 50)
    self.Container.BackgroundTransparency = 1
    self.Container.LayoutOrder = 999
    self.Container.Parent = self.Parent
    
    -- Button background (COM BORDA)
    self.ButtonFrame = Instance.new("TextButton")
    self.ButtonFrame.Name = "Button"
    self.ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
    self.ButtonFrame.Position = UDim2.new(0, 0, 0, 0)
    self.ButtonFrame.BackgroundColor3 = self.Theme.Background
    self.ButtonFrame.BorderSizePixel = 1
    self.ButtonFrame.BorderColor3 = self.Theme.Border
    self.ButtonFrame.Text = ""
    self.ButtonFrame.Parent = self.Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.ButtonFrame
    
    -- Button name
    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, -20, 0, 20)
    self.NameLabel.Position = UDim2.new(0, 10, 0, 5)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = self.Theme.Text
    self.NameLabel.TextSize = 14
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Font = Enum.Font.GothamBold
    self.NameLabel.Parent = self.ButtonFrame
    
    -- Button description
    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Desc"
    self.DescLabel.Size = UDim2.new(1, -20, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 10, 0, 25)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = self.Desc
    self.DescLabel.TextColor3 = self.Theme.TextSecondary
    self.DescLabel.TextSize = 11
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.Parent = self.ButtonFrame
    
    -- Hover effects
    self.ButtonFrame.MouseEnter:Connect(function()
        if not self.Locked then
            game:GetService("TweenService"):Create(
                self.ButtonFrame, 
                TweenInfo.new(0.2), 
                {BackgroundColor3 = self.Theme.Background:Lerp(Color3.new(1,1,1), 0.1)}
            ):Play()
        end
    end)
    
    self.ButtonFrame.MouseLeave:Connect(function()
        if not self.Locked then
            game:GetService("TweenService"):Create(
                self.ButtonFrame, 
                TweenInfo.new(0.2), 
                {BackgroundColor3 = self.Theme.Background}
            ):Play()
        end
    end)
    
    -- Click event
    self.ButtonFrame.MouseButton1Click:Connect(function()
        if not self.Locked then
            -- Click animation
            game:GetService("TweenService"):Create(
                self.ButtonFrame, 
                TweenInfo.new(0.1), 
                {BackgroundColor3 = self.Theme.Accent}
            ):Play()
            
            wait(0.1)
            
            game:GetService("TweenService"):Create(
                self.ButtonFrame, 
                TweenInfo.new(0.1), 
                {BackgroundColor3 = self.Theme.Background}
            ):Play()
            
            -- Call callback
            if self.Callback then
                self.Callback()
            end
        end
    end)
end

-- Public Methods
function Button:SetName(newName)
    self.Name = newName
    if self.NameLabel then
        self.NameLabel.Text = newName
    end
end

function Button:SetDesc(newDesc)
    self.Desc = newDesc
    if self.DescLabel then
        self.DescLabel.Text = newDesc
    end
end

function Button:SetLocked(isLocked)
    self.Locked = isLocked
    if self.Locked then
        self.ButtonFrame.BackgroundColor3 = self.Theme.BackgroundSecondary
        self.NameLabel.TextColor3 = self.Theme.TextSecondary
    else
        self.ButtonFrame.BackgroundColor3 = self.Theme.Background
        self.NameLabel.TextColor3 = self.Theme.Text
    end
end

return Button
```

# src/Elements/Paragraph.lua
```lua
local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(config, parent)
    local self = setmetatable({}, Paragraph)
    
    self.Name = config.Name or "Paragraph"
    self.Desc = config.Desc or ""
    self.Icon = config.Icon or nil
    self.Locked = config.Locked or false
    self.Parent = parent
    
    self:_Create()
    
    return self
end

function Paragraph:_Create()
    -- Paragraph container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Paragraph_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.BackgroundTransparency = 1
    self.Container.LayoutOrder = 999
    self.Container.Parent = self.Parent
    
    -- Background frame (COM BORDA)
    self.Background = Instance.new("Frame")
    self.Background.Name = "Background"
    self.Background.Size = UDim2.new(1, 0, 0, 55)
    self.Background.Position = UDim2.new(0, 0, 0, 0)
    self.Background.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.Background.BorderSizePixel = 1
    self.Background.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.Background.Parent = self.Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.Background
    
    -- Icon (if provided) - usando IDs fornecidos
    if self.Icon then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        self.IconLabel.Position = UDim2.new(0, 10, 0, 10)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = self.Icon
        self.IconLabel.Parent = self.Background
    end
    
    -- Paragraph name
    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, self.Icon and -35 or -20, 0, 20)
    self.NameLabel.Position = UDim2.new(0, self.Icon and 35 or 10, 0, 10)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.NameLabel.TextSize = 14
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Font = Enum.Font.GothamBold
    self.NameLabel.Parent = self.Background
    
    -- Paragraph description
    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Desc"
    self.DescLabel.Size = UDim2.new(1, -20, 0, 25)
    self.DescLabel.Position = UDim2.new(0, 10, 0, 30)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = self.Desc
    self.DescLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    self.DescLabel.TextSize = 11
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.DescLabel.TextWrapped = true
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.Parent = self.Background
    
    -- Update locked appearance
    self:_UpdateLockedAppearance()
end

function Paragraph:_UpdateLockedAppearance()
    if self.Locked then
        self.Background.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
        self.NameLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
        self.DescLabel.TextColor3 = Color3.fromRGB(108, 117, 125)
    else
        self.Background.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
        self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
        self.DescLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    end
end

-- Public Methods
function Paragraph:SetName(newName)
    self.Name = newName
    if self.NameLabel then
        self.NameLabel.Text = newName
    end
end

function Paragraph:SetDesc(newDesc)
    self.Desc = newDesc
    if self.DescLabel then
        self.DescLabel.Text = newDesc
    end
end

function Paragraph:SetIcon(newIcon)
    self.Icon = newIcon
    if self.IconLabel then
        self.IconLabel.Image = newIcon
    elseif newIcon and self.Background then
        -- Create icon if it doesn't exist but is now provided
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        self.IconLabel.Position = UDim2.new(0, 10, 0, 10)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = newIcon
        self.IconLabel.Parent = self.Background
        
        -- Adjust name label position
        if self.NameLabel then
            self.NameLabel.Position = UDim2.new(0, 35, 0, 10)
            self.NameLabel.Size = UDim2.new(1, -40, 0, 20)
        end
    end
end

function Paragraph:SetLocked(isLocked)
    self.Locked = isLocked
    self:_UpdateLockedAppearance()
end

return Paragraph
```

# src/Elements/Section.lua
```lua
local Section = {}
Section.__index = Section

function Section.new(config, parent)
    local self = setmetatable({}, Section)
    
    self.Name = config.Name or "Section"
    self.Icon = config.Icon or nil
    self.Opened = config.Opened or true
    self.Locked = config.Locked or false
    self.Parent = parent
    self.Elements = {}
    
    self:_Create()
    
    return self
end

function Section:_Create()
    -- Section container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Section_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.BackgroundTransparency = 1
    self.Container.LayoutOrder = 999
    self.Container.Parent = self.Parent
    
    -- Section header (clickable to toggle)
    self.Header = Instance.new("TextButton")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 30)
    self.Header.Position = UDim2.new(0, 0, 0, 0)
    self.Header.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.Header.BorderSizePixel = 1
    self.Header.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.Header.Text = ""
    self.Header.Parent = self.Container
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 4)
    headerCorner.Parent = self.Header
    
    -- Icon (if provided)
    if self.Icon then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 16, 0, 16)
        self.IconLabel.Position = UDim2.new(0, 8, 0.5, -8)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = self.Icon
        self.IconLabel.Parent = self.Header
    end
    
    -- Section name
    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, self.Icon and -30 or -15, 1, 0)
    self.NameLabel.Position = UDim2.new(0, self.Icon and 30 or 10, 0, 0)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.NameLabel.TextSize = 14
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Font = Enum.Font.Gotham
    self.NameLabel.Parent = self.Header
    
    -- Expand/collapse icon
    self.ExpandIcon = Instance.new("ImageLabel")
    self.ExpandIcon.Name = "ExpandIcon"
    self.ExpandIcon.Size = UDim2.new(0, 12, 0, 12)
    self.ExpandIcon.Position = UDim2.new(1, -20, 0.5, -6)
    self.ExpandIcon.BackgroundTransparency = 1
    self.ExpandIcon.Image = "rbxassetid://17739091190"
    self.ExpandIcon.Parent = self.Header
    
    -- Content area
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -10, 0, 0)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 35)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Visible = self.Opened
    self.ContentFrame.Parent = self.Container
    
    -- UIListLayout for content
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.ContentFrame
    
    -- Update visual state
    self:_UpdateVisualState()
    
    -- Toggle on click with animation
    self.Header.MouseButton1Click:Connect(function()
        if not self.Locked then
            self:SetOpened(not self.Opened)
        end
    end)
end

function Section:_UpdateVisualState()
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if self.Opened then
        self.ExpandIcon.Image = "rbxassetid://17739091190"
        tweenService:Create(self.ExpandIcon, tweenInfo, {Rotation = 0}):Play()
        
        -- Animate content frame appearance
        self.ContentFrame.Visible = true
        tweenService:Create(self.ContentFrame, tweenInfo, {Size = UDim2.new(1, -10, 0, self.ContentFrame.UIListLayout.AbsoluteContentSize.Y)}):Play()
    else
        self.ExpandIcon.Image = "rbxassetid://17739120383"
        tweenService:Create(self.ExpandIcon, tweenInfo, {Rotation = -90}):Play()
        
        -- Animate content frame disappearance
        tweenService:Create(self.ContentFrame, tweenInfo, {Size = UDim2.new(1, -10, 0, 0)}):Play()
        wait(0.2)
        self.ContentFrame.Visible = false
    end
    
    -- Update locked appearance
    if self.Locked then
        self.Header.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
        self.NameLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    else
        self.Header.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
        self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    end
end

-- Public Methods
function Section:SetName(newName)
    self.Name = newName
    if self.NameLabel then
        self.NameLabel.Text = newName
    end
end

function Section:SetIcon(newIcon)
    self.Icon = newIcon
    if self.IconLabel then
        self.IconLabel.Image = newIcon
    elseif newIcon and self.Header then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 16, 0, 16)
        self.IconLabel.Position = UDim2.new(0, 8, 0.5, -8)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = newIcon
        self.IconLabel.Parent = self.Header
        
        if self.NameLabel then
            self.NameLabel.Position = UDim2.new(0, 30, 0, 0)
            self.NameLabel.Size = UDim2.new(1, -35, 1, 0)
        end
    end
end

function Section:SetOpened(isOpened)
    self.Opened = isOpened
    self:_UpdateVisualState()
end

function Section:SetLocked(isLocked)
    self.Locked = isLocked
    self:_UpdateVisualState()
end

-- Element Methods
function Section:Paragraph(paragraphConfig)
    local ParagraphModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Paragraph.lua"))()
    local newParagraph = ParagraphModule.new(paragraphConfig, self.ContentFrame)
    table.insert(self.Elements, newParagraph)
    return newParagraph
end

function Section:Button(buttonConfig)
    local ButtonModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Button.lua"))()
    local newButton = ButtonModule.new(buttonConfig, self.ContentFrame)
    table.insert(self.Elements, newButton)
    return newButton
end

function Section:Toggle(toggleConfig)
    local ToggleModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Toggle.lua"))()
    local newToggle = ToggleModule.new(toggleConfig, self.ContentFrame)
    return newToggle
end

return Section
```
