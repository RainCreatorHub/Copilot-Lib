local Dialog = {}
Dialog.__index = Dialog

function Dialog.new(config, parentWindow, parentContainer)
    local self = setmetatable({}, Dialog)
    
    self.ParentWindow = parentWindow
    self.ParentContainer = parentContainer or parentWindow:GetDialogContainer()
    self.Title = config.Title or "Dialog"
    self.Desc = config.Desc or ""
    self.Icon = config.Icon
    self.Options = config.Options or {}
    self.IsOpen = false
    
    self:_CreateGUI()
    
    return self
end

function Dialog:_CreateGUI()
    -- Main Dialog Frame - Altura reduzida
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "DialogMain"
    self.MainFrame.Size = UDim2.new(0, 320, 0, 180)  -- Altura reduzida de 200 para 180
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)  -- Centralizado
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.MainFrame.BorderSizePixel = 1
    self.MainFrame.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.ZIndex = 25  -- ZIndex mais alto para ficar acima da sombra
    self.MainFrame.Visible = false
    self.MainFrame.Parent = self.ParentContainer

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
    glow.ZIndex = 24

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 26
    titleLabel.Parent = self.MainFrame

    -- Descrição - AGORA VISÍVEL
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Desc"
    descLabel.Size = UDim2.new(1, -20, 0, 40)  -- Altura aumentada para mostrar o texto
    descLabel.Position = UDim2.new(0, 10, 0, 45)  -- Posicionada abaixo do título
    descLabel.BackgroundTransparency = 1
    descLabel.Text = self.Desc
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextSize = 14
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextWrapped = true  -- Quebra de texto para descrições longas
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.ZIndex = 26
    descLabel.Parent = self.MainFrame

    -- Container para botões
    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Name = "Buttons"
    buttonsContainer.Size = UDim2.new(1, -20, 0, 40)
    buttonsContainer.Position = UDim2.new(0, 10, 1, -50)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.ZIndex = 26
    buttonsContainer.Parent = self.MainFrame

    local buttonsList = Instance.new("UIListLayout")
    buttonsList.FillDirection = Enum.FillDirection.Horizontal
    buttonsList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    buttonsList.VerticalAlignment = Enum.VerticalAlignment.Center
    buttonsList.SortOrder = Enum.SortOrder.LayoutOrder
    buttonsList.Padding = UDim.new(0, 10)
    buttonsList.Parent = buttonsContainer

    -- Criar botões das opções
    for i, option in ipairs(self.Options) do
        local button = Instance.new("TextButton")
        button.Name = option.Title
        button.Size = UDim2.new(0, 80, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(33, 139, 255)
        button.BorderSizePixel = 0
        button.Text = option.Title
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.ZIndex = 27
        button.LayoutOrder = i
        button.Parent = buttonsContainer

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button

        -- Efeito hover
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            }):Play()
        end)

        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(33, 139, 255)
            }):Play()
        end)

        button.MouseButton1Click:Connect(function()
            if option.Callback then
                option.Callback()
            end
            self:Close()
        end)
    end
end

function Dialog:Show()
    if self.ParentWindow then
        self.ParentWindow:SetDialogContainerVisible(true)
    end
    
    self.MainFrame.Visible = true
    self.IsOpen = true
    
    -- Animação de entrada
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    tweenService:Create(self.MainFrame, tweenInfo, {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 320, 0, 180)
    }):Play()
end

function Dialog:Close()
    if not self.IsOpen then return end
    
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    tweenService:Create(self.MainFrame, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    
    wait(0.25)
    self.MainFrame.Visible = false
    
    if self.ParentWindow then
        self.ParentWindow:ClearActiveDialog()
    end
    
    self.IsOpen = false
end

return Dialog
