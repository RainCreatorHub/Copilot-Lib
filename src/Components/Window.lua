local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    self.Title = config.Title or "Window"
    self.SubTitle = config.SubTitle or ""
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsOpen = true -- Track window state
    
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
    -- Use IgnoreGuiInset to have consistent sizing across devices[citation:10]
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Window Container
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainWindow"
    self.MainFrame.Size = UDim2.new(0, 470, 0, 340) -- Fixed size as requested
    -- Center the window using AnchorPoint and Scale[citation:2]
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- True center
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(33, 38, 45) -- GitHub dark
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Corner rounding
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
end

function Window:_CreateTitleBar()
    local TitleBarModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/TitleBar.lua"))()
    self.TitleBar = TitleBarModule.new({
        Title = self.Title,
        SubTitle = self.SubTitle,
        Parent = self.MainFrame
    })
end

-- Métodos Públicos
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
    -- positionTable should be {XScale, XOffset, YScale, YOffset}
    if self.MainFrame and type(positionTable) == "table" and #positionTable >= 4 then
        local newPos = UDim2.new(
            positionTable[1] or 0, positionTable[2] or 0,
            positionTable[3] or 0, positionTable[4] or 0
        )
        self.MainFrame.Position = newPos
    end
end

function Window:SetSize(sizeTable)
    -- sizeTable should be {Width, Height} in pixels
    if self.MainFrame and type(sizeTable) == "table" and #sizeTable >= 2 then
        local newSize = UDim2.new(0, sizeTable[1] or 470, 0, sizeTable[2] or 340)
        self.MainFrame.Size = newSize
    end
end

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
        self.ScreenGui = nil
    end
    self.IsOpen = false
end

function Window:Close()
    if self.ScreenGui then
        self.ScreenGui.Enabled = false
        self.IsOpen = false
    end
end

function Window:Open()
    if self.ScreenGui then
        self.ScreenGui.Enabled = true
        self.IsOpen = true
    end
end

-- In your existing Window.lua file, update the Tab method:

function Window:Tab(tabConfig)
    local TabModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Tab.lua"))()
    local newTab = TabModule.new(tabConfig, self.TabContainer)
    table.insert(self.Tabs, newTab)
    
    -- Set as current tab if it's the first one
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
