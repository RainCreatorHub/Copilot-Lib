-- Window.lua
local Window = {}
Window.__index = Window
local WindowPath = game:GetService("CoreGui"):WaitForChild("DeepLibWindow")
if WindowPath then
 WindowPath:Destroy()
end

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
    self.ActiveDialog = nil
    
    -- Sistema de Key
    self.Key = config.Key or false
    self.KeyS = config.KeyS or {}
    self.IsKeyValidated = false
    
    self:_CreateGUI()
    
    -- Se Key estiver ativado, mostra a tela de validação
    if self.Key then
        self:_ShowKeySystem()
    else
        self:_InitializeWindow()
    end
    
    return self
end

function Window:_ShowKeySystem()
    -- Container da tela de Key
    self.KeyContainer = Instance.new("Frame")
    self.KeyContainer.Name = "KeySystem"
    self.KeyContainer.Size = UDim2.new(1, 0, 1, 0)
    self.KeyContainer.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
    self.KeyContainer.BorderSizePixel = 0
    self.KeyContainer.Parent = self.MainFrame
    self.KeyContainer.ZIndex = 100
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 12)
    keyCorner.Parent = self.KeyContainer
    
    -- Título
    local keyTitle = Instance.new("TextLabel")
    keyTitle.Name = "KeyTitle"
    keyTitle.Size = UDim2.new(1, -40, 0, 40)
    keyTitle.Position = UDim2.new(0, 20, 0, 20)
    keyTitle.BackgroundTransparency = 1
    keyTitle.Text = self.KeyS.Title or "Key System"
    keyTitle.TextColor3 = Color3.fromRGB(248, 250, 252)
    keyTitle.TextSize = 24
    keyTitle.Font = Enum.Font.GothamBold
    keyTitle.TextXAlignment = Enum.TextXAlignment.Left
    keyTitle.Parent = self.KeyContainer
    
    -- Descrição
    local keyDesc = Instance.new("TextLabel")
    keyDesc.Name = "KeyDesc"
    keyDesc.Size = UDim2.new(1, -40, 0, 60)
    keyDesc.Position = UDim2.new(0, 20, 0, 70)
    keyDesc.BackgroundTransparency = 1
    keyDesc.Text = self.KeyS.Desc or "Please enter a valid key to continue"
    keyDesc.TextColor3 = Color3.fromRGB(139, 148, 160)
    keyDesc.TextSize = 14
    keyDesc.Font = Enum.Font.Gotham
    keyDesc.TextXAlignment = Enum.TextXAlignment.Left
    keyDesc.TextWrapped = true
    keyDesc.Parent = self.KeyContainer
    
    -- Input da Key
    local keyInputContainer = Instance.new("Frame")
    keyInputContainer.Name = "KeyInputContainer"
    keyInputContainer.Size = UDim2.new(1, -40, 0, 45)
    keyInputContainer.Position = UDim2.new(0, 20, 0, 150)
    keyInputContainer.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    keyInputContainer.BorderSizePixel = 1
    keyInputContainer.BorderColor3 = Color3.fromRGB(48, 54, 61)
    keyInputContainer.Parent = self.KeyContainer
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = keyInputContainer
    
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Size = UDim2.new(1, -20, 1, -10)
    keyInput.Position = UDim2.new(0, 10, 0, 5)
    keyInput.BackgroundTransparency = 1
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your key here..."
    keyInput.TextColor3 = Color3.fromRGB(248, 250, 252)
    keyInput.PlaceholderColor3 = Color3.fromRGB(139, 148, 160)
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = keyInputContainer
    
    -- Container dos botões
    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Name = "ButtonsContainer"
    buttonsContainer.Size = UDim2.new(1, -40, 0, 45)
    buttonsContainer.Position = UDim2.new(0, 20, 0, 210)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.Parent = self.KeyContainer
    
    -- Botão "Get Key"
    if self.KeyS.Url and self.KeyS.Url ~= "" then
        local getKeyButton = Instance.new("TextButton")
        getKeyButton.Name = "GetKeyButton"
        getKeyButton.Size = UDim2.new(0.48, 0, 1, 0)
        getKeyButton.Position = UDim2.new(0, 0, 0, 0)
        getKeyButton.BackgroundColor3 = Color3.fromRGB(33, 139, 255)
        getKeyButton.BorderSizePixel = 0
        getKeyButton.Text = "Get Key"
        getKeyButton.TextColor3 = Color3.fromRGB(248, 250, 252)
        getKeyButton.TextSize = 15
        getKeyButton.Font = Enum.Font.GothamBold
        getKeyButton.AutoButtonColor = false
        getKeyButton.Parent = buttonsContainer
        
        local getKeyCorner = Instance.new("UICorner")
        getKeyCorner.CornerRadius = UDim.new(0, 8)
        getKeyCorner.Parent = getKeyButton
        
        -- Animações do botão Get Key
        local tweenService = game:GetService("TweenService")
        getKeyButton.MouseEnter:Connect(function()
            tweenService:Create(getKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 156, 255)}):Play()
        end)
        
        getKeyButton.MouseLeave:Connect(function()
            tweenService:Create(getKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(33, 139, 255)}):Play()
        end)
        
        getKeyButton.MouseButton1Click:Connect(function()
            -- Copia a URL para o clipboard (se suportado)
            if setclipboard then
                setclipboard(self.KeyS.Url)
                self:Notify({
                    Title = "URL Copied!",
                    Desc = "Key URL has been copied to clipboard",
                    TimeE = true,
                    Time = 3
                })
            end
            
            -- Tenta abrir a URL no navegador
            if request or http_request or syn and syn.request then
                local requestFunc = request or http_request or syn.request
                pcall(function()
                    requestFunc({
                        Url = self.KeyS.Url,
                        Method = "GET"
                    })
                end)
            end
        end)
    end
    
    -- Botão "Check Key"
    local checkKeyButton = Instance.new("TextButton")
    checkKeyButton.Name = "CheckKeyButton"
    
    if self.KeyS.Url and self.KeyS.Url ~= "" then
        checkKeyButton.Size = UDim2.new(0.48, 0, 1, 0)
        checkKeyButton.Position = UDim2.new(0.52, 0, 0, 0)
    else
        checkKeyButton.Size = UDim2.new(1, 0, 1, 0)
        checkKeyButton.Position = UDim2.new(0, 0, 0, 0)
    end
    
    checkKeyButton.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
    checkKeyButton.BorderSizePixel = 0
    checkKeyButton.Text = "Check Key"
    checkKeyButton.TextColor3 = Color3.fromRGB(248, 250, 252)
    checkKeyButton.TextSize = 15
    checkKeyButton.Font = Enum.Font.GothamBold
    checkKeyButton.AutoButtonColor = false
    checkKeyButton.Parent = buttonsContainer
    
    local checkKeyCorner = Instance.new("UICorner")
    checkKeyCorner.CornerRadius = UDim.new(0, 8)
    checkKeyCorner.Parent = checkKeyButton
    
    -- Animações do botão Check Key
    local tweenService = game:GetService("TweenService")
    checkKeyButton.MouseEnter:Connect(function()
        tweenService:Create(checkKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(52, 187, 89)}):Play()
    end)
    
    checkKeyButton.MouseLeave:Connect(function()
        tweenService:Create(checkKeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 167, 69)}):Play()
    end)
    
    -- Label de status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -40, 0, 30)
    statusLabel.Position = UDim2.new(0, 20, 0, 270)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(220, 53, 69)
    statusLabel.TextSize = 13
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = self.KeyContainer
    
    -- Função para validar a key
    checkKeyButton.MouseButton1Click:Connect(function()
        local enteredKey = keyInput.Text
        
        if enteredKey == "" then
            statusLabel.Text = "Please enter a key"
            statusLabel.TextColor3 = Color3.fromRGB(220, 53, 69)
            return
        end
        
        -- Valida a key
        local isValid = false
        if self.KeyS.Key then
            for _, validKey in ipairs(self.KeyS.Key) do
                if enteredKey == validKey then
                    isValid = true
                    break
                end
            end
        end
        
        if isValid then
            statusLabel.Text = "Key validated! Loading..."
            statusLabel.TextColor3 = Color3.fromRGB(40, 167, 69)
            
            self.IsKeyValidated = true
            
            -- Animação de saída da tela de key
            tweenService:Create(
                self.KeyContainer,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0, 0, -1, 0)}
            ):Play()
            
            task.wait(0.3)
            self.KeyContainer:Destroy()
            self.KeyContainer = nil
            
            -- Inicializa a janela
            self:_InitializeWindow()
            
            self:Notify({
                Title = "Access Granted!",
                Desc = "Welcome to the hub!",
                TimeE = true,
                Time = 3
            })
        else
            statusLabel.Text = "Invalid key! Please try again"
            statusLabel.TextColor3 = Color3.fromRGB(220, 53, 69)
            
            -- Animação de shake no input
            local originalPos = keyInputContainer.Position
            tweenService:Create(keyInputContainer, TweenInfo.new(0.05), {Position = originalPos + UDim2.new(0, -10, 0, 0)}):Play()
            task.wait(0.05)
            tweenService:Create(keyInputContainer, TweenInfo.new(0.05), {Position = originalPos + UDim2.new(0, 10, 0, 0)}):Play()
            task.wait(0.05)
            tweenService:Create(keyInputContainer, TweenInfo.new(0.05), {Position = originalPos}):Play()
        end
    end)
    
    -- Suporte para Enter key
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            checkKeyButton.MouseButton1Click:Fire()
        end
    end)
end

function Window:_InitializeWindow()
    -- Cria a área de conteúdo se ainda não existir
    if not self.ContentFrame then
        self:_CreateContentArea()
    end
    
    self:_CreateTitleBar()
    self:_CreateTabBar()
    self:_SetupDrag()
end

function Window:_CreateGUI()
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "DeepLibWindow"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = game:WaitForChild("CoreGui")
    
    -- Main Window Container
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
    
    -- Container para diálogos
    self.DialogContainer = Instance.new("Frame")
    self.DialogContainer.Name = "DialogContainer"
    self.DialogContainer.Size = UDim2.new(1, 0, 1, 0)
    self.DialogContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    self.DialogContainer.Position = UDim2.new(0, 0, 0, 0)
    self.DialogContainer.BackgroundTransparency = 1
    self.DialogContainer.Visible = false
    self.DialogContainer.ZIndex = 20
    self.DialogContainer.Parent = self.MainFrame
    
    -- Overlay escuro para diálogos
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

function Window:_CreateContentArea()
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
end

function Window:_SetupDrag()
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
    
    self.TitleBar.Container.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
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
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(0, 130, 1, -60)
    self.TabBar.Position = UDim2.new(0, 0, 0, 60)
    self.TabBar.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Parent = self.MainFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 27, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 33, 40))
    })
    gradient.Rotation = 90
    gradient.Parent = self.TabBar
    
    self.TabButtonsContainer = Instance.new("Frame")
    self.TabButtonsContainer.Name = "TabButtons"
    self.TabButtonsContainer.Size = UDim2.new(1, -10, 1, -15)
    self.TabButtonsContainer.Position = UDim2.new(0, 5, 0, 5)
    self.TabButtonsContainer.BackgroundTransparency = 1
    self.TabButtonsContainer.Parent = self.TabBar
    
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
        self.IsMinimized = false
        self.TitleBar:SetMinimizeState(false)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local sizeTween = tweenService:Create(self.MainFrame, tweenInfo, {Size = UDim2.new(0, 470, 0, 340)})
        
        sizeTween:Play()
        if self.ContentFrame then
            self.ContentFrame.Visible = true
        end
        if self.TabBar then
            self.TabBar.Visible = true
        end
        
    else
        self.IsMinimized = true
        self.TitleBar:SetMinimizeState(true)
        
        if self.ContentFrame then
            self.ContentFrame.Visible = false
        end
        if self.TabBar then
            self.TabBar.Visible = false
        end
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local sizeTween = tweenService:Create(self.MainFrame, tweenInfo, {Size = UDim2.new(0, 470, 0, 60)})
        sizeTween:Play()
    end
end

function Window:GetDialogContainer()
    return self.DialogContainer
end

function Window:SetDialogContainerVisible(visible)
    if self.DialogContainer and self.DialogOverlay then
        self.DialogContainer.Visible = visible
        self.DialogOverlay.Visible = visible
        
        if visible then
            self.DialogContainer.ZIndex = 20
            self.DialogOverlay.ZIndex = 19
        end
    end
end

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
    if self.ActiveDialog then
        return self.ActiveDialog
    end
    
    local DialogModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Dialog.lua"))()
    
    self:SetDialogContainerVisible(true)
    
    local newDialog = DialogModule.new(dialogConfig, self, self.DialogContainer)
    self.ActiveDialog = newDialog
    
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

function Window:ClearActiveDialog()
    self.ActiveDialog = nil
    self:SetDialogContainerVisible(false)
end

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
