local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "0% Fluffy Hair Universal Script",
    Icon = 0,
    LoadingTitle = "Kobe does not like Alice Hub",
    LoadingSubtitle = "by Kobe",
    ShowText = "Rayfield",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Alice and Kobe should not be shipped"
    },

    Discord = {
        Enabled = false,
        Invite = "PhjMgGMB",
        RememberJoins = true
    },

    KeySystem = true,
    KeySettings = {
        Title = "Kobe Key System",
        Subtitle = "Ask Kobe for the key",
        Note = "Ask Kobe directly",
        FileName = "Kobe_Key_System",
        SaveKey = true,
        GrabKeyFromSite = true,
        Key = {"https://pastebin.com/raw/RfwxRRLT"}
    }
})

-- Services
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Tabs
local MainTab = Window:CreateTab("Home", nil)
local VisualsTab = Window:CreateTab("Visuals", nil)

Rayfield:Notify({
    Title = "Execution Successful",
    Content = "Hub Loaded - Full Visual Version 🚀",
    Duration = 3.5,
})

-------------------------------------------------
-- INFINITE JUMP
-------------------------------------------------
local InfiniteJumpEnabled = false
UIS.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
        Rayfield:Notify({
            Title = "Infinite Jump",
            Content = state and "Enabled ✅" or "Disabled ❌",
            Duration = 2,
        })
    end,
})

-------------------------------------------------
-- FLY MODE
-------------------------------------------------
local Flying = false
local FlySpeed = 3
local function Fly()
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:WaitForChild("HumanoidRootPart")

    RunService.RenderStepped:Connect(function()
        if Flying then
            local moveDirection = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                moveDirection += Camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                moveDirection -= Camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                moveDirection -= Camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                moveDirection += Camera.CFrame.RightVector
            end
            hrp.Velocity = moveDirection.Magnitude > 0 and moveDirection.Unit * (FlySpeed * 50) or Vector3.zero
        end
    end)
end

MainTab:CreateToggle({
    Name = "Fly Mode",
    CurrentValue = false,
    Callback = function(state)
        Flying = state
        Fly()
        Rayfield:Notify({
            Title = "Fly Mode",
            Content = state and "Fly Mode ON ✈️" or "Fly Mode OFF",
            Duration = 2,
        })
    end,
})

-------------------------------------------------
-- WALKSPEED SLIDER
-------------------------------------------------
local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 2,
    CurrentValue = 16,
    Callback = function(value)
        Humanoid.WalkSpeed = value
    end,
})

-------------------------------------------------
-- JUMPPOWER SLIDER
-------------------------------------------------
MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 50,
    Callback = function(value)
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = value
    end,
})

-------------------------------------------------
-- NOCLIP
-------------------------------------------------
local Noclip = false
RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(state)
        Noclip = state
        Rayfield:Notify({
            Title = "Noclip",
            Content = state and "Noclip Enabled 🧱➡️🚶" or "Noclip Disabled",
            Duration = 2,
        })
    end,
})

-------------------------------------------------
-- ESP + Rainbow Option
-------------------------------------------------
local ESPEnabled = false
local RainbowESP = false
local function ToggleESP(state)
    ESPEnabled = state
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local highlight = character:FindFirstChild("Highlight") or Instance.new("Highlight")
                highlight.Name = "Highlight"
                highlight.Parent = character
                highlight.FillTransparency = state and 0.5 or 1
                highlight.OutlineTransparency = state and 0 or 1
            end
        end
    end
end

VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(state)
        ToggleESP(state)
    end,
})

VisualsTab:CreateToggle({
    Name = "Rainbow ESP",
    CurrentValue = false,
    Callback = function(state)
        RainbowESP = state
    end,
})

RunService.RenderStepped:Connect(function()
    if ESPEnabled and RainbowESP then
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("Highlight")
                if highlight then
                    highlight.FillColor = color
                end
            end
        end
    end
end)

-------------------------------------------------
-- TELEPORT DROPDOWN (FIXED)
-------------------------------------------------
local PlayerNames = {}
local Dropdown

local function UpdatePlayers()
    PlayerNames = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(PlayerNames, plr.Name)
        end
    end
    if Dropdown then
        Dropdown:Set(PlayerNames)
    end
end

Dropdown = MainTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = PlayerNames,
    Callback = function(selected)
        local target = Players:FindFirstChild(selected)
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
        end
    end,
})

Players.PlayerAdded:Connect(UpdatePlayers)
Players.PlayerRemoving:Connect(UpdatePlayers)
UpdatePlayers()

-------------------------------------------------
-- KILL ALL BUTTON
-------------------------------------------------
MainTab:CreateButton({
    Name = "Kill All",
    Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                plr.Character:FindFirstChildOfClass("Humanoid"):TakeDamage(1000)
            end
        end
    end,
})

-------------------------------------------------
-- CUSTOM THEME PICKER
-------------------------------------------------
VisualsTab:CreateColorPicker({
    Name = "Change UI Theme",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        Window:ChangeThemeColor(color)
    end,
})

-------------------------------------------------
-- WATERMARK + FPS COUNTER
-------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Watermark = Instance.new("TextLabel", ScreenGui)
Watermark.Text = "0% Fluffy Hair | FPS: 0"
Watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
Watermark.BackgroundTransparency = 0.4
Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Watermark.Size = UDim2.new(0, 200, 0, 30)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.Active = true
Watermark.Draggable = true

local lastUpdate = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount += 1
    if tick() - lastUpdate >= 1 then
        Watermark.Text = ("0% Fluffy Hair | FPS: %d"):format(frameCount)
        frameCount = 0
        lastUpdate = tick()
    end
end)

