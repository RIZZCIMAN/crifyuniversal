-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- CONFIGURATION
local CorrectKey = "Crify2026"
local DiscordLink = "https://discord.gg/JwuV4qV85R"

-- State Variables
local Flying = false
local Noclip = false
local FlySpeed = 50
local MinSpeed = 10
local MaxSpeed = 300

-- ESP Settings
local BoxESP = false
local NameESP = false
local LineESP = false
local ESPColor = Color3.fromRGB(90, 105, 246)
local ESPColorsList = {
    Color3.fromRGB(90, 105, 246), -- Blue
    Color3.fromRGB(231, 76, 60),  -- Red
    Color3.fromRGB(46, 204, 113), -- Green
    Color3.fromRGB(241, 196, 15), -- Yellow
    Color3.fromRGB(155, 89, 182)  -- Purple
}
local CurrentColorIndex = 1

-- Aimbot & Aimlock Settings
local AimbotEnabled = false
local AimbotAiming = false
local AimlockTarget = nil
local FOVRadius = 120
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

local FlyConnection = nil
local NoclipConnection = nil

-- Storage for ESP Drawing objects
local ESPObjects = {}

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrifyHubGui"
ScreenGui.ResetOnSpawn = false

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

------------------------------------------------------------------------
-- 1. KEY SYSTEM FRAME
------------------------------------------------------------------------
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 320, 0, 240)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 12)
KeyCorner.Parent = KeyFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Thickness = 2
KeyStroke.Color = Color3.fromRGB(90, 105, 246)
KeyStroke.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(0.8, 0, 0, 45)
KeyTitle.Position = UDim2.new(0.05, 0, 0, 0)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "Crify Hub By NotCrix"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 15
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
KeyTitle.Parent = KeyFrame

local KeyExitButton = Instance.new("TextButton")
KeyExitButton.Size = UDim2.new(0, 30, 0, 30)
KeyExitButton.Position = UDim2.new(1, -35, 0, 8)
KeyExitButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
KeyExitButton.Text = "X"
KeyExitButton.TextColor3 = Color3.fromRGB(255, 85, 85)
KeyExitButton.TextSize = 14
KeyExitButton.Font = Enum.Font.GothamBold
KeyExitButton.Parent = KeyFrame

local KeyExitBtnCorner = Instance.new("UICorner")
KeyExitBtnCorner.CornerRadius = UDim.new(0, 6)
KeyExitBtnCorner.Parent = KeyExitButton

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.85, 0, 0, 38)
KeyInput.Position = UDim2.new(0.075, 0, 0.26, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
KeyInput.TextSize = 13
KeyInput.Font = Enum.Font.Gotham
KeyInput.Parent = KeyFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 8)
KeyInputCorner.Parent = KeyInput

local VerifyButton = Instance.new("TextButton")
VerifyButton.Size = UDim2.new(0.85, 0, 0, 36)
VerifyButton.Position = UDim2.new(0.075, 0, 0.48, 0)
VerifyButton.BackgroundColor3 = Color3.fromRGB(90, 105, 246)
VerifyButton.Text = "Verify Key"
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyButton.TextSize = 13
VerifyButton.Font = Enum.Font.GothamBold
VerifyButton.Parent = KeyFrame

local VerifyBtnCorner = Instance.new("UICorner")
VerifyBtnCorner.CornerRadius = UDim.new(0, 8)
VerifyBtnCorner.Parent = VerifyButton

local KeyDiscordButton = Instance.new("TextButton")
KeyDiscordButton.Size = UDim2.new(0.85, 0, 0, 36)
KeyDiscordButton.Position = UDim2.new(0.075, 0, 0.68, 0)
KeyDiscordButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
KeyDiscordButton.Text = "Copy Discord Invite"
KeyDiscordButton.TextColor3 = Color3.fromRGB(220, 220, 220)
KeyDiscordButton.TextSize = 13
KeyDiscordButton.Font = Enum.Font.GothamSemibold
KeyDiscordButton.Parent = KeyFrame

local KeyDiscordBtnCorner = Instance.new("UICorner")
KeyDiscordBtnCorner.CornerRadius = UDim.new(0, 8)
KeyDiscordBtnCorner.Parent = KeyDiscordButton

------------------------------------------------------------------------
-- 2. MAIN MENU FRAME
------------------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(90, 105, 246)
MainStroke.Parent = MainFrame

-- NAVBAR
local Navbar = Instance.new("Frame")
Navbar.Name = "Navbar"
Navbar.Size = UDim2.new(1, 0, 0, 40)
Navbar.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
Navbar.BorderSizePixel = 0
Navbar.Parent = MainFrame

local NavbarCorner = Instance.new("UICorner")
NavbarCorner.CornerRadius = UDim.new(0, 10)
NavbarCorner.Parent = Navbar

local NavbarTitle = Instance.new("TextLabel")
NavbarTitle.Size = UDim2.new(0.7, 0, 1, 0)
NavbarTitle.Position = UDim2.new(0.03, 0, 0, 0)
NavbarTitle.BackgroundTransparency = 1
NavbarTitle.Text = "Crify Hub By NotCrix [M: Toggle]"
NavbarTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
NavbarTitle.TextSize = 14
NavbarTitle.Font = Enum.Font.GothamBold
NavbarTitle.TextXAlignment = Enum.TextXAlignment.Left
NavbarTitle.Parent = Navbar

local MainExitButton = Instance.new("TextButton")
MainExitButton.Size = UDim2.new(0, 28, 0, 28)
MainExitButton.Position = UDim2.new(1, -34, 0, 6)
MainExitButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
MainExitButton.Text = "X"
MainExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainExitButton.TextSize = 13
MainExitButton.Font = Enum.Font.GothamBold
MainExitButton.Parent = Navbar

local MainExitCorner = Instance.new("UICorner")
MainExitCorner.CornerRadius = UDim.new(0, 6)
MainExitCorner.Parent = MainExitButton

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 4)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

-- CONTENT CONTAINER
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -135, 1, -45)
ContentContainer.Position = UDim2.new(0, 132, 0, 42)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

------------------------------------------------------------------------
-- TAB SYSTEM HELPER
------------------------------------------------------------------------
local Tabs = {}
local TabButtons = {}

local function CreateTab(name, layoutOrder)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 28)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.TextSize = 12
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.LayoutOrder = layoutOrder
    TabButton.Parent = Sidebar

    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabButton

    local TabPage = Instance.new("Frame")
    TabPage.Name = name .. "Tab"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.Parent = ContentContainer

    Tabs[name] = TabPage
    TabButtons[name] = TabButton

    TabButton.MouseButton1Click:Connect(function()
        for tabName, page in pairs(Tabs) do
            page.Visible = (tabName == name)
            if tabName == name then
                TweenService:Create(TabButtons[tabName], TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 105, 246), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                TweenService:Create(TabButtons[tabName], TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 36), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            end
        end
    end)

    return TabPage
end

-- Create Tabs
local HomeTab = CreateTab("Home", 1)
local MovementTab = CreateTab("Movement", 2)
local ESPTab = CreateTab("ESP", 3)
local TeleportTab = CreateTab("Teleport", 4)
local CombatTab = CreateTab("Combat", 5)
local PlayerTab = CreateTab("Player", 6)
local SettingsTab = CreateTab("Settings", 7)
local MiscTab = CreateTab("Misc", 8)

HomeTab.Visible = true
TabButtons["Home"].BackgroundColor3 = Color3.fromRGB(90, 105, 246)
TabButtons["Home"].TextColor3 = Color3.fromRGB(255, 255, 255)

------------------------------------------------------------------------
-- TAB CONTENTS
------------------------------------------------------------------------

-- 1. HOME TAB
local HomeTitle = Instance.new("TextLabel")
HomeTitle.Size = UDim2.new(1, -10, 0, 25)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Text = "Welcome To Crify Hub!"
HomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeTitle.TextSize = 15
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.TextXAlignment = Enum.TextXAlignment.Left
HomeTitle.Parent = HomeTab

local MainDiscordBtn = Instance.new("TextButton")
MainDiscordBtn.Size = UDim2.new(0.95, 0, 0, 35)
MainDiscordBtn.Position = UDim2.new(0, 0, 0, 35)
MainDiscordBtn.BackgroundColor3 = Color3.fromRGB(90, 105, 246)
MainDiscordBtn.Text = "Copy Discord Invite"
MainDiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainDiscordBtn.TextSize = 13
MainDiscordBtn.Font = Enum.Font.GothamBold
MainDiscordBtn.Parent = HomeTab

local MainDiscordCorner = Instance.new("UICorner")
MainDiscordCorner.CornerRadius = UDim.new(0, 6)
MainDiscordCorner.Parent = MainDiscordBtn

local UpdatesBox = Instance.new("Frame")
UpdatesBox.Size = UDim2.new(0.95, 0, 0, 190)
UpdatesBox.Position = UDim2.new(0, 0, 0, 80)
UpdatesBox.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
UpdatesBox.Parent = HomeTab

local UpdatesCorner = Instance.new("UICorner")
UpdatesCorner.CornerRadius = UDim.new(0, 6)
UpdatesCorner.Parent = UpdatesBox

local UpdatesLabel = Instance.new("TextLabel")
UpdatesLabel.Size = UDim2.new(0.9, 0, 0.9, 0)
UpdatesLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
UpdatesLabel.BackgroundTransparency = 1
UpdatesLabel.Text = "Recent Updates:\n\n• Added R-Key Toggle Aimlock\n• Added Right-Click Hold Aimbot\n• Added Square 2D Box ESP\n• Added Name/Distance & Tracer Lines\n• Dynamic Target Locking Indicator"
UpdatesLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
UpdatesLabel.TextSize = 12
UpdatesLabel.Font = Enum.Font.Gotham
UpdatesLabel.TextYAlignment = Enum.TextYAlignment.Top
UpdatesLabel.TextXAlignment = Enum.TextXAlignment.Left
UpdatesLabel.Parent = UpdatesBox

-- 2. MOVEMENT TAB
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0.95, 0, 0, 36)
FlyButton.Position = UDim2.new(0, 0, 0, 10)
FlyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
FlyButton.Text = "Fly Mode: OFF"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 13
FlyButton.Font = Enum.Font.GothamSemibold
FlyButton.Parent = MovementTab

local FlyBtnCorner = Instance.new("UICorner")
FlyBtnCorner.CornerRadius = UDim.new(0, 6)
FlyBtnCorner.Parent = FlyButton

local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(0.95, 0, 0, 36)
NoclipButton.Position = UDim2.new(0, 0, 0, 55)
NoclipButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
NoclipButton.Text = "Noclip Mode: OFF"
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.TextSize = 13
NoclipButton.Font = Enum.Font.GothamSemibold
NoclipButton.Parent = MovementTab

local NoclipBtnCorner = Instance.new("UICorner")
NoclipBtnCorner.CornerRadius = UDim.new(0, 6)
NoclipBtnCorner.Parent = NoclipButton

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.95, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 105)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Fly Speed: " .. tostring(FlySpeed)
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextSize = 12
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MovementTab

local SliderBacking = Instance.new("Frame")
SliderBacking.Size = UDim2.new(0.95, 0, 0, 8)
SliderBacking.Position = UDim2.new(0, 0, 0, 130)
SliderBacking.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
SliderBacking.BorderSizePixel = 0
SliderBacking.Parent = MovementTab

local SliderBackingCorner = Instance.new("UICorner")
SliderBackingCorner.CornerRadius = UDim.new(1, 0)
SliderBackingCorner.Parent = SliderBacking

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((FlySpeed - MinSpeed) / (MaxSpeed - MinSpeed), 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(90, 105, 246)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBacking

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local SliderBtn = Instance.new("TextButton")
SliderBtn.Size = UDim2.new(1, 0, 1, 0)
SliderBtn.BackgroundTransparency = 1
SliderBtn.Text = ""
SliderBtn.Parent = SliderBacking

-- 3. ESP TAB
local BoxESPButton = Instance.new("TextButton")
BoxESPButton.Size = UDim2.new(0.95, 0, 0, 34)
BoxESPButton.Position = UDim2.new(0, 0, 0, 10)
BoxESPButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
BoxESPButton.Text = "Box ESP: OFF"
BoxESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BoxESPButton.TextSize = 12
BoxESPButton.Font = Enum.Font.GothamSemibold
BoxESPButton.Parent = ESPTab

local BoxESPBtnCorner = Instance.new("UICorner")
BoxESPBtnCorner.CornerRadius = UDim.new(0, 6)
BoxESPBtnCorner.Parent = BoxESPButton

local NameESPButton = Instance.new("TextButton")
NameESPButton.Size = UDim2.new(0.95, 0, 0, 34)
NameESPButton.Position = UDim2.new(0, 0, 0, 50)
NameESPButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
NameESPButton.Text = "Name ESP: OFF"
NameESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NameESPButton.TextSize = 12
NameESPButton.Font = Enum.Font.GothamSemibold
NameESPButton.Parent = ESPTab

local NameESPBtnCorner = Instance.new("UICorner")
NameESPBtnCorner.CornerRadius = UDim.new(0, 6)
NameESPBtnCorner.Parent = NameESPButton

local LineESPButton = Instance.new("TextButton")
LineESPButton.Size = UDim2.new(0.95, 0, 0, 34)
LineESPButton.Position = UDim2.new(0, 0, 0, 90)
LineESPButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
LineESPButton.Text = "Tracer Lines: OFF"
LineESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LineESPButton.TextSize = 12
LineESPButton.Font = Enum.Font.GothamSemibold
LineESPButton.Parent = ESPTab

local LineESPBtnCorner = Instance.new("UICorner")
LineESPBtnCorner.CornerRadius = UDim.new(0, 6)
LineESPBtnCorner.Parent = LineESPButton

local ColorPickerButton = Instance.new("TextButton")
ColorPickerButton.Size = UDim2.new(0.95, 0, 0, 34)
ColorPickerButton.Position = UDim2.new(0, 0, 0, 130)
ColorPickerButton.BackgroundColor3 = ESPColor
ColorPickerButton.Text = "Change ESP Color"
ColorPickerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorPickerButton.TextSize = 12
ColorPickerButton.Font = Enum.Font.GothamBold
ColorPickerButton.Parent = ESPTab

local ColorPickerCorner = Instance.new("UICorner")
ColorPickerCorner.CornerRadius = UDim.new(0, 6)
ColorPickerCorner.Parent = ColorPickerButton

-- 4. TELEPORT TAB
local SelectedPlayer = nil

local RefreshPlayersBtn = Instance.new("TextButton")
RefreshPlayersBtn.Size = UDim2.new(0.95, 0, 0, 32)
RefreshPlayersBtn.Position = UDim2.new(0, 0, 0, 10)
RefreshPlayersBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
RefreshPlayersBtn.Text = "Refresh Player List"
RefreshPlayersBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
RefreshPlayersBtn.TextSize = 12
RefreshPlayersBtn.Font = Enum.Font.GothamSemibold
RefreshPlayersBtn.Parent = TeleportTab

local RefreshBtnCorner = Instance.new("UICorner")
RefreshBtnCorner.CornerRadius = UDim.new(0, 6)
RefreshBtnCorner.Parent = RefreshPlayersBtn

local DropdownButton = Instance.new("TextButton")
DropdownButton.Size = UDim2.new(0.95, 0, 0, 36)
DropdownButton.Position = UDim2.new(0, 0, 0, 50)
DropdownButton.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
DropdownButton.Text = "Select Player..."
DropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
DropdownButton.TextSize = 12
DropdownButton.Font = Enum.Font.Gotham
DropdownButton.Parent = TeleportTab

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 6)
DropdownCorner.Parent = DropdownButton

local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0.95, 0, 0, 120)
PlayerListFrame.Position = UDim2.new(0, 0, 0, 90)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
PlayerListFrame.Visible = false
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListFrame.ScrollBarThickness = 4
PlayerListFrame.Parent = TeleportTab

local PlayerListCorner = Instance.new("UICorner")
PlayerListCorner.CornerRadius = UDim.new(0, 6)
PlayerListCorner.Parent = PlayerListFrame

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Parent = PlayerListFrame

local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Size = UDim2.new(0.95, 0, 0, 36)
TeleportBtn.Position = UDim2.new(0, 0, 0, 220)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(90, 105, 246)
TeleportBtn.Text = "Teleport To Player"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.TextSize = 13
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.Parent = TeleportTab

local TeleportBtnCorner = Instance.new("UICorner")
TeleportBtnCorner.CornerRadius = UDim.new(0, 6)
TeleportBtnCorner.Parent = TeleportBtn

-- 5. COMBAT TAB (Aimbot & Aimlock)
local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Size = UDim2.new(0.95, 0, 0, 36)
AimbotBtn.Position = UDim2.new(0, 0, 0, 10)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
AimbotBtn.Text = "Aimbot System: OFF"
AimbotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotBtn.TextSize = 12
AimbotBtn.Font = Enum.Font.GothamSemibold
AimbotBtn.Parent = CombatTab

local AimbotBtnCorner = Instance.new("UICorner")
AimbotBtnCorner.CornerRadius = UDim.new(0, 6)
AimbotBtnCorner.Parent = AimbotBtn

local AimlockInfoLabel = Instance.new("TextLabel")
AimlockInfoLabel.Size = UDim2.new(0.95, 0, 0, 20)
AimlockInfoLabel.Position = UDim2.new(0, 0, 0, 52)
AimlockInfoLabel.BackgroundTransparency = 1
AimlockInfoLabel.Text = "Hold Right Click OR Press 'R' To Lock"
AimlockInfoLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
AimlockInfoLabel.TextSize = 11
AimlockInfoLabel.Font = Enum.Font.Gotham
AimlockInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
AimlockInfoLabel.Parent = CombatTab

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(0.95, 0, 0, 20)
FOVLabel.Position = UDim2.new(0, 0, 0, 80)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "Aimbot FOV Radius: " .. tostring(FOVRadius)
FOVLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FOVLabel.TextSize = 12
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Parent = CombatTab

local FOVSliderBacking = Instance.new("Frame")
FOVSliderBacking.Size = UDim2.new(0.95, 0, 0, 8)
FOVSliderBacking.Position = UDim2.new(0, 0, 0, 105)
FOVSliderBacking.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
FOVSliderBacking.BorderSizePixel = 0
FOVSliderBacking.Parent = CombatTab

local FOVSliderBackingCorner = Instance.new("UICorner")
FOVSliderBackingCorner.CornerRadius = UDim.new(1, 0)
FOVSliderBackingCorner.Parent = FOVSliderBacking

local FOVSliderFill = Instance.new("Frame")
FOVSliderFill.Size = UDim2.new(FOVRadius / 300, 0, 1, 0)
FOVSliderFill.BackgroundColor3 = Color3.fromRGB(90, 105, 246)
FOVSliderFill.BorderSizePixel = 0
FOVSliderFill.Parent = FOVSliderBacking

local FOVSliderFillCorner = Instance.new("UICorner")
FOVSliderFillCorner.CornerRadius = UDim.new(1, 0)
FOVSliderFillCorner.Parent = FOVSliderBacking

local FOVSliderBtn = Instance.new("TextButton")
FOVSliderBtn.Size = UDim2.new(1, 0, 1, 0)
FOVSliderBtn.BackgroundTransparency = 1
FOVSliderBtn.Text = ""
FOVSliderBtn.Parent = FOVSliderBacking

-- Placeholder Pages
for _, name in ipairs({"Player", "Settings", "Misc"}) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = name .. " Features Coming Soon..."
    label.TextColor3 = Color3.fromRGB(150, 150, 150)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.Parent = Tabs[name]
end

------------------------------------------------------------------------
-- FUNCTIONS & MECHANICS
------------------------------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function(Char)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
    RootPart = Char:WaitForChild("HumanoidRootPart")
end)

-- Fly Function
local function ToggleFly()
    Flying = not Flying
    if Flying then
        TweenService:Create(FlyButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(90, 105, 246)}):Play()
        FlyButton.Text = "Fly Mode: ON"
        
        local Bv = Instance.new("BodyVelocity")
        Bv.Name = "FlyVelocity"
        Bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
        Bv.Velocity = Vector3.new(0, 0, 0)
        Bv.Parent = RootPart

        local Bg = Instance.new("BodyGyro")
        Bg.Name = "FlyGyro"
        Bg.MaxTorque = Vector3.new(1, 1, 1) * math.huge
        Bg.P = 9e4
        Bg.CFrame = RootPart.CFrame
        Bg.Parent = RootPart

        FlyConnection = RunService.RenderStepped:Connect(function()
            if not Flying or not RootPart or not RootPart:FindFirstChild("FlyVelocity") then return end
            local MoveVector = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveVector = MoveVector + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveVector = MoveVector - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveVector = MoveVector - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveVector = MoveVector + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then MoveVector = MoveVector + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then MoveVector = MoveVector - Vector3.new(0, 1, 0) end

            Bv.Velocity = MoveVector * FlySpeed
            Bg.CFrame = Camera.CFrame
        end)
    else
        TweenService:Create(FlyButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}):Play()
        FlyButton.Text = "Fly Mode: OFF"
        if FlyConnection then FlyConnection:Disconnect() end
        if RootPart:FindFirstChild("FlyVelocity") then RootPart.FlyVelocity:Destroy() end
        if RootPart:FindFirstChild("FlyGyro") then RootPart.FlyGyro:Destroy() end
    end
end

-- Noclip Function
local function ToggleNoclip()
    Noclip = not Noclip
    if Noclip then
        TweenService:Create(NoclipButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(90, 105, 246)}):Play()
        NoclipButton.Text = "Noclip Mode: ON"
        NoclipConnection = RunService.Stepped:Connect(function()
            if Character then
                for _, Part in pairs(Character:GetDescendants()) do
                    if Part:IsA("BasePart") then Part.CanCollide = false end
                end
            end
        end)
    else
        TweenService:Create(NoclipButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}):Play()
        NoclipButton.Text = "Noclip Mode: OFF"
        if NoclipConnection then NoclipConnection:Disconnect() end
    end
end

-- Fly Speed Slider Logic
local Dragging = false
local function UpdateSlider(Input)
    local PositionRatio = math.clamp((Input.Position.X - SliderBacking.AbsolutePosition.X) / SliderBacking.AbsoluteSize.X, 0, 1)
    FlySpeed = math.floor(MinSpeed + (MaxSpeed - MinSpeed) * PositionRatio)
    SpeedLabel.Text = "Fly Speed: " .. tostring(FlySpeed)
    TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(PositionRatio, 0, 1, 0)}):Play()
end

SliderBtn.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true UpdateSlider(Input) end
end)
UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
end)
UserInputService.InputChanged:Connect(function(Input)
    if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(Input) end
end)

-- FOV Slider Logic
local FOVDragging = false
local function UpdateFOVSlider(Input)
    local PositionRatio = math.clamp((Input.Position.X - FOVSliderBacking.AbsolutePosition.X) / FOVSliderBacking.AbsoluteSize.X, 0, 1)
    FOVRadius = math.floor(30 + (300 - 30) * PositionRatio)
    FOVLabel.Text = "Aimbot FOV Radius: " .. tostring(FOVRadius)
    FOVCircle.Radius = FOVRadius
    TweenService:Create(FOVSliderFill, TweenInfo.new(0.1), {Size = UDim2.new(PositionRatio, 0, 1, 0)}):Play()
end

FOVSliderBtn.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then FOVDragging = true UpdateFOVSlider(Input) end
end)
UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then FOVDragging = false end
end)
UserInputService.InputChanged:Connect(function(Input)
    if FOVDragging and Input.UserInputType == Enum.UserInputType.MouseMovement then UpdateFOVSlider(Input) end
end)

------------------------------------------------------------------------
-- DRAWING ESP SYSTEM (Box, Name, Lines)
------------------------------------------------------------------------

local function CreateESP(plr)
    local Box = Drawing.new("Square")
    Box.Thickness = 1.5
    Box.Filled = false
    Box.Visible = false

    local Name = Drawing.new("Text")
    Name.Size = 13
    Name.Center = true
    Name.Outline = true
    Name.Visible = false

    local Line = Drawing.new("Line")
    Line.Thickness = 1.5
    Line.Visible = false

    ESPObjects[plr] = {Box = Box, Name = Name, Line = Line}
end

local function RemoveESP(plr)
    if ESPObjects[plr] then
        ESPObjects[plr].Box:Remove()
        ESPObjects[plr].Name:Remove()
        ESPObjects[plr].Line:Remove()
        ESPObjects[plr] = nil
    end
end

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then CreateESP(plr) end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then CreateESP(plr) end
end)

Players.PlayerRemoving:Connect(function(plr)
    RemoveESP(plr)
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Visible = AimbotEnabled

    for plr, esp in pairs(ESPObjects) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local hrp = plr.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local head = plr.Character:FindFirstChild("Head")
                local headPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or pos
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 1.5

                if BoxESP then
                    esp.Box.Size = Vector2.new(width, height)
                    esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                    esp.Box.Color = ESPColor
                    esp.Box.Visible = true
                else
                    esp.Box.Visible = false
                end

                if NameESP then
                    esp.Name.Text = plr.DisplayName .. " [" .. math.floor((hrp.Position - RootPart.Position).Magnitude) .. "m]"
                    esp.Name.Position = Vector2.new(pos.X, pos.Y - height / 2 - 16)
                    esp.Name.Color = Color3.fromRGB(255, 255, 255)
                    esp.Name.Visible = true
                else
                    esp.Name.Visible = false
                end

                if LineESP then
                    esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.Line.To = Vector2.new(pos.X, pos.Y + height / 2)
                    esp.Line.Color = ESPColor
                    esp.Line.Visible = true
                else
                    esp.Line.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Line.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Line.Visible = false
        end
    end
end)

------------------------------------------------------------------------
-- AIMBOT & AIMLOCK LOGIC
------------------------------------------------------------------------

local function GetClosestPlayer()
    local closest = nil
    local shortestDist = FOVRadius
    local mouseLoc = UserInputService:GetMouseLocation()

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mouseLoc).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

-- Key & Mouse Inputs for Aimbot/Aimlock
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimbotAiming = true
    elseif input.KeyCode == Enum.KeyCode.R and AimbotEnabled then
        if AimlockTarget then
            AimlockTarget = nil
            AimlockInfoLabel.Text = "Hold Right Click OR Press 'R' To Lock"
            AimlockInfoLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
        else
            local target = GetClosestPlayer()
            if target then
                AimlockTarget = target
                AimlockInfoLabel.Text = "Locked On: " .. target.DisplayName
                AimlockInfoLabel.TextColor3 = Color3.fromRGB(90, 105, 246)
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimbotAiming = false
    end
end)

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        -- 1. Aimlock Mode (R Key)
        if AimlockTarget then
            if AimlockTarget.Character and AimlockTarget.Character:FindFirstChild("Head") and AimlockTarget.Character:FindFirstChild("Humanoid") and AimlockTarget.Character.Humanoid.Health > 0 then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, AimlockTarget.Character.Head.Position)
            else
                AimlockTarget = nil
                AimlockInfoLabel.Text = "Hold Right Click OR Press 'R' To Lock"
                AimlockInfoLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
            end
        -- 2. Mouse Aim Mode (Right Click)
        elseif AimbotAiming then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            end
        end
    end
end)

------------------------------------------------------------------------
-- CONNECTIONS & BUTTON EVENTS
------------------------------------------------------------------------

-- ESP Toggles
BoxESPButton.MouseButton1Click:Connect(function()
    BoxESP = not BoxESP
    BoxESPButton.Text = "Box ESP: " .. (BoxESP and "ON" or "OFF")
    TweenService:Create(BoxESPButton, TweenInfo.new(0.3), {BackgroundColor3 = BoxESP and Color3.fromRGB(90, 105, 246) or Color3.fromRGB(30, 30, 36)}):Play()
end)

NameESPButton.MouseButton1Click:Connect(function()
    NameESP = not NameESP
    NameESPButton.Text = "Name ESP: " .. (NameESP and "ON" or "OFF")
    TweenService:Create(NameESPButton, TweenInfo.new(0.3), {BackgroundColor3 = NameESP and Color3.fromRGB(90, 105, 246) or Color3.fromRGB(30, 30, 36)}):Play()
end)

LineESPButton.MouseButton1Click:Connect(function()
    LineESP = not LineESP
    LineESPButton.Text = "Tracer Lines: " .. (LineESP and "ON" or "OFF")
    TweenService:Create(LineESPButton, TweenInfo.new(0.3), {BackgroundColor3 = LineESP and Color3.fromRGB(90, 105, 246) or Color3.fromRGB(30, 30, 36)}):Play()
end)

ColorPickerButton.MouseButton1Click:Connect(function()
    CurrentColorIndex = (CurrentColorIndex % #ESPColorsList) + 1
    ESPColor = ESPColorsList[CurrentColorIndex]
    ColorPickerButton.BackgroundColor3 = ESPColor
end)

-- Aimbot Toggle
AimbotBtn.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotBtn.Text = "Aimbot System: " .. (AimbotEnabled and "ON" or "OFF")
    if not AimbotEnabled then
        AimlockTarget = nil
        AimlockInfoLabel.Text = "Hold Right Click OR Press 'R' To Lock"
        AimlockInfoLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    end
    TweenService:Create(AimbotBtn, TweenInfo.new(0.3), {BackgroundColor3 = AimbotEnabled and Color3.fromRGB(90, 105, 246) or Color3.fromRGB(30, 30, 36)}):Play()
end)

-- Teleport Logic
local function PopulatePlayers()
    for _, child in pairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local count = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            count = count + 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
            btn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            btn.TextSize = 11
            btn.Font = Enum.Font.Gotham
            btn.Parent = PlayerListFrame

            btn.MouseButton1Click:Connect(function()
                SelectedPlayer = plr
                DropdownButton.Text = "Selected: " .. plr.DisplayName
                PlayerListFrame.Visible = false
            end)
        end
    end
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 25)
end

RefreshPlayersBtn.MouseButton1Click:Connect(PopulatePlayers)
DropdownButton.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then PopulatePlayers() end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if Character and RootPart then
            RootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

-- Key System & Exit Connections
VerifyButton.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyFrame:Destroy()
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Invalid Key!"
    end
end)

local function CopyDiscord(btn)
    if setclipboard then
        setclipboard(DiscordLink)
        btn.Text = "Copied!"
        task.wait(1.5)
        btn.Text = "Copy Discord Invite"
    end
end

KeyDiscordButton.MouseButton1Click:Connect(function() CopyDiscord(KeyDiscordButton) end)
MainDiscordBtn.MouseButton1Click:Connect(function() CopyDiscord(MainDiscordBtn) end)

KeyExitButton.MouseButton1Click:Connect(function()
    FOVCircle:Remove()
    ScreenGui:Destroy()
end)

MainExitButton.MouseButton1Click:Connect(function()
    if Flying then ToggleFly() end
    if Noclip then ToggleNoclip() end
    FOVCircle:Remove()
    for plr in pairs(ESPObjects) do RemoveESP(plr) end
    ScreenGui:Destroy()
end)

FlyButton.MouseButton1Click:Connect(ToggleFly)
NoclipButton.MouseButton1Click:Connect(ToggleNoclip)

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.M then
        if MainFrame and MainFrame.Parent and MainFrame.Visible then
            MainFrame.Visible = false
        elseif MainFrame and MainFrame.Parent and not KeyFrame.Parent then
            MainFrame.Visible = true
        end
    end
end)
