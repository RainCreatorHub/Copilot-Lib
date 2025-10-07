# `Deep` `Lib`


Uma biblioteca de UI para Roblox com elementos modernos e suporte completo a ícones dinâmicos.

---

## 📦 Load

```lua
local DeepLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/init.lua"))()
```

---

## 🪟 Window

```lua
local window = DeepLib:Window({
    Title = "Janela Demo",
    SubTitle = "Exemplo de todos os elementos",
    Icon = "Arrow" -- pode ser string ("Arrow"), asset id ("rbxassetid://...") ou number (133523441229450)
})
```

---

## 🗂️ Tab

```lua
local tab = window:Tab({
    Name = "Minha Tab",
    Icon = "Arrow"
})
```

---

## 📑 Section

```lua
local section = tab:Section({
    Name = "Minha Seção",
    Icon = "Arrow"
})
```

---

## 📝 Paragraph

```lua
section:Paragraph({
    Name = "Parágrafo Autosize",
    Desc = ("Texto muito grande para testar autosize! "):rep(12),
    Icon = "Arrow"
})
```

---

## 🔘 Button

```lua
section:Button({
    Name = "Botão de Teste",
    Desc = "Clique para notificar.",
    Icon = "Arrow",
    Callback = function()
        window:Notify({
            Title = "Notificação",
            Desc = "Notificação com ícone.",
            Icon = "Arrow"
        })
    end
})
```

---

## 🎚️ Toggle

```lua
section:Toggle({
    Name = "Toggle Exemplo",
    Desc = "Ative/desative algo!",
    Icon = "Arrow",
    Callback = function(state)
        window:Dialog({
            Title = "Estado do Toggle",
            Desc = "O toggle está " .. (state and "Ativado!" or "Desativado!"),
            Icon = "Arrow",
            Options = {
                {Title = "OK"}
            }
        }):Show()
    end
})
```

---

## ⬇️ Dropdown 
{ `Incomplete.` }

```lua
local D = section:Dropdown({
    Name = "Escolha algo",
    Desc = "Dropdown multi-uso",
    Icon = "Arrow",
    Options = {"A", "B", "C"},
    Defalth = "A",
    Multi = false,
    Callback = function(opt) print(opt) end
})

-- Métodos auxiliares do Dropdown:
D:SetName("Novo Nome")
D:SetDesc("Nova descrição")
D:SetIcon("Arrow")
D:SetOptions({"1", "2", "3"})
D:Refresh()
D:SetDefalth("2")
D:SetMulti(true)
```

---

## 💬 Notify
{ `Incomplete.` }

{ `Please use the button` }
```lua
window:Notify({
    Title = "Bem-vindo!",
    Desc = ("Você pode empilhar notificações e usar ícones também! "):rep(5),
    Icon = "Arrow",
    Options = {
        {Title = "Ok", Callback = function() print("Ok!") end}
    }
})
```

---

## 🗨️ Dialog

```lua
window:Dialog({
    Title = "Confirmação",
    Desc = "Tem certeza que deseja continuar?",
    Icon = "Arrow",
    Options = {
        {Title = "Sim", Callback = function() print("Sim!") end},
        {Title = "Não", Callback = function() print("Não!") end}
    }
}):Show()
```

---

# 🧑‍💻 Full Example

```lua
local DeepLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Deep-Lib/refs/heads/main/init.lua"))()

local window = DeepLib:Window({
    Title = "Deep-Lib Demo",
    SubTitle = "Full Example",
    Icon = "Arrow"
})

local tab = window:Tab({
    Name = "Geral",
    Icon = "Arrow"
})

local section = tab:Section({
    Name = "Tudo de Exemplo",
    Icon = "Arrow"
})

section:Paragraph({
    Name = "Texto Expansível",
    Desc = ("Este é um parágrafo longo para testar o autosize de parágrafos. "):rep(10),
    Icon = "Arrow"
})

section:Button({
    Name = "Clique-me",
    Desc = "Mostra uma notificação com ícone.",
    Icon = "Arrow",
    Callback = function()
        window:Notify({
            Title = "Notificação!",
            Desc = ("Notificação com ícone e autosize. "):rep(7),
            Icon = "Arrow",
            Options = {{Title = "Fechar"}}
        })
    end
})

section:Toggle({
    Name = "Ativar Diálogo",
    Desc = "Mostra um diálogo ao ativar.",
    Icon = "Arrow",
    Callback = function(state)
        window:Dialog({
            Title = "Diálogo",
            Desc = "Toggle está " .. (state and "Ligado" or "Desligado"),
            Icon = "Arrow",
            Options = {{Title = "OK"}}
        }):Show()
    end
})

--[[
local D = section:Dropdown({
    Name = "Escolha algo",
    Desc = "Dropdown multi-uso",
    Icon = "Arrow",
    Options = {"Opção 1", "Opção 2", "Opção 3"},
    Defalth = "Opção 1",
    Multi = false,
    Callback = function(opt) print("Selecionado:", opt) end
})

D:SetName("Selecione algo novo")
D:SetDesc("Descrição atualizada!")
D:SetIcon("Arrow")
D:SetOptions({"A", "B", "C"})
D:Refresh()
D:SetDefalth("B")
D:SetMulti(true)
]]
window:Notify({
    Title = "Notificação Inicial",
    Desc = "Tudo pronto para usar Deep-Lib!",
    Icon = "Arrow"
})

window:Dialog({
    Title = "Diálogo Inicial",
    Desc = "Esse é um diálogo de exemplo.",
    Icon = "Arrow",
    Options = {{Title = "Fechar"}}
}):Show()
```
