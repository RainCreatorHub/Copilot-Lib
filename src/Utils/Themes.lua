-- Themes.lua
-- Sistema básico de temas

local Themes = {}

Themes.Default = {
    Background = Color3.fromRGB(24, 24, 32),
    Accent = Color3.fromRGB(0, 170, 255),
    Section = Color3.fromRGB(32, 32, 40),
    Text = Color3.fromRGB(235, 235, 245),
    SubText = Color3.fromRGB(190, 190, 200),
    Success = Color3.fromRGB(35, 220, 60),
    Error = Color3.fromRGB(220, 35, 60),
}

function Themes:Get(name)
    return Themes[name] or Themes.Default
end

return Themes
