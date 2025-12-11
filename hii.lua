--[[
    ╔═══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                               ║
    ║      ██████╗███████╗███╗   ██╗████████╗██████╗ ██╗██╗  ██╗                    ║
    ║     ██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔══██╗██║╚██╗██╔╝                    ║
    ║     ██║     █████╗  ██╔██╗ ██║   ██║   ██████╔╝██║ ╚███╔╝                     ║
    ║     ██║     ██╔══╝  ██║╚██╗██║   ██║   ██╔══██╗██║ ██╔██╗                     ║
    ║     ╚██████╗███████╗██║ ╚████║   ██║   ██║  ██║██║██╔╝ ██╗                    ║
    ║      ╚═════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝                    ║
    ║                                                                               ║
    ║                    Premium Roblox UI Library                                  ║
    ║              Lavender • Acrylic • Smooth Animations                           ║
    ╚═══════════════════════════════════════════════════════════════════════════════╝
]]

local Centrix = {}
Centrix._VERSION = "1.0.0"

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Try to use CoreGui, fallback to PlayerGui
local ScreenGuiParent = (function()
    local success = pcall(function() return CoreGui.Name end)
    if success then return CoreGui end
    return Player:WaitForChild("PlayerGui")
end)()

-- ═══════════════════════════════════════════════════════════════════════════════
-- THEME - Lavender Purple with White Accents
-- ═══════════════════════════════════════════════════════════════════════════════

local Theme = {
    -- Primary Backgrounds (Dark with purple tint)
    Background = Color3.fromRGB(18, 15, 25),           -- Darkest base
    BackgroundSecondary = Color3.fromRGB(28, 24, 38),  -- Card backgrounds
    BackgroundTertiary = Color3.fromRGB(38, 32, 52),   -- Hover states
    
    -- Accent Colors (Lavender Purple)
    Accent = Color3.fromRGB(180, 140, 255),            -- Main lavender
    AccentDark = Color3.fromRGB(140, 100, 220),        -- Deeper purple
    AccentLight = Color3.fromRGB(210, 180, 255),       -- Light lavender
    AccentGlow = Color3.fromRGB(200, 160, 255),        -- Glow effect
    
    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),              -- Pure white
    TextSecondary = Color3.fromRGB(200, 195, 215),     -- Muted white
    TextMuted = Color3.fromRGB(140, 135, 160),         -- Dimmed text
    
    -- Decorative
    Border = Color3.fromRGB(60, 50, 80),               -- Subtle borders
    Divider = Color3.fromRGB(50, 42, 68),              -- Divider lines
    Shadow = Color3.fromRGB(10, 8, 15),                -- Deep shadow
    
    -- Status Colors
    Success = Color3.fromRGB(120, 220, 150),
    Warning = Color3.fromRGB(255, 200, 100),
    Error = Color3.fromRGB(255, 100, 120),
    Info = Color3.fromRGB(130, 180, 255),
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- ICONS - Predefined Roblox Asset IDs
-- ═══════════════════════════════════════════════════════════════════════════════

Centrix.Icons = {
    -- Navigation
    Home = "rbxassetid://7733960981",
    Settings = "rbxassetid://7734053495",
    Menu = "rbxassetid://7734027200",
    Close = "rbxassetid://7734003889",
    Minimize = "rbxassetid://7734029754",
    
    -- Arrows & Chevrons
    ChevronDown = "rbxassetid://7734004077",
    ChevronUp = "rbxassetid://7734004305",
    ChevronLeft = "rbxassetid://7734003645",
    ChevronRight = "rbxassetid://7734004018",
    ArrowRight = "rbxassetid://7733993319",
    ArrowLeft = "rbxassetid://7733992763",
    
    -- Actions
    Check = "rbxassetid://7733715400",
    Plus = "rbxassetid://7734039954",
    Minus = "rbxassetid://7734029547",
    Search = "rbxassetid://7734051714",
    Filter = "rbxassetid://7734010799",
    Refresh = "rbxassetid://7734043510",
    
    -- Status
    Warning = "rbxassetid://7734062330",
    Info = "rbxassetid://7734014268",
    Error = "rbxassetid://7733996255",
    Success = "rbxassetid://7733715400",
    
    -- Combat & Gaming
    Sword = "rbxassetid://7734055853",
    Shield = "rbxassetid://7734053248",
    Target = "rbxassetid://7734056001",
    Crosshair = "rbxassetid://7734005341",
    Skull = "rbxassetid://7734054619",
    Heart = "rbxassetid://7734013397",
    Fire = "rbxassetid://7734010601",
    
    -- User & Social
    User = "rbxassetid://7734058893",
    Users = "rbxassetid://7734058651",
    Crown = "rbxassetid://7734006247",
    Star = "rbxassetid://7734055553",
    
    -- Files & Data
    Folder = "rbxassetid://7734011232",
    File = "rbxassetid://7734010381",
    Download = "rbxassetid://7734007883",
    Upload = "rbxassetid://7734058439",
    Save = "rbxassetid://7734043337",
    
    -- Tools
    Wrench = "rbxassetid://7734062539",
    Hammer = "rbxassetid://7734012776",
    Key = "rbxassetid://7734019688",
    Lock = "rbxassetid://7734024363",
    Unlock = "rbxassetid://7734058189",
    
    -- Misc
    Eye = "rbxassetid://7734009521",
    EyeOff = "rbxassetid://7734009839",
    Bell = "rbxassetid://7733997459",
    Clock = "rbxassetid://7734001754",
    Globe = "rbxassetid://7734011989",
    Zap = "rbxassetid://7734063191",
    Moon = "rbxassetid://7734030271",
    Sun = "rbxassetid://7734056236",
    Fingerprint = "rbxassetid://7734010601",
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local function Tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.25,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function GetGameName()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if success and info and info.Name then
        return info.Name
    end
    return "Unknown Game"
end

local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = 0.5,
        Parent = parent
    })
end

local function AddGradient(parent, colorSequence, rotation)
    return Create("UIGradient", {
        Color = colorSequence or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
        }),
        Rotation = rotation or 90,
        Parent = parent
    })
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragStart, startPos

    dragHandle = dragHandle or frame

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Tween(frame, {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }, 0.08)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- BLUR EFFECT SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

local BlurEffect = nil
local ColorCorrection = nil

local function CreateBlurEffect()
    -- Remove existing effects
    if BlurEffect then BlurEffect:Destroy() end
    if ColorCorrection then ColorCorrection:Destroy() end
    
    BlurEffect = Create("BlurEffect", {
        Name = "CentrixBlur",
        Size = 0,
        Parent = Lighting
    })
    
    ColorCorrection = Create("ColorCorrectionEffect", {
        Name = "CentrixColorCorrection",
        Brightness = 0,
        Contrast = 0,
        Saturation = 0,
        TintColor = Color3.fromRGB(255, 255, 255),
        Parent = Lighting
    })
    
    return BlurEffect, ColorCorrection
end

local function AnimateBlurIn()
    if not BlurEffect then CreateBlurEffect() end
    
    Tween(BlurEffect, {Size = 24}, 0.5, Enum.EasingStyle.Quint)
    Tween(ColorCorrection, {
        Brightness = -0.05,
        Saturation = -0.1,
        TintColor = Color3.fromRGB(220, 210, 240)
    }, 0.5, Enum.EasingStyle.Quint)
end

local function AnimateBlurOut()
    if not BlurEffect then return end
    
    Tween(BlurEffect, {Size = 0}, 0.4, Enum.EasingStyle.Quint)
    Tween(ColorCorrection, {
        Brightness = 0,
        Saturation = 0,
        TintColor = Color3.fromRGB(255, 255, 255)
    }, 0.4, Enum.EasingStyle.Quint)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

local NotificationContainer = nil

local function CreateNotificationContainer()
    if NotificationContainer then return NotificationContainer end
    
    NotificationContainer = Create("Frame", {
        Name = "CentrixNotifications",
        Size = UDim2.new(0, 320, 1, -40),
        Position = UDim2.new(1, -330, 0, 20),
        BackgroundTransparency = 1,
        Parent = ScreenGuiParent
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = NotificationContainer
    })
    
    return NotificationContainer
end

function Centrix:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 4
    local notifType = options.Type or "Info"
    
    CreateNotificationContainer()
    
    local typeColors = {
        Info = Theme.Info,
        Success = Theme.Success,
        Warning = Theme.Warning,
        Error = Theme.Error
    }
    
    local typeIcons = {
        Info = "ℹ",
        Success = "✓",
        Warning = "⚠",
        Error = "✕"
    }
    
    local accentColor = typeColors[notifType] or Theme.Accent
    local icon = typeIcons[notifType] or "ℹ"
    
    -- Main notification frame
    local notification = Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Theme.BackgroundSecondary,
        BackgroundTransparency = 0.1,
        ClipsDescendants = true,
        Parent = NotificationContainer
    })
    AddCorner(notification, 12)
    AddStroke(notification, Theme.Border, 1)
    
    -- Acrylic inner glow
    local innerGlow = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0.95,
        Parent = notification
    })
    AddCorner(innerGlow, 12)
    
    -- Left accent bar
    local accentBar = Create("Frame", {
        Size = UDim2.new(0, 4, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = accentColor,
        Parent = notification
    })
    AddCorner(accentBar, 2)
    
    -- Icon container
    local iconContainer = Create("Frame", {
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 24, 0.5, -18),
        BackgroundColor3 = Theme.BackgroundTertiary,
        Parent = notification
    })
    AddCorner(iconContainer, 8)
    
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = icon,
        TextColor3 = accentColor,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = iconContainer
    })
    
    -- Title
    Create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20),
        Position = UDim2.new(0, 70, 0, 12),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    -- Message
    Create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 30),
        Position = UDim2.new(0, 70, 0, 32),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = notification
    })
    
    -- Progress bar at bottom
    local progressContainer = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 3),
        Position = UDim2.new(0, 10, 1, -8),
        BackgroundColor3 = Theme.BackgroundTertiary,
        Parent = notification
    })
    AddCorner(progressContainer, 2)
    
    local progressBar = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        Parent = progressContainer
    })
    AddCorner(progressBar, 2)
    
    -- Animate in
    notification.Position = UDim2.new(1, 50, 0, 0)
    notification.BackgroundTransparency = 1
    
    Tween(notification, {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0.1
    }, 0.4, Enum.EasingStyle.Back)
    
    -- Progress bar shrink
    Tween(progressBar, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    -- Auto dismiss
    task.delay(duration, function()
        Tween(notification, {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }, 0.3, Enum.EasingStyle.Quint)
        
        task.wait(0.35)
        notification:Destroy()
    end)
    
    return notification
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- MAIN WINDOW CREATION
-- ═══════════════════════════════════════════════════════════════════════════════

function Centrix:CreateWindow(options)
    options = options or {}
    
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Visible = false
    Window.ToggleKey = options.ToggleKey or Enum.KeyCode.Insert
    
    local gameName = GetGameName()
    
    -- Create blur effect
    CreateBlurEffect()
    
    -- ═══════════════════════════════════════════════════════════════
    -- SCREEN GUI
    -- ═══════════════════════════════════════════════════════════════
    
    local ScreenGui = Create("ScreenGui", {
        Name = "CentrixHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = ScreenGuiParent
    })
    
    -- ═══════════════════════════════════════════════════════════════
    -- MOBILE OPEN BUTTON
    -- ═══════════════════════════════════════════════════════════════
    
    local mobileButton
    if IsMobile() then
        mobileButton = Create("TextButton", {
            Name = "MobileOpenButton",
            Size = UDim2.new(0, 70, 0, 35),
            Position = UDim2.new(0, 15, 0.5, -17),
            BackgroundColor3 = Theme.Accent,
            Text = "OPEN",
            TextColor3 = Theme.Text,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            Parent = ScreenGui
        })
        AddCorner(mobileButton, 8)
        AddStroke(mobileButton, Theme.AccentLight, 2)
        
        -- Glow effect
        local glow = Create("ImageLabel", {
            Size = UDim2.new(1, 20, 1, 20),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://5028857084",
            ImageColor3 = Theme.Accent,
            ImageTransparency = 0.7,
            Parent = mobileButton
        })
        
        -- Pulse animation
        task.spawn(function()
            while mobileButton and mobileButton.Parent do
                Tween(glow, {ImageTransparency = 0.5}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(0.8)
                Tween(glow, {ImageTransparency = 0.8}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(0.8)
            end
        end)
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- MAIN WINDOW FRAME
    -- ═══════════════════════════════════════════════════════════════
    
    local MainFrame = Create("Frame", {
        Name = "MainWindow",
        Size = UDim2.new(0, 520, 0, 380),
        Position = UDim2.new(0.5, -260, 0.5, -190),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.05,
        Visible = false,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 16)
    AddStroke(MainFrame, Theme.Border, 2)
    
    -- Outer glow/shadow
    local outerShadow = Create("ImageLabel", {
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Theme.AccentGlow,
        ImageTransparency = 0.85,
        ZIndex = -1,
        Parent = MainFrame
    })
    
    -- Acrylic inner overlay
    local acrylicOverlay = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    AddCorner(acrylicOverlay, 16)
    
    AddGradient(acrylicOverlay, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 50, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 35, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 35))
    }), 135)
    
    -- ═══════════════════════════════════════════════════════════════
    -- HEADER SECTION
    -- ═══════════════════════════════════════════════════════════════
    
    local Header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    -- Logo/Title: CENTRIX HUB
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -100, 0, 30),
        Position = UDim2.new(0, 20, 0, 12),
        BackgroundTransparency = 1,
        Text = "CENTRIX HUB",
        TextColor3 = Theme.Text,
        TextSize = 22,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    -- Title gradient
    AddGradient(TitleLabel, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentLight),
        ColorSequenceKeypoint.new(1, Theme.Text)
    }), 0)
    
    -- Game name subtitle
    local GameLabel = Create("TextLabel", {
        Name = "GameName",
        Size = UDim2.new(1, -100, 0, 18),
        Position = UDim2.new(0, 20, 0, 42),
        BackgroundTransparency = 1,
        Text = gameName,
        TextColor3 = Theme.TextMuted,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = Header
    })
    
    -- Close button
    local CloseButton = Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(1, -52, 0, 17),
        BackgroundColor3 = Theme.BackgroundTertiary,
        BackgroundTransparency = 0.5,
        Text = "×",
        TextColor3 = Theme.TextMuted,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = Header
    })
    AddCorner(CloseButton, 8)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Theme.Error, BackgroundTransparency = 0.3}, 0.15)
        Tween(CloseButton, {TextColor3 = Theme.Text}, 0.15)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Theme.BackgroundTertiary, BackgroundTransparency = 0.5}, 0.15)
        Tween(CloseButton, {TextColor3 = Theme.TextMuted}, 0.15)
    end)
    
    -- Header divider
    local HeaderDivider = Create("Frame", {
        Size = UDim2.new(1, -40, 0, 1),
        Position = UDim2.new(0, 20, 1, -1),
        BackgroundColor3 = Theme.Divider,
        BorderSizePixel = 0,
        Parent = Header
    })
    
    AddGradient(HeaderDivider, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(0.5, Theme.Divider),
        ColorSequenceKeypoint.new(1, Theme.Accent)
    }), 0)
    
    -- ═══════════════════════════════════════════════════════════════
    -- HORIZONTAL TABS BAR
    -- ═══════════════════════════════════════════════════════════════
    
    local TabsBar = Create("Frame", {
        Name = "TabsBar",
        Size = UDim2.new(1, -40, 0, 44),
        Position = UDim2.new(0, 20, 0, 75),
        BackgroundColor3 = Theme.BackgroundSecondary,
        BackgroundTransparency = 0.3,
        Parent = MainFrame
    })
    AddCorner(TabsBar, 10)
    
    -- Tabs scroll frame (horizontal)
    local TabsScroll = Create("ScrollingFrame", {
        Name = "TabsScroll",
        Size = UDim2.new(1, -10, 1, -8),
        Position = UDim2.new(0, 5, 0, 4),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(0, 0, 1, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        Parent = TabsBar
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = TabsScroll
    })
    
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = TabsScroll
    })
    
    -- Tab indicator (sliding underline)
    local TabIndicator = Create("Frame", {
        Name = "TabIndicator",
        Size = UDim2.new(0, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -5),
        BackgroundColor3 = Theme.Accent,
        Parent = TabsBar
    })
    AddCorner(TabIndicator, 2)
    
    -- ═══════════════════════════════════════════════════════════════
    -- CONTENT AREA
    -- ═══════════════════════════════════════════════════════════════
    
    local ContentFrame = Create("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, -40, 1, -140),
        Position = UDim2.new(0, 20, 0, 125),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainFrame
    })
    
    -- Inside each tab will be a scrolling frame for content
    
    -- Make window draggable
    MakeDraggable(MainFrame, Header)
    
    -- ═══════════════════════════════════════════════════════════════
    -- TOGGLE VISIBILITY
    -- ═══════════════════════════════════════════════════════════════
    
    local function ToggleUI()
        Window.Visible = not Window.Visible
        
        if Window.Visible then
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 520, 0, 0)
            MainFrame.BackgroundTransparency = 1
            
            AnimateBlurIn()
            
            Tween(MainFrame, {
                Size = UDim2.new(0, 520, 0, 380),
                BackgroundTransparency = 0.05
            }, 0.4, Enum.EasingStyle.Back)
            
            if mobileButton then
                Tween(mobileButton, {BackgroundTransparency = 1, Position = UDim2.new(-1, 0, 0.5, -17)}, 0.3)
            end
        else
            AnimateBlurOut()
            
            Tween(MainFrame, {
                Size = UDim2.new(0, 520, 0, 0),
                BackgroundTransparency = 1
            }, 0.3, Enum.EasingStyle.Quint)
            
            if mobileButton then
                Tween(mobileButton, {BackgroundTransparency = 0, Position = UDim2.new(0, 15, 0.5, -17)}, 0.3)
            end
            
            task.delay(0.35, function()
                if not Window.Visible then
                    MainFrame.Visible = false
                end
            end)
        end
    end
    
    -- Close button action
    CloseButton.MouseButton1Click:Connect(ToggleUI)
    
    -- Keybind toggle (Insert key)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Window.ToggleKey then
            ToggleUI()
        end
    end)
    
    -- Mobile button toggle
    if mobileButton then
        mobileButton.MouseButton1Click:Connect(ToggleUI)
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- TAB CREATION
    -- ═══════════════════════════════════════════════════════════════
    
    function Window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local Tab = {}
        Tab.Elements = {}
        
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon or Centrix.Icons.Folder
        
        -- Tab button
        local TabButton = Create("TextButton", {
            Name = tabName .. "Tab",
            Size = UDim2.new(0, 0, 0, 34),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = Theme.BackgroundTertiary,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Parent = TabsScroll
        })
        AddCorner(TabButton, 8)
        
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            Parent = TabButton
        })
        
        -- Tab icon
        local TabIcon = Create("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 0, 0.5, -9),
            BackgroundTransparency = 1,
            Image = tabIcon,
            ImageColor3 = Theme.TextMuted,
            Parent = TabButton
        })
        
        -- Tab label
        local TabLabel = Create("TextLabel", {
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(0, 26, 0, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = Theme.TextMuted,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            Parent = TabButton
        })
        
        -- Tab content page
        local TabPage = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = ContentFrame
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabPage
        })
        
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 8),
            Parent = TabPage
        })
        
        Tab.Button = TabButton
        Tab.Page = TabPage
        Tab.Name = tabName
        Tab.Icon = TabIcon
        Tab.Label = TabLabel
        
        -- Select tab function
        local function SelectTab()
            -- Deselect all tabs
            for _, t in pairs(Window.Tabs) do
                Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(t.Icon, {ImageColor3 = Theme.TextMuted}, 0.2)
                Tween(t.Label, {TextColor3 = Theme.TextMuted}, 0.2)
                t.Page.Visible = false
            end
            
            -- Select this tab
            Tween(TabButton, {BackgroundTransparency = 0.5}, 0.2)
            Tween(TabIcon, {ImageColor3 = Theme.Accent}, 0.2)
            Tween(TabLabel, {TextColor3 = Theme.Text}, 0.2)
            
            -- Animate tab indicator
            local buttonPos = TabButton.AbsolutePosition.X - TabsBar.AbsolutePosition.X
            local buttonSize = TabButton.AbsoluteSize.X
            
            Tween(TabIndicator, {
                Position = UDim2.new(0, buttonPos + 5, 1, -5),
                Size = UDim2.new(0, buttonSize - 10, 0, 3)
            }, 0.25, Enum.EasingStyle.Quint)
            
            -- Animate content in (slide from right)
            TabPage.Visible = true
            TabPage.Position = UDim2.new(0.1, 0, 0, 0)
            Tween(TabPage, {Position = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint)
            
            Window.ActiveTab = Tab
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.7}, 0.15)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            task.defer(SelectTab)
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- ═══════════════════════════════════════════════════════════
        -- DROPDOWN ELEMENT
        -- ═══════════════════════════════════════════════════════════
        
        function Tab:CreateDropdown(dropdownOptions)
            dropdownOptions = dropdownOptions or {}
            local Dropdown = {}
            local isOpen = false
            local items = dropdownOptions.Items or {}
            local multi = dropdownOptions.Multi or false
            local selected = multi and {} or nil
            local callback = dropdownOptions.Callback or function() end
            
            -- Handle default values
            if multi and dropdownOptions.Default then
                for _, v in ipairs(dropdownOptions.Default) do
                    selected[v] = true
                end
            elseif dropdownOptions.Default then
                selected = dropdownOptions.Default
            end
            
            -- Container
            local Container = Create("Frame", {
                Name = (dropdownOptions.Name or "Dropdown") .. "Container",
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundColor3 = Theme.BackgroundSecondary,
                BackgroundTransparency = 0.2,
                ClipsDescendants = true,
                Parent = TabPage
            })
            AddCorner(Container, 10)
            AddStroke(Container, Theme.Border, 1)
            
            -- Header (clickable)
            local DropdownHeader = Create("TextButton", {
                Name = "Header",
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = Container
            })
            
            -- Dropdown label
            Create("TextLabel", {
                Size = UDim2.new(0.5, -20, 0, 20),
                Position = UDim2.new(0, 14, 0.5, -10),
                BackgroundTransparency = 1,
                Text = dropdownOptions.Name or "Dropdown",
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownHeader
            })
            
            -- Selected value display
            local function GetDisplayText()
                if multi then
                    local list = {}
                    for k, v in pairs(selected) do
                        if v then table.insert(list, k) end
                    end
                    if #list == 0 then return "None selected" end
                    if #list > 2 then return #list .. " selected" end
                    return table.concat(list, ", ")
                else
                    return selected or "Select..."
                end
            end
            
            local ValueLabel = Create("TextLabel", {
                Name = "ValueLabel",
                Size = UDim2.new(0.5, -40, 0, 20),
                Position = UDim2.new(0.5, 0, 0.5, -10),
                BackgroundTransparency = 1,
                Text = GetDisplayText(),
                TextColor3 = Theme.Accent,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = DropdownHeader
            })
            
            -- Chevron icon
            local Chevron = Create("TextLabel", {
                Name = "Chevron",
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -28, 0.5, -10),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = Theme.TextMuted,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                Parent = DropdownHeader
            })
            
            -- Items container
            local ItemsContainer = Create("Frame", {
                Name = "ItemsContainer",
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 50),
                BackgroundTransparency = 1,
                Parent = Container
            })
            
            Create("UIListLayout", {
                Padding = UDim.new(0, 4),
                Parent = ItemsContainer
            })
            
            -- Create item buttons
            local function CreateItemButton(itemName)
                local ItemButton = Create("TextButton", {
                    Name = itemName,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Theme.BackgroundTertiary,
                    BackgroundTransparency = 0.5,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ItemsContainer
                })
                AddCorner(ItemButton, 6)
                
                -- Checkbox for multi-select
                local checkbox
                if multi then
                    checkbox = Create("Frame", {
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 8, 0.5, -9),
                        BackgroundColor3 = Theme.Background,
                        Parent = ItemButton
                    })
                    AddCorner(checkbox, 4)
                    AddStroke(checkbox, Theme.Border, 1)
                    
                    local checkmark = Create("TextLabel", {
                        Name = "Checkmark",
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = "✓",
                        TextColor3 = Theme.Accent,
                        TextSize = 12,
                        Font = Enum.Font.GothamBold,
                        TextTransparency = selected[itemName] and 0 or 1,
                        Parent = checkbox
                    })
                end
                
                -- Item text
                Create("TextLabel", {
                    Size = UDim2.new(1, multi and -40 or -20, 1, 0),
                    Position = UDim2.new(0, multi and 34 or 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text = itemName,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ItemButton
                })
                
                -- Hover effects
                ItemButton.MouseEnter:Connect(function()
                    Tween(ItemButton, {BackgroundTransparency = 0.2}, 0.1)
                end)
                
                ItemButton.MouseLeave:Connect(function()
                    Tween(ItemButton, {BackgroundTransparency = 0.5}, 0.1)
                end)
                
                -- Click handler
                ItemButton.MouseButton1Click:Connect(function()
                    if multi then
                        selected[itemName] = not selected[itemName]
                        local check = checkbox:FindFirstChild("Checkmark")
                        Tween(check, {TextTransparency = selected[itemName] and 0 or 1}, 0.15)
                        
                        -- Get selected list
                        local list = {}
                        for k, v in pairs(selected) do
                            if v then table.insert(list, k) end
                        end
                        ValueLabel.Text = GetDisplayText()
                        callback(list)
                    else
                        selected = itemName
                        ValueLabel.Text = itemName
                        callback(itemName)
                        
                        -- Close dropdown
                        isOpen = false
                        Tween(Container, {Size = UDim2.new(1, 0, 0, 46)}, 0.25, Enum.EasingStyle.Quint)
                        Tween(Chevron, {Rotation = 0}, 0.2)
                    end
                end)
                
                return ItemButton
            end
            
            -- Create all items
            for _, item in ipairs(items) do
                CreateItemButton(item)
            end
            
            -- Toggle dropdown
            DropdownHeader.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    local height = 54 + (#items * 36)
                    Tween(Container, {Size = UDim2.new(1, 0, 0, height)}, 0.3, Enum.EasingStyle.Back)
                    Tween(Chevron, {Rotation = 180}, 0.2)
                else
                    Tween(Container, {Size = UDim2.new(1, 0, 0, 46)}, 0.25, Enum.EasingStyle.Quint)
                    Tween(Chevron, {Rotation = 0}, 0.2)
                end
            end)
            
            -- Hover effect on header
            DropdownHeader.MouseEnter:Connect(function()
                Tween(Container, {BackgroundTransparency = 0.1}, 0.1)
            end)
            
            DropdownHeader.MouseLeave:Connect(function()
                if not isOpen then
                    Tween(Container, {BackgroundTransparency = 0.2}, 0.1)
                end
            end)
            
            -- Dropdown methods
            function Dropdown:Set(value)
                if multi then
                    selected = {}
                    if type(value) == "table" then
                        for _, v in ipairs(value) do
                            selected[v] = true
                        end
                    end
                    -- Update checkmarks
                    for _, child in ipairs(ItemsContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            local checkbox = child:FindFirstChild("Frame")
                            if checkbox then
                                local check = checkbox:FindFirstChild("Checkmark")
                                if check then
                                    check.TextTransparency = selected[child.Name] and 0 or 1
                                end
                            end
                        end
                    end
                else
                    selected = value
                end
                ValueLabel.Text = GetDisplayText()
            end
            
            function Dropdown:Get()
                if multi then
                    local list = {}
                    for k, v in pairs(selected) do
                        if v then table.insert(list, k) end
                    end
                    return list
                end
                return selected
            end
            
            function Dropdown:Refresh(newItems)
                items = newItems
                -- Clear existing items
                for _, child in ipairs(ItemsContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                -- Create new items
                for _, item in ipairs(items) do
                    CreateItemButton(item)
                end
                -- Reset selection if needed
                if multi then
                    selected = {}
                else
                    selected = nil
                end
                ValueLabel.Text = GetDisplayText()
            end
            
            table.insert(Tab.Elements, Dropdown)
            return Dropdown
        end
        
        return Tab
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- WINDOW METHODS
    -- ═══════════════════════════════════════════════════════════════
    
    function Window:Toggle()
        ToggleUI()
    end
    
    function Window:Show()
        if not Window.Visible then
            ToggleUI()
        end
    end
    
    function Window:Hide()
        if Window.Visible then
            ToggleUI()
        end
    end
    
    function Window:Destroy()
        AnimateBlurOut()
        if BlurEffect then BlurEffect:Destroy() end
        if ColorCorrection then ColorCorrection:Destroy() end
        ScreenGui:Destroy()
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- INITIAL NOTIFICATION
    -- ═══════════════════════════════════════════════════════════════
    
    task.delay(0.5, function()
        local keyText = IsMobile() and "the OPEN button" or "Insert keybind"
        Centrix:Notify({
            Title = "Centrix Loaded",
            Message = "Press " .. keyText .. " to open or close the UI",
            Type = "Info",
            Duration = 5
        })
    end)
    
    return Window
end

return Centrix
