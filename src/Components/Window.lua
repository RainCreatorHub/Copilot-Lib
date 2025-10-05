local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    self.Title = config.Title or "Window"
    self.SubTitle = config.SubTitle or ""
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:_CreateGUI()
    self:_CreateTitleBar()
    
    return self
end

function Window:_CreateGUI()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "DeepLibWindow"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainWindow"
    
    -- Tamanho fixo conforme solicitado
    self.MainFrame.Size = UDim2.new(0, 470, 0, 340)
    
    -- POSIÇÃO OTIMIZADA PARA MOBILE - CENTRO DA TELA
    -- Usando Scale para responsividade e pequenos offsets para ajuste fino
    self.MainFrame.Position = UDim2.new(0.5, -235, 0.5, -170)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Cor de fundo estilo GitHub
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Shadow effect para profundidade
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
    
    -- Content area (below title bar)
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, 0, 1, -60) -- Space for title bar
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
    
    -- ADICIONANDO RESPONSIVIDADE PARA MOBILE
    self:_SetupMobileResponsive()
end

function Window:_SetupMobileResponsive()
    -- Detecta se é um dispositivo móvel
    local isMobile = (game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled)
    
    if isMobile then
        -- Ajustes específicos para mobile
        local aspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
        aspectRatioConstraint.AspectRatio = 470/340
        aspectRatioConstraint.Parent = self.MainFrame
        
        -- Garante que a janela não ultrapasse os limites da tela no mobile
        local screenSize = game:GetService("Workspace").CurrentCamera.ViewportSize
        
        -- Se a tela for muito pequena, ajusta o tamanho mantendo a proporção
        if screenSize.X < 500 or screenSize.Y < 400 then
            local scale = math.min(0.9, 400/screenSize.Y)
            self.MainFrame.Size = UDim2.new(0, 470 * scale, 0, 340 * scale)
            self.MainFrame.Position = UDim2.new(0.5, -235 * scale, 0.5, -170 * scale)
        end
        
        -- Adiciona gesto de arrastar para mover a janela no mobile
        self:_AddDragFunctionality()
    end
end

function Window:_AddDragFunctionality()
    local dragInput, dragStart, startPos
    local dragging = false
    
    local function update(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    self.TitleBar.Container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.Container.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            update(input)
        end
    end)
end

function Window:_CreateTitleBar()
    local TitleBarModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/TitleBar.lua"))()
    self.TitleBar = TitleBarModule.new({
        Title = self.Title,
        SubTitle = self.SubTitle,
        Parent = self.MainFrame
    })
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

-- In src/Components/Window.lua, inside the Window module

function Window:SetTitle(newTitle)
    if self.TitleBar and self.TitleBar.UpdateTitle then
        self.TitleBar:UpdateTitle(newTitle)
    end
    self.Title = newTitle
end

function Window:SetSubTitle(newSubTitle)
    if self.TitleBar and self.TitleBar.UpdateSubTitle then
        self.TitleBar:UpdateSubTitle(newSubTitle)
    end
    self.SubTitle = newSubTitle
end

function Window:SetPos(newPosition)
    -- newPosition should be a UDim2 value
    -- Example: UDim2.new(0.5, -235, 0.5, -170)
    if self.MainFrame and typeof(newPosition) == "UDim2" then
        self.MainFrame.Position = newPosition
    end
end

function Window:SetSize(newSize)
    -- newSize should be a UDim2 value
    -- Example: UDim2.new(0, 470, 0, 340)
    if self.MainFrame and typeof(newSize) == "UDim2" then
        self.MainFrame.Size = newSize
    end
end

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
        self.ScreenGui = nil
    end
    -- Clean up other references to help with memory
    self.Tabs = nil
    self.CurrentTab = nil
end

function Window:Close()
    if self.ScreenGui then
        self.ScreenGui.Enabled = false
        -- Alternatively, you can use: self.ScreenGui.Visible = false
    end
end

function Window:Open()
    if self.ScreenGui then
        self.ScreenGui.Enabled = true
        -- Alternatively, you can use: self.ScreenGui.Visible = true
    end
end

-- Método para centralizar a janela (útil caso o usuário a mova)
function Window:Center()
    self.MainFrame.Position = UDim2.new(0.5, -235, 0.5, -170)
end

return Window
