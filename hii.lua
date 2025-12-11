--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                     CENTRIX UI LIBRARY v2                     ║
    ║              Premium Design • Smooth Animations               ║
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

-- ═══════════════════════════════════════════════════════════════
-- PREMIUM THEME - Cohesive Lavender/Purple
-- ═══════════════════════════════════════════════════════════════

Centrix.Theme = {
    -- Main Colors
    Primary = Color3.fromRGB(138, 99, 210),
    PrimaryLight = Color3.fromRGB(167, 139, 225),
    PrimaryDark = Color3.fromRGB(98, 71, 170),
    Accent = Color3.fromRGB(180, 160, 255),
    
    -- Backgrounds (Less transparent, more solid)
    Background = Color3.fromRGB(18, 15, 28),
    BackgroundFloat = Color3.fromRGB(25, 21, 38),
    BackgroundCard = Color3.fromRGB(32, 27, 48),
    BackgroundElement = Color3.fromRGB(42, 36, 62),
    
    -- Text
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(190, 180, 210),
    TextMuted = Color3.fromRGB(130, 120, 155),
    
    -- Borders & Shadows
    Border = Color3.fromRGB(65, 55, 95),
    BorderHover = Color3.fromRGB(138, 99, 210),
    Shadow = Color3.fromRGB(8, 6, 15),
    
    -- States
    Success = Color3.fromRGB(100, 220, 140),
    Warning = Color3.fromRGB(255, 190, 80),
    Error = Color3.fromRGB(255, 100, 100),
    Info = Color3.fromRGB(100, 180, 255),
    
    -- Glow
    Glow = Color3.fromRGB(138, 99, 210),
    GlowAlpha = 0.3,
}

-- ═══════════════════════════════════════════════════════════════
-- ICONS
-- ═══════════════════════════════════════════════════════════════

Centrix.Icons = {
    Home = "rbxassetid://7733960981", Settings = "rbxassetid://7734053495",
    Close = "rbxassetid://7734003889", Minimize = "rbxassetid://7734042158",
    Check = "rbxassetid://7733715400", Warning = "rbxassetid://7734062330",
    Error = "rbxassetid://7734007747", Info = "rbxassetid://7734014268",
    Lock = "rbxassetid://7734038914", Key = "rbxassetid://7734028671",
    Shield = "rbxassetid://7734053248", User = "rbxassetid://7734058893",
    Sword = "rbxassetid://7734055853", Target = "rbxassetid://7734056001",
    ChevronDown = "rbxassetid://7734004077", ChevronUp = "rbxassetid://7734004305",
    Folder = "rbxassetid://7734011232", Code = "rbxassetid://7734004694",
    Lightning = "rbxassetid://7734038617", Sparkle = "rbxassetid://7734055142",
    Search = "rbxassetid://7734053104", Star = "rbxassetid://7734055553",
}

-- ═══════════════════════════════════════════════════════════════
-- ANIMATION SYSTEM
-- ═══════════════════════════════════════════════════════════════

local Anim = {}

function Anim.Tween(obj, props, dur, style, dir)
    local ti = TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, ti, props)
    tw:Play()
    return tw
end

function Anim.Spring(obj, props, dur)
    return Anim.Tween(obj, props, dur or 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function Anim.Bounce(obj, props, dur)
    return Anim.Tween(obj, props, dur or 0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
end

function Anim.Elastic(obj, props, dur)
    return Anim.Tween(obj, props, dur or 0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
end

-- ═══════════════════════════════════════════════════════════════
-- UTILITIES
-- ═══════════════════════════════════════════════════════════════

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function GetGameName()
    local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    return ok and info and info.Name or "Unknown Game"
end

local function MakeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle = handle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Anim.Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- TOOLTIP SYSTEM
-- ═══════════════════════════════════════════════════════════════

local TooltipFrame

local function ShowTooltip(text, parent)
    if not TooltipFrame then
        TooltipFrame = Create("Frame", {
            Name = "Tooltip",
            Size = UDim2.new(0, 200, 0, 40),
            BackgroundColor3 = Centrix.Theme.BackgroundFloat,
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = 100,
            Parent = CoreGui
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TooltipFrame})
        Create("UIStroke", {Color = Centrix.Theme.Border, Thickness = 1, Parent = TooltipFrame})
        Create("UIPadding", {PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10), PaddingTop = UDim.new(0,8), PaddingBottom = UDim.new(0,8), Parent = TooltipFrame})
        
        Create("TextLabel", {
            Name = "Text",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            TextColor3 = Centrix.Theme.TextSecondary,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 101,
            Parent = TooltipFrame
        })
    end
    
    TooltipFrame.Text.Text = text
    TooltipFrame.Size = UDim2.new(0, math.min(250, #text * 6 + 20), 0, 36)
    TooltipFrame.Visible = true
    TooltipFrame.BackgroundTransparency = 1
    Anim.Tween(TooltipFrame, {BackgroundTransparency = 0}, 0.15)
    
    RunService.RenderStepped:Connect(function()
        if TooltipFrame.Visible then
            local mouse = UserInputService:GetMouseLocation()
            TooltipFrame.Position = UDim2.new(0, mouse.X + 15, 0, mouse.Y + 15)
        end
    end)
end

local function HideTooltip()
    if TooltipFrame then
        Anim.Tween(TooltipFrame, {BackgroundTransparency = 1}, 0.1)
        task.delay(0.1, function() TooltipFrame.Visible = false end)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════

local NotifHolder

function Centrix:Notify(opts)
    opts = opts or {}
    
    if not NotifHolder then
        NotifHolder = Create("Frame", {
            Name = "CentrixNotifs", Size = UDim2.new(0, 300, 1, -20),
            Position = UDim2.new(1, -310, 0, 10), BackgroundTransparency = 1, Parent = CoreGui
        })
        Create("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = NotifHolder})
    end
    
    local colors = {Info = Centrix.Theme.Info, Success = Centrix.Theme.Success, Warning = Centrix.Theme.Warning, Error = Centrix.Theme.Error}
    local icons = {Info = Centrix.Icons.Info, Success = Centrix.Icons.Check, Warning = Centrix.Icons.Warning, Error = Centrix.Icons.Error}
    local col = colors[opts.Type] or colors.Info
    local ico = icons[opts.Type] or icons.Info
    
    local notif = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = Centrix.Theme.BackgroundCard,
        BorderSizePixel = 0, ClipsDescendants = true, Parent = NotifHolder
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = notif})
    
    -- Shadow
    Create("ImageLabel", {
        Size = UDim2.new(1, 24, 1, 24), Position = UDim2.new(0.5, 0, 0.5, 4), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1, Image = "rbxassetid://6014261993", ImageColor3 = Centrix.Theme.Shadow,
        ImageTransparency = 0.4, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = -1, Parent = notif
    })
    
    -- Accent
    Create("Frame", {Size = UDim2.new(0,4,1,0), BackgroundColor3 = col, BorderSizePixel = 0, Parent = notif})
    
    -- Icon
    Create("ImageLabel", {
        Size = UDim2.new(0,22,0,22), Position = UDim2.new(0,16,0.5,-11),
        BackgroundTransparency = 1, Image = ico, ImageColor3 = col, Parent = notif
    })
    
    -- Title
    Create("TextLabel", {
        Size = UDim2.new(1,-60,0,20), Position = UDim2.new(0,48,0,14),
        BackgroundTransparency = 1, Text = opts.Title or "Notification",
        TextColor3 = Centrix.Theme.TextPrimary, TextSize = 14, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = notif
    })
    
    -- Message
    Create("TextLabel", {
        Size = UDim2.new(1,-60,0,24), Position = UDim2.new(0,48,0,36),
        BackgroundTransparency = 1, Text = opts.Message or "",
        TextColor3 = Centrix.Theme.TextSecondary, TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = notif
    })
    
    -- Progress
    local prog = Create("Frame", {
        Size = UDim2.new(1,0,0,3), Position = UDim2.new(0,0,1,-3),
        BackgroundColor3 = col, BorderSizePixel = 0, Parent = notif
    })
    
    -- Animate
    notif.Position = UDim2.new(1, 50, 0, 0)
    Anim.Spring(notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.5)
    Anim.Tween(prog, {Size = UDim2.new(0, 0, 0, 3)}, opts.Duration or 4, Enum.EasingStyle.Linear)
    
    task.delay(opts.Duration or 4, function()
        Anim.Tween(notif, {Position = UDim2.new(1, 50, 0, 0)}, 0.3)
        task.wait(0.35)
        notif:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- WINDOW
-- ═══════════════════════════════════════════════════════════════

function Centrix:CreateWindow()
    local Window = {Tabs = {}, ActiveTab = nil}
    local gameName = GetGameName()
    
    local gui = Create("ScreenGui", {Name = "CentrixHub", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui})
    
    local main = Create("Frame", {
        Name = "Main", Size = UDim2.new(0, 600, 0, 440), Position = UDim2.new(0.5, -300, 0.5, -220),
        BackgroundColor3 = Centrix.Theme.Background, BorderSizePixel = 0, Parent = gui
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = main})
    
    -- Main Shadow
    Create("ImageLabel", {
        Size = UDim2.new(1, 60, 1, 60), Position = UDim2.new(0.5, 0, 0.5, 6), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1, Image = "rbxassetid://6014261993", ImageColor3 = Centrix.Theme.Shadow,
        ImageTransparency = 0.3, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = -1, Parent = main
    })
    
    -- Glow border
    Create("UIStroke", {Color = Centrix.Theme.Primary, Thickness = 1.5, Transparency = 0.7, Parent = main})
    
    -- Header
    local header = Create("Frame", {Name = "Header", Size = UDim2.new(1, 0, 0, 65), BackgroundTransparency = 1, Parent = main})
    
    -- Title with glow effect
    local title = Create("TextLabel", {
        Size = UDim2.new(0, 200, 0, 28), Position = UDim2.new(0, 20, 0, 12),
        BackgroundTransparency = 1, Text = "CENTRIX HUB", TextColor3 = Centrix.Theme.TextPrimary,
        TextSize = 22, Font = Enum.Font.GothamBlack, TextXAlignment = Enum.TextXAlignment.Left, Parent = header
    })
    
    -- Title gradient animation
    local grad = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Centrix.Theme.Primary),
            ColorSequenceKeypoint.new(0.5, Centrix.Theme.Accent),
            ColorSequenceKeypoint.new(1, Centrix.Theme.Primary)
        }), Parent = title
    })
    
    task.spawn(function()
        while title.Parent do
            for i = 0, 1, 0.008 do
                if not title.Parent then break end
                grad.Offset = Vector2.new(i - 0.5, 0)
                task.wait()
            end
        end
    end)
    
    -- Game name
    Create("TextLabel", {
        Size = UDim2.new(0, 300, 0, 16), Position = UDim2.new(0, 20, 0, 42),
        BackgroundTransparency = 1, Text = "🎮 " .. gameName,
        TextColor3 = Centrix.Theme.TextMuted, TextSize = 11, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = header
    })
    
    -- Close/Minimize buttons
    for i, data in ipairs({{Icon = Centrix.Icons.Close, Col = Centrix.Theme.Error, X = -20}, {Icon = Centrix.Icons.Minimize, Col = Centrix.Theme.Warning, X = -52}}) do
        local btn = Create("ImageButton", {
            Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, data.X, 0, 18), AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = data.Col, BackgroundTransparency = 0.85, Image = data.Icon,
            ImageColor3 = Centrix.Theme.TextPrimary, ImageTransparency = 0.3, Parent = header
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
        
        btn.MouseEnter:Connect(function()
            Anim.Tween(btn, {BackgroundTransparency = 0.4, ImageTransparency = 0}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Anim.Tween(btn, {BackgroundTransparency = 0.85, ImageTransparency = 0.3}, 0.15)
        end)
        
        if i == 1 then
            btn.MouseButton1Click:Connect(function()
                Anim.Tween(main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
                task.wait(0.35)
                gui:Destroy()
            end)
        end
    end
    
    -- Divider
    Create("Frame", {
        Size = UDim2.new(1, -40, 0, 1), Position = UDim2.new(0, 20, 0, 64),
        BackgroundColor3 = Centrix.Theme.Border, BorderSizePixel = 0, Parent = main
    })
    
    -- Tab sidebar
    local sidebar = Create("ScrollingFrame", {
        Name = "Sidebar", Size = UDim2.new(0, 150, 1, -84), Position = UDim2.new(0, 12, 0, 74),
        BackgroundColor3 = Centrix.Theme.BackgroundFloat, BackgroundTransparency = 0.3, BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = Centrix.Theme.Primary, CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = sidebar})
    Create("UIPadding", {PaddingTop = UDim.new(0,6), PaddingBottom = UDim.new(0,6), PaddingLeft = UDim.new(0,6), PaddingRight = UDim.new(0,6), Parent = sidebar})
    Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sidebar})
    
    -- Content area
    local content = Create("Frame", {
        Name = "Content", Size = UDim2.new(1, -180, 1, -84), Position = UDim2.new(0, 170, 0, 74),
        BackgroundTransparency = 1, ClipsDescendants = true, Parent = main
    })
    
    MakeDraggable(main, header)
    
    -- Open animation
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Anim.Spring(main, {Size = UDim2.new(0, 600, 0, 440), Position = UDim2.new(0.5, -300, 0.5, -220)}, 0.5)
    
    -- ═══════════════════════════════════════════════════════════
    -- TAB CREATION
    -- ═══════════════════════════════════════════════════════════
    
    function Window:CreateTab(opts)
        opts = opts or {}
        local Tab = {Elements = {}}
        
        -- Tab button
        local tabBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Centrix.Theme.BackgroundElement,
            BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", AutoButtonColor = false, Parent = sidebar
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tabBtn})
        
        -- Active indicator
        local indicator = Create("Frame", {
            Size = UDim2.new(0, 3, 0.5, 0), Position = UDim2.new(0, 0, 0.25, 0),
            BackgroundColor3 = Centrix.Theme.Primary, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = tabBtn
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = indicator})
        
        -- Icon
        local icon = Create("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 12, 0.5, -9),
            BackgroundTransparency = 1, Image = opts.Icon or Centrix.Icons.Folder,
            ImageColor3 = Centrix.Theme.TextMuted, Parent = tabBtn
        })
        
        -- Label
        local label = Create("TextLabel", {
            Size = UDim2.new(1, -42, 1, 0), Position = UDim2.new(0, 36, 0, 0),
            BackgroundTransparency = 1, Text = opts.Name or "Tab",
            TextColor3 = Centrix.Theme.TextMuted, TextSize = 13, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = tabBtn
        })
        
        -- Tab page
        local page = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, ScrollBarImageColor3 = Centrix.Theme.Primary,
            CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = content
        })
        Create("UIPadding", {PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), PaddingRight = UDim.new(0,8), Parent = page})
        Create("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})
        
        Tab.Button = tabBtn
        Tab.Page = page
        
        local function selectTab()
            for _, t in pairs(Window.Tabs) do
                Anim.Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                Anim.Tween(t.Button:FindFirstChild("ImageLabel"), {ImageColor3 = Centrix.Theme.TextMuted}, 0.2)
                Anim.Tween(t.Button:FindFirstChild("TextLabel"), {TextColor3 = Centrix.Theme.TextMuted}, 0.2)
                Anim.Tween(t.Button:FindFirstChild("Frame"), {BackgroundTransparency = 1}, 0.2)
                t.Page.Visible = false
            end
            Anim.Tween(tabBtn, {BackgroundTransparency = 0.6}, 0.2)
            Anim.Tween(icon, {ImageColor3 = Centrix.Theme.Primary}, 0.2)
            Anim.Tween(label, {TextColor3 = Centrix.Theme.TextPrimary}, 0.2)
            Anim.Tween(indicator, {BackgroundTransparency = 0}, 0.2)
            page.Visible = true
            Window.ActiveTab = Tab
        end
        
        tabBtn.MouseButton1Click:Connect(selectTab)
        tabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then Anim.Tween(tabBtn, {BackgroundTransparency = 0.8}, 0.15) end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then Anim.Tween(tabBtn, {BackgroundTransparency = 1}, 0.15) end
        end)
        
        if #Window.Tabs == 0 then task.defer(selectTab) end
        table.insert(Window.Tabs, Tab)
        
        -- ═══════════════════════════════════════════════════════
        -- PARAGRAPH/SECTION
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateParagraph(opts)
            opts = opts or {}
            local para = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = Centrix.Theme.BackgroundCard,
                BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = page
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = para})
            Create("UIPadding", {PaddingLeft = UDim.new(0,14), PaddingRight = UDim.new(0,14), PaddingTop = UDim.new(0,12), PaddingBottom = UDim.new(0,12), Parent = para})
            
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
                Text = opts.Title or "Section", TextColor3 = Centrix.Theme.TextPrimary,
                TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = para
            })
            
            local desc = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 22), BackgroundTransparency = 1,
                Text = opts.Content or "", TextColor3 = Centrix.Theme.TextSecondary,
                TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true, Parent = para
            })
            
            -- Auto-size
            local textHeight = desc.TextBounds.Y
            para.Size = UDim2.new(1, 0, 0, 44 + textHeight)
            
            return para
        end
        
        -- ═══════════════════════════════════════════════════════
        -- TOGGLE
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateToggle(opts)
            opts = opts or {}
            local Toggle = {}
            local enabled = opts.Default or false
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = Centrix.Theme.BackgroundCard,
                BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = page
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = frame})
            
            -- Shadow
            Create("ImageLabel", {
                Size = UDim2.new(1, 16, 1, 16), Position = UDim2.new(0.5, 0, 0.5, 4), AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1, Image = "rbxassetid://6014261993", ImageColor3 = Centrix.Theme.Shadow,
                ImageTransparency = 0.7, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
                ZIndex = -1, Parent = frame
            })
            
            Create("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1, Text = opts.Name or "Toggle",
                TextColor3 = Centrix.Theme.TextPrimary, TextSize = 13, Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = frame
            })
            
            local toggleBg = Create("Frame", {
                Size = UDim2.new(0, 44, 0, 24), Position = UDim2.new(1, -56, 0.5, -12),
                BackgroundColor3 = Centrix.Theme.BackgroundElement, BorderSizePixel = 0, Parent = frame
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = toggleBg})
            
            local knob = Create("Frame", {
                Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Centrix.Theme.TextMuted, BorderSizePixel = 0, Parent = toggleBg
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = knob})
            
            -- Tooltip
            if opts.Info then
                frame.MouseEnter:Connect(function() ShowTooltip(opts.Info, frame) end)
                frame.MouseLeave:Connect(function() HideTooltip() end)
            end
            
            local function updateToggle()
                if enabled then
                    Anim.Spring(knob, {Position = UDim2.new(0, 23, 0.5, -9), BackgroundColor3 = Centrix.Theme.TextPrimary}, 0.3)
                    Anim.Tween(toggleBg, {BackgroundColor3 = Centrix.Theme.Primary}, 0.2)
                else
                    Anim.Spring(knob, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Centrix.Theme.TextMuted}, 0.3)
                    Anim.Tween(toggleBg, {BackgroundColor3 = Centrix.Theme.BackgroundElement}, 0.2)
                end
                if opts.Callback then opts.Callback(enabled) end
            end
            
            local btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = frame
            })
            
            btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                updateToggle()
            end)
            
            if enabled then updateToggle() end
            
            function Toggle:Set(val) enabled = val updateToggle() end
            function Toggle:Get() return enabled end
            
            return Toggle
        end
        
        -- ═══════════════════════════════════════════════════════
        -- SLIDER
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateSlider(opts)
            opts = opts or {}
            local Slider = {}
            local min = opts.Min or 0
            local max = opts.Max or 100
            local value = opts.Default or min
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 56), BackgroundColor3 = Centrix.Theme.BackgroundCard,
                BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = page
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = frame})
            
            Create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20), Position = UDim2.new(0, 14, 0, 8),
                BackgroundTransparency = 1, Text = opts.Name or "Slider",
                TextColor3 = Centrix.Theme.TextPrimary, TextSize = 13, Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = frame
            })
            
            local valLabel = Create("TextLabel", {
                Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(1, -60, 0, 8),
                BackgroundTransparency = 1, Text = tostring(value),
                TextColor3 = Centrix.Theme.Primary, TextSize = 13, Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right, Parent = frame
            })
            
            local sliderBg = Create("Frame", {
                Size = UDim2.new(1, -28, 0, 8), Position = UDim2.new(0, 14, 0, 36),
                BackgroundColor3 = Centrix.Theme.BackgroundElement, BorderSizePixel = 0, Parent = frame
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sliderBg})
            
            local fill = Create("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Centrix.Theme.Primary, BorderSizePixel = 0, Parent = sliderBg
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})
            
            local knob = Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new((value - min) / (max - min), -8, 0.5, -8),
                BackgroundColor3 = Centrix.Theme.TextPrimary, BorderSizePixel = 0, Parent = sliderBg
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = knob})
            Create("UIStroke", {Color = Centrix.Theme.Primary, Thickness = 2, Parent = knob})
            
            -- Tooltip
            if opts.Info then
                frame.MouseEnter:Connect(function() ShowTooltip(opts.Info, frame) end)
                frame.MouseLeave:Connect(function() HideTooltip() end)
            end
            
            local dragging = false
            
            local function update(input)
                local rel = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * rel + 0.5)
                valLabel.Text = tostring(value)
                Anim.Tween(fill, {Size = UDim2.new(rel, 0, 1, 0)}, 0.08)
                Anim.Tween(knob, {Position = UDim2.new(rel, -8, 0.5, -8)}, 0.08)
                if opts.Callback then opts.Callback(value) end
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            function Slider:Set(val)
                value = math.clamp(val, min, max)
                local rel = (value - min) / (max - min)
                valLabel.Text = tostring(value)
                Anim.Tween(fill, {Size = UDim2.new(rel, 0, 1, 0)}, 0.15)
                Anim.Tween(knob, {Position = UDim2.new(rel, -8, 0.5, -8)}, 0.15)
            end
            
            function Slider:Get() return value end
            
            return Slider
        end
        
        -- ═══════════════════════════════════════════════════════
        -- DROPDOWN
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateDropdown(opts)
            opts = opts or {}
            local Dropdown = {}
            local isOpen = false
            local selected = opts.Multi and {} or nil
            local items = opts.Items or {}
            
            if opts.Multi and opts.Default then
                for _, v in pairs(opts.Default) do selected[v] = true end
            elseif opts.Default then
                selected = opts.Default
            end
            
            local frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 56), BackgroundColor3 = Centrix.Theme.BackgroundCard,
                BackgroundTransparency = 0.3, BorderSizePixel = 0, ClipsDescendants = true, Parent = page
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = frame})
            
            Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 18), Position = UDim2.new(0, 14, 0, 8),
                BackgroundTransparency = 1, Text = opts.Name or "Dropdown",
                TextColor3 = Centrix.Theme.TextPrimary, TextSize = 13, Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = frame
            })
            
            local selBtn = Create("TextButton", {
                Size = UDim2.new(1, -28, 0, 26), Position = UDim2.new(0, 14, 0, 26),
                BackgroundColor3 = Centrix.Theme.BackgroundElement, BorderSizePixel = 0, Text = "", AutoButtonColor = false, Parent = frame
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = selBtn})
            Create("UIStroke", {Color = Centrix.Theme.Border, Thickness = 1, Parent = selBtn})
            
            local function getSelText()
                if opts.Multi then
                    local list = {}
                    for k, v in pairs(selected) do if v then table.insert(list, k) end end
                    return #list > 0 and table.concat(list, ", ") or "Select..."
                else
                    return selected or "Select..."
                end
            end
            
            local selText = Create("TextLabel", {
                Size = UDim2.new(1, -32, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1, Text = getSelText(),
                TextColor3 = selected and Centrix.Theme.TextPrimary or Centrix.Theme.TextMuted,
                TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, Parent = selBtn
            })
            
            local arrow = Create("ImageLabel", {
                Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -20, 0.5, -7),
                BackgroundTransparency = 1, Image = Centrix.Icons.ChevronDown,
                ImageColor3 = Centrix.Theme.TextMuted, Parent = selBtn
            })
            
            local itemsCont = Create("Frame", {
                Size = UDim2.new(1, -28, 0, 0), Position = UDim2.new(0, 14, 0, 58),
                BackgroundTransparency = 1, ClipsDescendants = true, Parent = frame
            })
            Create("UIListLayout", {Padding = UDim.new(0, 2), Parent = itemsCont})
            
            local function createItem(name)
                local itemBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Centrix.Theme.BackgroundElement,
                    BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", AutoButtonColor = false, Parent = itemsCont
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = itemBtn})
                
                local check
                if opts.Multi then
                    check = Create("Frame", {
                        Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 6, 0.5, -7),
                        BackgroundColor3 = Centrix.Theme.BackgroundElement, BorderSizePixel = 0, Parent = itemBtn
                    })
                    Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = check})
                    Create("UIStroke", {Color = Centrix.Theme.Border, Thickness = 1, Parent = check})
                    Create("ImageLabel", {
                        Name = "Mark", Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0.5, -5, 0.5, -5),
                        BackgroundTransparency = 1, Image = Centrix.Icons.Check,
                        ImageColor3 = Centrix.Theme.Primary, ImageTransparency = selected[name] and 0 or 1, Parent = check
                    })
                end
                
                Create("TextLabel", {
                    Size = UDim2.new(1, opts.Multi and -28 or -12, 1, 0),
                    Position = UDim2.new(0, opts.Multi and 26 or 8, 0, 0),
                    BackgroundTransparency = 1, Text = name,
                    TextColor3 = Centrix.Theme.TextSecondary, TextSize = 12, Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = itemBtn
                })
                
                itemBtn.MouseEnter:Connect(function() Anim.Tween(itemBtn, {BackgroundTransparency = 0.5}, 0.1) end)
                itemBtn.MouseLeave:Connect(function() Anim.Tween(itemBtn, {BackgroundTransparency = 1}, 0.1) end)
                
                itemBtn.MouseButton1Click:Connect(function()
                    if opts.Multi then
                        selected[name] = not selected[name]
                        Anim.Tween(check:FindFirstChild("Mark"), {ImageTransparency = selected[name] and 0 or 1}, 0.15)
                        selText.Text = getSelText()
                        selText.TextColor3 = Centrix.Theme.TextPrimary
                        local list = {}
                        for k, v in pairs(selected) do if v then table.insert(list, k) end end
                        if opts.Callback then opts.Callback(list) end
                    else
                        selected = name
                        selText.Text = name
                        selText.TextColor3 = Centrix.Theme.TextPrimary
                        isOpen = false
                        Anim.Tween(frame, {Size = UDim2.new(1, 0, 0, 56)}, 0.2)
                        Anim.Tween(arrow, {Rotation = 0}, 0.2)
                        if opts.Callback then opts.Callback(name) end
                    end
                end)
            end
            
            for _, item in ipairs(items) do createItem(item) end
            
            selBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local h = isOpen and (62 + #items * 28) or 56
                Anim.Tween(frame, {Size = UDim2.new(1, 0, 0, h)}, 0.25)
                Anim.Tween(itemsCont, {Size = UDim2.new(1, -28, 0, isOpen and #items * 28 or 0)}, 0.25)
                Anim.Tween(arrow, {Rotation = isOpen and 180 or 0}, 0.25)
            end)
            
            selBtn.MouseEnter:Connect(function() Anim.Tween(selBtn:FindFirstChild("UIStroke"), {Color = Centrix.Theme.Primary}, 0.15) end)
            selBtn.MouseLeave:Connect(function() Anim.Tween(selBtn:FindFirstChild("UIStroke"), {Color = Centrix.Theme.Border}, 0.15) end)
            
            function Dropdown:Set(val)
                if opts.Multi then
                    selected = {}
                    for _, v in pairs(val) do selected[v] = true end
                else
                    selected = val
                end
                selText.Text = getSelText()
                selText.TextColor3 = Centrix.Theme.TextPrimary
            end
            
            function Dropdown:Get()
                if opts.Multi then
                    local list = {}
                    for k, v in pairs(selected) do if v then table.insert(list, k) end end
                    return list
                end
                return selected
            end
            
            return Dropdown
        end
        
        return Tab
    end
    
    return Window
end

return Centrix
