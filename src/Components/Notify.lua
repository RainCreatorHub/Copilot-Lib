-- Notify.lua
-- Componente para notificações flutuantes com botões customizados

local TweenService = game:GetService("TweenService")
local Themes = require(script.Parent.Parent.Utils.Themes)

local Notify = {}
Notify.__index = Notify

function Notify.Show(parent, data)
    local theme = Themes:Get("Default")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 90)
    frame.Position = UDim2.new(0.5, -160, 0, 30)
    frame.BackgroundColor3 = theme.Section
    frame.BackgroundTransparency = 0
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    if data.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Image = data.Icon
        icon.Size = UDim2.new(0, 32, 0, 32)
        icon.Position = UDim2.new(0, 10, 0, 8)
        icon.BackgroundTransparency = 1
        icon.Parent = frame
    end

    local title = Instance.new("TextLabel")
    title.Text = data.Title or "Notificação"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextColor3 = theme.Text
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -52, 0, 20)
    title.Position = UDim2.new(0, data.Icon and 52 or 10, 0, 8)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.Text = data.Desc or ""
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 14
    desc.TextColor3 = theme.SubText
    desc.BackgroundTransparency = 1
    desc.Size = UDim2.new(1, -52, 0, 32)
    desc.Position = UDim2.new(0, data.Icon and 52 or 10, 0, 30)
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextWrapped = true
    desc.Parent = frame

    local btns = {}
    if data.Buttons and #data.Buttons > 0 then
        for i, btnData in ipairs(data.Buttons) do
            local btn = Instance.new("TextButton")
            btn.Text = btnData.Title or "Opção"
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = theme.Text
            btn.BackgroundColor3 = theme.Accent
            btn.Size = UDim2.new(0, 80, 0, 24)
            btn.Position = UDim2.new(1, -90*i, 1, -34)
            btn.AnchorPoint = Vector2.new(1,1)
            btn.BorderSizePixel = 0
            btn.Parent = frame
            btn.MouseButton1Click:Connect(function()
                if btnData.Callback then btnData.Callback() end
                frame:Destroy()
            end)
            table.insert(btns, btn)
        end
    else
        -- Autoclose se não houver botão
        task.spawn(function()
            wait(2.5)
            TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            wait(0.3)
            frame:Destroy()
        end)
    end

    return frame
end

return Notify
