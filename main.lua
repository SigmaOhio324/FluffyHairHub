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
-- TELEPORT DROPDOWN
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
-- FASTFLAGS BUTTON
-------------------------------------------------
MainTab:CreateButton({
    Name = "Activate FastFlags",
    Callback = function()
        pcall(function()
            -- DFFlags (example, you can add all DFInt and other flags similarly)
            setfflag("DFFlagEnableControlRigIkTargets", "True")
            setfflag("DFFlagAnimatorPostProcessIK", "True")
            setfflag("DFFlagAssetPreloadingUrlVersionEnabled", "True")
            setfflag("DFFlagAddKtxTranscodedWidthHeight", "True")
            setfflag("DFFlagAnimatorThrottleRccEnabled", "True")
            setfflag("DFFlagDebugPrintDataPingBreakDown", "True")
            setfflag("DFFlagDebugLargeReplicatorForceFullSend", "True")
            setfflag("DFFlagAddMachineIDInstallerTelemetry", "False")
            setfflag("DFFlagDebugLargeReplicatorDisableCompression", "True")
            setfflag("DFFlagAnimatorEnableNewAdornments", "True")
            setfflag("DFFlagDebugPVLOD0SerializeFullMatrix", "True")
            setfflag("DFFlagAddMipPackMetadata", "True")
            setfflag("DFFlagEnableMeshPreloading", "True")
            setfflag("DFFlagAssetPreloadingUrlVersionEnabled2", "True")
            setfflag("DFFlagAlwaysSkipDiskCache", "False")
            setfflag("DFFlagAcceleratorUpdateOnPropsAndValueTimeChange", "True")
            setfflag("DFFlagEnableSoundPreloading", "True")
            setfflag("DFFlagEnableTexturePreloading", "True")
            setfflag("DFFlagFixRakPingTraceReport", "True")
            setfflag("DFFlagHumanoidReplicateSimulated2", "True")
            setfflag("DFFlagISRLimitSimulationRadiusToNOUCount", "False")
            setfflag("DFFlagNewPackageAnalytics", "False")
            setfflag("DFFlagRakNetDetectNetUnreachable", "True")
            setfflag("DFFlagRakNetDetectRecvThreadOverload", "True")
            setfflag("DFFlagRakNetEnablePoll", "True")
            setfflag("DFFlagRakNetFixBwCollapse", "True")
            setfflag("DFFlagRakNetUnblockSelectOnShutdownByWritingToSocket", "True")
            setfflag("DFFlagRakNetUseSlidingWindow4", "True")
            setfflag("DFFlagReplicateCreateToPlayer", "True")
            setfflag("DFFlagReplicatorCheckReadTableCollisions", "True")
            setfflag("DFFlagReplicatorKickBigV", "True")
            setfflag("DFFlagReplicatorKickRecvVariantSpeed", "True")
            setfflag("DFFlagReplicatorSeparateVarThresholds", "True")
            setfflag("DFFlagSampleAndRefreshRakPing", "True")
            setfflag("DFFlagSimAdaptiveExplicitlyMarkInterpolatedAssemblies", "True")
            setfflag("DFFlagSimLocalBallSocketInterpolation", "True")
            setfflag("DFFlagSimSmoothedRunningController2", "True")
            setfflag("DFFlagSolverNOURemovedUnderSetOptimized2", "True")
            setfflag("DFFlagSolverStateReplicatedOnly2", "True")
            setfflag("DFFlagSolverV2DisableChangedFixedNOUOptimization", "False")
            setfflag("DFFlagUpdateBoundExtentsForHugeMixedReplicationComponents", "True")
        end)

        Rayfield:Notify({
            Title = "FastFlags",
            Content = "FastFlags Activated ✅",
            Duration = 2
        })
    end
})

-------------------------------------------------
-- VISUALS / ESP / THEME PICKER / WATERMARK
-------------------------------------------------
-- (Keep your existing VisualsTab code for ESP, RainbowESP, Theme Picker, Watermark here)
