local Tab = {}
Tab.__index = Tab

function Tab.new(config, parent)
    local self = setmetatable({}, Tab)
    
    self.Name = config.Name or "New Tab"
    self.Icon = config.Icon or nil
    self.Locked = config.Locked or false
    self.Parent = parent
    self.Visible = false
    self.Sections = {}
    self.Elements = {}
    
    self:_Create()
    
    return self
end

function Tab:_Create()
    -- Main tab container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Tab_" .. string.gsub(self.Name, " ", "_")
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.Position = UDim2.new(0, 0, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.Visible = false
    self.Container.Parent = self.Parent
    
    -- Content area
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 0)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.Container
    
    -- UIListLayout para organizar elementos verticalmente
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = self.ContentFrame
    
    -- Content label (placeholder)
    self.ContentLabel = Instance.new("TextLabel")
    self.ContentLabel.Name = "ContentLabel"
    self.ContentLabel.Size = UDim2.new(1, -20, 0, 20)
    self.ContentLabel.Position = UDim2.new(0, 10, 0, 10)
    self.ContentLabel.BackgroundTransparency = 1
    self.ContentLabel.Text = self.Name .. " Content" .. (self.Locked and " (Locked)" or "")
    self.ContentLabel.TextColor3 = Color3.fromRGB(248, 250, 252)
    self.ContentLabel.TextSize = 14
    self.ContentLabel.Font = Enum.Font.Gotham
    self.ContentLabel.LayoutOrder = 0
    self.ContentLabel.Parent = self.ContentFrame
end

function Tab:_UpdateLockedAppearance()
    if self.Locked then
        if self.ContentLabel then
            self.ContentLabel.Text = self.Name .. " Content (Locked)"
        end
    else
        if self.ContentLabel then
            self.ContentLabel.Text = self.Name .. " Content"
        end
    end
end

-- Public Methods
function Tab:SetName(newName)
    self.Name = newName
    if self.ContentLabel then
        self.ContentLabel.Text = newName .. " Content" .. (self.Locked and " (Locked)" or "")
    end
end

function Tab:SetIcon(newIcon)
    self.Icon = newIcon
end

function Tab:SetLocked(isLocked)
    self.Locked = isLocked
    self:_UpdateLockedAppearance()
end

function Tab:SetVisible(visible)
    self.Visible = visible
    self.Container.Visible = visible
end

-- Section Methods
function Tab:Section(sectionConfig)
    local SectionModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Components/Section.lua"))()
    local newSection = SectionModule.new(sectionConfig, self.ContentFrame)
    table.insert(self.Sections, newSection)
    return newSection
end

-- Paragraph Methods
function Tab:Paragraph(paragraphConfig)
    local ParagraphModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Paragraph.lua"))()
    local newParagraph = ParagraphModule.new(paragraphConfig, self.ContentFrame)
    table.insert(self.Elements, newParagraph)
    return newParagraph
end

-- Button Methods
function Tab:Button(buttonConfig)
    local ButtonModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/src/Elements/Button.lua"))()
    local newButton = ButtonModule.new(buttonConfig, self.ContentFrame)
    table.insert(self.Elements, newButton)
    return newButton
end

return Tab
