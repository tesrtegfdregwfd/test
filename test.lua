-- Roblox GUI with Key System - REGISTER OVERFLOW FIXED
-- Key: cat
-- Delta Executor Compatible Version
-- Fixed: Modularized scopes, extracted functions, reduced closures

print("===========================================")
print("FlyOnion Hub - Starting...")
print("Delta Executor Optimized - v1.2 FIXED")
print("===========================================")

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 1: SERVICES & CORE INITIALIZATION             ║
-- ═══════════════════════════════════════════════════════════
do
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	print("✓ All services loaded")

	-- Make services global for other sections
	_G.FlyOnionServices = {
		Players = Players,
		ReplicatedStorage = ReplicatedStorage,
		TweenService = TweenService,
		UserInputService = UserInputService
	}
end

local Players = _G.FlyOnionServices.Players
local ReplicatedStorage = _G.FlyOnionServices.ReplicatedStorage
local TweenService = _G.FlyOnionServices.TweenService
local UserInputService = _G.FlyOnionServices.UserInputService

local player = Players.LocalPlayer

-- Universal wait function (Delta compatibility)
local customWait = task and task.wait or wait

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 2: PLAYER GUI INITIALIZATION                  ║
-- ═══════════════════════════════════════════════════════════
local playerGui
do
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
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 3: DEVICE DETECTION & RESPONSIVE CONFIG       ║
-- ═══════════════════════════════════════════════════════════
local deviceType, isMobile, isSmallScreen
do
	isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local screenSize = workspace.CurrentCamera.ViewportSize
	isSmallScreen = screenSize.X < 768 or screenSize.Y < 600

	deviceType = (isMobile or isSmallScreen) and "mobile" or "desktop"

	print("Device Type: " .. deviceType)
	print("Screen Size: " .. tostring(screenSize))
	print("Is Mobile: " .. tostring(isMobile))
	print("Is Small Screen: " .. tostring(isSmallScreen))
end

-- Responsive sizing function
local function getResponsiveSize(desktopSize, mobileSize)
	return deviceType == "mobile" and mobileSize or desktopSize
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 4: KEY SYSTEM CONFIGURATION                   ║
-- ═══════════════════════════════════════════════════════════
local CORRECT_KEY = "cat"
local KEY_STORAGE_NAME = "RobloxGUI_KeySaved"

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

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 5: SCREEN GUI CREATION                        ║
-- ═══════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 6: COLOR PALETTE & UI HELPERS                 ║
-- ═══════════════════════════════════════════════════════════
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

-- Helper functions
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

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 7: KEY SYSTEM UI                              ║
-- ═══════════════════════════════════════════════════════════
local keyFrame, keyInput, submitButton, statusLabel
do
	keyFrame = Instance.new("Frame")
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

	-- Glow bar
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

	-- Title
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

	-- Input box
	keyInput = Instance.new("TextBox")
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

	-- Submit button
	submitButton = Instance.new("TextButton")
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

	-- Status label
	statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(1, -40, 0, 30)
	statusLabel.Position = UDim2.new(0, 20, 0, 205)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = ""
	statusLabel.TextColor3 = C.OFF
	statusLabel.TextSize = 14
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.Parent = keyFrame
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 8: MAIN GUI FRAME                             ║
-- ═══════════════════════════════════════════════════════════
local mainFrame, titleBar, closeButton, minimizeButton, tabContainer, contentContainer
do
	mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Active = true
	local mainFrameSize = getResponsiveSize(
		UDim2.new(0, 640, 0, 430),
		UDim2.new(0.95, 0, 0.8, 0)
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

	-- Glow bar (hidden)
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

	-- Title bar
	titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 52)
	titleBar.BackgroundColor3 = C.BG2
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame
	addGradient(titleBar, C.BG2, Color3.fromRGB(20, 14, 40), 90)

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 14)
	titleCorner.Parent = titleBar

	-- Title dot
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

	-- Minimize button
	minimizeButton = Instance.new("TextButton")
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

	-- Close button
	closeButton = Instance.new("TextButton")
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

	-- Tab container
	tabContainer = Instance.new("Frame")
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

	-- Content container
	contentContainer = Instance.new("Frame")
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
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 9: MINIMIZE LOGIC (SEPARATE SCOPE)            ║
-- ═══════════════════════════════════════════════════════════
do
	local guiMinimized = false
	local originalSize = mainFrame.Size
	
	local function onMinimizeClick()
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
	end
	
	minimizeButton.MouseButton1Click:Connect(onMinimizeClick)
	
	-- Export for scale system
	_G.FlyOnionMinimize = {
		isMinimized = function() return guiMinimized end,
		setOriginalSize = function(size) originalSize = size end
	}
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 10: TAB SYSTEM (ISOLATED SCOPE)               ║
-- ═══════════════════════════════════════════════════════════
local tabs = {}
local currentTab = nil

do
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
		addStroke(tabButton, C.BORDER, 1)

		local tabCorner = Instance.new("UICorner")
		tabCorner.CornerRadius = UDim.new(0, 8)
		tabCorner.Parent = tabButton

		local tabPadding = Instance.new("UIPadding")
		tabPadding.PaddingLeft = UDim.new(0, 12)
		tabPadding.Parent = tabButton

		-- Content scrolling frame
		local content = Instance.new("ScrollingFrame")
		content.Name = name .. "Content"
		content.Size = UDim2.new(1, -14, 1, -14)
		content.Position = UDim2.new(0, 7, 0, 7)
		content.BackgroundTransparency = 1
		content.BorderSizePixel = 0
		content.ScrollBarThickness = 6
		content.ScrollBarImageColor3 = C.ACCENT
		content.Visible = false
		content.CanvasSize = UDim2.new(0, 0, 0, 0)
		content.Parent = contentContainer

		local contentLayout = Instance.new("UIListLayout")
		contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		contentLayout.Padding = UDim.new(0, 8)
		contentLayout.Parent = content

		local contentPad = Instance.new("UIPadding")
		contentPad.PaddingTop = UDim.new(0, 5)
		contentPad.PaddingBottom = UDim.new(0, 5)
		contentPad.Parent = content

		-- Update canvas size when content changes
		contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
		end)

		-- Tab click handler (separate function)
		local function onTabClick()
			-- Hide all tabs
			for _, tab in pairs(tabs) do
				tab.button.BackgroundColor3 = C.PANEL
				tab.button.TextColor3 = C.TEXTDIM
				tab.content.Visible = false
			end
			-- Show this tab
			tabButton.BackgroundColor3 = Color3.fromRGB(35, 25, 60)
			tabButton.TextColor3 = C.TEXT
			content.Visible = true
			currentTab = name
		end

		tabButton.MouseButton1Click:Connect(onTabClick)

		tabs[name] = {
			button = tabButton,
			content = content
		}

		return content
	end

	-- Create all tabs
	_G.FlyOnionTabs = {
		Info = createTab("Info", 1),
		Main = createTab("Main", 2),
		Auto = createTab("Auto", 3),
		Teleport = createTab("Teleport", 4),
		Misc = createTab("Misc", 5),
		UI = createTab("UI", 6)
	}
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 11: INFO TAB CONTENT                          ║
-- ═══════════════════════════════════════════════════════════
do
	local infoContent = _G.FlyOnionTabs.Info

	local infoText = Instance.new("TextLabel")
	infoText.Size = UDim2.new(1, 0, 0, 320)
	infoText.BackgroundColor3 = C.PANEL
	infoText.BorderSizePixel = 0
	infoText.Text = [[
✦  FlyOnion Hub  ✦

Welcome! This GUI is optimized for Delta and all major executors.

KEY FEATURES:
• Auto Collect Money
• Auto Rebirth
• Auto Equip Best
• Teleport System
• Fly Speed Control
• Infinite Stamina
• Auto Revive

All features have customizable cooldowns.

Made by cat 🐱
Version 1.2 - Register Overflow Fixed
]]
	infoText.TextColor3 = C.TEXT
	infoText.TextSize = 13
	infoText.Font = Enum.Font.Gotham
	infoText.TextXAlignment = Enum.TextXAlignment.Left
	infoText.TextYAlignment = Enum.TextYAlignment.Top
	infoText.Parent = infoContent
	addStroke(infoText, C.BORDER, 1)

	local infoCorner = Instance.new("UICorner")
	infoCorner.CornerRadius = UDim.new(0, 9)
	infoCorner.Parent = infoText

	local infoPadding = Instance.new("UIPadding")
	infoPadding.PaddingTop = UDim.new(0, 15)
	infoPadding.PaddingLeft = UDim.new(0, 15)
	infoPadding.PaddingRight = UDim.new(0, 15)
	infoPadding.Parent = infoText
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 12: MAIN TAB - HELPER FUNCTIONS              ║
-- ═══════════════════════════════════════════════════════════
local function createToggleRow(parent, labelText, layoutOrder)
	local row = Instance.new("Frame")
	row.Name = labelText
	row.Size = UDim2.new(1, 0, 0, 48)
	row.BackgroundColor3 = C.PANEL
	row.BorderSizePixel = 0
	row.LayoutOrder = layoutOrder
	row.Parent = parent
	addStroke(row, C.BORDER, 1)
	local rc = Instance.new("UICorner")
	rc.CornerRadius = UDim.new(0, 9)
	rc.Parent = row

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
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 7)
	bc.Parent = btn

	return row, btn
end

local function createCDBox(parent, offset)
	local cdLbl = Instance.new("TextLabel")
	cdLbl.Size = UDim2.new(0, 28, 0, 14)
	cdLbl.Position = UDim2.new(1, -218, 0.5, -20)
	cdLbl.BackgroundTransparency = 1
	cdLbl.Text = "CD(s)"
	cdLbl.TextColor3 = C.TEXTDIM
	cdLbl.TextSize = 10
	cdLbl.Font = Enum.Font.Gotham
	cdLbl.Parent = parent

	local cdBox = Instance.new("TextBox")
	cdBox.Size = UDim2.new(0, 48, 0, 28)
	cdBox.Position = UDim2.new(1, -164, 0.5, -14)
	cdBox.BackgroundColor3 = C.BG3
	cdBox.BorderSizePixel = 0
	cdBox.Text = tostring(offset)
	cdBox.TextColor3 = C.ACCENT2
	cdBox.TextSize = 13
	cdBox.Font = Enum.Font.GothamBold
	cdBox.ClearTextOnFocus = false
	cdBox.Parent = parent
	addStroke(cdBox, C.BORDER, 1)
	local cdbc = Instance.new("UICorner")
	cdbc.CornerRadius = UDim.new(0, 6)
	cdbc.Parent = cdBox

	return cdBox
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 13: MAIN TAB - AUTO CLICK (ISOLATED)         ║
-- ═══════════════════════════════════════════════════════════
do
	local mainContent = _G.FlyOnionTabs.Main
	local clickRow, clickBtn = createToggleRow(mainContent, "🖱  Auto Click", 1)
	local clickCDBox = createCDBox(clickRow, 0)

	local autoClickEnabled = false
	local autoClickThread = nil

	local function onAutoClickToggle()
		autoClickEnabled = not autoClickEnabled
		if autoClickEnabled then
			clickBtn.BackgroundColor3 = C.ON
			clickBtn.Text = "ON"
			addStroke(clickBtn, Color3.fromRGB(30, 210, 90), 1)
			autoClickThread = task.spawn(function()
				while autoClickEnabled do
					pcall(function()
						local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
						if tool then
							tool:Activate()
						end
					end)
					local cd = tonumber(clickCDBox.Text) or 0.1
					task.wait(math.max(0.01, cd))
				end
			end)
		else
			clickBtn.BackgroundColor3 = C.OFF
			clickBtn.Text = "OFF"
			addStroke(clickBtn, Color3.fromRGB(200, 40, 70), 1)
			if autoClickThread then
				task.cancel(autoClickThread)
				autoClickThread = nil
			end
		end
	end

	clickBtn.MouseButton1Click:Connect(onAutoClickToggle)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 14: MAIN TAB - AUTO FARM (ISOLATED)          ║
-- ═══════════════════════════════════════════════════════════
do
	local mainContent = _G.FlyOnionTabs.Main
	local farmRow, farmBtn = createToggleRow(mainContent, "⚔  Auto Farm", 2)
	local farmCDBox = createCDBox(farmRow, 1)

	local autoFarmEnabled = false
	local autoFarmThread = nil

	local function onAutoFarmToggle()
		autoFarmEnabled = not autoFarmEnabled
		if autoFarmEnabled then
			farmBtn.BackgroundColor3 = C.ON
			farmBtn.Text = "ON"
			addStroke(farmBtn, Color3.fromRGB(30, 210, 90), 1)
			autoFarmThread = task.spawn(function()
				while autoFarmEnabled do
					pcall(function()
						local mob = workspace:FindFirstChild("Mobs")
						if mob then
							for _, v in ipairs(mob:GetChildren()) do
								if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
									local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
									if tool then
										tool:Activate()
									end
									local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
									local mobHRP = v:FindFirstChild("HumanoidRootPart")
									if hrp and mobHRP then
										hrp.CFrame = mobHRP.CFrame * CFrame.new(0, 0, 5)
									end
									break
								end
							end
						end
					end)
					local cd = tonumber(farmCDBox.Text) or 1
					task.wait(math.max(0.1, cd))
				end
			end)
		else
			farmBtn.BackgroundColor3 = C.OFF
			farmBtn.Text = "OFF"
			addStroke(farmBtn, Color3.fromRGB(200, 40, 70), 1)
			if autoFarmThread then
				task.cancel(autoFarmThread)
				autoFarmThread = nil
			end
		end
	end

	farmBtn.MouseButton1Click:Connect(onAutoFarmToggle)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 15: MAIN TAB - AUTO COLLECT (ISOLATED)       ║
-- ═══════════════════════════════════════════════════════════
do
	local mainContent = _G.FlyOnionTabs.Main
	local collectRow, collectBtn = createToggleRow(mainContent, "💰  Auto Collect", 3)
	local collectCDBox = createCDBox(collectRow, 0)

	local autoCollectEnabled = false
	local autoCollectThread = nil

	local function onAutoCollectToggle()
		autoCollectEnabled = not autoCollectEnabled
		if autoCollectEnabled then
			collectBtn.BackgroundColor3 = C.ON
			collectBtn.Text = "ON"
			addStroke(collectBtn, Color3.fromRGB(30, 210, 90), 1)
			autoCollectThread = task.spawn(function()
				while autoCollectEnabled do
					pcall(function()
						local username = player.Name
						local basesFolder = workspace:FindFirstChild("Bases")
						if not basesFolder then return end
						local plot = basesFolder:FindFirstChild("Plot_" .. username)
						if not plot then return end
						for floorNum = 1, 14 do
							local floor = plot:FindFirstChild("Floor" .. tostring(floorNum))
							if floor then
								local slots = floor:FindFirstChild("Slots")
								if slots then
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
								end
							end
						end
					end)
					local cd = tonumber(collectCDBox.Text) or 0.5
					task.wait(math.max(0.1, cd))
				end
			end)
		else
			collectBtn.BackgroundColor3 = C.OFF
			collectBtn.Text = "OFF"
			addStroke(collectBtn, Color3.fromRGB(200, 40, 70), 1)
			if autoCollectThread then
				task.cancel(autoCollectThread)
				autoCollectThread = nil
			end
		end
	end

	collectBtn.MouseButton1Click:Connect(onAutoCollectToggle)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 16: MAIN TAB - AUTO REBIRTH (ISOLATED)       ║
-- ═══════════════════════════════════════════════════════════
do
	local mainContent = _G.FlyOnionTabs.Main
	local rebirthRow, rebirthBtn = createToggleRow(mainContent, "🔁  Auto Rebirth", 4)
	local rebirthCDBox = createCDBox(rebirthRow, 5)

	local autoRebirthEnabled = false
	local autoRebirthThread = nil

	local function onAutoRebirthToggle()
		autoRebirthEnabled = not autoRebirthEnabled
		if autoRebirthEnabled then
			rebirthBtn.BackgroundColor3 = C.ON
			rebirthBtn.Text = "ON"
			addStroke(rebirthBtn, Color3.fromRGB(30, 210, 90), 1)
			autoRebirthThread = task.spawn(function()
				while autoRebirthEnabled do
					pcall(function()
						ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RebirthEvent"):FireServer()
					end)
					local cd = tonumber(rebirthCDBox.Text) or 5
					task.wait(math.max(0.1, cd))
				end
			end)
		else
			rebirthBtn.BackgroundColor3 = C.OFF
			rebirthBtn.Text = "OFF"
			addStroke(rebirthBtn, Color3.fromRGB(200, 40, 70), 1)
			if autoRebirthThread then
				task.cancel(autoRebirthThread)
				autoRebirthThread = nil
			end
		end
	end

	rebirthBtn.MouseButton1Click:Connect(onAutoRebirthToggle)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 17: AUTO TAB - AUTO EQUIP BEST (ISOLATED)    ║
-- ═══════════════════════════════════════════════════════════
do
	local autoContent = _G.FlyOnionTabs.Auto

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

	-- Auto equip logic
	local autoEquipEnabled = false
	local autoEquipThread = nil

	local function onAutoEquipToggle()
		autoEquipEnabled = not autoEquipEnabled
		if autoEquipEnabled then
			autoEquipButton.BackgroundColor3 = C.ON
			autoEquipButton.Text = "ON"
			addStroke(autoEquipButton, Color3.fromRGB(30, 210, 90), 1)
			autoEquipThread = task.spawn(function()
				while autoEquipEnabled do
					pcall(function()
						ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EquipBest"):FireServer()
					end)
					local cd = tonumber(autoEquipCDBox.Text) or 3
					task.wait(math.max(0.1, cd))
				end
			end)
		else
			autoEquipButton.BackgroundColor3 = C.OFF
			autoEquipButton.Text = "OFF"
			addStroke(autoEquipButton, Color3.fromRGB(200, 40, 70), 1)
			if autoEquipThread then
				task.cancel(autoEquipThread)
				autoEquipThread = nil
			end
		end
	end

	autoEquipButton.MouseButton1Click:Connect(onAutoEquipToggle)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 18: AUTO TAB - INTERVAL SLIDER (ISOLATED)    ║
-- ═══════════════════════════════════════════════════════════
do
	local autoContent = _G.FlyOnionTabs.Auto

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

	-- Slider logic
	local intervalSteps = {}
	for i = 1, 30 do intervalSteps[i] = i end
	local currentIntervalIndex = 3
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
	
	local function onKnobInputBegan(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			sliderDragging = true
		end
	end
	
	local function onKnobInputEnded(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			sliderDragging = false
		end
	end
	
	local function onInputChanged(inp)
		if sliderDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			local barAbsPos = sliderBar.AbsolutePosition.X
			local barAbsSize = sliderBar.AbsoluteSize.X
			local relX = math.clamp(inp.Position.X - barAbsPos, 0, barAbsSize)
			local pct = relX / barAbsSize
			local index = math.round(pct * 29) + 1
			updateSlider(index)
		end
	end
	
	local function onBarInputBegan(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			local barAbsPos = sliderBar.AbsolutePosition.X
			local barAbsSize = sliderBar.AbsoluteSize.X
			local relX = math.clamp(inp.Position.X - barAbsPos, 0, barAbsSize)
			local pct = relX / barAbsSize
			local index = math.round(pct * 29) + 1
			updateSlider(index)
		end
	end

	sliderKnob.InputBegan:Connect(onKnobInputBegan)
	sliderKnob.InputEnded:Connect(onKnobInputEnded)
	UserInputService.InputChanged:Connect(onInputChanged)
	sliderBar.InputBegan:Connect(onBarInputBegan)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 19: AUTO TAB - AUTO COLLECT MONEY (ISOLATED) ║
-- ═══════════════════════════════════════════════════════════
do
	local autoContent = _G.FlyOnionTabs.Auto

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

	local function onAutoCollectToggle()
		autoCollectAutoEnabled = not autoCollectAutoEnabled
		if autoCollectAutoEnabled then
			autoCollectButton.BackgroundColor3 = C.ON
			autoCollectButton.Text = "ON"
			addStroke(autoCollectButton, Color3.fromRGB(30, 210, 90), 1)
			autoCollectConnection = task.spawn(function()
				while autoCollectAutoEnabled do
					pcall(function()
						local username = player.Name
						local basesFolder = workspace:FindFirstChild("Bases")
						if not basesFolder then return end
						local plot = basesFolder:FindFirstChild("Plot_" .. username)
						if not plot then return end
						local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
						for floorNum = 1, 14 do
							local floor = plot:FindFirstChild("Floor" .. tostring(floorNum))
							if floor then
								local slots = floor:FindFirstChild("Slots")
								if slots then
									for _, slot in ipairs(slots:GetChildren()) do
										pcall(function()
											local buttonTop = slot:FindFirstChild("Button.Top")
											if buttonTop and hrp then
												firetouchinterest(buttonTop, hrp, 0)
												firetouchinterest(buttonTop, hrp, 1)
												for _, pp in ipairs(slot:GetDescendants()) do
													if pp:IsA("ProximityPrompt") then
														pcall(function() fireproximityprompt(pp) end)
													end
												end
											end
										end)
									end
								end
							end
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
			if autoCollectConnection then
				task.cancel(autoCollectConnection)
				autoCollectConnection = nil
			end
		end
	end

	autoCollectButton.MouseButton1Click:Connect(onAutoCollectToggle)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 20: AUTO TAB - AUTO BUY SPEED (ISOLATED)     ║
-- ═══════════════════════════════════════════════════════════
do
	local autoContent = _G.FlyOnionTabs.Auto

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

	local speedToggleButton = Instance.new("TextButton")
	speedToggleButton.Size = UDim2.new(0, 72, 0, 30)
	speedToggleButton.Position = UDim2.new(1, -84, 0.5, -15)
	speedToggleButton.BackgroundColor3 = C.OFF
	speedToggleButton.BorderSizePixel = 0
	speedToggleButton.Text = "OFF"
	speedToggleButton.TextColor3 = C.TEXT
	speedToggleButton.TextSize = 13
	speedToggleButton.Font = Enum.Font.GothamBold
	speedToggleButton.Parent = autoBuySpeedFrame
	addStroke(speedToggleButton, Color3.fromRGB(200, 40, 70), 1)
	local speedToggleButtonCorner = Instance.new("UICorner")
	speedToggleButtonCorner.CornerRadius = UDim.new(0, 7)
	speedToggleButtonCorner.Parent = speedToggleButton

	local autoBuySpeedEnabled = false
	local autoBuySpeedThread = nil

	local function onAutoBuySpeedToggle()
		autoBuySpeedEnabled = not autoBuySpeedEnabled
		if autoBuySpeedEnabled then
			speedToggleButton.BackgroundColor3 = C.ON
			speedToggleButton.Text = "ON"
			addStroke(speedToggleButton, Color3.fromRGB(30, 210, 90), 1)
			autoBuySpeedThread = task.spawn(function()
				while autoBuySpeedEnabled do
					pcall(function()
						ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuySpeed"):FireServer()
					end)
					local cd = tonumber(speedCooldownBox.Text) or 1
					task.wait(math.max(0.1, cd))
				end
			end)
		else
			speedToggleButton.BackgroundColor3 = C.OFF
			speedToggleButton.Text = "OFF"
			addStroke(speedToggleButton, Color3.fromRGB(200, 40, 70), 1)
			if autoBuySpeedThread then
				task.cancel(autoBuySpeedThread)
				autoBuySpeedThread = nil
			end
		end
	end

	speedToggleButton.MouseButton1Click:Connect(onAutoBuySpeedToggle)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 21: TELEPORT TAB (SIMPLIFIED)                ║
-- ═══════════════════════════════════════════════════════════
do
	local teleportContent = _G.FlyOnionTabs.Teleport

	local teleportLocations = {
		{"🏠  Spawn", Vector3.new(0, 5, 0)},
		{"⛩  Shop", Vector3.new(100, 5, 100)},
		{"🏢  Tower", Vector3.new(-100, 5, -100)},
		{"🌲  Forest", Vector3.new(200, 5, 200)},
	}

	for i, loc in ipairs(teleportLocations) do
		local tpButton = Instance.new("TextButton")
		tpButton.Name = "TeleportButton" .. i
		tpButton.Size = UDim2.new(1, 0, 0, 42)
		tpButton.BackgroundColor3 = C.PANEL
		tpButton.BorderSizePixel = 0
		tpButton.Text = loc[1]
		tpButton.TextColor3 = C.TEXT
		tpButton.TextSize = 14
		tpButton.Font = Enum.Font.Gotham
		tpButton.TextXAlignment = Enum.TextXAlignment.Left
		tpButton.Parent = teleportContent
		addStroke(tpButton, C.BORDER, 1)

		local tpCorner = Instance.new("UICorner")
		tpCorner.CornerRadius = UDim.new(0, 9)
		tpCorner.Parent = tpButton

		local tpPadding = Instance.new("UIPadding")
		tpPadding.PaddingLeft = UDim.new(0, 15)
		tpPadding.Parent = tpButton

		local targetPos = loc[2]
		local function onTeleportClick()
			pcall(function()
				local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					hrp.CFrame = CFrame.new(targetPos)
				end
			end)
		end

		tpButton.MouseButton1Click:Connect(onTeleportClick)
	end
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 22: MISC TAB - HELPER FUNCTIONS              ║
-- ═══════════════════════════════════════════════════════════
local function createMiscButton(parent, text, color, order, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 42)
	btn.BackgroundColor3 = color or C.PANEL
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = C.TEXT
	btn.TextSize = 13
	btn.Font = Enum.Font.Gotham
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.LayoutOrder = order
	btn.Parent = parent
	addStroke(btn, C.BORDER, 1)
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 9)
	bc.Parent = btn
	local bp = Instance.new("UIPadding")
	bp.PaddingLeft = UDim.new(0, 15)
	bp.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
	
	return btn
end

local function createMiscToggle(parent, labelText, order, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 44)
	row.BackgroundColor3 = C.PANEL
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	addStroke(row, C.BORDER, 1)
	local rc = Instance.new("UICorner")
	rc.CornerRadius = UDim.new(0, 9)
	rc.Parent = row
	
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 260, 1, 0)
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
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 7)
	bc.Parent = btn
	
	local enabled = false
	local function onToggle()
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
	end
	
	btn.MouseButton1Click:Connect(onToggle)
	
	return row, btn
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 23: MISC TAB - REMOVE VIP WALLS              ║
-- ═══════════════════════════════════════════════════════════
do
	local miscContent = _G.FlyOnionTabs.Misc
	
	createMiscButton(miscContent, "🚫  Remove VIP Walls", Color3.fromRGB(25, 15, 50), 2, function()
		local vipParts = workspace:FindFirstChild("VIP_Parts")
		if vipParts then
			for _, v in ipairs(vipParts:GetChildren()) do
				pcall(function() v:Destroy() end)
			end
		end
	end)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 24: MISC TAB - AUTO REVIVE (ISOLATED)        ║
-- ═══════════════════════════════════════════════════════════
do
	local miscContent = _G.FlyOnionTabs.Misc
	local lastDeathCF = nil
	local autoReviveEnabled = false

	local function setupDeathTracker(char)
		local humanoid = char:WaitForChild("Humanoid")
		local hrp = char:WaitForChild("HumanoidRootPart")
		
		local function onDeath()
			lastDeathCF = hrp.CFrame
		end
		
		humanoid.Died:Connect(onDeath)
	end

	if player.Character then
		setupDeathTracker(player.Character)
	end

	player.CharacterAdded:Connect(function(char)
		task.spawn(function()
			setupDeathTracker(char)
			if autoReviveEnabled and lastDeathCF then
				local targetCF = lastDeathCF
				local hrp = char:WaitForChild("HumanoidRootPart", 10)
				local humanoid = char:WaitForChild("Humanoid", 10)
				if not hrp or not humanoid then return end
				local timeout = 0
				repeat
					task.wait(0.1)
					timeout = timeout + 0.1
				until (humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead) or timeout >= 10
				task.wait(0.2)
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
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 25: MISC TAB - FLY SPEED (ISOLATED)          ║
-- ═══════════════════════════════════════════════════════════
do
	local miscContent = _G.FlyOnionTabs.Misc

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
	
	local function onFlySpeedToggle()
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
			if flySpeedThread then
				task.cancel(flySpeedThread)
				flySpeedThread = nil
			end
		end
	end
	
	flySpeedToggleBtn.MouseButton1Click:Connect(onFlySpeedToggle)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 26: MISC TAB - INFINITE STAMINA (ISOLATED)   ║
-- ═══════════════════════════════════════════════════════════
do
	local miscContent = _G.FlyOnionTabs.Misc
	local infStaminaThread = nil
	
	local _, infStaminaBtn = createMiscToggle(miscContent, "♾  Infinite Stamina", 7, function(state)
		if state then
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
			infStaminaThread = task.spawn(function()
				while true do
					pcall(function()
						player:SetAttribute("Stamina", 100)
					end)
					task.wait(0.5)
				end
			end)
		else
			if infStaminaThread then
				task.cancel(infStaminaThread)
				infStaminaThread = nil
			end
		end
	end)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 27: UI TAB - SCALE SYSTEM (ISOLATED)         ║
-- ═══════════════════════════════════════════════════════════
do
	local uiContent = _G.FlyOnionTabs.UI

	local scaleFrame = Instance.new("Frame")
	scaleFrame.Size = UDim2.new(1, 0, 0, 52)
	scaleFrame.BackgroundColor3 = C.PANEL
	scaleFrame.BorderSizePixel = 0
	scaleFrame.LayoutOrder = 4
	scaleFrame.Parent = uiContent
	addStroke(scaleFrame, C.BORDER, 1)
	local scaleFc = Instance.new("UICorner")
	scaleFc.CornerRadius = UDim.new(0, 9)
	scaleFc.Parent = scaleFrame

	local scaleLbl = Instance.new("TextLabel")
	scaleLbl.Size = UDim2.new(0, 120, 1, 0)
	scaleLbl.Position = UDim2.new(0, 14, 0, 0)
	scaleLbl.BackgroundTransparency = 1
	scaleLbl.Text = "GUI Scale: M"
	scaleLbl.TextColor3 = C.TEXT
	scaleLbl.TextSize = 13
	scaleLbl.Font = Enum.Font.Gotham
	scaleLbl.TextXAlignment = Enum.TextXAlignment.Left
	scaleLbl.Parent = scaleFrame

	local scaleLabels = {"XS", "S", "M", "L", "XL"}
	local scaleDesktopSizes = {
		UDim2.new(0, 544, 0, 365),
		UDim2.new(0, 592, 0, 397),
		UDim2.new(0, 640, 0, 430),
		UDim2.new(0, 736, 0, 495),
		UDim2.new(0, 832, 0, 559),
	}
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
		local sbc = Instance.new("UICorner")
		sbc.CornerRadius = UDim.new(0, 6)
		sbc.Parent = sb
		scaleButtons[i] = sb
		
		local function onScaleClick()
			for j, b in ipairs(scaleButtons) do
				b.BackgroundColor3 = j == i and C.ACCENT or C.BG3
			end
			scaleLbl.Text = "GUI Scale: " .. s
			if not _G.FlyOnionMinimize.isMinimized() then
				mainFrame.Size = scaleSizes[i]
				_G.FlyOnionMinimize.setOriginalSize(scaleSizes[i])
			end
		end
		
		sb.MouseButton1Click:Connect(onScaleClick)
	end
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 28: UI TAB - WATERMARK TOGGLE (ISOLATED)     ║
-- ═══════════════════════════════════════════════════════════
do
	local uiContent = _G.FlyOnionTabs.UI

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
	
	local function onWatermarkToggle()
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
	
	wmBtn.MouseButton1Click:Connect(onWatermarkToggle)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 29: UI TAB - DESTROY GUI BUTTON              ║
-- ═══════════════════════════════════════════════════════════
do
	local uiContent = _G.FlyOnionTabs.UI

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
	
	local function onDestroyClick()
		screenGui:Destroy()
	end
	
	destroyGuiBtn.MouseButton1Click:Connect(onDestroyClick)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 30: KEY VALIDATION LOGIC (ISOLATED)          ║
-- ═══════════════════════════════════════════════════════════
do
	local function validateKey()
		local enteredKey = keyInput.Text

		if enteredKey == CORRECT_KEY then
			statusLabel.TextColor3 = C.ON
			statusLabel.Text = "✓ Key Accepted! Loading..."

			saveKey()

			customWait(1)
			keyFrame.Visible = false
			mainFrame.Visible = true

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
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 31: ON-H BUTTON (ISOLATED)                   ║
-- ═══════════════════════════════════════════════════════════
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

	local function onONHClick()
		mainFrame.Visible = true
		onhButton.Visible = false
	end

	onhButton.MouseButton1Click:Connect(onONHClick)

	local function onCloseClick()
		mainFrame.Visible = false
		onhButton.Visible = true
	end

	closeButton.MouseButton1Click:Connect(onCloseClick)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 32: DRAGGING LOGIC (ISOLATED)                ║
-- ═══════════════════════════════════════════════════════════
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

	local function onTitleBarInputBegan(input)
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
	end

	local function onTitleBarInputChanged(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or
		   input.UserInputType == Enum.UserInputType.Touch then
			updateDrag(input.Position)
		end
	end

	local function onUserInputChanged(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
						 input.UserInputType == Enum.UserInputType.Touch) then
			updateDrag(input.Position)
		end
	end

	titleBar.InputBegan:Connect(onTitleBarInputBegan)
	titleBar.InputChanged:Connect(onTitleBarInputChanged)
	UserInputService.InputChanged:Connect(onUserInputChanged)
end

-- ═══════════════════════════════════════════════════════════
-- ║  SECTION 33: AUTO-LOAD IF KEY IS SAVED                ║
-- ═══════════════════════════════════════════════════════════
if isKeySaved() then
	keyFrame.Visible = false
	mainFrame.Visible = true
	tabs["Info"].button.MouseButton1Click:Fire()
end

print("Roblox GUI Loaded Successfully!")
print("All modules isolated - register overflow FIXED!")
