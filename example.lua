--[[
    OP-CODE PREMIUM HUB
    FULL EXAMPLE SCRIPT V3.1

    TAB ORDER:
    1. Main
    2. Information
    3. Setting

    FITUR:
    - Custom Floating Logo
    - Animated Background (9 GIF)
    - Live Theme Switcher
    - Background Transparency
    - Animation Play / Pause
    - Next / Previous Animation
    - Floating Button
    - GUI Resize & Drag
    - Mobile Support
    - Sound Effects
]]

--------------------------------------------------
-- LOAD LIBRARY
--------------------------------------------------

local AnimatedUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Saputra0231/Op.CodeLibrary/refs/heads/main/AnimatedUILibrary_V2_Pro.lua"
))()

--------------------------------------------------
-- CONFIGURATION
--------------------------------------------------

local LOGO_ID = 95922158965353

local Animations = {
    "Skulls",
    "Wave",
    "Clouds",
    "Fireworks",
    "Gold",
    "Matrix",
    "Blue Glitch",
    "Glow Neon",
    "RY GANTENG"
}

local CurrentAnimation = 9
local CurrentTheme = "Midnight"

--------------------------------------------------
-- CREATE WINDOW
--------------------------------------------------

local Window = AnimatedUI:CreateWindow({
    Name = "OP_CODE_PremiumHub",
    Title = "OP-CODE PREMIUM HUB",

    Theme = CurrentTheme,
    Animation = Animations[CurrentAnimation],
    Transparency = 0.35,

    Size = UDim2.fromOffset(570, 420),

    LogoId = LOGO_ID,

    Sounds = true
})

--------------------------------------------------
-- 1. MAIN TAB
--------------------------------------------------

local Main = Window:CreateTab({
    Title = "Main"
})

Main:Section("OP-CODE PREMIUM HUB")

Main:Paragraph({
    Text = "Welcome to OP-CODE AnimatedUI Library!"
})

Main:Button({
    Title = "Test Button",

    Callback = function()
        print("[OP-CODE] Button clicked!")
    end
})

Main:Toggle({
    Title = "Test Toggle",
    Value = false,

    Callback = function(value)
        print("[OP-CODE] Toggle:", value)
    end
})

Main:Slider({
    Title = "Volume Test",
    Min = 0,
    Max = 100,
    Default = 50,

    Callback = function(value)
        print("[OP-CODE] Volume:", value)
    end
})

Main:Input({
    Title = "Message",

    Callback = function(text)
        print("[OP-CODE] Message:", text)
    end
})

--------------------------------------------------
-- 2. INFORMATION TAB
--------------------------------------------------

local Info = Window:CreateTab({
    Title = "Information"
})

Info:Section("ABOUT OP-CODE")

Info:Paragraph({
    Text =
        "OP-CODE AnimatedUI Library V3.1\n\n" ..
        "Developer: OP-CODE\n\n" ..
        "Features:\n" ..
        "- 9 Animated Backgrounds\n" ..
        "- 9 GUI Themes\n" ..
        "- Custom Theme Support\n" ..
        "- Custom Floating Logo\n" ..
        "- Draggable & Resizable Window\n" ..
        "- Mobile Support\n" ..
        "- Live Appearance Settings"
})

Info:Button({
    Title = "Print Library Info",

    Callback = function()
        print("OP-CODE AnimatedUI Library V3.1")
        print("Developer: OP-CODE")
    end
})

--------------------------------------------------
-- 3. SETTING TAB
--------------------------------------------------

local Setting = Window:CreateTab({
    Title = "Setting"
})

Setting:Section("ANIMATED BACKGROUND")

--------------------------------------------------
-- ANIMATION DROPDOWN
--------------------------------------------------

Setting:Dropdown({
    Title = "Pilih Animasi",
    Values = Animations,
    Value = Animations[CurrentAnimation],

    Callback = function(selected)

        if type(selected) == "table" then
            selected = selected[1]
        end

        if not selected then
            return
        end

        for index, name in ipairs(Animations) do
            if name == selected then
                CurrentAnimation = index
                break
            end
        end

        Window:SetAnimation(selected)

        print("[OP-CODE] Animation:", selected)
    end
})

--------------------------------------------------
-- NEXT ANIMATION
--------------------------------------------------

Setting:Button({
    Title = "Next Animation ▶",

    Callback = function()

        CurrentAnimation =
            (CurrentAnimation % #Animations) + 1

        Window:SetAnimation(
            Animations[CurrentAnimation]
        )

        print(
            "[OP-CODE] Animation:",
            Animations[CurrentAnimation]
        )
    end
})

--------------------------------------------------
-- PREVIOUS ANIMATION
--------------------------------------------------

Setting:Button({
    Title = "◀ Previous Animation",

    Callback = function()

        CurrentAnimation =
            ((CurrentAnimation - 2) % #Animations) + 1

        Window:SetAnimation(
            Animations[CurrentAnimation]
        )

        print(
            "[OP-CODE] Animation:",
            Animations[CurrentAnimation]
        )
    end
})

--------------------------------------------------
-- BACKGROUND TRANSPARENCY
--------------------------------------------------

Setting:Section("BACKGROUND SETTINGS")

Setting:Slider({
    Title = "Background Transparency",
    Min = 0,
    Max = 100,
    Default = 35,

    Callback = function(value)
        Window:SetTransparency(value / 100)
    end
})

--------------------------------------------------
-- ANIMATION PLAY / PAUSE
--------------------------------------------------

Setting:Toggle({
    Title = "Play Animation",
    Value = true,

    Callback = function(enabled)
        Window:SetPlaying(enabled)
    end
})

--------------------------------------------------
-- THEME MANAGER
--------------------------------------------------

Setting:Section("THEME MANAGER")

Setting:Dropdown({
    Title = "Pilih Tema",
    Values = Window:GetThemes(),
    Value = CurrentTheme,

    Callback = function(theme)

        if type(theme) == "table" then
            theme = theme[1]
        end

        if not theme then
            return
        end

        CurrentTheme = theme

        Window:SetTheme(theme)

        print("[OP-CODE] Theme:", theme)
    end
})

--------------------------------------------------
-- CUSTOM THEME
--------------------------------------------------

Setting:Button({
    Title = "Custom Neon Theme",

    Callback = function()

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

        print("[OP-CODE] Custom theme applied!")
    end
})

--------------------------------------------------
-- RESET APPEARANCE
--------------------------------------------------

Setting:Section("RESET")

Setting:Button({
    Title = "Reset Appearance",

    Callback = function()

        CurrentAnimation = 9
        CurrentTheme = "Midnight"

        Window:SetAnimation("RY GANTENG")
        Window:SetTransparency(0.35)
        Window:SetPlaying(true)
        Window:SetTheme("Midnight")

        print("[OP-CODE] Appearance reset!")
    end
})

--------------------------------------------------
-- START
--------------------------------------------------

print("====================================")
print(" OP-CODE PREMIUM HUB")
print(" AnimatedUI Library V3.1")
print(" Status: Loaded")
print("====================================")
