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

local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(config, parent)
    local self = setmetatable({}, Paragraph)
    self.Name = config.Name or "Paragraph"
    self.Desc = config.Desc or ""
    self.Icon = config.Icon or nil
    self.Locked = config.Locked or false
    self.Parent = parent
    self:_Create()
    return self
end

function Paragraph:_Create()
    self.Container = Instance.new("Frame")
    self.Container.Name = "Paragraph_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.BackgroundTransparency = 1
    self.Container.LayoutOrder = 999
    self.Container.Parent = self.Parent

    self.Background = Instance.new("Frame")
    self.Background.Name = "Background"
    self.Background.Size = UDim2.new(1, 0, 0, 55)
    self.Background.Position = UDim2.new(0, 0, 0, 0)
    self.Background.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
    self.Background.BorderSizePixel = 1
    self.Background.BorderColor3 = Color3.fromRGB(48, 54, 61)
    self.Background.Parent = self.Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.Background

    if self.Icon then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        self.IconLabel.Position = UDim2.new(0, 10, 0, 10)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = ResolveIcon(self.Icon)
        self.IconLabel.Parent = self.Background
    end

    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Name = "Name"
    self.NameLabel.Size = UDim2.new(1, self.Icon and -35 or -20, 0, 20)
    self.NameLabel.Position = UDim2.new(0, self.Icon and 35 or 10, 0, 10)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = self.Name
    self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.NameLabel.TextSize = 14
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Font = Enum.Font.GothamBold
    self.NameLabel.Parent = self.Background

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Desc"
    self.DescLabel.Size = UDim2.new(1, -20, 0, 25)
    self.DescLabel.Position = UDim2.new(0, 10, 0, 30)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = self.Desc
    self.DescLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    self.DescLabel.TextSize = 11
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.DescLabel.TextWrapped = true
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.Parent = self.Background

    self:_UpdateLockedAppearance()
end

function Paragraph:_UpdateLockedAppearance()
    if self.Locked then
        self.Background.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
        self.NameLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
        self.DescLabel.TextColor3 = Color3.fromRGB(108, 117, 125)
    else
        self.Background.BackgroundColor3 = Color3.fromRGB(33, 38, 45)
        self.NameLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
        self.DescLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    end
end

function Paragraph:SetName(newName)
    self.Name = newName
    if self.NameLabel then
        self.NameLabel.Text = newName
    end
end

function Paragraph:SetDesc(newDesc)
    self.Desc = newDesc
    if self.DescLabel then
        self.DescLabel.Text = newDesc
    end
end

function Paragraph:SetIcon(newIcon)
    self.Icon = newIcon
    if self.IconLabel then
        self.IconLabel.Image = ResolveIcon(newIcon)
    elseif newIcon and self.Background then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        self.IconLabel.Position = UDim2.new(0, 10, 0, 10)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = ResolveIcon(newIcon)
        self.IconLabel.Parent = self.Background
        if self.NameLabel then
            self.NameLabel.Position = UDim2.new(0, 35, 0, 10)
            self.NameLabel.Size = UDim2.new(1, -40, 0, 20)
        end
    end
end

function Paragraph:SetLocked(isLocked)
    self.Locked = isLocked
    self:_UpdateLockedAppearance()
end

return Paragraph
