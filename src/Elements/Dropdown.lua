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

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(config, parent)
    local self = setmetatable({}, Dropdown)
    self.Name = config.Name or "Dropdown"
    self.Desc = config.Desc or ""
    self.Icon = config.Icon
    self.Options = config.Options or {}
    self.Defalth = config.Defalth
    self.Multi = config.Multi or false
    self.Callback = config.Callback or function() end
    self.Parent = parent
    self:_Create()
    return self
end

function Dropdown:_Create()
    self.Container = Instance.new("Frame")
    self.Container.Name = "Dropdown_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 0, 60)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Parent

    if self.Icon then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        self.IconLabel.Position = UDim2.new(0, 10, 0, 10)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = ResolveIcon(self.Icon)
        self.IconLabel.Parent = self.Container
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
    self.NameLabel.Parent = self.Container

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Desc"
    self.DescLabel.Size = UDim2.new(1, -20, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 10, 0, 30)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = self.Desc
    self.DescLabel.TextColor3 = Color3.fromRGB(139, 148, 160)
    self.DescLabel.TextSize = 11
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.Parent = self.Container

    self.Dropdown = Instance.new("TextButton")
    self.Dropdown.Name = "DropdownButton"
    self.Dropdown.Size = UDim2.new(1, -20, 0, 24)
    self.Dropdown.Position = UDim2.new(0, 10, 0, 47)
    self.Dropdown.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
    self.Dropdown.Text = "Selecionar"
    self.Dropdown.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.Dropdown.Font = Enum.Font.Gotham
    self.Dropdown.TextSize = 12
    self.Dropdown.Parent = self.Container
end

function Dropdown:SetName(name)
    self.Name = name
    if self.NameLabel then
        self.NameLabel.Text = name
    end
end

function Dropdown:SetDesc(desc)
    self.Desc = desc
    if self.DescLabel then
        self.DescLabel.Text = desc
    end
end

function Dropdown:SetIcon(icon)
    self.Icon = icon
    if self.IconLabel then
        self.IconLabel.Image = ResolveIcon(icon)
    elseif icon then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        self.IconLabel.Position = UDim2.new(0, 10, 0, 10)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = ResolveIcon(icon)
        self.IconLabel.Parent = self.Container
        if self.NameLabel then
            self.NameLabel.Position = UDim2.new(0, 35, 0, 10)
            self.NameLabel.Size = UDim2.new(1, -40, 0, 20)
        end
    end
end

function Dropdown:SetOptions(options)
    self.Options = options
end

function Dropdown:Refresh()
end

function Dropdown:SetDefalth(def)
    self.Defalth = def
end

function Dropdown:SetMulti(multi)
    self.Multi = multi
end

return Dropdown
