-- Roblox GUI with Key System
-- Key: cat
-- Delta Executor Compatible Version - FIXED REGISTER OVERFLOW
-- Fixes: Register overflow, UpValue limits, customWait crash, proper scoping

print("===========================================")
print("FlyOnion Hub - Starting...")
print("Delta Executor Optimized - v1.2 (Register Fixed)")
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
    playerGui = player:WaitForChild("PlayerGui", 10)
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
    if not success then
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
    if writefile then
        writefile(KEY_STORAGE_NAME .. ".txt", CORRECT_KEY)
    end
end

-- Create ScreenGui
print("Creating ScreenGui...")
customWait(0.1)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyOnionHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
print("Parenting ScreenGui to PlayerGui...")
screenGui.Parent = playerGui
customWait(0.1)
print("ScreenGui Created and Parented")

-- Color Palette (shared reference)
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

-- Helper functions (minimal scope)
local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or C.BORDER
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
end

local function addGradient(parent, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0 or C.BG2, c1 or C.BG3)
    g.Rotation = rot or 90
    g.Parent = parent
end

-- SCOPE 1: KEY SYSTEM UI
do
    local keyFrame = Instance.new("Frame")
    keyFrame.Name = "KeyFrame"
    keyFrame.Active = true
    local keyFrameSize = getResponsiveSize(
        UDim2.new(0, 420, 0, 270),
        UDim2.new(0.9, 0, 0, 280)
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

    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
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
    addStroke(submitButton, C.ACCENT2, 1.5)

    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 10)
    submitCorner.Parent = submitButton

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0, 24)
    statusLabel.Position = UDim2.new(0, 0, 0, 208)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = C.TEXTDIM
    statusLabel.TextSize = 13
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Parent = keyFrame

    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Name = "GetKeyButton"
    getKeyButton.Size = UDim2.new(0, 180, 0, 26)
    getKeyButton.Position = UDim2.new(0.5, 0, 1, -38)
    getKeyButton.AnchorPoint = Vector2.new(0.5, 0)
    getKeyButton.BackgroundColor3 = C.BG3
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Text = "🔗  Get Key (Discord)"
    getKeyButton.TextColor3 = C.ACCENT2
    getKeyButton.TextSize = 12
    getKeyButton.Font = Enum.Font.Gotham
    getKeyButton.Parent = keyFrame
    addStroke(getKeyButton, C.BORDER, 1)

    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 8)
    getKeyCorner.Parent = getKeyButton

    -- Store references for validation function
    _G.KeySystemRefs = {
        keyFrame = keyFrame,
        keyInput = keyInput,
        statusLabel = statusLabel,
        submitButton = submitButton
    }

    -- Button hover effects (isolated)
    local function setupButtonHover(btn, normalColor, hoverColor)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
        end)
    end

    setupButtonHover(submitButton, C.ACCENT, C.ACCENT2)
    setupButtonHover(getKeyButton, C.BG3, C.PANEL)

    getKeyButton.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/yourserver")
        statusLabel.TextColor3 = C.ON
        statusLabel.Text = "✓ Discord link copied to clipboard!"
        customWait(3)
        statusLabel.Text = ""
    end)
end

-- SCOPE 2: MAIN GUI FRAME
local mainFrame, titleBar, closeButton, minimizeButton, tabs, tabButtons, tabContent
do
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Active = true
    mainFrame.Size = getResponsiveSize(
        UDim2.new(0, 640, 0, 430),
        UDim2.new(0.9, 0, 0.75, 0)
    )
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = C.BG
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    addGradient(mainFrame, C.BG, Color3.fromRGB(12, 10, 22), 135)

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    addStroke(mainFrame, C.BORDER, 1.5)

    local glowBar = Instance.new("Frame")
    glowBar.Size = UDim2.new(1, 0, 0, 3)
    glowBar.Position = UDim2.new(0, 0, 0, 0)
    glowBar.BackgroundColor3 = C.ACCENT2
    glowBar.BorderSizePixel = 0
    glowBar.ZIndex = 5
    glowBar.Parent = mainFrame
    local glowBarCorner = Instance.new("UICorner")
    glowBarCorner.CornerRadius = UDim.new(0, 12)
    glowBarCorner.Parent = glowBar
    addGradient(glowBar, C.ACCENT, C.ACCENT2, 0)

    titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = C.BG2
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    addGradient(titleBar, C.BG2, Color3.fromRGB(18, 14, 32), 90)

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 240, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "✦  FlyOnion Hub"
    titleLabel.TextColor3 = C.TEXT
    titleLabel.TextSize = deviceType == "mobile" and 15 or 17
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 32, 0, 32)
    closeButton.Position = UDim2.new(1, -38, 0, 7)
    closeButton.BackgroundColor3 = Color3.fromRGB(180, 30, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = C.TEXT
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    addStroke(closeButton, Color3.fromRGB(200, 40, 60), 1)

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 32, 0, 32)
    minimizeButton.Position = UDim2.new(1, -74, 0, 7)
    minimizeButton.BackgroundColor3 = C.PANEL
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = C.TEXT
    minimizeButton.TextSize = 18
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = titleBar
    addStroke(minimizeButton, C.BORDER, 1)

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = minimizeButton

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(0, 140, 1, -52)
    tabBar.Position = UDim2.new(0, 6, 0, 49)
    tabBar.BackgroundColor3 = C.BG2
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame
    addStroke(tabBar, C.BORDER, 1)

    local tabBarCorner = Instance.new("UICorner")
    tabBarCorner.CornerRadius = UDim.new(0, 10)
    tabBarCorner.Parent = tabBar

    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 3)
    tabList.FillDirection = Enum.FillDirection.Vertical
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabBar

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 6)
    tabPadding.PaddingBottom = UDim.new(0, 6)
    tabPadding.PaddingLeft = UDim.new(0, 6)
    tabPadding.PaddingRight = UDim.new(0, 6)
    tabPadding.Parent = tabBar

    tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, -158, 1, -58)
    tabContent.Position = UDim2.new(0, 152, 0, 52)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Parent = mainFrame

    tabs = {}
    tabButtons = {}
end

-- SCOPE 3: TAB CREATION FUNCTION (isolated)
local function createTab(name, icon, order)
    do
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = name .. "Tab"
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundColor3 = C.BG3
        tabFrame.BorderSizePixel = 0
        tabFrame.Visible = false
        tabFrame.ScrollBarThickness = 4
        tabFrame.ScrollBarImageColor3 = C.ACCENT
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabFrame.Parent = tabContent

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 10)
        tabCorner.Parent = tabFrame
        addStroke(tabFrame, C.BORDER, 1)

        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 8)
        contentList.FillDirection = Enum.FillDirection.Vertical
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Parent = tabFrame

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 10)
        contentPadding.PaddingBottom = UDim.new(0, 10)
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.Parent = tabFrame

        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 36)
        tabButton.BackgroundColor3 = C.BG3
        tabButton.BorderSizePixel = 0
        tabButton.Text = icon .. "  " .. name
        tabButton.TextColor3 = C.TEXTDIM
        tabButton.TextSize = 13
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.LayoutOrder = order
        tabButton.Parent = tabBar
        addStroke(tabButton, Color3.fromRGB(0, 0, 0, 0), 1)

        local tabButtonCorner = Instance.new("UICorner")
        tabButtonCorner.CornerRadius = UDim.new(0, 8)
        tabButtonCorner.Parent = tabButton

        local tabButtonPadding = Instance.new("UIPadding")
        tabButtonPadding.PaddingLeft = UDim.new(0, 12)
        tabButtonPadding.Parent = tabButton

        tabs[name] = {frame = tabFrame, button = tabButton, content = {}}
        table.insert(tabButtons, tabButton)

        -- Isolated click handler
        local function onTabClick()
            for _, tab in pairs(tabs) do
                tab.frame.Visible = false
                tab.button.BackgroundColor3 = C.BG3
                tab.button.TextColor3 = C.TEXTDIM
                addStroke(tab.button, Color3.fromRGB(0, 0, 0, 0), 1)
            end
            tabFrame.Visible = true
            tabButton.BackgroundColor3 = C.ACCENT
            tabButton.TextColor3 = C.TEXT
            addStroke(tabButton, C.ACCENT2, 1)
        end

        tabButton.MouseButton1Click:Connect(onTabClick)

        return tabFrame
    end
end

-- Create all tabs
local infoTab = createTab("Info", "ℹ", 1)
local playerTab = createTab("Player", "👤", 2)
local teleportTab = createTab("Teleport", "📍", 3)
local autoTab = createTab("Auto Farm", "⚡", 4)
local miscTab = createTab("Misc", "⚙", 5)
local espTab = createTab("ESP", "👁", 6)
local settingsTab = createTab("Settings", "🔧", 7)

-- SCOPE 4: INFO TAB CONTENT
do
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, 0, 0, 120)
    welcomeLabel.BackgroundColor3 = C.PANEL
    welcomeLabel.BorderSizePixel = 0
    welcomeLabel.Text = "Welcome to FlyOnion Hub!\n\nA powerful GUI for enhanced gameplay.\nUse the tabs to explore features."
    welcomeLabel.TextColor3 = C.TEXT
    welcomeLabel.TextSize = 13
    welcomeLabel.Font = Enum.Font.Gotham
    welcomeLabel.TextWrapped = true
    welcomeLabel.TextYAlignment = Enum.TextYAlignment.Top
    welcomeLabel.LayoutOrder = 1
    welcomeLabel.Parent = infoTab
    addStroke(welcomeLabel, C.BORDER, 1)

    local welcomeCorner = Instance.new("UICorner")
    welcomeCorner.CornerRadius = UDim.new(0, 9)
    welcomeCorner.Parent = welcomeLabel

    local welcomePadding = Instance.new("UIPadding")
    welcomePadding.PaddingTop = UDim.new(0, 14)
    welcomePadding.PaddingLeft = UDim.new(0, 14)
    welcomePadding.PaddingRight = UDim.new(0, 14)
    welcomePadding.Parent = welcomeLabel

    local creditLabel = Instance.new("TextLabel")
    creditLabel.Size = UDim2.new(1, 0, 0, 80)
    creditLabel.BackgroundColor3 = C.PANEL
    creditLabel.BorderSizePixel = 0
    creditLabel.Text = "Credits:\n• Created by: cat\n• Version: 1.2\n• Discord: discord.gg/yourserver"
    creditLabel.TextColor3 = C.TEXTDIM
    creditLabel.TextSize = 12
    creditLabel.Font = Enum.Font.Gotham
    creditLabel.TextWrapped = true
    creditLabel.TextYAlignment = Enum.TextYAlignment.Top
    creditLabel.LayoutOrder = 2
    creditLabel.Parent = infoTab
    addStroke(creditLabel, C.BORDER, 1)

    local creditCorner = Instance.new("UICorner")
    creditCorner.CornerRadius = UDim.new(0, 9)
    creditCorner.Parent = creditLabel

    local creditPadding = Instance.new("UIPadding")
    creditPadding.PaddingTop = UDim.new(0, 12)
    creditPadding.PaddingLeft = UDim.new(0, 14)
    creditPadding.PaddingRight = UDim.new(0, 14)
    creditPadding.Parent = creditLabel
end

-- SCOPE 5: PLAYER TAB TOGGLES
do
    -- WalkSpeed Toggle
    local wsFrame = Instance.new("Frame")
    wsFrame.Size = UDim2.new(1, 0, 0, 44)
    wsFrame.BackgroundColor3 = C.PANEL
    wsFrame.BorderSizePixel = 0
    wsFrame.LayoutOrder = 1
    wsFrame.Parent = playerTab
    addStroke(wsFrame, C.BORDER, 1)

    local wsFc = Instance.new("UICorner")
    wsFc.CornerRadius = UDim.new(0, 9)
    wsFc.Parent = wsFrame

    local wsLbl = Instance.new("TextLabel")
    wsLbl.Size = UDim2.new(0, 200, 1, 0)
    wsLbl.Position = UDim2.new(0, 14, 0, 0)
    wsLbl.BackgroundTransparency = 1
    wsLbl.Text = "🏃  WalkSpeed"
    wsLbl.TextColor3 = C.TEXT
    wsLbl.TextSize = 13
    wsLbl.Font = Enum.Font.Gotham
    wsLbl.TextXAlignment = Enum.TextXAlignment.Left
    wsLbl.Parent = wsFrame

    local wsBtn = Instance.new("TextButton")
    wsBtn.Size = UDim2.new(0, 68, 0, 28)
    wsBtn.Position = UDim2.new(1, -80, 0.5, -14)
    wsBtn.BackgroundColor3 = C.OFF
    wsBtn.BorderSizePixel = 0
    wsBtn.Text = "OFF"
    wsBtn.TextColor3 = C.TEXT
    wsBtn.TextSize = 12
    wsBtn.Font = Enum.Font.GothamBold
    wsBtn.Parent = wsFrame
    addStroke(wsBtn, Color3.fromRGB(200, 40, 70), 1)

    local wsbc = Instance.new("UICorner")
    wsbc.CornerRadius = UDim.new(0, 7)
    wsbc.Parent = wsBtn

    local wsEnabled = false
    local wsLoop = nil

    -- Isolated click handler
    local function toggleWalkSpeed()
        wsEnabled = not wsEnabled
        if wsEnabled then
            wsBtn.BackgroundColor3 = C.ON
            wsBtn.Text = "ON"
            addStroke(wsBtn, Color3.fromRGB(30, 210, 90), 1)
            
            wsLoop = task.spawn(function()
                while wsEnabled do
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChild("Humanoid")
                        if hum then
                            hum.WalkSpeed = 50
                        end
                    end
                    customWait(0.1)
                end
            end)
        else
            wsBtn.BackgroundColor3 = C.OFF
            wsBtn.Text = "OFF"
            addStroke(wsBtn, Color3.fromRGB(200, 40, 70), 1)
            
            local char = player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = 16
                end
            end
        end
    end

    wsBtn.MouseButton1Click:Connect(toggleWalkSpeed)

    -- JumpPower Toggle
    local jpFrame = Instance.new("Frame")
    jpFrame.Size = UDim2.new(1, 0, 0, 44)
    jpFrame.BackgroundColor3 = C.PANEL
    jpFrame.BorderSizePixel = 0
    jpFrame.LayoutOrder = 2
    jpFrame.Parent = playerTab
    addStroke(jpFrame, C.BORDER, 1)

    local jpFc = Instance.new("UICorner")
    jpFc.CornerRadius = UDim.new(0, 9)
    jpFc.Parent = jpFrame

    local jpLbl = Instance.new("TextLabel")
    jpLbl.Size = UDim2.new(0, 200, 1, 0)
    jpLbl.Position = UDim2.new(0, 14, 0, 0)
    jpLbl.BackgroundTransparency = 1
    jpLbl.Text = "🦘  JumpPower"
    jpLbl.TextColor3 = C.TEXT
    jpLbl.TextSize = 13
    jpLbl.Font = Enum.Font.Gotham
    jpLbl.TextXAlignment = Enum.TextXAlignment.Left
    jpLbl.Parent = jpFrame

    local jpBtn = Instance.new("TextButton")
    jpBtn.Size = UDim2.new(0, 68, 0, 28)
    jpBtn.Position = UDim2.new(1, -80, 0.5, -14)
    jpBtn.BackgroundColor3 = C.OFF
    jpBtn.BorderSizePixel = 0
    jpBtn.Text = "OFF"
    jpBtn.TextColor3 = C.TEXT
    jpBtn.TextSize = 12
    jpBtn.Font = Enum.Font.GothamBold
    jpBtn.Parent = jpFrame
    addStroke(jpBtn, Color3.fromRGB(200, 40, 70), 1)

    local jpbc = Instance.new("UICorner")
    jpbc.CornerRadius = UDim.new(0, 7)
    jpbc.Parent = jpBtn

    local jpEnabled = false
    local jpLoop = nil

    -- Isolated click handler
    local function toggleJumpPower()
        jpEnabled = not jpEnabled
        if jpEnabled then
            jpBtn.BackgroundColor3 = C.ON
            jpBtn.Text = "ON"
            addStroke(jpBtn, Color3.fromRGB(30, 210, 90), 1)
            
            jpLoop = task.spawn(function()
                while jpEnabled do
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChild("Humanoid")
                        if hum then
                            hum.JumpPower = 100
                        end
                    end
                    customWait(0.1)
                end
            end)
        else
            jpBtn.BackgroundColor3 = C.OFF
            jpBtn.Text = "OFF"
            addStroke(jpBtn, Color3.fromRGB(200, 40, 70), 1)
            
            local char = player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.JumpPower = 50
                end
            end
        end
    end

    jpBtn.MouseButton1Click:Connect(toggleJumpPower)

    -- Infinite Jump Toggle
    local ijFrame = Instance.new("Frame")
    ijFrame.Size = UDim2.new(1, 0, 0, 44)
    ijFrame.BackgroundColor3 = C.PANEL
    ijFrame.BorderSizePixel = 0
    ijFrame.LayoutOrder = 3
    ijFrame.Parent = playerTab
    addStroke(ijFrame, C.BORDER, 1)

    local ijFc = Instance.new("UICorner")
    ijFc.CornerRadius = UDim.new(0, 9)
    ijFc.Parent = ijFrame

    local ijLbl = Instance.new("TextLabel")
    ijLbl.Size = UDim2.new(0, 200, 1, 0)
    ijLbl.Position = UDim2.new(0, 14, 0, 0)
    ijLbl.BackgroundTransparency = 1
    ijLbl.Text = "♾  Infinite Jump"
    ijLbl.TextColor3 = C.TEXT
    ijLbl.TextSize = 13
    ijLbl.Font = Enum.Font.Gotham
    ijLbl.TextXAlignment = Enum.TextXAlignment.Left
    ijLbl.Parent = ijFrame

    local ijBtn = Instance.new("TextButton")
    ijBtn.Size = UDim2.new(0, 68, 0, 28)
    ijBtn.Position = UDim2.new(1, -80, 0.5, -14)
    ijBtn.BackgroundColor3 = C.OFF
    ijBtn.BorderSizePixel = 0
    ijBtn.Text = "OFF"
    ijBtn.TextColor3 = C.TEXT
    ijBtn.TextSize = 12
    ijBtn.Font = Enum.Font.GothamBold
    ijBtn.Parent = ijFrame
    addStroke(ijBtn, Color3.fromRGB(200, 40, 70), 1)

    local ijbc = Instance.new("UICorner")
    ijbc.CornerRadius = UDim.new(0, 7)
    ijbc.Parent = ijBtn

    local ijEnabled = false
    local ijConnection = nil

    -- Isolated click handler
    local function toggleInfiniteJump()
        ijEnabled = not ijEnabled
        if ijEnabled then
            ijBtn.BackgroundColor3 = C.ON
            ijBtn.Text = "ON"
            addStroke(ijBtn, Color3.fromRGB(30, 210, 90), 1)
            
            ijConnection = UserInputService.JumpRequest:Connect(function()
                local char = player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            ijBtn.BackgroundColor3 = C.OFF
            ijBtn.Text = "OFF"
            addStroke(ijBtn, Color3.fromRGB(200, 40, 70), 1)
            
            if ijConnection then
                ijConnection:Disconnect()
                ijConnection = nil
            end
        end
    end

    ijBtn.MouseButton1Click:Connect(toggleInfiniteJump)

    -- Noclip Toggle
    local ncFrame = Instance.new("Frame")
    ncFrame.Size = UDim2.new(1, 0, 0, 44)
    ncFrame.BackgroundColor3 = C.PANEL
    ncFrame.BorderSizePixel = 0
    ncFrame.LayoutOrder = 4
    ncFrame.Parent = playerTab
    addStroke(ncFrame, C.BORDER, 1)

    local ncFc = Instance.new("UICorner")
    ncFc.CornerRadius = UDim.new(0, 9)
    ncFc.Parent = ncFrame

    local ncLbl = Instance.new("TextLabel")
    ncLbl.Size = UDim2.new(0, 200, 1, 0)
    ncLbl.Position = UDim2.new(0, 14, 0, 0)
    ncLbl.BackgroundTransparency = 1
    ncLbl.Text = "👻  Noclip"
    ncLbl.TextColor3 = C.TEXT
    ncLbl.TextSize = 13
    ncLbl.Font = Enum.Font.Gotham
    ncLbl.TextXAlignment = Enum.TextXAlignment.Left
    ncLbl.Parent = ncFrame

    local ncBtn = Instance.new("TextButton")
    ncBtn.Size = UDim2.new(0, 68, 0, 28)
    ncBtn.Position = UDim2.new(1, -80, 0.5, -14)
    ncBtn.BackgroundColor3 = C.OFF
    ncBtn.BorderSizePixel = 0
    ncBtn.Text = "OFF"
    ncBtn.TextColor3 = C.TEXT
    ncBtn.TextSize = 12
    ncBtn.Font = Enum.Font.GothamBold
    ncBtn.Parent = ncFrame
    addStroke(ncBtn, Color3.fromRGB(200, 40, 70), 1)

    local ncbc = Instance.new("UICorner")
    ncbc.CornerRadius = UDim.new(0, 7)
    ncbc.Parent = ncBtn

    local ncEnabled = false
    local ncLoop = nil

    -- Isolated click handler
    local function toggleNoclip()
        ncEnabled = not ncEnabled
        if ncEnabled then
            ncBtn.BackgroundColor3 = C.ON
            ncBtn.Text = "ON"
            addStroke(ncBtn, Color3.fromRGB(30, 210, 90), 1)
            
            ncLoop = task.spawn(function()
                while ncEnabled do
                    local char = player.Character
                    if char then
                        for _, v in pairs(char:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                    customWait(0.1)
                end
            end)
        else
            ncBtn.BackgroundColor3 = C.OFF
            ncBtn.Text = "OFF"
            addStroke(ncBtn, Color3.fromRGB(200, 40, 70), 1)
            
            local char = player.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
        end
    end

    ncBtn.MouseButton1Click:Connect(toggleNoclip)

    -- Fly Toggle
    local flyFrame = Instance.new("Frame")
    flyFrame.Size = UDim2.new(1, 0, 0, 44)
    flyFrame.BackgroundColor3 = C.PANEL
    flyFrame.BorderSizePixel = 0
    flyFrame.LayoutOrder = 5
    flyFrame.Parent = playerTab
    addStroke(flyFrame, C.BORDER, 1)

    local flyFc = Instance.new("UICorner")
    flyFc.CornerRadius = UDim.new(0, 9)
    flyFc.Parent = flyFrame

    local flyLbl = Instance.new("TextLabel")
    flyLbl.Size = UDim2.new(0, 200, 1, 0)
    flyLbl.Position = UDim2.new(0, 14, 0, 0)
    flyLbl.BackgroundTransparency = 1
    flyLbl.Text = "✈  Fly (E to toggle)"
    flyLbl.TextColor3 = C.TEXT
    flyLbl.TextSize = 13
    flyLbl.Font = Enum.Font.Gotham
    flyLbl.TextXAlignment = Enum.TextXAlignment.Left
    flyLbl.Parent = flyFrame

    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(0, 68, 0, 28)
    flyBtn.Position = UDim2.new(1, -80, 0.5, -14)
    flyBtn.BackgroundColor3 = C.OFF
    flyBtn.BorderSizePixel = 0
    flyBtn.Text = "OFF"
    flyBtn.TextColor3 = C.TEXT
    flyBtn.TextSize = 12
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.Parent = flyFrame
    addStroke(flyBtn, Color3.fromRGB(200, 40, 70), 1)

    local flybc = Instance.new("UICorner")
    flybc.CornerRadius = UDim.new(0, 7)
    flybc.Parent = flyBtn

    local flyEnabled = false
    local flying = false
    local flySpeed = 50
    local flyConnection = nil
    local flyLoop = nil
    local bodyVelocity = nil
    local bodyGyro = nil

    -- Isolated fly functions
    local function startFlying()
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        flying = true

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Parent = hrp

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.P = 1000
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp

        flyLoop = task.spawn(function()
            while flying do
                local cam = workspace.CurrentCamera
                local direction = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + cam.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - cam.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - cam.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + cam.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, 1, 0)
                end

                if bodyVelocity then
                    bodyVelocity.Velocity = direction.Unit * flySpeed
                end
                if bodyGyro then
                    bodyGyro.CFrame = cam.CFrame
                end

                customWait(0.03)
            end
        end)
    end

    local function stopFlying()
        flying = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        bodyVelocity = nil
        bodyGyro = nil
    end

    local function toggleFly()
        flyEnabled = not flyEnabled
        if flyEnabled then
            flyBtn.BackgroundColor3 = C.ON
            flyBtn.Text = "ON"
            addStroke(flyBtn, Color3.fromRGB(30, 210, 90), 1)
            
            flyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.E then
                    if flying then
                        stopFlying()
                    else
                        startFlying()
                    end
                end
            end)
        else
            flyBtn.BackgroundColor3 = C.OFF
            flyBtn.Text = "OFF"
            addStroke(flyBtn, Color3.fromRGB(200, 40, 70), 1)
            
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            stopFlying()
        end
    end

    flyBtn.MouseButton1Click:Connect(toggleFly)
end

-- SCOPE 6: TELEPORT TAB
do
    local tpLabel = Instance.new("TextLabel")
    tpLabel.Size = UDim2.new(1, 0, 0, 60)
    tpLabel.BackgroundColor3 = C.PANEL
    tpLabel.BorderSizePixel = 0
    tpLabel.Text = "Teleport to locations\n(Add teleport buttons here)"
    tpLabel.TextColor3 = C.TEXTDIM
    tpLabel.TextSize = 13
    tpLabel.Font = Enum.Font.Gotham
    tpLabel.TextWrapped = true
    tpLabel.LayoutOrder = 1
    tpLabel.Parent = teleportTab
    addStroke(tpLabel, C.BORDER, 1)

    local tpCorner = Instance.new("UICorner")
    tpCorner.CornerRadius = UDim.new(0, 9)
    tpCorner.Parent = tpLabel

    local tpPadding = Instance.new("UIPadding")
    tpPadding.PaddingTop = UDim.new(0, 10)
    tpPadding.PaddingLeft = UDim.new(0, 12)
    tpPadding.Parent = tpLabel
end

-- SCOPE 7: AUTO FARM TAB
do
    local afFrame = Instance.new("Frame")
    afFrame.Size = UDim2.new(1, 0, 0, 44)
    afFrame.BackgroundColor3 = C.PANEL
    afFrame.BorderSizePixel = 0
    afFrame.LayoutOrder = 1
    afFrame.Parent = autoTab
    addStroke(afFrame, C.BORDER, 1)

    local afFc = Instance.new("UICorner")
    afFc.CornerRadius = UDim.new(0, 9)
    afFc.Parent = afFrame

    local afLbl = Instance.new("TextLabel")
    afLbl.Size = UDim2.new(0, 220, 1, 0)
    afLbl.Position = UDim2.new(0, 14, 0, 0)
    afLbl.BackgroundTransparency = 1
    afLbl.Text = "⚡  Auto Farm (Collect coins)"
    afLbl.TextColor3 = C.TEXT
    afLbl.TextSize = 13
    afLbl.Font = Enum.Font.Gotham
    afLbl.TextXAlignment = Enum.TextXAlignment.Left
    afLbl.Parent = afFrame

    local afBtn = Instance.new("TextButton")
    afBtn.Size = UDim2.new(0, 68, 0, 28)
    afBtn.Position = UDim2.new(1, -80, 0.5, -14)
    afBtn.BackgroundColor3 = C.OFF
    afBtn.BorderSizePixel = 0
    afBtn.Text = "OFF"
    afBtn.TextColor3 = C.TEXT
    afBtn.TextSize = 12
    afBtn.Font = Enum.Font.GothamBold
    afBtn.Parent = afFrame
    addStroke(afBtn, Color3.fromRGB(200, 40, 70), 1)

    local afbc = Instance.new("UICorner")
    afbc.CornerRadius = UDim.new(0, 7)
    afbc.Parent = afBtn

    local afEnabled = false
    local afLoop = nil

    -- Isolated auto farm function
    local function toggleAutoFarm()
        afEnabled = not afEnabled
        if afEnabled then
            afBtn.BackgroundColor3 = C.ON
            afBtn.Text = "ON"
            addStroke(afBtn, Color3.fromRGB(30, 210, 90), 1)
            
            afLoop = task.spawn(function()
                while afEnabled do
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v.Name == "Coin" and v:IsA("BasePart") then
                            local char = player.Character
                            if char then
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hrp.CFrame = v.CFrame
                                    customWait(0.1)
                                end
                            end
                        end
                    end
                    customWait(1)
                end
            end)
        else
            afBtn.BackgroundColor3 = C.OFF
            afBtn.Text = "OFF"
            addStroke(afBtn, Color3.fromRGB(200, 40, 70), 1)
        end
    end

    afBtn.MouseButton1Click:Connect(toggleAutoFarm)
end

-- SCOPE 8: MISC TAB
do
    local miscLabel = Instance.new("TextLabel")
    miscLabel.Size = UDim2.new(1, 0, 0, 60)
    miscLabel.BackgroundColor3 = C.PANEL
    miscLabel.BorderSizePixel = 0
    miscLabel.Text = "Miscellaneous Features\n(Add extra features here)"
    miscLabel.TextColor3 = C.TEXTDIM
    miscLabel.TextSize = 13
    miscLabel.Font = Enum.Font.Gotham
    miscLabel.TextWrapped = true
    miscLabel.LayoutOrder = 1
    miscLabel.Parent = miscTab
    addStroke(miscLabel, C.BORDER, 1)

    local miscCorner = Instance.new("UICorner")
    miscCorner.CornerRadius = UDim.new(0, 9)
    miscCorner.Parent = miscLabel

    local miscPadding = Instance.new("UIPadding")
    miscPadding.PaddingTop = UDim.new(0, 10)
    miscPadding.PaddingLeft = UDim.new(0, 12)
    miscPadding.Parent = miscLabel
end

-- SCOPE 9: ESP TAB
do
    local espFrame = Instance.new("Frame")
    espFrame.Size = UDim2.new(1, 0, 0, 44)
    espFrame.BackgroundColor3 = C.PANEL
    espFrame.BorderSizePixel = 0
    espFrame.LayoutOrder = 1
    espFrame.Parent = espTab
    addStroke(espFrame, C.BORDER, 1)

    local espFc = Instance.new("UICorner")
    espFc.CornerRadius = UDim.new(0, 9)
    espFc.Parent = espFrame

    local espLbl = Instance.new("TextLabel")
    espLbl.Size = UDim2.new(0, 200, 1, 0)
    espLbl.Position = UDim2.new(0, 14, 0, 0)
    espLbl.BackgroundTransparency = 1
    espLbl.Text = "👁  Player ESP"
    espLbl.TextColor3 = C.TEXT
    espLbl.TextSize = 13
    espLbl.Font = Enum.Font.Gotham
    espLbl.TextXAlignment = Enum.TextXAlignment.Left
    espLbl.Parent = espFrame

    local espBtn = Instance.new("TextButton")
    espBtn.Size = UDim2.new(0, 68, 0, 28)
    espBtn.Position = UDim2.new(1, -80, 0.5, -14)
    espBtn.BackgroundColor3 = C.OFF
    espBtn.BorderSizePixel = 0
    espBtn.Text = "OFF"
    espBtn.TextColor3 = C.TEXT
    espBtn.TextSize = 12
    espBtn.Font = Enum.Font.GothamBold
    espBtn.Parent = espFrame
    addStroke(espBtn, Color3.fromRGB(200, 40, 70), 1)

    local espbc = Instance.new("UICorner")
    espbc.CornerRadius = UDim.new(0, 7)
    espbc.Parent = espBtn

    local espEnabled = false
    local espFolder = nil

    -- Isolated ESP functions
    local function createESP(targetPlayer)
        if targetPlayer == player then return end
        local char = targetPlayer.Character
        if not char then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_" .. targetPlayer.Name
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = espFolder

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = targetPlayer.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Parent = billboard

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            billboard.Adornee = hrp
        end
    end

    local function removeESP()
        if espFolder then
            espFolder:ClearAllChildren()
        end
    end

    local function toggleESP()
        espEnabled = not espEnabled
        if espEnabled then
            espBtn.BackgroundColor3 = C.ON
            espBtn.Text = "ON"
            addStroke(espBtn, Color3.fromRGB(30, 210, 90), 1)
            
            if not espFolder then
                espFolder = Instance.new("Folder")
                espFolder.Name = "ESP_Folder"
                espFolder.Parent = screenGui
            end
            
            for _, p in pairs(Players:GetPlayers()) do
                createESP(p)
            end
            
            Players.PlayerAdded:Connect(function(p)
                if espEnabled then
                    customWait(1)
                    createESP(p)
                end
            end)
        else
            espBtn.BackgroundColor3 = C.OFF
            espBtn.Text = "OFF"
            addStroke(espBtn, Color3.fromRGB(200, 40, 70), 1)
            
            removeESP()
        end
    end

    espBtn.MouseButton1Click:Connect(toggleESP)
end

-- SCOPE 10: SETTINGS TAB
do
    local uiContent = settingsTab

    -- Theme section
    local themeLabel = Instance.new("TextLabel")
    themeLabel.Size = UDim2.new(1, 0, 0, 32)
    themeLabel.BackgroundColor3 = C.BG2
    themeLabel.BorderSizePixel = 0
    themeLabel.Text = "  ✦  Appearance"
    themeLabel.TextColor3 = C.TEXT
    themeLabel.TextSize = 14
    themeLabel.Font = Enum.Font.GothamBold
    themeLabel.TextXAlignment = Enum.TextXAlignment.Left
    themeLabel.LayoutOrder = 1
    themeLabel.Parent = uiContent
    addStroke(themeLabel, C.BORDER, 1)

    local themeCorner = Instance.new("UICorner")
    themeCorner.CornerRadius = UDim.new(0, 9)
    themeCorner.Parent = themeLabel

    -- GUI Scale
    local scaleFrame = Instance.new("Frame")
    scaleFrame.Size = UDim2.new(1, 0, 0, 50)
    scaleFrame.BackgroundColor3 = C.PANEL
    scaleFrame.BorderSizePixel = 0
    scaleFrame.LayoutOrder = 2
    scaleFrame.Parent = uiContent
    addStroke(scaleFrame, C.BORDER, 1)

    local scaleFc = Instance.new("UICorner")
    scaleFc.CornerRadius = UDim.new(0, 9)
    scaleFc.Parent = scaleFrame

    local scaleLbl = Instance.new("TextLabel")
    scaleLbl.Size = UDim2.new(0, 120, 1, 0)
    scaleLbl.Position = UDim2.new(0, 14, 0, 0)
    scaleLbl.BackgroundTransparency = 1
    scaleLbl.Text = "GUI Scale: 100%"
    scaleLbl.TextColor3 = C.TEXT
    scaleLbl.TextSize = 13
    scaleLbl.Font = Enum.Font.Gotham
    scaleLbl.TextXAlignment = Enum.TextXAlignment.Left
    scaleLbl.Parent = scaleFrame

    local guiMinimized = false
    local originalSize = mainFrame.Size

    local minimizeButton = minimizeButton
    minimizeButton.MouseButton1Click:Connect(function()
        do
            guiMinimized = not guiMinimized
            if guiMinimized then
                mainFrame.Size = UDim2.new(0, 300, 0, 45)
                minimizeButton.Text = "+"
                tabContent.Visible = false
            else
                mainFrame.Size = originalSize
                minimizeButton.Text = "−"
                tabContent.Visible = true
            end
        end
    end)

    local scaleLabels = {"80%", "90%", "100%", "110%", "120%"}
    local scaleDesktopSizes = {
        UDim2.new(0, 512, 0, 344),
        UDim2.new(0, 576, 0, 387),
        UDim2.new(0, 640, 0, 430),
        UDim2.new(0, 704, 0, 473),
        UDim2.new(0, 768, 0, 516),
    }
    local scaleMobileSizes = {
        UDim2.new(0.85, 0, 0.65, 0),
        UDim2.new(0.87, 0, 0.70, 0),
        UDim2.new(0.9, 0, 0.75, 0),
        UDim2.new(0.95, 0, 0.80, 0),
        UDim2.new(1.0, -10, 0.85, 0),
    }
    local scaleSizes = deviceType == "mobile" and scaleMobileSizes or scaleDesktopSizes
    local scaleButtons = {}

    for i, s in ipairs(scaleLabels) do
        do
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

            local sbc = Instance.new("UICorner")
            sbc.CornerRadius = UDim.new(0, 6)
            sbc.Parent = sb

            scaleButtons[i] = sb

            local currentIndex = i
            local function onScaleClick()
                for j, b in ipairs(scaleButtons) do
                    b.BackgroundColor3 = j == currentIndex and C.ACCENT or C.BG3
                end
                scaleLbl.Text = "GUI Scale: " .. s
                if not guiMinimized then
                    mainFrame.Size = scaleSizes[currentIndex]
                    originalSize = scaleSizes[currentIndex]
                end
            end

            sb.MouseButton1Click:Connect(onScaleClick)
        end
    end

    -- Watermark toggle
    local wmFrame = Instance.new("Frame")
    wmFrame.Size = UDim2.new(1, 0, 0, 44)
    wmFrame.BackgroundColor3 = C.PANEL
    wmFrame.BorderSizePixel = 0
    wmFrame.LayoutOrder = 5
    wmFrame.Parent = uiContent
    addStroke(wmFrame, C.BORDER, 1)

    local wmFc = Instance.new("UICorner")
    wmFc.CornerRadius = UDim.new(0, 9)
    wmFc.Parent = wmFrame

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

    local wmbc = Instance.new("UICorner")
    wmbc.CornerRadius = UDim.new(0, 7)
    wmbc.Parent = wmBtn

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

    local wmLabelCorner = Instance.new("UICorner")
    wmLabelCorner.CornerRadius = UDim.new(0, 7)
    wmLabelCorner.Parent = watermark

    local wmEnabled = true

    local function toggleWatermark()
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
    end

    wmBtn.MouseButton1Click:Connect(toggleWatermark)

    -- Destroy GUI button
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
end

-- SCOPE 11: KEY VALIDATION (isolated)
do
    local keyRefs = _G.KeySystemRefs
    local function validateKey()
        local enteredKey = keyRefs.keyInput.Text
        
        if enteredKey == CORRECT_KEY then
            keyRefs.statusLabel.TextColor3 = C.ON
            keyRefs.statusLabel.Text = "✓ Key Accepted! Loading..."
            
            saveKey()
            
            customWait(1)
            keyRefs.keyFrame.Visible = false
            mainFrame.Visible = true
            
            tabs["Info"].button.MouseButton1Click:Fire()
        else
            keyRefs.statusLabel.TextColor3 = C.OFF
            keyRefs.statusLabel.Text = "✗ Invalid Key!"
            customWait(2)
            keyRefs.statusLabel.Text = ""
        end
    end

    keyRefs.submitButton.MouseButton1Click:Connect(validateKey)

    keyRefs.keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            validateKey()
        end
    end)
end

-- SCOPE 12: ON-H BUTTON (isolated)
do
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

    local function showMainFrame()
        mainFrame.Visible = true
        onhButton.Visible = false
    end

    onhButton.MouseButton1Click:Connect(showMainFrame)

    local function hideMainFrame()
        mainFrame.Visible = false
        onhButton.Visible = true
    end

    closeButton.MouseButton1Click:Connect(hideMainFrame)
end

-- SCOPE 13: DRAGGING LOGIC (isolated)
do
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
end

-- SCOPE 14: AUTO-LOAD IF KEY SAVED
do
    if isKeySaved() then
        _G.KeySystemRefs.keyFrame.Visible = false
        mainFrame.Visible = true
        tabs["Info"].button.MouseButton1Click:Fire()
    end
end

print("Roblox GUI Loaded Successfully!")
print("Register overflow FIXED - all scopes isolated")
