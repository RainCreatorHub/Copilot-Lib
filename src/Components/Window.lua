-- Window.lua
-- Componente raiz de janela, com suporte para MakeWindow/Notify

local TitleBar = require(script.Parent.TitleBar)
local Notify = require(script.Parent.Notify)
local Themes = require(script.Parent.Parent.Utils.Themes)

local Window = {}
Window.__index = Window

function Window.new(props)
    local self = setmetatable({}, Window)
    local theme = Themes:Get("Default")

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CopilotWindow"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    self.Frame = Instance.new("Frame")
    self.Frame.Size = props.Size or UDim2.new(0, 480, 0, 300)
    self.Frame.Position = UDim2.new(0.5, -240, 0.5, -150)
    self.Frame.BackgroundColor3 = theme.Background
    self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Frame.BorderSizePixel = 0
    self.Frame.Parent = self.ScreenGui
    if props.MinSize then self.MinSize = props.MinSize end
    if props.MaxSize then self.MaxSize = props.MaxSize end

    self.TitleBar = TitleBar.new(props.Title, props.SubTitle, props.Icon, theme)
    self.TitleBar.Frame.Parent = self.Frame

    -- Resizable (básico, pode expandir para lógica real)
    if props.Resizable then
        -- Adicione lógica de resize se desejar
    end

    return self
end

function Window:Notify(args)
    return Notify.Show(self.Frame, args)
end

return Window
