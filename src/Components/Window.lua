local TitleBar = require(script.Parent.TitleBar)
local Tab = require(script.Parent.Tab)

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
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "DeepLibWindow"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Window Container
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainWindow"
    self.MainFrame.Size = UDim2.new(0, 470, 0, 340)
    self.MainFrame.Position = UDim2.new(0.5, -235, 0.5, -170)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
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
    self.TitleBar = TitleBar.new({
        Title = self.Title,
        SubTitle = self.SubTitle,
        Parent = self.MainFrame
    })
end

function Window:Tab(tabConfig)
    local newTab = Tab.new(tabConfig, self.TabContainer)
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

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return Window
