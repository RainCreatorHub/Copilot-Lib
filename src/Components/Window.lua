-- Script principal da Window
local Window = {}
Window.__index = Window

function Window.new(title, size)
    local self = setmetatable({}, Window)
    
    -- Inicializar propriedades primeiro
    self.Container = nil
    self.Dragger = nil
    self.Title = title or "Window"
    self.Size = size or UDim2.new(0, 300, 0, 200)
    
    -- Criar a GUI
    self:_CreateGUI()
    
    return self
end

function Window:_CreateGUI()
    -- Criar a ScreenGui principal
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WindowGUI"
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Criar o Container PRIMEIRO
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Size = self.Size
    self.Container.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    self.Container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    self.Container.BorderSizePixel = 0
    self.Container.ClipsDescendants = true
    self.Container.Parent = self.ScreenGui
    
    -- Criar o título/dragger
    self.Dragger = Instance.new("Frame")
    self.Dragger.Name = "Dragger"
    self.Dragger.Size = UDim2.new(1, 0, 0, 30)
    self.Dragger.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.Dragger.BorderSizePixel = 0
    self.Dragger.Parent = self.Container
    
    -- Adicionar título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextSize = 14
    titleLabel.Parent = self.Dragger
    
    -- VERIFICAÇÃO CRÍTICA: Garantir que Container existe antes de configurar drag
    if not self.Container then
        warn("❌ ERRO: Container não foi criado antes de _SetupDrag")
        return
    end
    
    if not self.Dragger then
        warn("❌ ERRO: Dragger não foi criado antes de _SetupDrag")
        return
    end
    
    -- Agora podemos configurar o drag com segurança
    self:_SetupDrag(self.Dragger, self.Container)
    
    -- Adicionar conteúdo básico
    self:_AddContent()
end

function Window:_SetupDrag(dragger, frame)
    -- VERIFICAÇÃO DUPLA de segurança
    if not dragger or not frame then
        warn("🚨 ERRO CRÍTICO: dragger ou frame é nil em _SetupDrag")
        warn("Dragger:", dragger)
        warn("Frame:", frame)
        return
    end
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    -- Função de update
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    -- Conexões de input
    dragger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

function Window:_AddContent()
    -- Adicionar algum conteúdo básico ao container
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, -30)
    contentFrame.Position = UDim2.new(0, 0, 0, 30)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = self.Container
    
    -- Exemplo de conteúdo
    local exampleText = Instance.new("TextLabel")
    exampleText.Size = UDim2.new(1, -20, 1, -20)
    exampleText.Position = UDim2.new(0, 10, 0, 10)
    exampleText.BackgroundTransparency = 1
    exampleText.Text = "Conteúdo da Window"
    exampleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    exampleText.TextSize = 16
    exampleText.Font = Enum.Font.Gotham
    exampleText.Parent = contentFrame
end

-- Função estática para criar window
function Window.Create(title, size)
    return Window.new(title, size)
end

return Window
