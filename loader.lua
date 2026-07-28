-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- CONFIGURATION
local CorrectKey = "Crify2026" -- İstediğin hazır key'i buraya yazabilirsin
local DiscordLink = "https://discord.gg/JwuV4qV85R"

-- State Variables
local Flying = false
local Noclip = false
local FlySpeed = 50
local MinSpeed = 10
local MaxSpeed = 300

local FlyConnection = nil
local NoclipConnection = nil

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

    -- Title
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

    -- Top Right Exit Button (X)
    local ExitButton = Instance.new("TextButton")
    ExitButton.Size = UDim2.new(0, 30, 0, 30)
    ExitButton.Position = UDim2.new(1, -35, 0, 8)
    ExitButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    ExitButton.Text = "X"
    ExitButton.TextColor3 = Color3.fromRGB(255, 85, 85)
    ExitButton.TextSize = 14
    ExitButton.Font = Enum.Font.GothamBold
    ExitButton.Parent = KeyFrame

    local ExitBtnCorner = Instance.new("UICorner")
    ExitBtnCorner.CornerRadius = UDim.new(0, 6)
    ExitBtnCorner.Parent = ExitButton

    -- Centered Key Input Box
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

    -- Verify Key Button
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

    -- Discord Invite Copy Button (Under Verify Key)
    local DiscordButton = Instance.new("TextButton")
    DiscordButton.Size = UDim2.new(0.85, 0, 0, 36)
    DiscordButton.Position = UDim2.new(0.075, 0, 0.68, 0)
    DiscordButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    DiscordButton.Text = "Copy Discord Invite"
    DiscordButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    DiscordButton.TextSize = 13
    DiscordButton.Font = Enum.Font.GothamSemibold
    DiscordButton.Parent = KeyFrame

    local DiscordBtnCorner = Instance.new("UICorner")
    DiscordBtnCorner.CornerRadius = UDim.new(0, 8)
    DiscordBtnCorner.Parent = DiscordButton

    ------------------------------------------------------------------------
    -- 2. MAIN MENU FRAME
    ------------------------------------------------------------------------
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 280)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 2
    MainStroke.Color = Color3.fromRGB(90, 105, 246)
    MainStroke.Parent = MainFrame

    local MainTitle = Instance.new("TextLabel")
    MainTitle.Size = UDim2.new(1, 0, 0, 45)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = "Crify Hub [Press M To Toggle]"
    MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTitle.TextSize = 14
    MainTitle.Font = Enum.Font.GothamBold
    MainTitle.Parent = MainFrame

    local FlyButton = Instance.new("TextButton")
    FlyButton.Size = UDim2.new(0.85, 0, 0, 38)
    FlyButton.Position = UDim2.new(0.075, 0, 0.2, 0)
    FlyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    FlyButton.Text = "Fly Mode: OFF"
    FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlyButton.TextSize = 13
    FlyButton.Font = Enum.Font.GothamSemibold
    FlyButton.Parent = MainFrame

    local FlyBtnCorner = Instance.new("UICorner")
    FlyBtnCorner.CornerRadius = UDim.new(0, 8)
    FlyBtnCorner.Parent = FlyButton

    local NoclipButton = Instance.new("TextButton")
    NoclipButton.Size = UDim2.new(0.85, 0, 0, 36)
    NoclipButton.Position = UDim2.new(0.075, 0, 0.36, 0)
    NoclipButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    NoclipButton.Text = "Noclip Mode: OFF"
    NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoclipButton.TextSize = 13
    NoclipButton.Font = Enum.Font.GothamSemibold
    NoclipButton.Parent = MainFrame

    local NoclipBtnCorner = Instance.new("UICorner")
    NoclipBtnCorner.CornerRadius = UDim.new(0, 8)
    NoclipBtnCorner.Parent = NoclipButton

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0.85, 0, 0, 20)
    SpeedLabel.Position = UDim2.new(0.075, 0, 0.54, 0)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Text = "Fly Speed: " .. tostring(FlySpeed)
    SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SpeedLabel.TextSize = 12
    SpeedLabel.Font = Enum.Font.Gotham
    SpeedLabel.Parent = MainFrame

    local SliderBacking = Instance.new("Frame")
    SliderBacking.Size = UDim2.new(0.85, 0, 0, 8)
    SliderBacking.Position = UDim2.new(0.075, 0, 0.65, 0)
    SliderBacking.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    SliderBacking.BorderSizePixel = 0
    SliderBacking.Parent = MainFrame

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

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0.85, 0, 0, 36)
    CloseButton.Position = UDim2.new(0.075, 0, 0.78, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    CloseButton.Text = "Close Script"
    CloseButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    CloseButton.TextSize = 13
    CloseButton.Font = Enum.Font.GothamSemibold
    CloseButton.Parent = MainFrame

    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 8)
    CloseBtnCorner.Parent = CloseButton

    ------------------------------------------------------------------------
    -- FUNCTIONS & MECHANICS
    ------------------------------------------------------------------------

    LocalPlayer.CharacterAdded:Connect(function(Char)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
    RootPart = Char:WaitForChild("HumanoidRootPart")
    end)

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
        if not Flying or not RootPart or not RootPart:FindFirstChild("FlyVelocity") then
            return
            end

            local Camera = workspace.CurrentCamera
            local MoveVector = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                MoveVector = MoveVector + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    MoveVector = MoveVector - Camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        MoveVector = MoveVector - Camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            MoveVector = MoveVector + Camera.CFrame.RightVector
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                                MoveVector = MoveVector + Vector3.new(0, 1, 0)
                                end
                                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                                    MoveVector = MoveVector - Vector3.new(0, 1, 0)
                                    end

                                    Bv.Velocity = MoveVector * FlySpeed
                                    Bg.CFrame = Camera.CFrame
                                    end)
        else
            TweenService:Create(FlyButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
            FlyButton.Text = "Fly Mode: OFF"
            if FlyConnection then FlyConnection:Disconnect() end
                if RootPart:FindFirstChild("FlyVelocity") then RootPart.FlyVelocity:Destroy() end
                    if RootPart:FindFirstChild("FlyGyro") then RootPart.FlyGyro:Destroy() end
                        end
                        end

                        local function ToggleNoclip()
                        Noclip = not Noclip
                        if Noclip then
                            TweenService:Create(NoclipButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(90, 105, 246)}):Play()
                            NoclipButton.Text = "Noclip Mode: ON"
                            NoclipConnection = RunService.Stepped:Connect(function()
                            if Character then
                                for _, Part in pairs(Character:GetDescendants()) do
                                    if Part:IsA("BasePart") then
                                        Part.CanCollide = false
                                        end
                                        end
                                        end
                                        end)
                            else
                                TweenService:Create(NoclipButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
                                NoclipButton.Text = "Noclip Mode: OFF"
                                if NoclipConnection then NoclipConnection:Disconnect() end
                                    end
                                    end

                                    -- Slider Logic
                                    local Dragging = false
                                    local function UpdateSlider(Input)
                                    local PositionRatio = math.clamp((Input.Position.X - SliderBacking.AbsolutePosition.X) / SliderBacking.AbsoluteSize.X, 0, 1)
                                    FlySpeed = math.floor(MinSpeed + (MaxSpeed - MinSpeed) * PositionRatio)
                                    SpeedLabel.Text = "Fly Speed: " .. tostring(FlySpeed)
                                    TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(PositionRatio, 0, 1, 0)}):Play()
                                    end

                                    SliderBtn.InputBegan:Connect(function(Input)
                                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                        Dragging = true
                                        UpdateSlider(Input)
                                        end
                                        end)

                                    UserInputService.InputEnded:Connect(function(Input)
                                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                        Dragging = false
                                        end
                                        end)

                                    UserInputService.InputChanged:Connect(function(Input)
                                    if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                                        UpdateSlider(Input)
                                        end
                                        end)

                                    ------------------------------------------------------------------------
                                    -- KEY SYSTEM LOGIC
                                    ------------------------------------------------------------------------

                                    -- Verify Key Button Event
                                    VerifyButton.MouseButton1Click:Connect(function()
                                    if KeyInput.Text == CorrectKey then
                                        KeyFrame:Destroy()
                                        MainFrame.Visible = true
                                        else
                                            KeyInput.Text = ""
                                            KeyInput.PlaceholderText = "Invalid Key! Try Again."
                                            end
                                            end)

                                    -- Discord Copy Button Event
                                    DiscordButton.MouseButton1Click:Connect(function()
                                    if setclipboard then
                                        setclipboard(DiscordLink)
                                        DiscordButton.Text = "Copied To Clipboard!"
                                        task.wait(1.5)
                                        DiscordButton.Text = "Copy Discord Invite"
                                        end
                                        end)

                                    -- Exit Button Event (Closes Whole Script)
                                    ExitButton.MouseButton1Click:Connect(function()
                                    ScreenGui:Destroy()
                                    end)

                                    ------------------------------------------------------------------------
                                    -- CONNECTIONS
                                    ------------------------------------------------------------------------

                                    CloseButton.MouseButton1Click:Connect(function()
                                    if Flying then ToggleFly() end
                                        if Noclip then ToggleNoclip() end
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
