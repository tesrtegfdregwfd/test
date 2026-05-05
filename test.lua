-- Roblox GUI with Key System
-- Key: cat
-- Delta Executor Compatible Version - FIXED
-- Fixes: Register overflow, UpValue limits, customWait crash

print("===========================================")
print("FlyOnion Hub - Starting...")
print("Delta Executor Optimized - v1.1")
print("===========================================")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
print("✓ All services loaded")

local player = Players.LocalPlayer

-- Universal wait function (Delta compatibility) - MUST BE DEFINED FIRST
local customWait = task and task.wait or wait

local playerGui
local success, err = pcall(function()
    playerGui = player:WaitForChild("PlayerGui", 10) -- Increased timeout for Delta
end)

if not success or not playerGui then
    warn("Failed to get PlayerGui, retrying...")
    customWait(2)
    playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 15)
end

print("Player found: " .. player.Name)
print("PlayerGui loaded successfully")

-- Mobile/Device Detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local screenSize = workspace.CurrentCamera.ViewportSize
local isSmallScreen = screenSize.X < 768 or screenSize.Y < 600

-- Determine device type for optimal sizing
local deviceType = "desktop"
if isMobile or isSmallScreen then
    deviceType = "mobile"
end

-- Debug print for mobile
print("Device Type: " .. deviceType)
print("Screen Size: " .. tostring(screenSize))
print("Is Mobile: " .. tostring(isMobile))
print("Is Small Screen: " .. tostring(isSmallScreen))

-- Responsive sizing function
local function getResponsiveSize(desktopSize, mobileSize)
    return deviceType == "mobile" and mobileSize or desktopSize
end

-- Key System Configuration
local CORRECT_KEY = "cat"
local KEY_STORAGE_NAME = "RobloxGUI_KeySaved"

-- Check if key is already saved
local function isKeySaved()
    local success, result = pcall(function()
        return game:GetService("DataStoreService"):GetDataStore("LocalData"):GetAsync(KEY_STORAGE_NAME)
    end)
    -- For local storage, we'll use a different method
    if not success then
        -- Try reading from a file (this won't work in Roblox, so we use a workaround)
        -- In Roblox, we'll use writefile/readfile if executor supports it
        if writefile and readfile and isfile then
            if isfile(KEY_STORAGE_NAME .. ".txt") then
                local savedKey = readfile(KEY_STORAGE_NAME .. ".txt")
                return savedKey == CORRECT_KEY
            end
        end
    end
    return false
end

local function saveKey()
    -- Save key locally
    if writefile then
        writefile(KEY_STORAGE_NAME .. ".txt", CORRECT_KEY)
    end
end

-- Create ScreenGui
print("Creating ScreenGui...")
customWait(0.1) -- Reduced wait for Delta performance
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyOnionHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
print("Parenting ScreenGui to PlayerGui...")
screenGui.Parent = playerGui
customWait(0.1) -- Reduced wait
print("ScreenGui Created and Parented")

-- Color Palette
local C = {
    BG        = Color3.fromRGB(8, 8, 14),
    BG2       = Color3.fromRGB(13, 13, 22),
    BG3       = Color3.fromRGB(18, 18, 30),
    PANEL     = Color3.fromRGB(22, 22, 36),
    ACCENT    = Color3.fromRGB(110, 50, 230),
    ACCENT2   = Color3.fromRGB(180, 60, 255),
    ON        = Color3.fromRGB(30, 200, 100),
    OFF       = Color3.fromRGB(180, 30, 60),
    TEXT      = Color3.fromRGB(240, 240, 255),
    TEXTDIM   = Color3.fromRGB(160, 155, 200),
    BORDER    = Color3.fromRGB(60, 40, 100),
    GLOW      = Color3.fromRGB(130, 60, 255),
}

-- Helper: add stroke
local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or C.BORDER
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
end

-- Helper: add gradient
local function addGradient(parent, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0 or C.BG2, c1 or C.BG3)
    g.Rotation = rot or 90
    g.Parent = parent
end

-- Key System Frame
local keyFrame = Instance.new("Frame")
keyFrame.Name = "KeyFrame"
keyFrame.Active = true
-- Responsive sizing: smaller on mobile
local keyFrameSize = getResponsiveSize(
    UDim2.new(0, 420, 0, 270),  -- Desktop
    UDim2.new(0.9, 0, 0, 280)    -- Mobile (90% width, slightly taller)
)
keyFrame.Size = keyFrameSize
keyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
keyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
keyFrame.BackgroundColor3 = C.BG
keyFrame.BorderSizePixel = 0
keyFrame.Parent = screenGui
print("KeyFrame Created - Size: " .. tostring(keyFrame.Size))
addGradient(keyFrame, C.BG, Color3.fromRGB(14, 10, 28), 135)

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 14)
keyCorner.Parent = keyFrame
addStroke(keyFrame, C.BORDER, 1.5)

-- Animated glow bar at top of key frame
local keyGlowBar = Instance.new("Frame")
keyGlowBar.Size = UDim2.new(1, 0, 0, 3)
keyGlowBar.Position = UDim2.new(0, 0, 0, 0)
keyGlowBar.BackgroundColor3 = C.ACCENT2
keyGlowBar.BorderSizePixel = 0
keyGlowBar.ZIndex = 5
keyGlowBar.Parent = keyFrame
local keyGlowBarCorner = Instance.new("UICorner")
keyGlowBarCorner.CornerRadius = UDim.new(0, 14)
keyGlowBarCorner.Parent = keyGlowBar
addGradient(keyGlowBar, C.ACCENT, C.ACCENT2, 0)

-- Key Frame Title
local keyTitle = Instance.new("TextLabel")
keyTitle.Name = "Title"
keyTitle.Size = UDim2.new(1, 0, 0, 55)
keyTitle.BackgroundColor3 = C.BG2
keyTitle.BorderSizePixel = 0
keyTitle.Text = "🔑  Key System"
keyTitle.TextColor3 = C.TEXT
keyTitle.TextSize = 22
keyTitle.Font = Enum.Font.GothamBold
keyTitle.Parent = keyFrame
addGradient(keyTitle, C.BG2, Color3.fromRGB(20, 14, 40), 90)

local keyTitleCorner = Instance.new("UICorner")
keyTitleCorner.CornerRadius = UDim.new(0, 14)
keyTitleCorner.Parent = keyTitle

local keySubTitle = Instance.new("TextLabel")
keySubTitle.Size = UDim2.new(1, 0, 0, 20)
keySubTitle.Position = UDim2.new(0, 0, 0, 58)
keySubTitle.BackgroundTransparency = 1
keySubTitle.Text = "FlyOnion Hub  •  Enter your key to continue"
keySubTitle.TextColor3 = C.TEXTDIM
keySubTitle.TextSize = 12
keySubTitle.Font = Enum.Font.Gotham
keySubTitle.Parent = keyFrame

-- Key Input Box
local keyInput = Instance.new("TextBox")
keyInput.Name = "KeyInput"
-- Responsive sizing
keyInput.Size = getResponsiveSize(
    UDim2.new(0, 340, 0, 42),
    UDim2.new(0.85, 0, 0, 45)
)
keyInput.Position = UDim2.new(0.5, 0, 0, 90)
keyInput.AnchorPoint = Vector2.new(0.5, 0)
keyInput.BackgroundColor3 = C.BG3
keyInput.BorderSizePixel = 0
keyInput.PlaceholderText = "Enter Key..."
keyInput.PlaceholderColor3 = C.TEXTDIM
keyInput.Text = ""
keyInput.TextColor3 = C.TEXT
keyInput.TextSize = deviceType == "mobile" and 14 or 16
keyInput.Font = Enum.Font.Gotham
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyFrame
addStroke(keyInput, C.BORDER, 1)

local keyInputCorner = Instance.new("UICorner")
keyInputCorner.CornerRadius = UDim.new(0, 9)
keyInputCorner.Parent = keyInput

-- Submit Button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = getResponsiveSize(
    UDim2.new(0, 160, 0, 42),
    UDim2.new(0.7, 0, 0, 45)
)
submitButton.Position = UDim2.new(0.5, 0, 0, 148)
submitButton.AnchorPoint = Vector2.new(0.5, 0)
submitButton.BackgroundColor3 = C.ACCENT
submitButton.BorderSizePixel = 0
submitButton.AutoButtonColor = false
submitButton.Text = "Unlock ✦"
submitButton.TextColor3 = C.TEXT
submitButton.TextSize = deviceType == "mobile" and 15 or 17
submitButton.Font = Enum.Font.GothamBold
submitButton.Parent = keyFrame
addGradient(submitButton, C.ACCENT, C.ACCENT2, 45)
addStroke(submitButton, C.ACCENT2, 1)

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 9)
submitCorner.Parent = submitButton

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 205)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = C.OFF
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = keyFrame

-- Main GUI Frame (Hidden initially)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Active = true
-- Responsive sizing: use scale on mobile for better fit
local mainFrameSize = getResponsiveSize(
    UDim2.new(0, 640, 0, 430),   -- Desktop
    UDim2.new(0.95, 0, 0.8, 0)   -- Mobile (95% width, 80% height)
)
mainFrame.Size = mainFrameSize
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = C.BG
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
print("MainFrame Created - Size: " .. tostring(mainFrame.Size))
addGradient(mainFrame, C.BG, Color3.fromRGB(12, 8, 24), 135)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame
addStroke(mainFrame, C.BORDER, 1.5)

-- Top glow bar (hidden – was causing a visible line artifact)
local mainGlowBar = Instance.new("Frame")
mainGlowBar.Size = UDim2.new(1, 0, 0, 3)
mainGlowBar.Position = UDim2.new(0, 0, 0, 0)
mainGlowBar.BackgroundColor3 = C.ACCENT
mainGlowBar.BorderSizePixel = 0
mainGlowBar.ZIndex = 5
mainGlowBar.Visible = false
mainGlowBar.Parent = mainFrame
local mainGlowBarCorner = Instance.new("UICorner")
mainGlowBarCorner.CornerRadius = UDim.new(0, 14)
mainGlowBarCorner.Parent = mainGlowBar
addGradient(mainGlowBar, C.ACCENT, C.ACCENT2, 0)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3 = C.BG2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
addGradient(titleBar, C.BG2, Color3.fromRGB(20, 14, 40), 90)

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

-- Title icon dot
local titleDot = Instance.new("Frame")
titleDot.Size = UDim2.new(0, 10, 0, 10)
titleDot.Position = UDim2.new(0, 18, 0.5, -5)
titleDot.BackgroundColor3 = C.ACCENT2
titleDot.BorderSizePixel = 0
titleDot.Parent = titleBar
local titleDotCorner = Instance.new("UICorner")
titleDotCorner.CornerRadius = UDim.new(0.5, 0)
titleDotCorner.Parent = titleDot

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 300, 1, 0)
title.Position = UDim2.new(0, 36, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✦  FlyOnion Hub"
title.TextColor3 = C.TEXT
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local titleSub = Instance.new("TextLabel")
titleSub.Size = UDim2.new(0, 200, 1, 0)
titleSub.Position = UDim2.new(0, 36, 0, 16)
titleSub.BackgroundTransparency = 1
titleSub.Text = "by cat"
titleSub.TextColor3 = C.TEXTDIM
titleSub.TextSize = 11
titleSub.Font = Enum.Font.Gotham
titleSub.TextXAlignment = Enum.TextXAlignment.Left
titleSub.Parent = titleBar

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 36, 0, 36)
minimizeButton.Position = UDim2.new(1, -88, 0, 8)
minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "─"
minimizeButton.TextColor3 = C.TEXTDIM
minimizeButton.TextSize = 18
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = titleBar
addStroke(minimizeButton, C.BORDER, 1)
local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 36, 0, 36)
closeButton.Position = UDim2.new(1, -46, 0, 8)
closeButton.BackgroundColor3 = C.OFF
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = C.TEXT
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar
addStroke(closeButton, Color3.fromRGB(220, 50, 80), 1)

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Tab Container
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(0, 155, 1, -62)
tabContainer.Position = UDim2.new(0, 10, 0, 57)
tabContainer.BackgroundColor3 = C.BG2
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame
addStroke(tabContainer, C.BORDER, 1)

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 10)
tabCorner.Parent = tabContainer

local tabPad = Instance.new("UIPadding")
tabPad.PaddingTop = UDim.new(0, 8)
tabPad.PaddingLeft = UDim.new(0, 6)
tabPad.PaddingRight = UDim.new(0, 6)
tabPad.Parent = tabContainer

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabContainer

-- Content Container
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -185, 1, -62)
contentContainer.Position = UDim2.new(0, 175, 0, 57)
contentContainer.BackgroundColor3 = C.BG2
contentContainer.BorderSizePixel = 0
contentContainer.Parent = mainFrame
addStroke(contentContainer, C.BORDER, 1)

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentContainer

-- Minimize logic
local guiMinimized = false
local originalSize = mainFrame.Size
minimizeButton.MouseButton1Click:Connect(function()
    guiMinimized = not guiMinimized
    if guiMinimized then
        mainFrame.Size = UDim2.new(0, 640, 0, 52)
        tabContainer.Visible = false
        contentContainer.Visible = false
        minimizeButton.Text = "□"
    else
        mainFrame.Size = originalSize
        tabContainer.Visible = true
        contentContainer.Visible = true
        minimizeButton.Text = "─"
    end
end)

-- Tab Creation Function
local tabs = {}
local currentTab = nil

local TAB_ICONS = {
    Info = "ℹ",
    Main = "⚡",
    Auto = "♻",
    Teleport = "⟶",
    Misc = "⚙",
    UI = "✦",
}

local function createTab(name, order)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 38)
    tabButton.BackgroundColor3 = C.PANEL
    tabButton.BorderSizePixel = 0
    tabButton.Text = (TAB_ICONS[name] or "•") .. "  " .. name
    tabButton.TextColor3 = C.TEXTDIM
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.LayoutOrder = order
    tabButton.Parent = tabContainer
    addStroke(tabButton, Color3.fromRGB(40, 30, 70), 1)

    local tabPadL = Instance.new("UIPadding")
    tabPadL.PaddingLeft = UDim.new(0, 12)
    tabPadL.Parent = tabButton

    local tabButtonCorner = Instance.new("UICorner")
    tabButtonCorner.CornerRadius = UDim.new(0, 7)
    tabButtonCorner.Parent = tabButton

    -- Active indicator bar
    local activeBar = Instance.new("Frame")
    activeBar.Size = UDim2.new(0, 3, 0.6, 0)
    activeBar.Position = UDim2.new(0, 0, 0.2, 0)
    activeBar.BackgroundColor3 = C.ACCENT2
    activeBar.BorderSizePixel = 0
    activeBar.Visible = false
    activeBar.ZIndex = 3
    activeBar.Parent = tabButton
    local activeBarCorner = Instance.new("UICorner")
    activeBarCorner.CornerRadius = UDim.new(0, 2)
    activeBarCorner.Parent = activeBar

    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, -20, 1, -20)
    content.Position = UDim2.new(0, 10, 0, 10)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = C.ACCENT
    content.Visible = false
    content.Parent = contentContainer

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = content

    tabs[name] = {button = tabButton, content = content, bar = activeBar}

    -- DELTA FIX: Store references locally instead of capturing entire tabs table
    local myContent = content
    local myButton = tabButton
    local myBar = activeBar
    
    tabButton.MouseButton1Click:Connect(function()
        -- Only access what we need from tabs
        for tabName, tab in pairs(tabs) do
            tab.content.Visible = false
            tab.button.BackgroundColor3 = C.PANEL
            tab.button.TextColor3 = C.TEXTDIM
            tab.button.Font = Enum.Font.Gotham
            tab.bar.Visible = false
        end
        myContent.Visible = true
        myButton.BackgroundColor3 = Color3.fromRGB(35, 20, 60)
        myButton.TextColor3 = C.TEXT
        myButton.Font = Enum.Font.GothamBold
        myBar.Visible = true
        currentTab = name
    end)

    return content
end

-- Create Tabs
local infoContent = createTab("Info", 1)
local mainContent = createTab("Main", 2)
local autoContent = createTab("Auto", 3)
local teleportContent = createTab("Teleport", 4)
local miscContent = createTab("Misc", 5)
local uiContent = createTab("UI", 6)

-- Info Tab Content
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(1, 0, 0, 70)
infoLabel.BackgroundColor3 = C.PANEL
infoLabel.BorderSizePixel = 0
infoLabel.Text = "✦  FlyOnion Hub"
infoLabel.TextColor3 = C.TEXT
infoLabel.TextSize = 22
infoLabel.Font = Enum.Font.GothamBold
infoLabel.Parent = infoContent
addGradient(infoLabel, C.PANEL, Color3.fromRGB(35, 20, 60), 90)
addStroke(infoLabel, C.BORDER, 1)

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 9)
infoCorner.Parent = infoLabel

local infoCredits = Instance.new("TextLabel")
infoCredits.Name = "Credits"
infoCredits.Size = UDim2.new(1, 0, 0, 50)
infoCredits.BackgroundColor3 = C.PANEL
infoCredits.BorderSizePixel = 0
infoCredits.Text = "Credits to cat  ·  Made for Transform to Fly Onion"
infoCredits.TextColor3 = C.TEXTDIM
infoCredits.TextSize = 14
infoCredits.Font = Enum.Font.Gotham
infoCredits.Parent = infoContent
addStroke(infoCredits, C.BORDER, 1)
local infoCreditCorner = Instance.new("UICorner")
infoCreditCorner.CornerRadius = UDim.new(0, 9)
infoCreditCorner.Parent = infoCredits

local infoKey = Instance.new("TextLabel")
infoKey.Name = "KeyInfo"
infoKey.Size = UDim2.new(1, 0, 0, 50)
infoKey.BackgroundColor3 = C.PANEL
infoKey.BorderSizePixel = 0
infoKey.Text = "🔑  Key: cat"
infoKey.TextColor3 = C.ACCENT2
infoKey.TextSize = 15
infoKey.Font = Enum.Font.GothamBold
infoKey.Parent = infoContent
addStroke(infoKey, C.BORDER, 1)
local infoKeyCorner = Instance.new("UICorner")
infoKeyCorner.CornerRadius = UDim.new(0, 9)
infoKeyCorner.Parent = infoKey

-- Main Tab Content
local mainLabel = Instance.new("TextLabel")
mainLabel.Name = "MainLabel"
mainLabel.Size = UDim2.new(1, 0, 0, 40)
mainLabel.BackgroundColor3 = C.PANEL
mainLabel.BorderSizePixel = 0
mainLabel.Text = "⚡  Main Features"
mainLabel.TextColor3 = C.TEXT
mainLabel.TextSize = 15
mainLabel.Font = Enum.Font.GothamBold
mainLabel.Parent = mainContent
addGradient(mainLabel, C.PANEL, Color3.fromRGB(35, 20, 60), 90)
addStroke(mainLabel, C.BORDER, 1)
local mainLabelCorner = Instance.new("UICorner")
mainLabelCorner.CornerRadius = UDim.new(0, 9)
mainLabelCorner.Parent = mainLabel

-- Helper: create styled toggle row
local function createToggleRow(parent, labelText, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundColor3 = C.PANEL
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = parent
    addStroke(row, C.BORDER, 1)
    local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 9) rc.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 250, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = C.TEXT
    lbl.TextSize = 14
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 72, 0, 30)
    btn.Position = UDim2.new(1, -84, 0.5, -15)
    btn.BackgroundColor3 = C.OFF
    btn.BorderSizePixel = 0
    btn.Text = "OFF"
    btn.TextColor3 = C.TEXT
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = row
    addStroke(btn, Color3.fromRGB(200, 40, 70), 1)
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 7) bc.Parent = btn
    return row, btn
end

-- Helper: create cooldown box
local function createCDBox(parent, defaultVal)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 48, 0, 30)
    box.Position = UDim2.new(1, -164, 0.5, -15)
    box.BackgroundColor3 = C.BG3
    box.BorderSizePixel = 0
    box.Text = tostring(defaultVal or 1)
    box.TextColor3 = C.ACCENT2
    box.TextSize = 13
    box.Font = Enum.Font.GothamBold
    box.ClearTextOnFocus = false
    box.Parent = parent
    addStroke(box, C.BORDER, 1)
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = box
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 24, 0, 14)
    lbl.Position = UDim2.new(1, -218, 0.5, -7)
    lbl.BackgroundTransparency = 1
    lbl.Text = "CD"
    lbl.TextColor3 = C.TEXTDIM
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = parent
    return box
end

-- ── AUTO X GIFTS ──
local giftRow, giftBtn = createToggleRow(mainContent, "🎁  Auto X Gifts", 2)
local giftCDBox = createCDBox(giftRow, 1)
-- Shrink auto-label so the dropdown doesn't sit on top of it
do
    local gl = giftRow:FindFirstChildOfClass("TextLabel")
    if gl then gl.Size = UDim2.new(0, 145, 1, 0) end
end

-- Gift action dropdown (Accept / Decline)
local giftActionSelected = "Accept"
local giftDropdownOpen = false

local giftDropBg = Instance.new("TextButton")
giftDropBg.Size = UDim2.new(0, 90, 0, 30)
giftDropBg.Position = UDim2.new(0, 150, 0.5, -15)
giftDropBg.BackgroundColor3 = C.BG3
giftDropBg.BorderSizePixel = 0
giftDropBg.Text = "Accept  v"
giftDropBg.TextColor3 = C.ACCENT2
giftDropBg.TextSize = 12
giftDropBg.Font = Enum.Font.GothamBold
giftDropBg.Parent = giftRow
addStroke(giftDropBg, C.BORDER, 1)
local giftDropCorner = Instance.new("UICorner") giftDropCorner.CornerRadius = UDim.new(0, 7) giftDropCorner.Parent = giftDropBg

-- Dropdown list parented to screenGui so it renders above everything (no ScrollingFrame clipping)
local giftDropList = Instance.new("Frame")
giftDropList.Size = UDim2.new(0, 90, 0, 72)
giftDropList.BackgroundColor3 = C.BG3
giftDropList.BorderSizePixel = 0
giftDropList.Visible = false
giftDropList.ZIndex = 20
giftDropList.Parent = screenGui
addStroke(giftDropList, C.BORDER, 1)
local giftDropListCorner = Instance.new("UICorner") giftDropListCorner.CornerRadius = UDim.new(0, 7) giftDropListCorner.Parent = giftDropList

local giftOpts = {"Accept", "Decline"}
for idx, opt in ipairs(giftOpts) do
    local optBtn = Instance.new("TextButton")
    optBtn.Size = UDim2.new(1, 0, 0, 34)
    optBtn.Position = UDim2.new(0, 0, 0, (idx-1)*34)
    optBtn.BackgroundTransparency = 1
    optBtn.Text = opt
    optBtn.TextColor3 = C.TEXT
    optBtn.TextSize = 13
    optBtn.Font = Enum.Font.Gotham
    optBtn.ZIndex = 21
    optBtn.Parent = giftDropList
    optBtn.MouseButton1Click:Connect(function()
        giftActionSelected = opt
        giftDropBg.Text = opt .. "  v"
        giftDropList.Visible = false
        giftDropdownOpen = false
    end)
end

giftDropBg.MouseButton1Click:Connect(function()
    giftDropdownOpen = not giftDropdownOpen
    if giftDropdownOpen then
        -- Position dropdown absolutely below the button
        local absPos = giftDropBg.AbsolutePosition
        local absSize = giftDropBg.AbsoluteSize
        giftDropList.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
    end
    giftDropList.Visible = giftDropdownOpen
end)

local autoGiftEnabled = false
local autoGiftThread = nil
giftBtn.MouseButton1Click:Connect(function()
    autoGiftEnabled = not autoGiftEnabled
    if autoGiftEnabled then
        giftBtn.BackgroundColor3 = C.ON
        giftBtn.Text = "ON"
        addStroke(giftBtn, Color3.fromRGB(30, 210, 90), 1)
        autoGiftThread = task.spawn(function()
            while autoGiftEnabled do
                pcall(function()
                    local args = { giftActionSelected }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RequestGift"):FireServer(unpack(args))
                end)
                local cd = tonumber(giftCDBox.Text) or 1
                task.wait(math.max(0.1, cd))
            end
        end)
    else
        giftBtn.BackgroundColor3 = C.OFF
        giftBtn.Text = "OFF"
        addStroke(giftBtn, Color3.fromRGB(200, 40, 70), 1)
        if autoGiftThread then task.cancel(autoGiftThread) autoGiftThread = nil end
    end
end)

-- ── AUTO COLLECT MONEY ──
local collectRow, collectBtn = createToggleRow(mainContent, "💰  Auto Collect Money", 3)

local autoCollectEnabled = false
local autoCollectThread = nil
collectBtn.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    if autoCollectEnabled then
        collectBtn.BackgroundColor3 = C.ON
        collectBtn.Text = "ON"
        addStroke(collectBtn, Color3.fromRGB(30, 210, 90), 1)
        autoCollectThread = task.spawn(function()
            while autoCollectEnabled do
                pcall(function()
                    local username = game:GetService("Players").LocalPlayer.Name
                    local basesFolder = workspace:FindFirstChild("Bases")
                    if not basesFolder then return end
                    local plot = basesFolder:FindFirstChild("Plot_" .. username)
                    if not plot then return end
                    for floorNum = 1, 14 do
                        pcall(function()
                            local floor = plot:FindFirstChild("Floor" .. floorNum)
                            if not floor then return end
                            local slots = floor:FindFirstChild("Slots")
                            if not slots then return end
                            for _, slot in ipairs(slots:GetChildren()) do
                                pcall(function()
                                    local buttonTop = slot:FindFirstChild("Button.Top")
                                    if buttonTop then
                                        local ti = buttonTop:FindFirstChild("TouchInterest")
                                        if ti then
                                            firetouchinterest(buttonTop, ti, 0)
                                            firetouchinterest(buttonTop, ti, 1)
                                        end
                                    end
                                end)
                            end
                        end)
                    end
                end)
                task.wait(0.5)
            end
        end)
    else
        collectBtn.BackgroundColor3 = C.OFF
        collectBtn.Text = "OFF"
        addStroke(collectBtn, Color3.fromRGB(200, 40, 70), 1)
        if autoCollectThread then task.cancel(autoCollectThread) autoCollectThread = nil end
    end
end)

-- ── AUTO REBIRTH ──
local rebirthRow, rebirthBtn = createToggleRow(mainContent, "🔁  Auto Rebirth", 4)
local rebirthCDBox = createCDBox(rebirthRow, 5)

local autoRebirthEnabled = false
local autoRebirthThread = nil
rebirthBtn.MouseButton1Click:Connect(function()
    autoRebirthEnabled = not autoRebirthEnabled
    if autoRebirthEnabled then
        rebirthBtn.BackgroundColor3 = C.ON
        rebirthBtn.Text = "ON"
        addStroke(rebirthBtn, Color3.fromRGB(30, 210, 90), 1)
        autoRebirthThread = task.spawn(function()
            while autoRebirthEnabled do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RebirthEvent"):FireServer()
                end)
                local cd = tonumber(rebirthCDBox.Text) or 5
                task.wait(math.max(0.1, cd))
            end
        end)
    else
        rebirthBtn.BackgroundColor3 = C.OFF
        rebirthBtn.Text = "OFF"
        addStroke(rebirthBtn, Color3.fromRGB(200, 40, 70), 1)
        if autoRebirthThread then task.cancel(autoRebirthThread) autoRebirthThread = nil end
    end
end)

-- Auto Tab Content - Toggle for Auto Equip Best
local autoEquipToggle = Instance.new("Frame")
autoEquipToggle.Name = "AutoEquipToggle"
autoEquipToggle.Size = UDim2.new(1, 0, 0, 48)
autoEquipToggle.BackgroundColor3 = C.PANEL
autoEquipToggle.BorderSizePixel = 0
autoEquipToggle.Parent = autoContent
addStroke(autoEquipToggle, C.BORDER, 1)

local autoEquipCorner = Instance.new("UICorner")
autoEquipCorner.CornerRadius = UDim.new(0, 9)
autoEquipCorner.Parent = autoEquipToggle

local autoEquipLabel = Instance.new("TextLabel")
autoEquipLabel.Name = "Label"
autoEquipLabel.Size = UDim2.new(0, 250, 1, 0)
autoEquipLabel.Position = UDim2.new(0, 15, 0, 0)
autoEquipLabel.BackgroundTransparency = 1
autoEquipLabel.Text = "⚔  Auto Equip Best"
autoEquipLabel.TextColor3 = C.TEXT
autoEquipLabel.TextSize = 14
autoEquipLabel.Font = Enum.Font.Gotham
autoEquipLabel.TextXAlignment = Enum.TextXAlignment.Left
autoEquipLabel.Parent = autoEquipToggle

local autoEquipButton = Instance.new("TextButton")
autoEquipButton.Name = "ToggleButton"
autoEquipButton.Size = UDim2.new(0, 72, 0, 30)
autoEquipButton.Position = UDim2.new(1, -84, 0.5, -15)
autoEquipButton.BackgroundColor3 = C.OFF
autoEquipButton.BorderSizePixel = 0
autoEquipButton.Text = "OFF"
autoEquipButton.TextColor3 = C.TEXT
autoEquipButton.TextSize = 13
autoEquipButton.Font = Enum.Font.GothamBold
autoEquipButton.Parent = autoEquipToggle
addStroke(autoEquipButton, Color3.fromRGB(200, 40, 70), 1)

local autoEquipButtonCorner = Instance.new("UICorner")
autoEquipButtonCorner.CornerRadius = UDim.new(0, 7)
autoEquipButtonCorner.Parent = autoEquipButton

-- CD label and box for Auto Equip Best
local autoEquipCDLbl = Instance.new("TextLabel")
autoEquipCDLbl.Size = UDim2.new(0, 28, 0, 14)
autoEquipCDLbl.Position = UDim2.new(1, -218, 0.5, -20)
autoEquipCDLbl.BackgroundTransparency = 1
autoEquipCDLbl.Text = "CD(s)"
autoEquipCDLbl.TextColor3 = C.TEXTDIM
autoEquipCDLbl.TextSize = 10
autoEquipCDLbl.Font = Enum.Font.Gotham
autoEquipCDLbl.Parent = autoEquipToggle

local autoEquipCDBox = Instance.new("TextBox")
autoEquipCDBox.Size = UDim2.new(0, 48, 0, 30)
autoEquipCDBox.Position = UDim2.new(1, -164, 0.5, -15)
autoEquipCDBox.BackgroundColor3 = C.BG3
autoEquipCDBox.BorderSizePixel = 0
autoEquipCDBox.Text = "3"
autoEquipCDBox.TextColor3 = C.ACCENT2
autoEquipCDBox.TextSize = 13
autoEquipCDBox.Font = Enum.Font.GothamBold
autoEquipCDBox.ClearTextOnFocus = false
autoEquipCDBox.Parent = autoEquipToggle
addStroke(autoEquipCDBox, C.BORDER, 1)
local autoEquipCDBoxCorner = Instance.new("UICorner")
autoEquipCDBoxCorner.CornerRadius = UDim.new(0, 6)
autoEquipCDBoxCorner.Parent = autoEquipCDBox

-- Auto Equip Interval Slider
local intervalFrame = Instance.new("Frame")
intervalFrame.Name = "IntervalFrame"
intervalFrame.Size = UDim2.new(1, 0, 0, 48)
intervalFrame.BackgroundColor3 = C.PANEL
intervalFrame.BorderSizePixel = 0
intervalFrame.Parent = autoContent
addStroke(intervalFrame, C.BORDER, 1)

local intervalFrameCorner = Instance.new("UICorner")
intervalFrameCorner.CornerRadius = UDim.new(0, 9)
intervalFrameCorner.Parent = intervalFrame

local intervalLabel = Instance.new("TextLabel")
intervalLabel.Name = "IntervalLabel"
intervalLabel.Size = UDim2.new(0, 160, 1, 0)
intervalLabel.Position = UDim2.new(0, 15, 0, 0)
intervalLabel.BackgroundTransparency = 1
intervalLabel.Text = "Equip Interval: 3s"
intervalLabel.TextColor3 = C.ACCENT2
intervalLabel.TextSize = 13
intervalLabel.Font = Enum.Font.Gotham
intervalLabel.TextXAlignment = Enum.TextXAlignment.Left
intervalLabel.Parent = intervalFrame

local sliderBar = Instance.new("Frame")
sliderBar.Name = "SliderBar"
sliderBar.Size = UDim2.new(0, 180, 0, 6)
sliderBar.Position = UDim2.new(0, 170, 0.5, -3)
sliderBar.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
sliderBar.BorderSizePixel = 0
sliderBar.Parent = intervalFrame
addStroke(sliderBar, C.BORDER, 1)

local sliderBarCorner = Instance.new("UICorner")
sliderBarCorner.CornerRadius = UDim.new(0, 3)
sliderBarCorner.Parent = sliderBar

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new(0.1, 0, 1, 0)
sliderFill.BackgroundColor3 = C.ACCENT
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBar
addGradient(sliderFill, C.ACCENT, C.ACCENT2, 0)

local sliderFillCorner = Instance.new("UICorner")
sliderFillCorner.CornerRadius = UDim.new(0, 3)
sliderFillCorner.Parent = sliderFill

local sliderKnob = Instance.new("TextButton")
sliderKnob.Name = "SliderKnob"
sliderKnob.Size = UDim2.new(0, 16, 0, 16)
sliderKnob.Position = UDim2.new(0.1, -8, 0.5, -8)
sliderKnob.BackgroundColor3 = C.ACCENT2
sliderKnob.BorderSizePixel = 0
sliderKnob.Text = ""
sliderKnob.ZIndex = 5
sliderKnob.Parent = sliderBar

local sliderKnobCorner = Instance.new("UICorner")
sliderKnobCorner.CornerRadius = UDim.new(0.5, 0)
sliderKnobCorner.Parent = sliderKnob

-- Interval steps: 1s to 30s
local intervalSteps = {}
for i = 1, 30 do intervalSteps[i] = i end
local currentIntervalIndex = 3 -- default 3s
local autoEquipInterval = 3

local function updateSlider(index)
    index = math.clamp(index, 1, 30)
    currentIntervalIndex = index
    autoEquipInterval = intervalSteps[index]
    intervalLabel.Text = "Equip Interval: " .. autoEquipInterval .. "s"
    local pct = (index - 1) / 29
    sliderFill.Size = UDim2.new(pct, 0, 1, 0)
    sliderKnob.Position = UDim2.new(pct, -8, 0.5, -8)
end

updateSlider(3)

local sliderDragging = false
sliderKnob.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)
sliderKnob.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if sliderDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local barAbsPos = sliderBar.AbsolutePosition.X
        local barAbsSize = sliderBar.AbsoluteSize.X
        local relX = math.clamp(inp.Position.X - barAbsPos, 0, barAbsSize)
        local pct = relX / barAbsSize
        local index = math.round(pct * 29) + 1
        updateSlider(index)
    end
end)
sliderBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        local barAbsPos = sliderBar.AbsolutePosition.X
        local barAbsSize = sliderBar.AbsoluteSize.X
        local relX = math.clamp(inp.Position.X - barAbsPos, 0, barAbsSize)
        local pct = relX / barAbsSize
        local index = math.round(pct * 29) + 1
        updateSlider(index)
    end
end)

-- Auto Collect Money Toggle
local autoCollectToggle = Instance.new("Frame")
autoCollectToggle.Name = "AutoCollectToggle"
autoCollectToggle.Size = UDim2.new(1, 0, 0, 48)
autoCollectToggle.BackgroundColor3 = C.PANEL
autoCollectToggle.BorderSizePixel = 0
autoCollectToggle.Parent = autoContent
addStroke(autoCollectToggle, C.BORDER, 1)

local autoCollectCorner = Instance.new("UICorner")
autoCollectCorner.CornerRadius = UDim.new(0, 9)
autoCollectCorner.Parent = autoCollectToggle

local autoCollectLabel = Instance.new("TextLabel")
autoCollectLabel.Name = "Label"
autoCollectLabel.Size = UDim2.new(0, 140, 1, 0)
autoCollectLabel.Position = UDim2.new(0, 15, 0, 0)
autoCollectLabel.BackgroundTransparency = 1
autoCollectLabel.Text = "💵  Auto Collect Money"
autoCollectLabel.TextColor3 = C.TEXT
autoCollectLabel.TextSize = 13
autoCollectLabel.Font = Enum.Font.Gotham
autoCollectLabel.TextXAlignment = Enum.TextXAlignment.Left
autoCollectLabel.Parent = autoCollectToggle

-- Cooldown box for auto collect
local collectCDLabel = Instance.new("TextLabel")
collectCDLabel.Size = UDim2.new(0, 24, 0, 14)
collectCDLabel.Position = UDim2.new(1, -218, 0.5, -20)
collectCDLabel.BackgroundTransparency = 1
collectCDLabel.Text = "CD(s)"
collectCDLabel.TextColor3 = C.TEXTDIM
collectCDLabel.TextSize = 10
collectCDLabel.Font = Enum.Font.Gotham
collectCDLabel.Parent = autoCollectToggle

local collectCDBox = Instance.new("TextBox")
collectCDBox.Size = UDim2.new(0, 48, 0, 28)
collectCDBox.Position = UDim2.new(1, -218, 0.5, -14)
collectCDBox.BackgroundColor3 = C.BG3
collectCDBox.BorderSizePixel = 0
collectCDBox.Text = "1"
collectCDBox.TextColor3 = C.ACCENT2
collectCDBox.TextSize = 13
collectCDBox.Font = Enum.Font.GothamBold
collectCDBox.ClearTextOnFocus = false
collectCDBox.Parent = autoCollectToggle
addStroke(collectCDBox, C.BORDER, 1)
local collectCDBoxCorner = Instance.new("UICorner")
collectCDBoxCorner.CornerRadius = UDim.new(0, 6)
collectCDBoxCorner.Parent = collectCDBox

local autoCollectButton = Instance.new("TextButton")
autoCollectButton.Name = "ToggleButton"
autoCollectButton.Size = UDim2.new(0, 72, 0, 30)
autoCollectButton.Position = UDim2.new(1, -84, 0.5, -15)
autoCollectButton.BackgroundColor3 = C.OFF
autoCollectButton.BorderSizePixel = 0
autoCollectButton.Text = "OFF"
autoCollectButton.TextColor3 = C.TEXT
autoCollectButton.TextSize = 13
autoCollectButton.Font = Enum.Font.GothamBold
autoCollectButton.Parent = autoCollectToggle
addStroke(autoCollectButton, Color3.fromRGB(200, 40, 70), 1)

local autoCollectButtonCorner = Instance.new("UICorner")
autoCollectButtonCorner.CornerRadius = UDim.new(0, 7)
autoCollectButtonCorner.Parent = autoCollectButton

local autoCollectAutoEnabled = false
local autoCollectConnection = nil

autoCollectButton.MouseButton1Click:Connect(function()
    autoCollectAutoEnabled = not autoCollectAutoEnabled
    if autoCollectAutoEnabled then
        autoCollectButton.BackgroundColor3 = C.ON
        autoCollectButton.Text = "ON"
        addStroke(autoCollectButton, Color3.fromRGB(30, 210, 90), 1)
        autoCollectConnection = task.spawn(function()
            while autoCollectAutoEnabled do
                pcall(function()
                    local username = game:GetService("Players").LocalPlayer.Name
                    local basesFolder = workspace:FindFirstChild("Bases")
                    if not basesFolder then return end
                    local plot = basesFolder:FindFirstChild("Plot_" .. username)
                    if not plot then return end
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    for floorNum = 1, 14 do
                        pcall(function()
                            local floor = plot:FindFirstChild("Floor" .. tostring(floorNum))
                            if not floor then return end
                            local slots = floor:FindFirstChild("Slots")
                            if not slots then return end
                            for _, slot in ipairs(slots:GetChildren()) do
                                pcall(function()
                                    local buttonTop = slot:FindFirstChild("Button.Top")
                                    if buttonTop and hrp then
                                        -- Fire touch enter and leave
                                        firetouchinterest(buttonTop, hrp, 0)
                                        firetouchinterest(buttonTop, hrp, 1)
                                        -- Also fire any ProximityPrompts inside the slot
                                        for _, pp in ipairs(slot:GetDescendants()) do
                                            if pp:IsA("ProximityPrompt") then
                                                pcall(function() fireproximityprompt(pp) end)
                                            end
                                        end
                                    end
                                end)
                            end
                        end)
                    end
                end)
                local cd = tonumber(collectCDBox.Text) or 1
                task.wait(math.max(0.1, cd))
            end
        end)
    else
        autoCollectButton.BackgroundColor3 = C.OFF
        autoCollectButton.Text = "OFF"
        addStroke(autoCollectButton, Color3.fromRGB(200, 40, 70), 1)
        if autoCollectConnection then task.cancel(autoCollectConnection) autoCollectConnection = nil end
    end
end)

-- Auto Buy Speed
local autoBuySpeedFrame = Instance.new("Frame")
autoBuySpeedFrame.Name = "AutoBuySpeedFrame"
autoBuySpeedFrame.Size = UDim2.new(1, 0, 0, 48)
autoBuySpeedFrame.BackgroundColor3 = C.PANEL
autoBuySpeedFrame.BorderSizePixel = 0
autoBuySpeedFrame.Parent = autoContent
addStroke(autoBuySpeedFrame, C.BORDER, 1)

local autoBuySpeedCorner = Instance.new("UICorner")
autoBuySpeedCorner.CornerRadius = UDim.new(0, 9)
autoBuySpeedCorner.Parent = autoBuySpeedFrame

local autoBuySpeedLabel = Instance.new("TextLabel")
autoBuySpeedLabel.Size = UDim2.new(0, 110, 1, 0)
autoBuySpeedLabel.Position = UDim2.new(0, 10, 0, 0)
autoBuySpeedLabel.BackgroundTransparency = 1
autoBuySpeedLabel.Text = "⚡  Auto Buy Speed"
autoBuySpeedLabel.TextColor3 = C.TEXT
autoBuySpeedLabel.TextSize = 13
autoBuySpeedLabel.Font = Enum.Font.Gotham
autoBuySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
autoBuySpeedLabel.Parent = autoBuySpeedFrame

-- Cooldown input
local speedCooldownBox = Instance.new("TextBox")
speedCooldownBox.Size = UDim2.new(0, 50, 0, 28)
speedCooldownBox.Position = UDim2.new(0, 120, 0.5, -14)
speedCooldownBox.BackgroundColor3 = C.BG3
speedCooldownBox.BorderSizePixel = 0
speedCooldownBox.Text = "1"
speedCooldownBox.TextColor3 = C.ACCENT2
speedCooldownBox.TextSize = 13
speedCooldownBox.Font = Enum.Font.Gotham
speedCooldownBox.ClearTextOnFocus = false
speedCooldownBox.Parent = autoBuySpeedFrame
addStroke(speedCooldownBox, C.BORDER, 1)

local speedCooldownBoxCorner = Instance.new("UICorner")
speedCooldownBoxCorner.CornerRadius = UDim.new(0, 6)
speedCooldownBoxCorner.Parent = speedCooldownBox

local speedCooldownLabel = Instance.new("TextLabel")
speedCooldownLabel.Size = UDim2.new(0, 30, 0, 28)
speedCooldownLabel.Position = UDim2.new(0, 115, 0.5, -28)
speedCooldownLabel.BackgroundTransparency = 1
speedCooldownLabel.Text = "CD(s)"
speedCooldownLabel.TextColor3 = C.TEXTDIM
speedCooldownLabel.TextSize = 10
speedCooldownLabel.Font = Enum.Font.Gotham
speedCooldownLabel.Parent = autoBuySpeedFrame

-- Amount choice buttons (1 / 5 / 10)
local speedAmountSelected = 1
local speedAmountButtons = {}
local speedAmountValues = {1, 5, 10}
for i, val in ipairs(speedAmountValues) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 36, 0, 28)
    btn.Position = UDim2.new(0, 175 + (i-1)*42, 0.5, -14)
    btn.BackgroundColor3 = i == 1 and C.ACCENT or C.BG3
    btn.BorderSizePixel = 0
    btn.Text = tostring(val)
    btn.TextColor3 = C.TEXT
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = autoBuySpeedFrame
    addStroke(btn, C.BORDER, 1)
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    speedAmountButtons[i] = btn
    btn.MouseButton1Click:Connect(function()
        speedAmountSelected = val
        for j, b in ipairs(speedAmountButtons) do
            b.BackgroundColor3 = j == i and C.ACCENT or C.BG3
        end
    end)
end

local autoBuySpeedToggle = Instance.new("TextButton")
autoBuySpeedToggle.Size = UDim2.new(0, 50, 0, 28)
autoBuySpeedToggle.Position = UDim2.new(1, -60, 0.5, -14)
autoBuySpeedToggle.BackgroundColor3 = C.OFF
autoBuySpeedToggle.BorderSizePixel = 0
autoBuySpeedToggle.Text = "OFF"
autoBuySpeedToggle.TextColor3 = C.TEXT
autoBuySpeedToggle.TextSize = 13
autoBuySpeedToggle.Font = Enum.Font.GothamBold
autoBuySpeedToggle.Parent = autoBuySpeedFrame
addStroke(autoBuySpeedToggle, Color3.fromRGB(200, 40, 70), 1)

local autoBuySpeedToggleCorner = Instance.new("UICorner")
autoBuySpeedToggleCorner.CornerRadius = UDim.new(0, 6)
autoBuySpeedToggleCorner.Parent = autoBuySpeedToggle

local autoBuySpeedEnabled = false
local autoBuySpeedConnection = nil
autoBuySpeedToggle.MouseButton1Click:Connect(function()
    autoBuySpeedEnabled = not autoBuySpeedEnabled
    if autoBuySpeedEnabled then
        autoBuySpeedToggle.BackgroundColor3 = C.ON
        autoBuySpeedToggle.Text = "ON"
        addStroke(autoBuySpeedToggle, Color3.fromRGB(30, 210, 90), 1)
        autoBuySpeedConnection = task.spawn(function()
            while autoBuySpeedEnabled do
                pcall(function()
                    local args = { speedAmountSelected }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PurchaseSpeed"):FireServer(unpack(args))
                end)
                local cd = tonumber(speedCooldownBox.Text) or 1
                task.wait(math.max(0.1, cd))
            end
        end)
    else
        autoBuySpeedToggle.BackgroundColor3 = C.OFF
        autoBuySpeedToggle.Text = "OFF"
        addStroke(autoBuySpeedToggle, Color3.fromRGB(200, 40, 70), 1)
        if autoBuySpeedConnection then task.cancel(autoBuySpeedConnection) autoBuySpeedConnection = nil end
    end
end)

-- Auto Buy Carry
local autoBuyCarryFrame = Instance.new("Frame")
autoBuyCarryFrame.Name = "AutoBuyCarryFrame"
autoBuyCarryFrame.Size = UDim2.new(1, 0, 0, 48)
autoBuyCarryFrame.BackgroundColor3 = C.PANEL
autoBuyCarryFrame.BorderSizePixel = 0
autoBuyCarryFrame.Parent = autoContent
addStroke(autoBuyCarryFrame, C.BORDER, 1)

local autoBuyCarryCorner = Instance.new("UICorner")
autoBuyCarryCorner.CornerRadius = UDim.new(0, 9)
autoBuyCarryCorner.Parent = autoBuyCarryFrame

local autoBuyCarryLabel = Instance.new("TextLabel")
autoBuyCarryLabel.Size = UDim2.new(0, 110, 1, 0)
autoBuyCarryLabel.Position = UDim2.new(0, 10, 0, 0)
autoBuyCarryLabel.BackgroundTransparency = 1
autoBuyCarryLabel.Text = "🎒  Auto Buy Carry"
autoBuyCarryLabel.TextColor3 = C.TEXT
autoBuyCarryLabel.TextSize = 13
autoBuyCarryLabel.Font = Enum.Font.Gotham
autoBuyCarryLabel.TextXAlignment = Enum.TextXAlignment.Left
autoBuyCarryLabel.Parent = autoBuyCarryFrame

local carryCooldownBox = Instance.new("TextBox")
carryCooldownBox.Size = UDim2.new(0, 50, 0, 28)
carryCooldownBox.Position = UDim2.new(0, 120, 0.5, -14)
carryCooldownBox.BackgroundColor3 = C.BG3
carryCooldownBox.BorderSizePixel = 0
carryCooldownBox.Text = "1"
carryCooldownBox.TextColor3 = C.ACCENT2
carryCooldownBox.TextSize = 13
carryCooldownBox.Font = Enum.Font.Gotham
carryCooldownBox.ClearTextOnFocus = false
carryCooldownBox.Parent = autoBuyCarryFrame
addStroke(carryCooldownBox, C.BORDER, 1)

local carryCooldownBoxCorner = Instance.new("UICorner")
carryCooldownBoxCorner.CornerRadius = UDim.new(0, 6)
carryCooldownBoxCorner.Parent = carryCooldownBox

local carryCooldownLabel = Instance.new("TextLabel")
carryCooldownLabel.Size = UDim2.new(0, 30, 0, 28)
carryCooldownLabel.Position = UDim2.new(0, 115, 0.5, -28)
carryCooldownLabel.BackgroundTransparency = 1
carryCooldownLabel.Text = "CD(s)"
carryCooldownLabel.TextColor3 = C.TEXTDIM
carryCooldownLabel.TextSize = 10
carryCooldownLabel.Font = Enum.Font.Gotham
carryCooldownLabel.Parent = autoBuyCarryFrame

local autoBuyCarryToggle = Instance.new("TextButton")
autoBuyCarryToggle.Size = UDim2.new(0, 50, 0, 28)
autoBuyCarryToggle.Position = UDim2.new(1, -60, 0.5, -14)
autoBuyCarryToggle.BackgroundColor3 = C.OFF
autoBuyCarryToggle.BorderSizePixel = 0
autoBuyCarryToggle.Text = "OFF"
autoBuyCarryToggle.TextColor3 = C.TEXT
autoBuyCarryToggle.TextSize = 13
autoBuyCarryToggle.Font = Enum.Font.GothamBold
autoBuyCarryToggle.Parent = autoBuyCarryFrame
addStroke(autoBuyCarryToggle, Color3.fromRGB(200, 40, 70), 1)

local autoBuyCarryToggleCorner = Instance.new("UICorner")
autoBuyCarryToggleCorner.CornerRadius = UDim.new(0, 6)
autoBuyCarryToggleCorner.Parent = autoBuyCarryToggle

local autoBuyCarryEnabled = false
local autoBuyCarryConnection = nil
autoBuyCarryToggle.MouseButton1Click:Connect(function()
    autoBuyCarryEnabled = not autoBuyCarryEnabled
    if autoBuyCarryEnabled then
        autoBuyCarryToggle.BackgroundColor3 = C.ON
        autoBuyCarryToggle.Text = "ON"
        addStroke(autoBuyCarryToggle, Color3.fromRGB(30, 210, 90), 1)
        autoBuyCarryConnection = task.spawn(function()
            while autoBuyCarryEnabled do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PurchaseCarry"):FireServer()
                end)
                local cd = tonumber(carryCooldownBox.Text) or 1
                task.wait(math.max(0.1, cd))
            end
        end)
    else
        autoBuyCarryToggle.BackgroundColor3 = C.OFF
        autoBuyCarryToggle.Text = "OFF"
        addStroke(autoBuyCarryToggle, Color3.fromRGB(200, 40, 70), 1)
        if autoBuyCarryConnection then task.cancel(autoBuyCarryConnection) autoBuyCarryConnection = nil end
    end
end)

local autoEquipEnabled = false
local autoEquipConnection = nil

local function toggleAutoEquip()
    autoEquipEnabled = not autoEquipEnabled
    
    if autoEquipEnabled then
        autoEquipButton.BackgroundColor3 = C.ON
        autoEquipButton.Text = "ON"
        addStroke(autoEquipButton, Color3.fromRGB(30, 210, 90), 1)
        
        autoEquipConnection = task.spawn(function()
            while autoEquipEnabled do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EquipBestItems"):FireServer()
                end)
                local cd = tonumber(autoEquipCDBox.Text) or autoEquipInterval
                task.wait(math.max(0.1, cd))
            end
        end)
    else
        autoEquipButton.BackgroundColor3 = C.OFF
        autoEquipButton.Text = "OFF"
        addStroke(autoEquipButton, Color3.fromRGB(200, 40, 70), 1)
        
        if autoEquipConnection then
            task.cancel(autoEquipConnection)
            autoEquipConnection = nil
        end
    end
end

autoEquipButton.MouseButton1Click:Connect(toggleAutoEquip)

-- ── AUTO CLAIM BRAINROT ──
local autoBrainrotToggle = Instance.new("Frame")
autoBrainrotToggle.Name = "AutoBrainrotToggle"
autoBrainrotToggle.Size = UDim2.new(1, 0, 0, 48)
autoBrainrotToggle.BackgroundColor3 = C.PANEL
autoBrainrotToggle.BorderSizePixel = 0
autoBrainrotToggle.Parent = autoContent
addStroke(autoBrainrotToggle, C.BORDER, 1)
local autoBrainrotCorner = Instance.new("UICorner")
autoBrainrotCorner.CornerRadius = UDim.new(0, 9)
autoBrainrotCorner.Parent = autoBrainrotToggle

local autoBrainrotLabel = Instance.new("TextLabel")
autoBrainrotLabel.Size = UDim2.new(0, 250, 1, 0)
autoBrainrotLabel.Position = UDim2.new(0, 15, 0, 0)
autoBrainrotLabel.BackgroundTransparency = 1
autoBrainrotLabel.Text = "🧠  Auto Claim Brainrot (OP)"
autoBrainrotLabel.TextColor3 = C.TEXT
autoBrainrotLabel.TextSize = 14
autoBrainrotLabel.Font = Enum.Font.Gotham
autoBrainrotLabel.TextXAlignment = Enum.TextXAlignment.Left
autoBrainrotLabel.Parent = autoBrainrotToggle

local autoBrainrotButton = Instance.new("TextButton")
autoBrainrotButton.Size = UDim2.new(0, 72, 0, 30)
autoBrainrotButton.Position = UDim2.new(1, -84, 0.5, -15)
autoBrainrotButton.BackgroundColor3 = C.OFF
autoBrainrotButton.BorderSizePixel = 0
autoBrainrotButton.Text = "OFF"
autoBrainrotButton.TextColor3 = C.TEXT
autoBrainrotButton.TextSize = 13
autoBrainrotButton.Font = Enum.Font.GothamBold
autoBrainrotButton.Parent = autoBrainrotToggle
addStroke(autoBrainrotButton, Color3.fromRGB(200, 40, 70), 1)
local autoBrainrotBtnCorner = Instance.new("UICorner")
autoBrainrotBtnCorner.CornerRadius = UDim.new(0, 7)
autoBrainrotBtnCorner.Parent = autoBrainrotButton

local autoBrainrotEnabled = false
local autoBrainrotConnection = nil

local function getBaseCFrame()
    local basesFolder = workspace:FindFirstChild("Bases")
    if not basesFolder then return nil end
    local plot = basesFolder:FindFirstChild("Plot_" .. player.Name)
    if not plot then return nil end
    local baseUpgrade = plot:FindFirstChild("BaseUpgrade")
    if not baseUpgrade then return nil end
    local guiPart = baseUpgrade:FindFirstChild("GUIPart")
    return (guiPart or baseUpgrade).CFrame + Vector3.new(0, 5, 0)
end

autoBrainrotButton.MouseButton1Click:Connect(function()
    autoBrainrotEnabled = not autoBrainrotEnabled
    if autoBrainrotEnabled then
        autoBrainrotButton.BackgroundColor3 = C.ON
        autoBrainrotButton.Text = "ON"
        addStroke(autoBrainrotButton, Color3.fromRGB(30, 210, 90), 1)
        autoBrainrotConnection = game:GetService("ProximityPromptService").PromptTriggered:Connect(function(prompt, triggeringPlayer)
            if not autoBrainrotEnabled then return end
            if triggeringPlayer ~= player then return end
            local promptName = (prompt.Name or ""):lower()
            local promptAction = (prompt.ActionText or ""):lower()
            if promptName:find("collect") or promptAction:find("collect") then
                local char = player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local returnCF = hrp.CFrame
                -- Teleport to base to claim/deposit
                local baseCF = getBaseCFrame()
                if baseCF then
                    pcall(function() hrp.CFrame = baseCF end)
                    task.wait(0.4)
                end
                -- Return to original position
                if autoBrainrotEnabled then
                    pcall(function() hrp.CFrame = returnCF end)
                end
            end
        end)
    else
        autoBrainrotButton.BackgroundColor3 = C.OFF
        autoBrainrotButton.Text = "OFF"
        addStroke(autoBrainrotButton, Color3.fromRGB(200, 40, 70), 1)
        if autoBrainrotConnection then
            autoBrainrotConnection:Disconnect()
            autoBrainrotConnection = nil
        end
    end
end)

-- Teleport Tab Content
local function createTeleportButton(parent, labelText, order, callback)
    local btn = Instance.new("TextButton")
    btn.Name = labelText
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = C.PANEL
    btn.BorderSizePixel = 0
    btn.Text = "⟶  " .. labelText
    btn.TextColor3 = C.ACCENT2
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    btn.Parent = parent
    addStroke(btn, C.BORDER, 1)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = btn
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 14)
    pad.Parent = btn
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    return btn
end

-- Teleport to Base (FIXED)
createTeleportButton(teleportContent, "Teleport to Base", 1, function()
    local username = game:GetService("Players").LocalPlayer.Name
    local basesFolder = workspace:WaitForChild("Bases")
    local plot = basesFolder:FindFirstChild("Plot_" .. username)
    if plot then
        local baseUpgrade = plot:FindFirstChild("BaseUpgrade")
        if baseUpgrade then
            local guiPart = baseUpgrade:FindFirstChild("GUIPart")
            if guiPart then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = guiPart.CFrame + Vector3.new(0, 5, 0)
            else
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = baseUpgrade.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end)

-- Rarity teleports
local rarityTeleports = {
    {"Teleport to Common",    CFrame.new(-189.340134, 36.2953339, -385.012085, 0.915230691, -4.27641638e-08, 0.40293026, 8.21741182e-08, 1, -8.05204081e-08, -0.40293026, 1.06805189e-07, 0.915230691)},
    {"Teleport to Uncommon",  CFrame.new(-182.575256, 474.052521, -1816.83667, -0.601815522, -0.136750996, 0.786840022, 8.63422578e-09, 0.985230923, 0.171230897, -0.798635125, 0.10304942, -0.592927277)},
    {"Teleport to Rare",      CFrame.new(-196.837311, 1252.53015, -3383.46851, -0.737276971, 0.0442068987, -0.674142718, -1.62005065e-09, 0.997856855, 0.0654344484, 0.675590575, 0.0482433178, -0.735696912)},
    {"Teleport to Epic",      CFrame.new(-190.129791, 2432.65845, -5361.70898, -0.906307638, -0.0304880422, -0.421517462, -9.03735975e-10, 0.997394443, -0.0721407905, 0.422618598, -0.0653817505, -0.903946221)},
    {"Teleport to Legendary", CFrame.new(-194.983688, 5261.96045, -8396.07129, -0.999961913, -0.00106632011, 0.00866066758, -5.19492713e-11, 0.99250555, 0.122199431, -0.00872606412, 0.122194782, -0.992467761)},
    {"Teleport to Mythic",    CFrame.new(-199.532333, 6612.60693, -12265.5, -0.992546082, -8.51348059e-09, -0.121869788, -6.46170983e-09, 1, -1.72309775e-08, 0.121869788, -1.63150524e-08, -0.992546082)},
    {"Teleport to Secret",    CFrame.new(-187.167053, 8395.00781, -14823.4443, -0.874619782, -4.98978245e-08, -0.484809518, -4.91366912e-08, 1, -1.42775702e-08, 0.484809518, 1.13344898e-08, -0.874619782)},
    {"Teleport to Celestial", CFrame.new(-193.599716, 11640.0879, -19479.8887, -0.118348785, 1.25731949e-08, -0.992972076, -3.90091195e-08, 1, 1.73115406e-08, 0.992972076, 4.07837639e-08, -0.118348785)},
    {"Teleport to Evolution", CFrame.new(-147.33847, 12890.6504, -40555.3516, 0.737199247, 2.50245797e-08, -0.675675392, -5.41760095e-08, 1, -2.20726317e-08, 0.675675392, 5.28773256e-08, 0.737199247)},
    {"Teleport to Transform", CFrame.new(-131.675461, 3.99783802, -85.3779678, -0.820784807, -2.42494753e-08, 0.571237504, -2.02536725e-08, 1, 1.3349208e-08, -0.571237504, -6.1283062e-10, -0.820784807)},
    {"Teleport to Wings",     CFrame.new(-151.42688, 3.9978385, -85.7723083, 0.755157232, 6.57732002e-08, 0.655543685, -7.30665448e-08, 1, -1.61643996e-08, -0.655543685, -3.56916487e-08, 0.755157232)},
    {"Teleport to Upgrades",  CFrame.new(-110.943245, 3.99783802, -84.8676376, -0.106691368, -6.12849078e-08, -0.9942922, -1.34341915e-08, 1, -6.01951768e-08, 0.9942922, 6.93520574e-09, -0.106691368)},
}

for i, data in ipairs(rarityTeleports) do
    local label, cf = data[1], data[2]
    createTeleportButton(teleportContent, label, i + 1, function()
        local char = game:GetService("Players").LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = cf
        end
    end)
end

-- Misc Tab Content
local miscLabel = Instance.new("TextLabel")
miscLabel.Name = "MiscLabel"
miscLabel.Size = UDim2.new(1, 0, 0, 38)
miscLabel.BackgroundColor3 = C.PANEL
miscLabel.BorderSizePixel = 0
miscLabel.Text = "⚙  Miscellaneous"
miscLabel.TextColor3 = C.TEXT
miscLabel.TextSize = 15
miscLabel.Font = Enum.Font.GothamBold
miscLabel.Parent = miscContent
addGradient(miscLabel, C.PANEL, Color3.fromRGB(35, 20, 60), 90)
addStroke(miscLabel, C.BORDER, 1)

local miscCorner = Instance.new("UICorner")
miscCorner.CornerRadius = UDim.new(0, 9)
miscCorner.Parent = miscLabel

-- Helper: action button for misc
local function createMiscButton(parent, labelText, color, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.BackgroundColor3 = color or C.PANEL
    btn.BorderSizePixel = 0
    btn.Text = labelText
    btn.TextColor3 = C.TEXT
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = order
    btn.Parent = parent
    addStroke(btn, C.BORDER, 1)
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 9) c.Parent = btn
    btn.MouseButton1Click:Connect(function() pcall(callback) end)
    return btn
end

-- Helper: misc toggle row
local function createMiscToggle(parent, labelText, order, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = C.PANEL
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = parent
    addStroke(row, C.BORDER, 1)
    local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 9) rc.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 240, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = C.TEXT
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 68, 0, 28)
    btn.Position = UDim2.new(1, -80, 0.5, -14)
    btn.BackgroundColor3 = C.OFF
    btn.BorderSizePixel = 0
    btn.Text = "OFF"
    btn.TextColor3 = C.TEXT
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = row
    addStroke(btn, Color3.fromRGB(200, 40, 70), 1)
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 7) bc.Parent = btn
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.BackgroundColor3 = C.ON
            btn.Text = "ON"
            addStroke(btn, Color3.fromRGB(30, 210, 90), 1)
        else
            btn.BackgroundColor3 = C.OFF
            btn.Text = "OFF"
            addStroke(btn, Color3.fromRGB(200, 40, 70), 1)
        end
        pcall(callback, enabled)
    end)
    return row, btn
end

-- ── REMOVE VIP WALLS ──
createMiscButton(miscContent, "🚫  Remove VIP Walls  (won't claim vip brainrots)", Color3.fromRGB(25, 15, 50), 2, function()
    local vipParts = workspace:FindFirstChild("VIP_Parts")
    if vipParts then
        for _, v in ipairs(vipParts:GetChildren()) do
            pcall(function() v:Destroy() end)
        end
    end
end)

-- ── AUTO REVIVE ──
local lastDeathCF = nil
local autoReviveEnabled = false

local function setupDeathTracker(char)
    local humanoid = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    humanoid.Died:Connect(function()
        -- Capture exact position at moment of death
        lastDeathCF = hrp.CFrame
    end)
end

-- Setup on current character
if player.Character then
    setupDeathTracker(player.Character)
end

player.CharacterAdded:Connect(function(char)
    task.spawn(function()
        -- Setup death tracker for new character
        setupDeathTracker(char)
        -- If auto revive is on and we have a death position, teleport there
        if autoReviveEnabled and lastDeathCF then
            local targetCF = lastDeathCF -- capture before any race condition
            local hrp = char:WaitForChild("HumanoidRootPart", 10)
            local humanoid = char:WaitForChild("Humanoid", 10)
            if not hrp or not humanoid then return end
            -- Wait until fully alive and loaded
            local timeout = 0
            repeat
                task.wait(0.1)
                timeout = timeout + 0.1
            until (humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead) or timeout >= 10
            task.wait(0.2) -- buffer for server/physics to settle
            -- Retry teleport several times to ensure it sticks
            for _ = 1, 10 do
                if not autoReviveEnabled then break end
                pcall(function() hrp.CFrame = targetCF end)
                task.wait(0.05)
            end
        end
    end)
end)

local _, autoReviveBtn = createMiscToggle(miscContent, "💀  Auto Revive in Place", 3, function(state)
    autoReviveEnabled = state
end)

-- ── FLY SPEED CONTROLLER ──
local flySpeedFrame = Instance.new("Frame")
flySpeedFrame.Name = "FlySpeedFrame"
flySpeedFrame.Size = UDim2.new(1, 0, 0, 48)
flySpeedFrame.BackgroundColor3 = C.PANEL
flySpeedFrame.BorderSizePixel = 0
flySpeedFrame.LayoutOrder = 6
flySpeedFrame.Parent = miscContent
addStroke(flySpeedFrame, C.BORDER, 1)
local flySpeedCorner = Instance.new("UICorner")
flySpeedCorner.CornerRadius = UDim.new(0, 9)
flySpeedCorner.Parent = flySpeedFrame

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0, 130, 1, 0)
flySpeedLabel.Position = UDim2.new(0, 14, 0, 0)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "✈  Fly Speed"
flySpeedLabel.TextColor3 = C.TEXT
flySpeedLabel.TextSize = 13
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = flySpeedFrame

local flySpeedInputLabel = Instance.new("TextLabel")
flySpeedInputLabel.Size = UDim2.new(0, 30, 0, 14)
flySpeedInputLabel.Position = UDim2.new(0, 138, 0.5, -20)
flySpeedInputLabel.BackgroundTransparency = 1
flySpeedInputLabel.Text = "Speed"
flySpeedInputLabel.TextColor3 = C.TEXTDIM
flySpeedInputLabel.TextSize = 10
flySpeedInputLabel.Font = Enum.Font.Gotham
flySpeedInputLabel.Parent = flySpeedFrame

local flySpeedInput = Instance.new("TextBox")
flySpeedInput.Size = UDim2.new(0, 58, 0, 30)
flySpeedInput.Position = UDim2.new(0, 136, 0.5, -15)
flySpeedInput.BackgroundColor3 = C.BG3
flySpeedInput.BorderSizePixel = 0
flySpeedInput.Text = "10"
flySpeedInput.TextColor3 = C.ACCENT2
flySpeedInput.TextSize = 13
flySpeedInput.Font = Enum.Font.GothamBold
flySpeedInput.ClearTextOnFocus = false
flySpeedInput.Parent = flySpeedFrame
addStroke(flySpeedInput, C.BORDER, 1)
local flySpeedInputCorner = Instance.new("UICorner")
flySpeedInputCorner.CornerRadius = UDim.new(0, 6)
flySpeedInputCorner.Parent = flySpeedInput

local flySpeedToggleBtn = Instance.new("TextButton")
flySpeedToggleBtn.Size = UDim2.new(0, 72, 0, 30)
flySpeedToggleBtn.Position = UDim2.new(1, -84, 0.5, -15)
flySpeedToggleBtn.BackgroundColor3 = C.OFF
flySpeedToggleBtn.BorderSizePixel = 0
flySpeedToggleBtn.Text = "OFF"
flySpeedToggleBtn.TextColor3 = C.TEXT
flySpeedToggleBtn.TextSize = 13
flySpeedToggleBtn.Font = Enum.Font.GothamBold
flySpeedToggleBtn.Parent = flySpeedFrame
addStroke(flySpeedToggleBtn, Color3.fromRGB(200, 40, 70), 1)
local flySpeedToggleBtnCorner = Instance.new("UICorner")
flySpeedToggleBtnCorner.CornerRadius = UDim.new(0, 7)
flySpeedToggleBtnCorner.Parent = flySpeedToggleBtn

local flySpeedEnabled = false
local flySpeedThread = nil
flySpeedToggleBtn.MouseButton1Click:Connect(function()
    flySpeedEnabled = not flySpeedEnabled
    if flySpeedEnabled then
        flySpeedToggleBtn.BackgroundColor3 = C.ON
        flySpeedToggleBtn.Text = "ON"
        addStroke(flySpeedToggleBtn, Color3.fromRGB(30, 210, 90), 1)
        flySpeedThread = task.spawn(function()
            while flySpeedEnabled do
                pcall(function()
                    local speed = tonumber(flySpeedInput.Text) or 10
                    player:SetAttribute("Speed", speed)
                    player:SetAttribute("Stamina", 100)
                end)
                task.wait(0.5)
            end
        end)
    else
        flySpeedToggleBtn.BackgroundColor3 = C.OFF
        flySpeedToggleBtn.Text = "OFF"
        addStroke(flySpeedToggleBtn, Color3.fromRGB(200, 40, 70), 1)
        if flySpeedThread then task.cancel(flySpeedThread) flySpeedThread = nil end
    end
end)

-- ── INFINITE STAMINA ──
local infStaminaThread = nil
local _, infStaminaBtn = createMiscToggle(miscContent, "♾  Infinite Stamina (once real ends reclick fly)", 7, function(state)
    if state then
        -- Hook metatable so any script reading Stamina sees math.huge
        pcall(function()
            local mt = getrawmetatable(game)
            local oldIndex = mt.__index
            setreadonly(mt, false)
            mt.__index = newcclosure(function(t, k)
                if t == player and (k == "Stamina" or k == "MaxStamina") then
                    return math.huge
                end
                return oldIndex(t, k)
            end)
            setreadonly(mt, true)
        end)
        -- Heartbeat: force attributes and destroy Refill UI
        infStaminaThread = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                player:SetAttribute("Stamina", math.huge)
                player:SetAttribute("MaxStamina", math.huge)
                local frames = player.PlayerGui:FindFirstChild("Frames", true)
                if frames then
                    local refill = frames:FindFirstChild("Refill")
                    if refill then refill:Destroy() end
                end
            end)
        end)
    else
        if infStaminaThread then
            infStaminaThread:Disconnect()
            infStaminaThread = nil
        end
    end
end)

-- ── DISABLE NOTIFICATIONS ──
local notifEnabled = true
local _, notifBtn = createMiscToggle(miscContent, "🔕  Disable Game Notifications", 4, function(state)
    if state then
        -- Disable notifications
        pcall(function()
            local NotificationPath = game:GetService("ReplicatedStorage").Shared.SharedModule.NotificationManager
            local NotificationModule = require(NotificationPath)
            _G.NotificationsEnabled = false
            local oldShow = NotificationModule.show
            NotificationModule.show = function(...)
                if _G.NotificationsEnabled == false then return nil end
                return oldShow(...)
            end
        end)
    else
        -- Re-enable
        pcall(function()
            _G.NotificationsEnabled = true
        end)
    end
end)

-- ── REMOVE ALL AGENTS ──
createMiscButton(miscContent, "☠  Remove All Agents  (they will still kill u)", Color3.fromRGB(35, 10, 10), 5, function()
    local agents = workspace:FindFirstChild("Agents")
    if agents then
        for _, v in ipairs(agents:GetChildren()) do
            pcall(function() v:Destroy() end)
        end
    end
end)

-- UI Tab Content
local uiLabel = Instance.new("TextLabel")
uiLabel.Name = "UILabel"
uiLabel.Size = UDim2.new(1, 0, 0, 38)
uiLabel.BackgroundColor3 = C.PANEL
uiLabel.BorderSizePixel = 0
uiLabel.Text = "✦  UI Settings"
uiLabel.TextColor3 = C.TEXT
uiLabel.TextSize = 15
uiLabel.Font = Enum.Font.GothamBold
uiLabel.Parent = uiContent
addGradient(uiLabel, C.PANEL, Color3.fromRGB(35, 20, 60), 90)
addStroke(uiLabel, C.BORDER, 1)

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 9)
uiCorner.Parent = uiLabel

-- GUI Opacity Slider
local opacityFrame = Instance.new("Frame")
opacityFrame.Size = UDim2.new(1, 0, 0, 44)
opacityFrame.BackgroundColor3 = C.PANEL
opacityFrame.BorderSizePixel = 0
opacityFrame.LayoutOrder = 2
opacityFrame.Parent = uiContent
addStroke(opacityFrame, C.BORDER, 1)
local oc = Instance.new("UICorner") oc.CornerRadius = UDim.new(0, 9) oc.Parent = opacityFrame
local opLabel = Instance.new("TextLabel")
opLabel.Size = UDim2.new(0, 160, 1, 0)
opLabel.Position = UDim2.new(0, 14, 0, 0)
opLabel.BackgroundTransparency = 1
opLabel.Text = "GUI Opacity: 100%"
opLabel.TextColor3 = C.ACCENT2
opLabel.TextSize = 13
opLabel.Font = Enum.Font.Gotham
opLabel.TextXAlignment = Enum.TextXAlignment.Left
opLabel.Parent = opacityFrame

local opSliderBar = Instance.new("Frame")
opSliderBar.Size = UDim2.new(0, 160, 0, 6)
opSliderBar.Position = UDim2.new(1, -175, 0.5, -3)
opSliderBar.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
opSliderBar.BorderSizePixel = 0
opSliderBar.Parent = opacityFrame
addStroke(opSliderBar, C.BORDER, 1)
local opSliderBarCorner = Instance.new("UICorner") opSliderBarCorner.CornerRadius = UDim.new(0, 3) opSliderBarCorner.Parent = opSliderBar
local opFill = Instance.new("Frame")
opFill.Size = UDim2.new(1, 0, 1, 0)
opFill.BackgroundColor3 = C.ACCENT
opFill.BorderSizePixel = 0
opFill.Parent = opSliderBar
addGradient(opFill, C.ACCENT, C.ACCENT2, 0)
local opFillCorner = Instance.new("UICorner") opFillCorner.CornerRadius = UDim.new(0, 3) opFillCorner.Parent = opFill
local opKnob = Instance.new("TextButton")
opKnob.Size = UDim2.new(0, 16, 0, 16)
opKnob.Position = UDim2.new(1, -8, 0.5, -8)
opKnob.BackgroundColor3 = C.ACCENT2
opKnob.BorderSizePixel = 0
opKnob.Text = ""
opKnob.ZIndex = 5
opKnob.Parent = opSliderBar
local opKnobCorner = Instance.new("UICorner") opKnobCorner.CornerRadius = UDim.new(0.5, 0) opKnobCorner.Parent = opKnob

local opDragging = false
opKnob.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then opDragging = true end
end)
opKnob.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then opDragging = false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if opDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local barAbsPos = opSliderBar.AbsolutePosition.X
        local barAbsSize = opSliderBar.AbsoluteSize.X
        local relX = math.clamp(inp.Position.X - barAbsPos, 0, barAbsSize)
        local pct = relX / barAbsSize
        opFill.Size = UDim2.new(pct, 0, 1, 0)
        opKnob.Position = UDim2.new(pct, -8, 0.5, -8)
        local opacityPct = math.round(pct * 100)
        opLabel.Text = "GUI Opacity: " .. opacityPct .. "%"
        local transparency = 1 - pct
        mainFrame.BackgroundTransparency = transparency * 0.6
        tabContainer.BackgroundTransparency = transparency * 0.5
        contentContainer.BackgroundTransparency = transparency * 0.5
    end
end)

-- Accent Color Presets
local colorFrame = Instance.new("Frame")
colorFrame.Size = UDim2.new(1, 0, 0, 48)
colorFrame.BackgroundColor3 = C.PANEL
colorFrame.BorderSizePixel = 0
colorFrame.LayoutOrder = 3
colorFrame.Parent = uiContent
addStroke(colorFrame, C.BORDER, 1)
local colorFC = Instance.new("UICorner") colorFC.CornerRadius = UDim.new(0, 9) colorFC.Parent = colorFrame
local colorLbl = Instance.new("TextLabel")
colorLbl.Size = UDim2.new(0, 100, 1, 0)
colorLbl.Position = UDim2.new(0, 14, 0, 0)
colorLbl.BackgroundTransparency = 1
colorLbl.Text = "Accent Color"
colorLbl.TextColor3 = C.TEXT
colorLbl.TextSize = 13
colorLbl.Font = Enum.Font.Gotham
colorLbl.TextXAlignment = Enum.TextXAlignment.Left
colorLbl.Parent = colorFrame

local colorPresets = {
    {Color3.fromRGB(110,50,230), "Purple"},
    {Color3.fromRGB(0,180,230), "Cyan"},
    {Color3.fromRGB(230,60,80), "Red"},
    {Color3.fromRGB(30,200,100), "Green"},
    {Color3.fromRGB(255,150,0), "Gold"},
}

for i, preset in ipairs(colorPresets) do
    local dot = Instance.new("TextButton")
    dot.Size = UDim2.new(0, 24, 0, 24)
    dot.Position = UDim2.new(0, 95 + (i-1)*34, 0.5, -12)
    dot.BackgroundColor3 = preset[1]
    dot.BorderSizePixel = 0
    dot.Text = ""
    dot.Parent = colorFrame
    addStroke(dot, Color3.fromRGB(255,255,255), 1)
    local dc = Instance.new("UICorner") dc.CornerRadius = UDim.new(0.5, 0) dc.Parent = dot
    dot.MouseButton1Click:Connect(function()
        C.ACCENT = preset[1]
        C.ACCENT2 = preset[1]
        -- Update visible glow bars and active tab
        mainGlowBar.BackgroundColor3 = preset[1]
        keyGlowBar.BackgroundColor3 = preset[1]
        titleDot.BackgroundColor3 = preset[1]
        for _, tab in pairs(tabs) do
            tab.bar.BackgroundColor3 = preset[1]
        end
    end)
end

-- GUI Scale
local scaleFrame = Instance.new("Frame")
scaleFrame.Size = UDim2.new(1, 0, 0, 44)
scaleFrame.BackgroundColor3 = C.PANEL
scaleFrame.BorderSizePixel = 0
scaleFrame.LayoutOrder = 4
scaleFrame.Parent = uiContent
addStroke(scaleFrame, C.BORDER, 1)
local scaleFc = Instance.new("UICorner") scaleFc.CornerRadius = UDim.new(0, 9) scaleFc.Parent = scaleFrame
local scaleLbl = Instance.new("TextLabel")
scaleLbl.Size = UDim2.new(0, 130, 1, 0)
scaleLbl.Position = UDim2.new(0, 14, 0, 0)
scaleLbl.BackgroundTransparency = 1
scaleLbl.Text = "GUI Scale: 100%"
scaleLbl.TextColor3 = C.ACCENT2
scaleLbl.TextSize = 13
scaleLbl.Font = Enum.Font.Gotham
scaleLbl.TextXAlignment = Enum.TextXAlignment.Left
scaleLbl.Parent = scaleFrame

local scaleSteps = {75, 85, 100, 115, 130}
local scaleLabels = {"75%","85%","100%","115%","130%"}
-- Desktop sizes
local scaleDesktopSizes = {
    UDim2.new(0, 480, 0, 323),
    UDim2.new(0, 544, 0, 365),
    UDim2.new(0, 640, 0, 430),
    UDim2.new(0, 736, 0, 495),
    UDim2.new(0, 832, 0, 559),
}
-- Mobile sizes (using scale for responsiveness)
local scaleMobileSizes = {
    UDim2.new(0.85, 0, 0.7, 0),
    UDim2.new(0.90, 0, 0.75, 0),
    UDim2.new(0.95, 0, 0.8, 0),
    UDim2.new(1.0, -10, 0.85, 0),
    UDim2.new(1.0, -5, 0.9, 0),
}
local scaleSizes = deviceType == "mobile" and scaleMobileSizes or scaleDesktopSizes
local scaleButtons = {}
for i, s in ipairs(scaleLabels) do
    local sb = Instance.new("TextButton")
    sb.Size = UDim2.new(0, 40, 0, 26)
    sb.Position = UDim2.new(0, 130 + (i-1)*48, 0.5, -13)
    sb.BackgroundColor3 = i == 3 and C.ACCENT or C.BG3
    sb.BorderSizePixel = 0
    sb.Text = s
    sb.TextColor3 = C.TEXT
    sb.TextSize = 11
    sb.Font = Enum.Font.GothamBold
    sb.Parent = scaleFrame
    addStroke(sb, C.BORDER, 1)
    local sbc = Instance.new("UICorner") sbc.CornerRadius = UDim.new(0, 6) sbc.Parent = sb
    scaleButtons[i] = sb
    sb.MouseButton1Click:Connect(function()
        for j, b in ipairs(scaleButtons) do
            b.BackgroundColor3 = j == i and C.ACCENT or C.BG3
        end
        scaleLbl.Text = "GUI Scale: " .. s
        if not guiMinimized then
            mainFrame.Size = scaleSizes[i]
            originalSize = scaleSizes[i]
        end
    end)
end

-- Watermark toggle
local wmFrame = Instance.new("Frame")
wmFrame.Size = UDim2.new(1, 0, 0, 44)
wmFrame.BackgroundColor3 = C.PANEL
wmFrame.BorderSizePixel = 0
wmFrame.LayoutOrder = 5
wmFrame.Parent = uiContent
addStroke(wmFrame, C.BORDER, 1)
local wmFc = Instance.new("UICorner") wmFc.CornerRadius = UDim.new(0, 9) wmFc.Parent = wmFrame
local wmLbl = Instance.new("TextLabel")
wmLbl.Size = UDim2.new(0, 240, 1, 0)
wmLbl.Position = UDim2.new(0, 14, 0, 0)
wmLbl.BackgroundTransparency = 1
wmLbl.Text = "✦  Show Watermark"
wmLbl.TextColor3 = C.TEXT
wmLbl.TextSize = 13
wmLbl.Font = Enum.Font.Gotham
wmLbl.TextXAlignment = Enum.TextXAlignment.Left
wmLbl.Parent = wmFrame
local wmBtn = Instance.new("TextButton")
wmBtn.Size = UDim2.new(0, 68, 0, 28)
wmBtn.Position = UDim2.new(1, -80, 0.5, -14)
wmBtn.BackgroundColor3 = C.ON
wmBtn.BorderSizePixel = 0
wmBtn.Text = "ON"
wmBtn.TextColor3 = C.TEXT
wmBtn.TextSize = 12
wmBtn.Font = Enum.Font.GothamBold
wmBtn.Parent = wmFrame
addStroke(wmBtn, Color3.fromRGB(30, 210, 90), 1)
local wmbc = Instance.new("UICorner") wmbc.CornerRadius = UDim.new(0, 7) wmbc.Parent = wmBtn

-- Watermark label
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 200, 0, 24)
watermark.Position = UDim2.new(0, 10, 0, 10)
watermark.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
watermark.BackgroundTransparency = 0.3
watermark.BorderSizePixel = 0
watermark.Text = "✦ FlyOnion Hub  |  by cat"
watermark.TextColor3 = C.ACCENT2
watermark.TextSize = 12
watermark.Font = Enum.Font.GothamBold
watermark.Visible = true
watermark.ZIndex = 2
watermark.Parent = screenGui
addStroke(watermark, C.BORDER, 1)
local wmLabelCorner = Instance.new("UICorner") wmLabelCorner.CornerRadius = UDim.new(0, 7) wmLabelCorner.Parent = watermark

local wmEnabled = true
wmBtn.MouseButton1Click:Connect(function()
    wmEnabled = not wmEnabled
    watermark.Visible = wmEnabled
    if wmEnabled then
        wmBtn.BackgroundColor3 = C.ON
        wmBtn.Text = "ON"
        addStroke(wmBtn, Color3.fromRGB(30, 210, 90), 1)
    else
        wmBtn.BackgroundColor3 = C.OFF
        wmBtn.Text = "OFF"
        addStroke(wmBtn, Color3.fromRGB(200, 40, 70), 1)
    end
end)

-- Destroy GUI button (full removal)
local destroyGuiBtn = Instance.new("TextButton")
destroyGuiBtn.Size = UDim2.new(1, 0, 0, 40)
destroyGuiBtn.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
destroyGuiBtn.BorderSizePixel = 0
destroyGuiBtn.Text = "🗑  Destroy GUI (permanent)"
destroyGuiBtn.TextColor3 = C.TEXT
destroyGuiBtn.TextSize = 13
destroyGuiBtn.Font = Enum.Font.GothamBold
destroyGuiBtn.LayoutOrder = 10
destroyGuiBtn.Parent = uiContent
addStroke(destroyGuiBtn, Color3.fromRGB(200, 40, 40), 1.5)
local destroyGuiBtnCorner = Instance.new("UICorner")
destroyGuiBtnCorner.CornerRadius = UDim.new(0, 9)
destroyGuiBtnCorner.Parent = destroyGuiBtn
destroyGuiBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Key System Logic
local function validateKey()
    local enteredKey = keyInput.Text
    
    if enteredKey == CORRECT_KEY then
        statusLabel.TextColor3 = C.ON
        statusLabel.Text = "✓ Key Accepted! Loading..."
        
        saveKey()
        
        customWait(1)
        keyFrame.Visible = false
        mainFrame.Visible = true
        
        -- Open Info tab by default
        tabs["Info"].button.MouseButton1Click:Fire()
    else
        statusLabel.TextColor3 = C.OFF
        statusLabel.Text = "✗ Invalid Key!"
        customWait(2)
        statusLabel.Text = ""
    end
end

submitButton.MouseButton1Click:Connect(validateKey)

keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        validateKey()
    end
end)

-- ON-H floating button (shown when GUI is hidden, click to restore)
local onhButton = Instance.new("TextButton")
onhButton.Name = "ONHButton"
onhButton.Size = UDim2.new(0, 56, 0, 56)
onhButton.Position = UDim2.new(0, 20, 0.5, -28)
onhButton.BackgroundColor3 = Color3.fromRGB(90, 30, 160)
onhButton.BorderSizePixel = 0
onhButton.Text = "ON-H"
onhButton.TextColor3 = C.TEXT
onhButton.TextSize = 11
onhButton.Font = Enum.Font.GothamBold
onhButton.Visible = false
onhButton.ZIndex = 30
onhButton.Parent = screenGui
addStroke(onhButton, C.ACCENT2, 1.5)
local onhCorner = Instance.new("UICorner")
onhCorner.CornerRadius = UDim.new(0, 14)
onhCorner.Parent = onhButton

onhButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    onhButton.Visible = false
end)

-- Close Button Logic (hides GUI, shows ON-H button)
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    onhButton.Visible = true
end)

-- Dragging Logic for Main Frame (optimized for Delta)
local dragging = false
local dragStart, startPos

local function updateDrag(inputPos)
    if not dragging then return end
    local delta = inputPos - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                connection:Disconnect()
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or 
       input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input.Position)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                     input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input.Position)
    end
end)

-- Check if key is already saved
if isKeySaved() then
    keyFrame.Visible = false
    mainFrame.Visible = true
    tabs["Info"].button.MouseButton1Click:Fire()
end

print("Roblox GUI Loaded Successfully!")
