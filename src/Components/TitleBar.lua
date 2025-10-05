local TitleBar = {}
TitleBar.__index = TitleBar

function TitleBar.new(config)
    local self = setmetatable({}, TitleBar)
    
    self.Title = config.Title or "Title"
    self.SubTitle = config.SubTitle or ""
    self.Parent = config.Parent
    self.OnClose = config.OnClose or function() end
    self.OnMinimize = config.OnMinimize or function() end
    
    self:_Create()
    
    return self
end

function TitleBar:_Create()
    -- Title bar container
    self.Container = Instance.new("Frame")
    self.Container.Name = "TitleBar"
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.Position = UDim2.new(0, 0, 0, 0)
    self.Container.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
    self.Container.BorderSizePixel = 0
    self.Container.Parent = self.Parent
    
    -- Bottom border
    local border = Instance.new("Frame")
    border.Name = "BottomBorder"
    border.Size = UDim2.new(1, 0, 0, 1)
    border.Position = UDim2.new(0, 0, 1, -1)
    border.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
    border.BorderSizePixel = 0
    border.Parent = self.Container
    
    -- Main title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -80, 0, 24) -- Menos espaço para os botões
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 10)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Parent = self.Container
    
    -- Subtitle
    self.SubTitleLabel = Instance.new("TextLabel")
    self.SubTitleLabel.Name = "SubTitle"
    self.SubTitleLabel.Size = UDim2.new(1, -80, 0, 16)
    self.SubTitleLabel.Position = UDim2.new(0, 10, 0, 34)
    self.SubTitleLabel.BackgroundTransparency = 1
    self.SubTitleLabel.Text = self.SubTitle
    self.SubTitleLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    self.SubTitleLabel.TextSize = 14
    self.SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.SubTitleLabel.Font = Enum.Font.Gotham
    self.SubTitleLabel.Parent = self.Container
    
    -- Minimize Button (-)
    self.MinimizeButton = Instance.new("TextButton")
    self.MinimizeButton.Name = "MinimizeButton"
    self.MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    self.MinimizeButton.Position = UDim2.new(1, -55, 0.5, -12)
    self.MinimizeButton.AnchorPoint = Vector2.new(0, 0.5)
    self.MinimizeButton.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.MinimizeButton.BorderSizePixel = 1
    self.MinimizeButton.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.MinimizeButton.Text = "–"
    self.MinimizeButton.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.MinimizeButton.TextSize = 16
    self.MinimizeButton.Font = Enum.Font.GothamBold
    self.MinimizeButton.Parent = self.Container
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    minimizeCorner.Parent = self.MinimizeButton
    
    -- Close Button (X)
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 25, 0, 25)
    self.CloseButton.Position = UDim2.new(1, -25, 0.5, -12)
    self.CloseButton.AnchorPoint = Vector2.new(0, 0.5)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.CloseButton.BorderSizePixel = 1
    self.CloseButton.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.CloseButton.Text = "X"
    self.CloseButton.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.CloseButton.TextSize = 14
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.Container
    
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
            {BackgroundColor3 = Color3.fromRGB(40, 46, 55)}
        ):Play()
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        tweenService:Create(
            self.MinimizeButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(33, 38, 45)}
        ):Play()
    end)
    
    self.MinimizeButton.MouseButton1Down:Connect(function()
        tweenService:Create(
            self.MinimizeButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(28, 33, 40)}
        ):Play()
    end)
    
    self.MinimizeButton.MouseButton1Up:Connect(function()
        tweenService:Create(
            self.MinimizeButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(40, 46, 55)}
        ):Play()
    end)
    
    -- Animações do botão Fechar
    self.CloseButton.MouseEnter:Connect(function()
        tweenService:Create(
            self.CloseButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(220, 53, 69)}
        ):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        tweenService:Create(
            self.CloseButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(33, 38, 45)}
        ):Play()
    end)
    
    self.CloseButton.MouseButton1Down:Connect(function()
        tweenService:Create(
            self.CloseButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(190, 33, 49)}
        ):Play()
    end)
    
    self.CloseButton.MouseButton1Up:Connect(function()
        tweenService:Create(
            self.CloseButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(220, 53, 69)}
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
        self.MinimizeButton.Text = "+" -- Quando minimizado, mostra "+"
    else
        self.MinimizeButton.Text = "–" -- Quando normal, mostra "–"
    end
end

return TitleBar
