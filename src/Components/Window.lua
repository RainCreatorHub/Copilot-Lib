local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    self.Title = config.Title or "Window"
    self.SubTitle = config.SubTitle or ""
    self.Resizable = config.Resizable or true
    self.Icon = config.Icon or nil
    self.Theme = config.Theme or "Dark"
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsOpen = true
    self.IsMinimized = false
    
    self:_LoadTheme()
    self:_CreateGUI()
    self:_CreateTitleBar()
    self:_CreateTabBar()
    
    return self
end

function Window:_LoadTheme()
    local themeModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Themes/" .. self.Theme .. ".lua"))()
    self.ThemeData = themeModule
end

function Window:_CreateGUI()
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "DeepLibWindow"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Window Container
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainWindow"
    self.MainFrame.Size = UDim2.new(0, 470, 0, 340)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = self.ThemeData.Background
    self.MainFrame.BorderSizePixel = 1
    self.MainFrame.BorderColor3 = self.ThemeData.Border
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = self.ThemeData.Shadow
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Parent = self.MainFrame
    shadow.ZIndex = 0
    
    -- Content area
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -130, 1, -60)
    self.ContentFrame.Position = UDim2.new(0, 130, 0, 60)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.MainFrame
    
    -- Resize Grip (para redimensionamento)
    if self.Resizable then
        self:_CreateResizeGrip()
    end
end

function Window:_CreateResizeGrip()
    self.ResizeGrip = Instance.new("TextButton")
    self.ResizeGrip.Name = "ResizeGrip"
    self.ResizeGrip.Size = UDim2.new(0, 15, 0, 15)
    self.ResizeGrip.Position = UDim2.new(1, -15, 1, -15)
    self.ResizeGrip.BackgroundColor3 = self.ThemeData.Accent
    self.ResizeGrip.BorderSizePixel = 0
    self.ResizeGrip.Text = ""
    self.ResizeGrip.ZIndex = 10
    self.ResizeGrip.Parent = self.MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = self.ResizeGrip
    
    -- Hover effects
    self.ResizeGrip.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            self.ResizeGrip,
            TweenInfo.new(0.2),
            {BackgroundColor3 = self.ThemeData.Accent:Lerp(Color3.new(1,1,1), 0.2)}
        ):Play()
    end)
    
    self.ResizeGrip.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            self.ResizeGrip,
            TweenInfo.new(0.2),
            {BackgroundColor3 = self.ThemeData.Accent}
        ):Play()
    end)
    
    -- Resize functionality
    local dragging = false
    local dragStart, startSize
    
    self.ResizeGrip.MouseButton1Down:Connect(function(input)
        dragging = true
        dragStart = input.Position
        startSize = self.MainFrame.Size
        self.ResizeGrip.BackgroundColor3 = self.ThemeData.Accent:Lerp(Color3.new(0,0,0), 0.2)
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            game:GetService("TweenService"):Create(
                self.ResizeGrip,
                TweenInfo.new(0.2),
                {BackgroundColor3 = self.ThemeData.Accent}
            ):Play()
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newSize = UDim2.new(
                0, math.max(400, startSize.X.Offset + delta.X),
                0, math.max(300, startSize.Y.Offset + delta.Y)
            )
            self.MainFrame.Size = newSize
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
            -- Ao invés de fechar diretamente, abrimos um diálogo
            self:CloseDialog()
        end,
        OnMinimize = function()
            self:Minimize()
        end,
        Theme = self.ThemeData
    })
end

function Window:_CreateTabBar()
    -- Tab Bar Container (lateral esquerdo)
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(0, 120, 1, -60)
    self.TabBar.Position = UDim2.new(0, 0, 0, 60)
    self.TabBar.BackgroundColor3 = self.ThemeData.BackgroundTertiary
    self.TabBar.BorderSizePixel = 1
    self.TabBar.BorderColor3 = self.ThemeData.Border
    self.TabBar.Parent = self.MainFrame
    
    -- Separator entre tab bar e conteúdo
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(0, 1, 1, 0)
    separator.Position = UDim2.new(1, 0, 0, 0)
    separator.BackgroundColor3 = self.ThemeData.Border
    separator.BorderSizePixel = 0
    separator.Parent = self.TabBar
    
    -- Container para os botões das tabs
    self.TabButtonsContainer = Instance.new("Frame")
    self.TabButtonsContainer.Name = "TabButtons"
    self.TabButtonsContainer.Size = UDim2.new(1, -5, 1, -10)
    self.TabButtonsContainer.Position = UDim2.new(0, 5, 0, 5)
    self.TabButtonsContainer.BackgroundTransparency = 1
    self.TabButtonsContainer.Parent = self.TabBar
    
    -- UIListLayout para organizar os botões verticalmente
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 3)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.TabButtonsContainer
end

function Window:CloseDialog()
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
                        Desc = "The hub was not closed.",
                        TimeE = true,
                        Time = 3
                    })
                end
            }
        }
    }, self)
    closeDialog:Show()
end

function Window:Minimize()
    local tweenService = game:GetService("TweenService")
    
    if self.IsMinimized then
        -- Restaurar janela
        self.IsMinimized = false
        self.TitleBar:SetMinimizeState(false)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local sizeTween = tweenService:Create(self.MainFrame, tweenInfo, {Size = UDim2.new(0, 470, 0, 340)})
        
        sizeTween:Play()
        sizeTween.Completed:Wait()
        
        self.ContentFrame.Visible = true
        self.TabBar.Visible = true
    else
        -- Minimizar janela
        self.IsMinimized = true
        self.TitleBar:SetMinimizeState(true)
        
        self.ContentFrame.Visible = false
        self.TabBar.Visible = false
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
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
        
        tweenService:Create(self.MainFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
        tweenService:Create(self.MainFrame.Shadow, tweenInfo, {ImageTransparency = 1}):Play()
        
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
        tweenService:Create(self.MainFrame.Shadow, tweenInfo, {ImageTransparency = 1}):Play()
        
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
        self.MainFrame.Shadow.ImageTransparency = 0.8
        
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
        tweenService:Create(self.MainFrame, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        
        self.IsOpen = true
    end
end

function Window:Tab(tabConfig)
    local TabModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Tab.lua"))()
    local newTab = TabModule.new(tabConfig, self.ContentFrame, self.TabButtonsContainer, self, self.ThemeData)
    table.insert(self.Tabs, newTab)
    
    -- Set as current tab if it's the first one
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
    local DialogModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Dialog.lua"))()
    local newDialog = DialogModule.new(dialogConfig, self)
    return newDialog
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
