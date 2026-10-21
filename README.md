<div align="center">

# ✨ OP-CODE AnimatedUI Library

### Animated • Customizable • Mobile-Friendly Roblox UI

[![Roblox](https://img.shields.io/badge/Platform-Roblox-00A2FF?style=for-the-badge&logo=robloxstudio&logoColor=white)](https://create.roblox.com/)
[![Language](https://img.shields.io/badge/Language-Luau-2C2D72?style=for-the-badge)](https://luau.org/)
[![GitHub](https://img.shields.io/badge/Source-GitHub-181717?style=for-the-badge&logo=github)](https://github.com/Saputra0231/Op.CodeLibrary)

**A sleek Roblox UI library featuring animated sprite-sheet backgrounds, live theme controls, and flexible components.**

[Features](#-features) • [Quick Start](#-quick-start) • [Components](#-components) • [Customization](#-customization) • [Notes](#-notes)

</div>

---

## 🌟 Features

- 🎞️ **9 animated backgrounds** — Skulls, Wave, Clouds, Fireworks, Gold, Matrix, Blue Glitch, Glow Neon, and RY GANTENG.
- 🎨 **Live theme switcher** with custom theme support.
- 🖼️ **Custom floating logo** to open or close the interface.
- 👤 **Player profile** with Roblox avatar, display name, username, and real-time clock *(requires the profile-enabled library version)*.
- 📱 **Mobile-friendly** layout with draggable and resizable window.
- 🧩 **Ready-to-use components** — Button, Toggle, Slider, Input, Dropdown, Section, and Paragraph.
- ⚡ **Live controls** for animation selection, transparency, and playback.
- 🔊 **Optional UI sounds**.

## 🚀 Quick Start

Use the library's existing raw GitHub URL:

```lua
local AnimatedUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Saputra0231/Op.CodeLibrary/refs/heads/main/AnimatedUILibrary_V2_Pro.lua"
))()

local Window = AnimatedUI:CreateWindow({
    Name = "OP_CODE_Demo",
    Title = "OP-CODE PREMIUM HUB",
    Theme = "Midnight",
    Animation = "RY GANTENG",
    Transparency = 0.35,
    Size = UDim2.fromOffset(570, 420),
    LogoId = 95922158965353,
    Sounds = true
})

local Main = Window:CreateTab({ Title = "Main" })
Main:Section("Welcome to OP-CODE")
Main:Paragraph({ Text = "Animated UI, your style." })
Main:Button({
    Title = "Try Me",
    Callback = function()
        print("OP-CODE works!")
    end
})
```

> **Important:** This example uses `loadstring` and `game:HttpGet`, which are not supported in ordinary Roblox Studio game scripts. For a standard Roblox experience, integrate the library as an appropriate ModuleScript and use supported Roblox APIs.

## 🧩 Components

| Component | Example |
|---|---|
| Section | `Main:Section("General")` |
| Paragraph | `Main:Paragraph({Text="Hello!"})` |
| Button | `Main:Button({Title="Click", Callback=function() end})` |
| Toggle | `Main:Toggle({Title="Enabled", Value=false, Callback=function(v) end})` |
| Slider | `Main:Slider({Title="Volume", Min=0, Max=100, Default=50, Callback=function(v) end})` |
| Input | `Main:Input({Title="Message", Callback=function(text) end})` |
| Dropdown | `Main:Dropdown({Title="Theme", Values={"Midnight"}, Value="Midnight", Callback=function(v) end})` |

## 🎨 Customization

### Change themes live

```lua
local Setting = Window:CreateTab({ Title = "Setting" })

Setting:Dropdown({
    Title = "Choose Theme",
    Values = Window:GetThemes(),
    Value = "Midnight",
    Callback = function(theme)
        if type(theme) == "table" then theme = theme[1] end
        Window:SetTheme(theme)
    end
})
```

### Switch animated backgrounds

```lua
local Animations = {
    "Skulls", "Wave", "Clouds", "Fireworks", "Gold",
    "Matrix", "Blue Glitch", "Glow Neon", "RY GANTENG"
}

Setting:Dropdown({
    Title = "Background Animation",
    Values = Animations,
    Value = "RY GANTENG",
    Callback = function(name)
        if type(name) == "table" then name = name[1] end
        Window:SetAnimation(name)
    end
})

Setting:Slider({
    Title = "Transparency",
    Min = 0, Max = 100, Default = 35,
    Callback = function(value)
        Window:SetTransparency(value / 100)
    end
})

Setting:Toggle({
    Title = "Play Animation",
    Value = true,
    Callback = function(enabled)
        Window:SetPlaying(enabled)
    end
})
```

### Custom neon theme

```lua
Window:SetCustomTheme({
    Background = Color3.fromRGB(9, 16, 20),
    Header = Color3.fromRGB(12, 27, 33),
    Sidebar = Color3.fromRGB(14, 30, 39),
    Control = Color3.fromRGB(27, 54, 64),
    Accent = Color3.fromRGB(0, 255, 190),
    Border = Color3.fromRGB(0, 255, 190),
    Text = Color3.fromRGB(245, 255, 255),
    Overlay = Color3.fromRGB(3, 12, 15)
})
```

## 🧭 Suggested Tab Layout

```text
OP-CODE PREMIUM HUB
├── Main
├── Information
└── Setting
```

Tabs appear in the order they are created, provided the loaded library does not apply its own sorting.

## 🖼️ Screenshots

Add your screenshots to the repository's `assets` folder, then uncomment these lines:

![OP-CODE UI Preview](https://github.com/Saputra0231/Op.CodeLibrary/blob/main/Screenshot_2026-10-21-23-52-38-198_com.roblox.client.jpg)

![OP-CODE Banner](assets/banner.png)

## 📌 Notes

- Replace `LogoId` with a Roblox image asset accessible to your experience.
- The floating logo and in-window player avatar are separate elements when supported by the installed library version.
- Feature availability depends on the version currently hosted at the raw GitHub URL.
- This README documents the intended example API; test your specific library build before publishing it to others.

## 👨‍💻 Developer

Made by **OP-CODE**  
GitHub: [@Saputra0231](https://github.com/Saputra0231)

---

<div align="center">

**⭐ If you enjoy OP-CODE AnimatedUI, consider starring the repository!**

*Build your UI. Choose your theme. Bring it to life.*

</div>
