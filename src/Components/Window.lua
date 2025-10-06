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
    local newDialog = DialogModule.new(dialogConfig, self)
    self.ActiveDialog = newDialog
    return newDialog
end

-- Método para limpar diálogo ativo
function Window:ClearActiveDialog()
    self.ActiveDialog = nil
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
