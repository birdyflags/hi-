--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                     CENTRIX UI LIBRARY                        ║
    ║           Clean • Minimal • Modern Design                     ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Centrix = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

-- ═══════════════════════════════════════════════════════════════
-- THEME - Lavender/Purple
-- ═══════════════════════════════════════════════════════════════

local Theme = {
    -- Backgrounds
    Primary = Color3.fromRGB(30, 27, 38),          -- Main bg
    Secondary = Color3.fromRGB(38, 34, 48),        -- Cards/containers
    Tertiary = Color3.fromRGB(48, 43, 60),         -- Hover/active
    
    -- Accent (Purple/Lavender)
    Accent = Color3.fromRGB(147, 112, 219),        -- Main purple
    AccentDark = Color3.fromRGB(120, 90, 180),
    
    -- Text
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 155, 175),
    TextMuted = Color3.fromRGB(100, 95, 115),
    
    -- Misc
    Border = Color3.fromRGB(55, 50, 70),
    Divider = Color3.fromRGB(60, 55, 75),
    
    -- States  
    Success = Color3.fromRGB(100, 200, 130),
    Warning = Color3.fromRGB(230, 180, 80),
    Error = Color3.fromRGB(220, 90, 90),
    Info = Color3.fromRGB(100, 160, 220),
}

-- ═══════════════════════════════════════════════════════════════
-- ICONS
-- ═══════════════════════════════════════════════════════════════

Centrix.Icons = {
    Home = "rbxassetid://7733960981",
    Settings = "rbxassetid://7734053495",
    Close = "rbxassetid://7734003889",
    ChevronDown = "rbxassetid://7734004077",
    ChevronUp = "rbxassetid://7734004305",
    Check = "rbxassetid://7733715400",
    Warning = "rbxassetid://7734062330",
    Info = "rbxassetid://7734014268",
    Sword = "rbxassetid://7734055853",
    Shield = "rbxassetid://7734053248",
    User = "rbxassetid://7734058893",
    Star = "rbxassetid://7734055553",
    Target = "rbxassetid://7734056001",
    Folder = "rbxassetid://7734011232",
}

-- ═══════════════════════════════════════════════════════════════
-- UTILITIES
-- ═══════════════════════════════════════════════════════════════

local function Tween(obj, props, dur, style)
    local ti = TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, ti, props)
    tw:Play()
    return tw
end

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

local function Draggable(frame, handle)
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
            Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM (Bottom right, minimal style)
-- ═══════════════════════════════════════════════════════════════

local NotifContainer

function Centrix:Notify(opts)
    opts = opts or {}
    local title = opts.Title or "Notification"
    local message = opts.Message or ""
    local duration = opts.Duration or 4
    local nType = opts.Type or "Info"
    
    if not NotifContainer then
        NotifContainer = Create("Frame", {
            Name = "CentrixNotifications",
            Size = UDim2.new(0, 260, 0, 300),
            Position = UDim2.new(1, -270, 1, -310),
            BackgroundTransparency = 1,
            Parent = CoreGui
        })
        Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Parent = NotifContainer
        })
    end
    
    local colors = {
        Info = Theme.Info,
        Success = Theme.Success,
        Warning = Theme.Warning,
        Error = Theme.Error
    }
    local accentColor = colors[nType] or Theme.Accent
    
    -- Main notification frame
    local notif = Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = NotifContainer
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = notif})
    
    -- Warning/Info triangle icon
    local iconBg = Create("Frame", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 10, 0.5, -16),
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Parent = notif
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = iconBg})
    
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = nType == "Warning" and "⚠" or (nType == "Error" and "✕" or (nType == "Success" and "✓" or "ℹ")),
        TextColor3 = accentColor,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = iconBg
    })
    
    -- Title
    Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 18),
        Position = UDim2.new(0, 50, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    -- Message
    Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 16),
        Position = UDim2.new(0, 50, 0, 28),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Theme.TextDim,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = notif
    })
    
    -- Bottom accent line
    local line = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 2),
        Position = UDim2.new(0, 10, 1, -6),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Parent = notif
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 1), Parent = line})
    
    -- Animate in
    notif.BackgroundTransparency = 1
    notif.Position = UDim2.new(1, 20, 0, 0)
    Tween(notif, {BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
    
    -- Animate line shrinking
    Tween(line, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)
    
    -- Auto dismiss
    task.delay(duration, function()
        Tween(notif, {BackgroundTransparency = 1, Position = UDim2.new(1, 20, 0, 0)}, 0.25)
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- WINDOW CREATION
-- ═══════════════════════════════════════════════════════════════

function Centrix:CreateWindow(opts)
    opts = opts or {}
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    local gameName = GetGameName()
    
    -- ScreenGui
    local gui = Create("ScreenGui", {
        Name = "CentrixHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    -- Main Window (Right side panel style)
    local main = Create("Frame", {
        Name = "MainWindow",
        Size = UDim2.new(0, 280, 0, 420),
        Position = UDim2.new(1, -290, 0.5, -210),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = gui
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = main})
    Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = main})
    
    -- Header
    local header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = main
    })
    
    -- Title (Tab name - will change)
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = "Home",
        TextColor3 = Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    -- Close button
    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -34, 0.5, -12),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Theme.TextDim,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        Parent = header
    })
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {TextColor3 = Theme.Error}, 0.15)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {TextColor3 = Theme.TextDim}, 0.15)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(main, {Position = UDim2.new(1, 20, 0.5, -210)}, 0.3)
        task.wait(0.35)
        gui:Destroy()
    end)
    
    -- Divider
    Create("Frame", {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundColor3 = Theme.Divider,
        BorderSizePixel = 0,
        Parent = main
    })
    
    -- Content container
    local content = Create("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, -10, 1, -90),
        Position = UDim2.new(0, 5, 0, 46),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = main
    })
    Create("UIPadding", {PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), PaddingLeft = UDim.new(0,5), PaddingRight = UDim.new(0,5), Parent = content})
    Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = content})
    
    -- Tab bar at bottom
    local tabBar = Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, -20, 0, 38),
        Position = UDim2.new(0, 10, 1, -44),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tabBar})
    
    local tabLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        Parent = tabBar
    })
    
    Draggable(main, header)
    
    -- Open animation
    main.Position = UDim2.new(1, 20, 0.5, -210)
    Tween(main, {Position = UDim2.new(1, -290, 0.5, -210)}, 0.4, Enum.EasingStyle.Back)
    
    -- ═══════════════════════════════════════════════════════════
    -- TAB CREATION
    -- ═══════════════════════════════════════════════════════════
    
    function Window:CreateTab(tabOpts)
        tabOpts = tabOpts or {}
        local Tab = {}
        Tab.Elements = {}
        
        local tabName = tabOpts.Name or "Tab"
        local tabIcon = tabOpts.Icon or Centrix.Icons.Folder
        
        -- Tab button (icon in tab bar)
        local tabBtn = Create("ImageButton", {
            Size = UDim2.new(0, 28, 0, 28),
            BackgroundColor3 = Theme.Tertiary,
            BackgroundTransparency = 1,
            Image = tabIcon,
            ImageColor3 = Theme.TextMuted,
            Parent = tabBar
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tabBtn})
        
        -- Tab content page
        local page = Create("Frame", {
            Name = tabName .. "Page",
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = content
        })
        Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})
        
        Tab.Button = tabBtn
        Tab.Page = page
        Tab.Name = tabName
        
        local function selectTab()
            -- Deselect all
            for _, t in pairs(Window.Tabs) do
                Tween(t.Button, {BackgroundTransparency = 1, ImageColor3 = Theme.TextMuted}, 0.2)
                t.Page.Visible = false
            end
            -- Select this
            Tween(tabBtn, {BackgroundTransparency = 0.5, ImageColor3 = Theme.Accent}, 0.2)
            page.Visible = true
            titleLabel.Text = tabName
            Window.ActiveTab = Tab
        end
        
        tabBtn.MouseButton1Click:Connect(selectTab)
        tabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 0.7}, 0.15)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            task.defer(selectTab)
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- ═══════════════════════════════════════════════════════
        -- DROPDOWN (Single & Multi)
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateDropdown(dropOpts)
            dropOpts = dropOpts or {}
            local Dropdown = {}
            local isOpen = false
            local items = dropOpts.Items or {}
            local multi = dropOpts.Multi or false
            local selected = multi and {} or nil
            
            if multi and dropOpts.Default then
                for _, v in pairs(dropOpts.Default) do selected[v] = true end
            elseif dropOpts.Default then
                selected = dropOpts.Default
            end
            
            -- Container (collapsible style)
            local container = Create("Frame", {
                Name = (dropOpts.Name or "Dropdown") .. "Container",
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = page
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = container})
            
            -- Header button
            local headerBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Text = "",
                Parent = container
            })
            
            -- Label
            Create("TextLabel", {
                Size = UDim2.new(1, -40, 0, 32),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = dropOpts.Name or "Dropdown",
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = headerBtn
            })
            
            -- Chevron
            local chevron = Create("TextLabel", {
                Size = UDim2.new(0, 20, 0, 32),
                Position = UDim2.new(1, -28, 0, 0),
                BackgroundTransparency = 1,
                Text = "∨",
                TextColor3 = Theme.TextMuted,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                Parent = headerBtn
            })
            
            -- Items container
            local itemsCont = Create("Frame", {
                Size = UDim2.new(1, -16, 0, 0),
                Position = UDim2.new(0, 8, 0, 36),
                BackgroundTransparency = 1,
                Parent = container
            })
            Create("UIListLayout", {Padding = UDim.new(0, 2), Parent = itemsCont})
            
            local function getDisplayText()
                if multi then
                    local list = {}
                    for k, v in pairs(selected) do if v then table.insert(list, k) end end
                    return #list > 0 and table.concat(list, ", ") or "None selected"
                else
                    return selected or "Select..."
                end
            end
            
            local function createItem(itemName)
                local itemBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundColor3 = Theme.Tertiary,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = itemsCont
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = itemBtn})
                
                -- Checkbox for multi
                local checkBox
                if multi then
                    checkBox = Create("Frame", {
                        Size = UDim2.new(0, 14, 0, 14),
                        Position = UDim2.new(0, 6, 0.5, -7),
                        BackgroundColor3 = Theme.Primary,
                        BorderSizePixel = 0,
                        Parent = itemBtn
                    })
                    Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = checkBox})
                    Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = checkBox})
                    
                    local checkMark = Create("TextLabel", {
                        Name = "Check",
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = "✓",
                        TextColor3 = Theme.Accent,
                        TextSize = 10,
                        Font = Enum.Font.GothamBold,
                        TextTransparency = selected[itemName] and 0 or 1,
                        Parent = checkBox
                    })
                end
                
                -- Item label
                Create("TextLabel", {
                    Size = UDim2.new(1, multi and -28 or -12, 1, 0),
                    Position = UDim2.new(0, multi and 26 or 8, 0, 0),
                    BackgroundTransparency = 1,
                    Text = itemName,
                    TextColor3 = Theme.TextDim,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = itemBtn
                })
                
                itemBtn.MouseEnter:Connect(function()
                    Tween(itemBtn, {BackgroundTransparency = 0.5}, 0.1)
                end)
                itemBtn.MouseLeave:Connect(function()
                    Tween(itemBtn, {BackgroundTransparency = 1}, 0.1)
                end)
                
                itemBtn.MouseButton1Click:Connect(function()
                    if multi then
                        selected[itemName] = not selected[itemName]
                        local check = checkBox:FindFirstChild("Check")
                        Tween(check, {TextTransparency = selected[itemName] and 0 or 1}, 0.15)
                        
                        local list = {}
                        for k, v in pairs(selected) do if v then table.insert(list, k) end end
                        if dropOpts.Callback then dropOpts.Callback(list) end
                    else
                        selected = itemName
                        if dropOpts.Callback then dropOpts.Callback(itemName) end
                        
                        -- Close dropdown
                        isOpen = false
                        Tween(container, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
                        chevron.Text = "∨"
                    end
                end)
            end
            
            -- Create items
            for _, item in ipairs(items) do
                createItem(item)
            end
            
            -- Toggle open/close
            headerBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    local h = 40 + (#items * 28)
                    Tween(container, {Size = UDim2.new(1, 0, 0, h)}, 0.25, Enum.EasingStyle.Back)
                    Tween(itemsCont, {Size = UDim2.new(1, -16, 0, #items * 28)}, 0.25)
                    chevron.Text = "∧"
                else
                    Tween(container, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
                    Tween(itemsCont, {Size = UDim2.new(1, -16, 0, 0)}, 0.2)
                    chevron.Text = "∨"
                end
            end)
            
            headerBtn.MouseEnter:Connect(function()
                Tween(headerBtn, {BackgroundTransparency = 0.8}, 0.1)
            end)
            headerBtn.MouseLeave:Connect(function()
                Tween(headerBtn, {BackgroundTransparency = 1}, 0.1)
            end)
            
            -- Accent line at bottom
            local accentLine = Create("Frame", {
                Size = UDim2.new(1, -16, 0, 2),
                Position = UDim2.new(0, 8, 1, -4),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Parent = container
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 1), Parent = accentLine})
            
            function Dropdown:Set(val)
                if multi then
                    selected = {}
                    for _, v in pairs(val) do selected[v] = true end
                else
                    selected = val
                end
            end
            
            function Dropdown:Get()
                if multi then
                    local list = {}
                    for k, v in pairs(selected) do if v then table.insert(list, k) end end
                    return list
                end
                return selected
            end
            
            function Dropdown:Refresh(newItems)
                items = newItems
                for _, child in pairs(itemsCont:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, item in ipairs(items) do createItem(item) end
            end
            
            table.insert(Tab.Elements, Dropdown)
            return Dropdown
        end
        
        return Tab
    end
    
    function Window:Destroy()
        gui:Destroy()
    end
    
    return Window
end

return Centrix
