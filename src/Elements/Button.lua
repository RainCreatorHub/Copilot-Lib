local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Icons.lua"))()
local function ResolveIcon(icon)
    if type(icon) == "number" then
        return "rbxassetid://" .. icon
    elseif type(icon) == "string" then
        if icon:sub(1, 13) == "rbxassetid://" then
            return icon
        elseif Icons[icon] then
            return "rbxassetid://" .. Icons[icon]
        end
    end
    return nil
end

local Button = {}
Button.__index = Button

function Button.new(config, parent, theme)
    local self = setmetatable({}, Button)
    self.Name = config.Name or "Button"
    self.Desc = config.Desc or ""
    self.Icon = config.Icon
    self.Callback = config.Callback or function() end
    self.Parent = parent
    self.Theme = theme or {
        Background = Color3.fromRGB(33, 38, 45),
        BackgroundSecondary = Color3.fromRGB(25, 30, 35),
        Text = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(139, 148, 160),
        Accent = Color3.fromRGB(33, 139, 255),
        Border = Color3.fromRGB(48, 54, 61)
    }
    self.Locked = false
    self:_Create()
    return self
end

function Button:_Create()
    self.Container = Instance.new("Frame")
    self.Container.Name = "Button_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 0, 50)
    self.Container.BackgroundTransparency = 1
    self.Container.LayoutOrder = 999
    self.Container.Parent = self.Parent

    self.ButtonFrame = Instance.new("TextButton")
    self.ButtonFrame.Name = "Button"
    self.ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
    self.ButtonFrame.Position = UDim2.new(0, 0, 0, 0)
    self.ButtonFrame.BackgroundColor3 = self.Theme.Background
    self.ButtonFrame.BorderSizePixel = 1
    self.ButtonFrame.BorderColor3 = self.Theme.Border
    self.ButtonFrame.Text = ""
    self.ButtonFrame.Parent = self.Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.ButtonFrame

    if self.Icon then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        self.IconLabel.Position = UDim2.new(0, 10, 0, 10)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = ResolveIcon(self.Icon)
        self.IconLabel.Parent = self.ButtonFrame
    end

    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, self.Icon and -35 or -20, 0, 20)
    self.NameLabel.Position = UDim2.new(0, self.Icon and 35 or 10, 0, 5)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = self.Theme.Text
    self.NameLabel.TextSize = 14
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Font = Enum.Font.GothamBold
    self.NameLabel.Parent = self.ButtonFrame

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Desc"
    self.DescLabel.Size = UDim2.new(1, -20, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 10, 0, 25)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = self.Desc
    self.DescLabel.TextColor3 = self.Theme.TextSecondary
    self.DescLabel.TextSize = 11
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.Parent = self.ButtonFrame

    self.ButtonFrame.MouseEnter:Connect(function()
        if not self.Locked then
            game:GetService("TweenService"):Create(
                self.ButtonFrame,
                TweenInfo.new(0.2),
                {BackgroundColor3 = self.Theme.Background:Lerp(Color3.new(1,1,1), 0.1)}
            ):Play()
        end
    end)

    self.ButtonFrame.MouseLeave:Connect(function()
        if not self.Locked then
            game:GetService("TweenService"):Create(
                self.ButtonFrame,
                TweenInfo.new(0.2),
                {BackgroundColor3 = self.Theme.Background}
            ):Play()
        end
    end)

    self.ButtonFrame.MouseButton1Click:Connect(function()
        if not self.Locked then
            game:GetService("TweenService"):Create(
                self.ButtonFrame,
                TweenInfo.new(0.1),
                {BackgroundColor3 = self.Theme.Accent}
            ):Play()
            wait(0.1)
            game:GetService("TweenService"):Create(
                self.ButtonFrame,
                TweenInfo.new(0.1),
                {BackgroundColor3 = self.Theme.Background}
            ):Play()
            if self.Callback then
                self.Callback()
            end
        end
    end)
end

function Button:SetName(newName)
    self.Name = newName
    if self.NameLabel then
        self.NameLabel.Text = newName
    end
end

function Button:SetDesc(newDesc)
    self.Desc = newDesc
    if self.DescLabel then
        self.DescLabel.Text = newDesc
    end
end

function Button:SetIcon(newIcon)
    self.Icon = newIcon
    if self.IconLabel then
        self.IconLabel.Image = ResolveIcon(newIcon)
    elseif newIcon and self.ButtonFrame then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        self.IconLabel.Position = UDim2.new(0, 10, 0, 10)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = ResolveIcon(newIcon)
        self.IconLabel.Parent = self.ButtonFrame
        if self.NameLabel then
            self.NameLabel.Position = UDim2.new(0, 35, 0, 5)
            self.NameLabel.Size = UDim2.new(1, -40, 0, 20)
        end
    end
end

function Button:SetLocked(isLocked)
    self.Locked = isLocked
    if self.Locked then
        self.ButtonFrame.BackgroundColor3 = self.Theme.BackgroundSecondary
        self.NameLabel.TextColor3 = self.Theme.TextSecondary
    else
        self.ButtonFrame.BackgroundColor3 = self.Theme.Background
        self.NameLabel.TextColor3 = self.Theme.Text
    end
end

return Button
