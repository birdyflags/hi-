--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                     CENTRIX UI LIBRARY                        ║
    ║                        Version 1.0                            ║
    ║                                                               ║
    ║     A modern, smooth Roblox UI library with acrylic          ║
    ║     transparency and lavender aesthetics                     ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Centrix = {}
Centrix.__index = Centrix

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ═══════════════════════════════════════════════════════════════
-- THEME CONFIGURATION
-- ═══════════════════════════════════════════════════════════════

Centrix.Theme = {
    -- Primary Colors (Lavender/Purple with white accents)
    Primary = Color3.fromRGB(147, 112, 219),        -- Medium Purple
    PrimaryDark = Color3.fromRGB(123, 88, 195),     -- Darker Purple
    PrimaryLight = Color3.fromRGB(180, 150, 230),   -- Light Lavender
    
    -- Accent Colors
    Accent = Color3.fromRGB(200, 180, 255),         -- Soft Lavender
    AccentGlow = Color3.fromRGB(220, 200, 255),     -- Glow Lavender
    
    -- Background Colors (with transparency support)
    Background = Color3.fromRGB(25, 20, 35),        -- Deep Purple-Black
    BackgroundSecondary = Color3.fromRGB(35, 28, 50), -- Slightly lighter
    BackgroundTertiary = Color3.fromRGB(45, 38, 65),  -- Tab hover
    
    -- Surface Colors
    Surface = Color3.fromRGB(40, 32, 55),           -- Card/Surface
    SurfaceHover = Color3.fromRGB(55, 45, 75),      -- Hover state
    SurfaceActive = Color3.fromRGB(65, 55, 90),     -- Active/Selected
    
    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),           -- Primary text
    TextSecondary = Color3.fromRGB(180, 170, 200),  -- Secondary text
    TextMuted = Color3.fromRGB(120, 110, 140),      -- Muted text
    
    -- Border & Divider
    Border = Color3.fromRGB(80, 65, 110),           -- Subtle border
    Divider = Color3.fromRGB(60, 50, 80),           -- Dividers
    
    -- States
    Success = Color3.fromRGB(130, 220, 150),        -- Green
    Warning = Color3.fromRGB(255, 200, 100),        -- Yellow/Orange
    Error = Color3.fromRGB(255, 120, 120),          -- Red
    Info = Color3.fromRGB(130, 180, 255),           -- Blue
    
    -- Transparency
    AcrylicTransparency = 0.15,
    BackgroundTransparency = 0.05,
}

-- ═══════════════════════════════════════════════════════════════
-- ICON LIBRARY (Roblox Asset IDs)
-- ═══════════════════════════════════════════════════════════════

Centrix.Icons = {
    -- Navigation & UI
    Home = "rbxassetid://7733960981",
    Settings = "rbxassetid://7734053495",
    Menu = "rbxassetid://7734042665",
    Close = "rbxassetid://7734003889",
    Minimize = "rbxassetid://7734042158",
    Maximize = "rbxassetid://7734041324",
    
    -- Actions
    Search = "rbxassetid://7734053104",
    Add = "rbxassetid://7733664961",
    Remove = "rbxassetid://7734048430",
    Edit = "rbxassetid://7734007140",
    Save = "rbxassetid://7734052561",
    Refresh = "rbxassetid://7734048175",
    
    -- Status
    Check = "rbxassetid://7733715400",
    Warning = "rbxassetid://7734062330",
    Error = "rbxassetid://7734007747",
    Info = "rbxassetid://7734014268",
    
    -- Security
    Lock = "rbxassetid://7734038914",
    Unlock = "rbxassetid://7734059314",
    Key = "rbxassetid://7734028671",
    Fingerprint = "rbxassetid://7734011497",
    Shield = "rbxassetid://7734053248",
    
    -- User & Social
    User = "rbxassetid://7734058893",
    Users = "rbxassetid://7734059057",
    Heart = "rbxassetid://7734013726",
    Star = "rbxassetid://7734055553",
    
    -- Media
    Play = "rbxassetid://7734045577",
    Pause = "rbxassetid://7734045232",
    Stop = "rbxassetid://7734055693",
    Music = "rbxassetid://7734042870",
    
    -- Arrows
    ArrowUp = "rbxassetid://7734010862",
    ArrowDown = "rbxassetid://7734010692",
    ArrowLeft = "rbxassetid://7734010755",
    ArrowRight = "rbxassetid://7734010812",
    ChevronDown = "rbxassetid://7734004077",
    ChevronUp = "rbxassetid://7734004305",
    
    -- Gaming
    Sword = "rbxassetid://7734055853",
    Target = "rbxassetid://7734056001",
    Gamepad = "rbxassetid://7734011654",
    Trophy = "rbxassetid://7734058509",
    
    -- Misc
    Folder = "rbxassetid://7734011232",
    File = "rbxassetid://7734008073",
    Code = "rbxassetid://7734004694",
    Terminal = "rbxassetid://7734056149",
    Globe = "rbxassetid://7734012060",
    Lightning = "rbxassetid://7734038617",
    Fire = "rbxassetid://7734008238",
    Sparkle = "rbxassetid://7734055142",
}

-- ═══════════════════════════════════════════════════════════════
-- ANIMATION UTILITIES
-- ═══════════════════════════════════════════════════════════════

local Animations = {}

function Animations.Tween(object, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Quint
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function Animations.FadeIn(object, duration)
    object.BackgroundTransparency = 1
    return Animations.Tween(object, {BackgroundTransparency = Centrix.Theme.AcrylicTransparency}, duration or 0.3)
end

function Animations.FadeOut(object, duration)
    return Animations.Tween(object, {BackgroundTransparency = 1}, duration or 0.3)
end

function Animations.ScaleIn(object, duration)
    local originalSize = object.Size
    object.Size = UDim2.new(originalSize.X.Scale * 0.8, originalSize.X.Offset * 0.8, originalSize.Y.Scale * 0.8, originalSize.Y.Offset * 0.8)
    return Animations.Tween(object, {Size = originalSize}, duration or 0.3, Enum.EasingStyle.Back)
end

function Animations.SlideIn(object, direction, duration)
    local originalPosition = object.Position
    direction = direction or "Bottom"
    
    if direction == "Bottom" then
        object.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 1.5, 0)
    elseif direction == "Top" then
        object.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, -0.5, 0)
    elseif direction == "Left" then
        object.Position = UDim2.new(-0.5, 0, originalPosition.Y.Scale, originalPosition.Y.Offset)
    elseif direction == "Right" then
        object.Position = UDim2.new(1.5, 0, originalPosition.Y.Scale, originalPosition.Y.Offset)
    end
    
    return Animations.Tween(object, {Position = originalPosition}, duration or 0.4, Enum.EasingStyle.Quint)
end

function Animations.Ripple(button, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0, x, 0, y)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    
    Animations.Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local Utils = {}

function Utils.Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utils.GetGameName()
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if success and info then
        return info.Name
    end
    return "Unknown Game"
end

function Utils.Draggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Animations.Tween(frame, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.08)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- ACRYLIC BACKGROUND CREATOR
-- ═══════════════════════════════════════════════════════════════

local function CreateAcrylicBackground(parent, cornerRadius)
    -- Main blur effect container
    local acrylicContainer = Utils.Create("Frame", {
        Name = "AcrylicBackground",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Centrix.Theme.Background,
        BackgroundTransparency = Centrix.Theme.AcrylicTransparency,
        BorderSizePixel = 0,
        Parent = parent,
        ZIndex = parent.ZIndex
    })
    
    -- Corner rounding
    Utils.Create("UICorner", {
        CornerRadius = cornerRadius or UDim.new(0, 12),
        Parent = acrylicContainer
    })
    
    -- Gradient overlay for depth
    local gradient = Utils.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 180, 220))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.95),
            NumberSequenceKeypoint.new(1, 0.98)
        }),
        Rotation = 45,
        Parent = acrylicContainer
    })
    
    -- Subtle inner glow/border
    local stroke = Utils.Create("UIStroke", {
        Color = Centrix.Theme.Border,
        Thickness = 1,
        Transparency = 0.5,
        Parent = acrylicContainer
    })
    
    -- Noise texture for acrylic effect
    local noise = Utils.Create("ImageLabel", {
        Name = "Noise",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8992230677", -- Noise texture
        ImageTransparency = 0.97,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 128, 0, 128),
        Parent = acrylicContainer,
        ZIndex = acrylicContainer.ZIndex + 1
    })
    
    Utils.Create("UICorner", {
        CornerRadius = cornerRadius or UDim.new(0, 12),
        Parent = noise
    })
    
    return acrylicContainer
end

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════

local NotificationHolder

function Centrix:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 4
    local notifType = options.Type or "Info" -- Info, Success, Warning, Error
    
    -- Create notification holder if doesn't exist
    if not NotificationHolder or not NotificationHolder.Parent then
        NotificationHolder = Utils.Create("Frame", {
            Name = "CentrixNotifications",
            Size = UDim2.new(0, 320, 1, -20),
            Position = UDim2.new(1, -330, 0, 10),
            BackgroundTransparency = 1,
            Parent = CoreGui
        })
        
        Utils.Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = NotificationHolder
        })
    end
    
    -- Notification colors based on type
    local colors = {
        Info = Centrix.Theme.Info,
        Success = Centrix.Theme.Success,
        Warning = Centrix.Theme.Warning,
        Error = Centrix.Theme.Error
    }
    
    local icons = {
        Info = Centrix.Icons.Info,
        Success = Centrix.Icons.Check,
        Warning = Centrix.Icons.Warning,
        Error = Centrix.Icons.Error
    }
    
    local notifColor = colors[notifType] or colors.Info
    local notifIcon = icons[notifType] or icons.Info
    
    -- Create notification
    local notification = Utils.Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Centrix.Theme.Surface,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = NotificationHolder
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = notification
    })
    
    Utils.Create("UIStroke", {
        Color = notifColor,
        Thickness = 1,
        Transparency = 0.5,
        Parent = notification
    })
    
    -- Accent bar
    local accentBar = Utils.Create("Frame", {
        Name = "AccentBar",
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = notifColor,
        BorderSizePixel = 0,
        Parent = notification
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = accentBar
    })
    
    -- Icon
    local icon = Utils.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 16, 0.5, -12),
        BackgroundTransparency = 1,
        Image = notifIcon,
        ImageColor3 = notifColor,
        Parent = notification
    })
    
    -- Title
    local titleLabel = Utils.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -70, 0, 22),
        Position = UDim2.new(0, 50, 0, 12),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Centrix.Theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    -- Message
    local messageLabel = Utils.Create("TextLabel", {
        Name = "Message",
        Size = UDim2.new(1, -70, 0, 30),
        Position = UDim2.new(0, 50, 0, 34),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Centrix.Theme.TextSecondary,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = notification
    })
    
    -- Progress bar
    local progressBar = Utils.Create("Frame", {
        Name = "ProgressBar",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = notifColor,
        BorderSizePixel = 0,
        Parent = notification
    })
    
    -- Animate in
    notification.Position = UDim2.new(1, 50, 0, 0)
    Animations.Tween(notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Quint)
    
    -- Animate progress bar
    Animations.Tween(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)
    
    -- Auto dismiss
    task.delay(duration, function()
        Animations.Tween(notification, {Position = UDim2.new(1, 50, 0, 0)}, 0.3)
        task.wait(0.35)
        notification:Destroy()
    end)
    
    return notification
end

-- ═══════════════════════════════════════════════════════════════
-- WINDOW CREATION
-- ═══════════════════════════════════════════════════════════════

function Centrix:CreateWindow(options)
    options = options or {}
    
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    -- Get game name
    local gameName = Utils.GetGameName()
    
    -- Create ScreenGui
    local screenGui = Utils.Create("ScreenGui", {
        Name = "CentrixHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    Window.ScreenGui = screenGui
    
    -- Main Window Frame
    local mainWindow = Utils.Create("Frame", {
        Name = "MainWindow",
        Size = UDim2.new(0, 580, 0, 420),
        Position = UDim2.new(0.5, -290, 0.5, -210),
        BackgroundTransparency = 1,
        Parent = screenGui
    })
    
    Window.MainFrame = mainWindow
    
    -- Acrylic Background
    local acrylicBg = CreateAcrylicBackground(mainWindow, UDim.new(0, 12))
    
    -- Shadow
    local shadow = Utils.Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = mainWindow.ZIndex - 1,
        Parent = mainWindow
    })
    
    -- Header
    local header = Utils.Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundTransparency = 1,
        Parent = mainWindow,
        ZIndex = 2
    })
    
    -- Title: CENTRIX HUB
    local titleLabel = Utils.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -100, 0, 32),
        Position = UDim2.new(0, 20, 0, 12),
        BackgroundTransparency = 1,
        Text = "CENTRIX HUB",
        TextColor3 = Centrix.Theme.Text,
        TextSize = 24,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header,
        ZIndex = 3
    })
    
    -- Title gradient effect
    local titleGradient = Utils.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Centrix.Theme.Primary),
            ColorSequenceKeypoint.new(0.5, Centrix.Theme.AccentGlow),
            ColorSequenceKeypoint.new(1, Centrix.Theme.Primary)
        }),
        Parent = titleLabel
    })
    
    -- Animate title gradient
    task.spawn(function()
        while titleLabel and titleLabel.Parent do
            for i = 0, 1, 0.01 do
                if not titleLabel or not titleLabel.Parent then break end
                titleGradient.Offset = Vector2.new(i - 0.5, 0)
                task.wait(0.03)
            end
        end
    end)
    
    -- Game name subtitle
    local gameLabel = Utils.Create("TextLabel", {
        Name = "GameName",
        Size = UDim2.new(1, -100, 0, 18),
        Position = UDim2.new(0, 20, 0, 42),
        BackgroundTransparency = 1,
        Text = gameName,
        TextColor3 = Centrix.Theme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header,
        ZIndex = 3
    })
    
    -- Close button
    local closeBtn = Utils.Create("ImageButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -42, 0, 20),
        BackgroundColor3 = Centrix.Theme.Error,
        BackgroundTransparency = 0.8,
        Image = Centrix.Icons.Close,
        ImageColor3 = Centrix.Theme.Text,
        ImageTransparency = 0.2,
        Parent = header,
        ZIndex = 3
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = closeBtn
    })
    
    closeBtn.MouseEnter:Connect(function()
        Animations.Tween(closeBtn, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        Animations.Tween(closeBtn, {BackgroundTransparency = 0.8}, 0.2)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        Animations.Tween(mainWindow, {
            Size = UDim2.new(0, 580, 0, 0),
            Position = UDim2.new(0.5, -290, 0.5, 0)
        }, 0.3)
        task.wait(0.35)
        screenGui:Destroy()
    end)
    
    -- Minimize button
    local minimizeBtn = Utils.Create("ImageButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -76, 0, 20),
        BackgroundColor3 = Centrix.Theme.Warning,
        BackgroundTransparency = 0.8,
        Image = Centrix.Icons.Minimize,
        ImageColor3 = Centrix.Theme.Text,
        ImageTransparency = 0.2,
        Parent = header,
        ZIndex = 3
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = minimizeBtn
    })
    
    local minimized = false
    local originalSize = mainWindow.Size
    
    minimizeBtn.MouseEnter:Connect(function()
        Animations.Tween(minimizeBtn, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        Animations.Tween(minimizeBtn, {BackgroundTransparency = 0.8}, 0.2)
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Animations.Tween(mainWindow, {Size = UDim2.new(0, 580, 0, 70)}, 0.3)
        else
            Animations.Tween(mainWindow, {Size = originalSize}, 0.3)
        end
    end)
    
    -- Divider line under header
    local headerDivider = Utils.Create("Frame", {
        Name = "HeaderDivider",
        Size = UDim2.new(1, -40, 0, 1),
        Position = UDim2.new(0, 20, 0, 68),
        BackgroundColor3 = Centrix.Theme.Divider,
        BorderSizePixel = 0,
        Parent = mainWindow,
        ZIndex = 2
    })
    
    -- Tab Container (Left sidebar)
    local tabContainer = Utils.Create("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 140, 1, -90),
        Position = UDim2.new(0, 12, 0, 78),
        BackgroundColor3 = Centrix.Theme.BackgroundSecondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Centrix.Theme.Primary,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = mainWindow,
        ZIndex = 2
    })
    
    Utils.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = tabContainer
    })
    
    Utils.Create("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        Parent = tabContainer
    })
    
    Utils.Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabContainer
    })
    
    -- Content Container
    local contentContainer = Utils.Create("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -170, 1, -90),
        Position = UDim2.new(0, 160, 0, 78),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = mainWindow,
        ZIndex = 2
    })
    
    -- Make window draggable
    Utils.Draggable(mainWindow, header)
    
    -- Open animation
    mainWindow.Size = UDim2.new(0, 580, 0, 0)
    mainWindow.Position = UDim2.new(0.5, -290, 0.5, 0)
    Animations.Tween(mainWindow, {
        Size = originalSize,
        Position = UDim2.new(0.5, -290, 0.5, -210)
    }, 0.4, Enum.EasingStyle.Back)
    
    -- ═══════════════════════════════════════════════════════════
    -- TAB CREATION
    -- ═══════════════════════════════════════════════════════════
    
    function Window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon or Centrix.Icons.Folder
        
        local Tab = {}
        Tab.Elements = {}
        
        -- Tab Button
        local tabButton = Utils.Create("TextButton", {
            Name = tabName .. "Tab",
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Centrix.Theme.Surface,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = tabContainer,
            ZIndex = 3
        })
        
        Utils.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = tabButton
        })
        
        -- Tab Icon
        local tabIconImg = Utils.Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 10, 0.5, -9),
            BackgroundTransparency = 1,
            Image = tabIcon,
            ImageColor3 = Centrix.Theme.TextMuted,
            Parent = tabButton,
            ZIndex = 4
        })
        
        -- Tab Label
        local tabLabel = Utils.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 34, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = Centrix.Theme.TextMuted,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabButton,
            ZIndex = 4
        })
        
        -- Active indicator
        local activeIndicator = Utils.Create("Frame", {
            Name = "ActiveIndicator",
            Size = UDim2.new(0, 3, 0.6, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundColor3 = Centrix.Theme.Primary,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = tabButton,
            ZIndex = 4
        })
        
        Utils.Create("UICorner", {
            CornerRadius = UDim.new(0, 2),
            Parent = activeIndicator
        })
        
        -- Tab Content Page
        local tabPage = Utils.Create("ScrollingFrame", {
            Name = tabName .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Centrix.Theme.Primary,
            ScrollBarImageTransparency = 0.5,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = contentContainer,
            ZIndex = 2
        })
        
        Utils.Create("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 8),
            Parent = tabPage
        })
        
        Utils.Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabPage
        })
        
        Tab.Button = tabButton
        Tab.Page = tabPage
        
        -- Tab selection logic
        local function selectTab()
            -- Deselect all tabs
            for _, t in pairs(Window.Tabs) do
                Animations.Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                Animations.Tween(t.Button:FindFirstChild("Icon"), {ImageColor3 = Centrix.Theme.TextMuted}, 0.2)
                Animations.Tween(t.Button:FindFirstChild("Label"), {TextColor3 = Centrix.Theme.TextMuted}, 0.2)
                Animations.Tween(t.Button:FindFirstChild("ActiveIndicator"), {BackgroundTransparency = 1}, 0.2)
                t.Page.Visible = false
            end
            
            -- Select this tab
            Animations.Tween(tabButton, {BackgroundTransparency = 0.7}, 0.2)
            Animations.Tween(tabIconImg, {ImageColor3 = Centrix.Theme.Primary}, 0.2)
            Animations.Tween(tabLabel, {TextColor3 = Centrix.Theme.Text}, 0.2)
            Animations.Tween(activeIndicator, {BackgroundTransparency = 0}, 0.2)
            tabPage.Visible = true
            
            Window.ActiveTab = Tab
        end
        
        tabButton.MouseButton1Click:Connect(function()
            selectTab()
        end)
        
        tabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Animations.Tween(tabButton, {BackgroundTransparency = 0.85}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Animations.Tween(tabButton, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            task.defer(selectTab)
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- ═══════════════════════════════════════════════════════
        -- DROPDOWN COMPONENT
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateDropdown(dropdownOptions)
            dropdownOptions = dropdownOptions or {}
            local dropdownName = dropdownOptions.Name or "Dropdown"
            local items = dropdownOptions.Items or {}
            local defaultValue = dropdownOptions.Default
            local multiSelect = dropdownOptions.Multi or false
            local callback = dropdownOptions.Callback or function() end
            
            local Dropdown = {}
            local isOpen = false
            local selectedItems = {}
            
            if multiSelect and defaultValue and type(defaultValue) == "table" then
                for _, v in pairs(defaultValue) do
                    selectedItems[v] = true
                end
            elseif defaultValue then
                selectedItems[defaultValue] = true
            end
            
            -- Main dropdown container
            local dropdownFrame = Utils.Create("Frame", {
                Name = dropdownName .. "Dropdown",
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = Centrix.Theme.Surface,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = tabPage,
                ZIndex = 5
            })
            
            Utils.Create("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = dropdownFrame
            })
            
            -- Label
            local dropdownLabel = Utils.Create("TextLabel", {
                Name = "Label",
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                Text = dropdownName,
                TextColor3 = Centrix.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdownFrame,
                ZIndex = 6
            })
            
            -- Selection display button
            local selectionButton = Utils.Create("TextButton", {
                Name = "SelectionButton",
                Size = UDim2.new(1, -24, 0, 28),
                Position = UDim2.new(0, 12, 0, 28),
                BackgroundColor3 = Centrix.Theme.BackgroundSecondary,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = dropdownFrame,
                ZIndex = 6
            })
            
            Utils.Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = selectionButton
            })
            
            Utils.Create("UIStroke", {
                Color = Centrix.Theme.Border,
                Thickness = 1,
                Transparency = 0.5,
                Parent = selectionButton
            })
            
            -- Selection text
            local selectionText = Utils.Create("TextLabel", {
                Name = "SelectionText",
                Size = UDim2.new(1, -36, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = multiSelect and "Select..." or (defaultValue or "Select..."),
                TextColor3 = Centrix.Theme.TextSecondary,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = selectionButton,
                ZIndex = 7
            })
            
            -- Arrow icon
            local arrowIcon = Utils.Create("ImageLabel", {
                Name = "Arrow",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -22, 0.5, -8),
                BackgroundTransparency = 1,
                Image = Centrix.Icons.ChevronDown,
                ImageColor3 = Centrix.Theme.TextMuted,
                Parent = selectionButton,
                ZIndex = 7
            })
            
            -- Items container
            local itemsContainer = Utils.Create("Frame", {
                Name = "ItemsContainer",
                Size = UDim2.new(1, -24, 0, 0),
                Position = UDim2.new(0, 12, 0, 62),
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Parent = dropdownFrame,
                ZIndex = 6
            })
            
            Utils.Create("UIListLayout", {
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = itemsContainer
            })
            
            local function updateSelectionText()
                local selected = {}
                for item, isSelected in pairs(selectedItems) do
                    if isSelected then
                        table.insert(selected, item)
                    end
                end
                
                if #selected == 0 then
                    selectionText.Text = "Select..."
                    selectionText.TextColor3 = Centrix.Theme.TextMuted
                else
                    selectionText.Text = table.concat(selected, ", ")
                    selectionText.TextColor3 = Centrix.Theme.Text
                end
            end
            
            local function createItemButton(itemName)
                local itemButton = Utils.Create("TextButton", {
                    Name = itemName,
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundColor3 = Centrix.Theme.SurfaceHover,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = itemsContainer,
                    ZIndex = 7
                })
                
                Utils.Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = itemButton
                })
                
                -- Checkbox for multi-select
                local checkbox
                if multiSelect then
                    checkbox = Utils.Create("Frame", {
                        Name = "Checkbox",
                        Size = UDim2.new(0, 14, 0, 14),
                        Position = UDim2.new(0, 6, 0.5, -7),
                        BackgroundColor3 = Centrix.Theme.BackgroundSecondary,
                        BorderSizePixel = 0,
                        Parent = itemButton,
                        ZIndex = 8
                    })
                    
                    Utils.Create("UICorner", {
                        CornerRadius = UDim.new(0, 3),
                        Parent = checkbox
                    })
                    
                    Utils.Create("UIStroke", {
                        Color = Centrix.Theme.Border,
                        Thickness = 1,
                        Parent = checkbox
                    })
                    
                    local checkmark = Utils.Create("ImageLabel", {
                        Name = "Checkmark",
                        Size = UDim2.new(0, 10, 0, 10),
                        Position = UDim2.new(0.5, -5, 0.5, -5),
                        BackgroundTransparency = 1,
                        Image = Centrix.Icons.Check,
                        ImageColor3 = Centrix.Theme.Primary,
                        ImageTransparency = selectedItems[itemName] and 0 or 1,
                        Parent = checkbox,
                        ZIndex = 9
                    })
                end
                
                local itemLabel = Utils.Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, multiSelect and -28 or -12, 1, 0),
                    Position = UDim2.new(0, multiSelect and 26 or 8, 0, 0),
                    BackgroundTransparency = 1,
                    Text = itemName,
                    TextColor3 = selectedItems[itemName] and Centrix.Theme.Text or Centrix.Theme.TextSecondary,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = itemButton,
                    ZIndex = 8
                })
                
                itemButton.MouseEnter:Connect(function()
                    Animations.Tween(itemButton, {BackgroundTransparency = 0.5}, 0.15)
                end)
                
                itemButton.MouseLeave:Connect(function()
                    Animations.Tween(itemButton, {BackgroundTransparency = 1}, 0.15)
                end)
                
                itemButton.MouseButton1Click:Connect(function()
                    if multiSelect then
                        selectedItems[itemName] = not selectedItems[itemName]
                        local checkmark = checkbox:FindFirstChild("Checkmark")
                        Animations.Tween(checkmark, {
                            ImageTransparency = selectedItems[itemName] and 0 or 1
                        }, 0.15)
                        itemLabel.TextColor3 = selectedItems[itemName] and Centrix.Theme.Text or Centrix.Theme.TextSecondary
                        
                        updateSelectionText()
                        
                        local selected = {}
                        for item, sel in pairs(selectedItems) do
                            if sel then table.insert(selected, item) end
                        end
                        callback(selected)
                    else
                        selectedItems = {[itemName] = true}
                        updateSelectionText()
                        callback(itemName)
                        
                        -- Close dropdown
                        isOpen = false
                        local itemCount = #items
                        local targetHeight = 60
                        Animations.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25)
                        Animations.Tween(arrowIcon, {Rotation = 0}, 0.25)
                    end
                end)
                
                return itemButton
            end
            
            -- Create item buttons
            for _, item in ipairs(items) do
                createItemButton(item)
            end
            
            if multiSelect then
                updateSelectionText()
            end
            
            -- Toggle dropdown
            selectionButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                local itemCount = #items
                local itemsHeight = itemCount * 28
                
                if isOpen then
                    local targetHeight = 66 + itemsHeight
                    Animations.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25, Enum.EasingStyle.Quint)
                    Animations.Tween(itemsContainer, {Size = UDim2.new(1, -24, 0, itemsHeight)}, 0.25, Enum.EasingStyle.Quint)
                    Animations.Tween(arrowIcon, {Rotation = 180}, 0.25)
                else
                    Animations.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 60)}, 0.25, Enum.EasingStyle.Quint)
                    Animations.Tween(itemsContainer, {Size = UDim2.new(1, -24, 0, 0)}, 0.25, Enum.EasingStyle.Quint)
                    Animations.Tween(arrowIcon, {Rotation = 0}, 0.25)
                end
            end)
            
            selectionButton.MouseEnter:Connect(function()
                Animations.Tween(selectionButton:FindFirstChild("UIStroke"), {Color = Centrix.Theme.Primary}, 0.2)
            end)
            
            selectionButton.MouseLeave:Connect(function()
                Animations.Tween(selectionButton:FindFirstChild("UIStroke"), {Color = Centrix.Theme.Border}, 0.2)
            end)
            
            -- Dropdown API
            function Dropdown:Set(value)
                if multiSelect and type(value) == "table" then
                    selectedItems = {}
                    for _, v in pairs(value) do
                        selectedItems[v] = true
                    end
                    updateSelectionText()
                    callback(value)
                elseif not multiSelect then
                    selectedItems = {[value] = true}
                    updateSelectionText()
                    callback(value)
                end
            end
            
            function Dropdown:Get()
                if multiSelect then
                    local selected = {}
                    for item, sel in pairs(selectedItems) do
                        if sel then table.insert(selected, item) end
                    end
                    return selected
                else
                    for item, sel in pairs(selectedItems) do
                        if sel then return item end
                    end
                    return nil
                end
            end
            
            function Dropdown:Refresh(newItems)
                items = newItems
                
                for _, child in pairs(itemsContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                for _, item in ipairs(items) do
                    createItemButton(item)
                end
            end
            
            table.insert(Tab.Elements, Dropdown)
            return Dropdown
        end
        
        return Tab
    end
    
    -- Window API
    function Window:Destroy()
        screenGui:Destroy()
    end
    
    function Window:Toggle(visible)
        mainWindow.Visible = visible
    end
    
    return Window
end

-- ═══════════════════════════════════════════════════════════════
-- RETURN LIBRARY
-- ═══════════════════════════════════════════════════════════════

return Centrix
