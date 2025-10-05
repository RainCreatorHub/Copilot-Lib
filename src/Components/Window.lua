local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    self.Title = config.Title or "Window"
    self.SubTitle = config.SubTitle or ""
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsOpen = true
    self.IsMinimized = false
    
    self:_CreateGUI()
    self:_CreateTitleBar()
    
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
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Shadow effect
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
    shadow.Parent = self.MainFrame
    shadow.ZIndex = 0
    
    -- Content area
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, 0, 1, -60)
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 60)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.MainFrame
    
    -- Tab container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, -20, 1, -10)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 5)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.ContentFrame
end

function Window:_CreateTitleBar()
    local TitleBarModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/TitleBar.lua"))()
    self.TitleBar = TitleBarModule.new({
        Title = self.Title,
        SubTitle = self.SubTitle,
        Parent = self.MainFrame,
        OnClose = function()
            self:Close()
        end,
        OnMinimize = function()
            self:Minimize()
        end
    })
end

-- Método Minimize
function Window:Minimize()
    local tweenService = game:GetService("TweenService")
    
    if self.IsMinimized then
        -- Restaurar janela
        self.IsMinimized = false
        self.TitleBar:SetMinimizeState(false)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local sizeTween = tweenService:Create(self.MainFrame, tweenInfo, {Size = UDim2.new(0, 470, 0, 340)})
        
        -- Esperar um pouco antes de mostrar o conteúdo
        sizeTween:Play()
        sizeTween.Completed:Wait()
        
        self.ContentFrame.Visible = true
        
    else
        -- Minimizar janela
        self.IsMinimized = true
        self.TitleBar:SetMinimizeState(true)
        
        self.ContentFrame.Visible = false
        
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
        
        -- Animação de fade out antes de destruir
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
        
        -- Reset transparency
        self.MainFrame.BackgroundTransparency = 0
        self.MainFrame.Shadow.ImageTransparency = 0.8
        
        -- Animação de entrada
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
        tweenService:Create(self.MainFrame, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        
        self.IsOpen = true
    end
end

function Window:Tab(tabConfig)
    local TabModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Tab.lua"))()
    local newTab = TabModule.new(tabConfig, self.TabContainer)
    table.insert(self.Tabs, newTab)
    
    if not self.CurrentTab then
        self.CurrentTab = newTab
        newTab:SetVisible(true)
    else
        newTab:SetVisible(false)
    end
    
    return newTab
end

function Window:Notify(notifyConfig)
    local NotifyModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Notify.lua"))()
    return NotifyModule.new(notifyConfig, self)
end

return Window
