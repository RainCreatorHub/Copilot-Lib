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
    self.Gui.Size = UDim2.new(0, 300, 0, 240)
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
    
    -- Header com gradiente
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
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
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 17
    title.Parent = header
    
    -- Description area
    local descContainer = Instance.new("Frame")
    descContainer.Name = "DescContainer"
    descContainer.Size = UDim2.new(1, -20, 0, 120)
    descContainer.Position = UDim2.new(0, 10, 0, 60)
    descContainer.BackgroundTransparency = 1
    descContainer.ZIndex = 16
    descContainer.Parent = self.Gui
    
    -- ScrollingFrame para descrição
    local descScroll = Instance.new("ScrollingFrame")
    descScroll.Name = "DescScroll"
    descScroll.Size = UDim2.new(1, 0, 1, 0)
    descScroll.BackgroundTransparency = 1
    descScroll.ScrollBarThickness = 3
    descScroll.ScrollBarImageColor3 = Color3.fromRGB(48, 54, 61)
    descScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    descScroll.AutomaticCanvasSize = Enum.AutomaticSize.None -- Desativado
    descScroll.ZIndex = 16
    descScroll.Parent = descContainer

    local TextService = game:GetService("TextService")
    local desc = Instance.new("TextLabel")
    desc.Name = "Desc"
    desc.Size = UDim2.new(1, -10, 0, 0) -- largura com margem, altura dinâmica
    desc.Position = UDim2.new(0, 5, 0, 0)
    desc.BackgroundTransparency = 1 -- Corrigido: sem fundo
    desc.Text = self.Desc
    desc.TextColor3 = Color3.fromRGB(139, 148, 160)
    desc.TextSize = 14
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextWrapped = true
    desc.Font = Enum.Font.Gotham
    desc.ZIndex = 16
    desc.Parent = descScroll

    -- Função para atualizar o tamanho do texto e do canvas
    local function updateDescSize()
        if desc.Text == "" then
            desc.Size = UDim2.new(1, -10, 0, 20)
            descScroll.CanvasSize = UDim2.new(0, 0, 0, 20)
            return
        end

        local textSize = TextService:GetTextSize(
            desc.Text,
            desc.TextSize,
            desc.Font,
            Vector2.new(desc.AbsoluteSize.X, math.huge)
        )
        desc.Size = UDim2.new(1, -10, 0, textSize.Y)
        descScroll.CanvasSize = UDim2.new(0, 0, 0, textSize.Y)
    end

    -- Atualiza quando o texto muda
    desc:GetPropertyChangedSignal("Text"):Connect(updateDescSize)

    -- Atualiza quando o container muda de tamanho (ex: janela redimensionada)
    descContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if descContainer.AbsoluteSize.X > 0 then
            updateDescSize()
        end
    end)

    -- Atualização inicial
    updateDescSize()
    
    -- Options container
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
            Size = UDim2.new(0, 300, 0, 240), -- Corrigido: era 270, mas o frame é 240
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
