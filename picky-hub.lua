-- PICKY HUB PREMIUM v8.1 - POWER YOUR CITY
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local VirtualInput = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

local config = {
    AutoCollect = true,
    AutoSell = false,
    AutoNegotiate = false,
    RareDetector = true,
    CollectInterval = 0.35
}

local selectedRarities = { Legendary = true, Epic = true, Mythic = true }
local detectedRares = {}

-- GUI
local sg = Instance.new("ScreenGui")
sg.Name = "PickyHubV81"
sg.ResetOnSpawn = false
sg.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 460, 0, 680)
frame.Position = UDim2.new(0.5, -230, 0.5, -340)
frame.BackgroundColor3 = Color3.fromRGB(13,13,21)
frame.Active = true
frame.Draggable = true
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 170, 255)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,75)
title.BackgroundColor3 = Color3.fromRGB(0, 115, 245)
title.Text = "PICKY HUB v8.1"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 20)

local y = 90
local function AddToggle(name, default, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,56)
    btn.Position = UDim2.new(0.05,0,0,y)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,42)
    btn.Text = name .. ": ON"
    btn.TextColor3 = Color3.fromRGB(0,255,140)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)

    btn.MouseButton1Click:Connect(function()
        config[key] = not config[key]
        btn.Text = name .. ": " .. (config[key] and "ON" or "OFF")
        btn.TextColor3 = config[key] and Color3.fromRGB(0,255,140) or Color3.fromRGB(255,70,70)
    end)
    y = y + 70
end

AddToggle("Auto Collect", true, "AutoCollect")
AddToggle("Auto Sell", false, "AutoSell")
AddToggle("Auto Negotiate", false, "AutoNegotiate")
AddToggle("Rare Detector", true, "RareDetector")

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9,0,0,130)
status.Position = UDim2.new(0.05,0,0,420)
status.BackgroundTransparency = 1
status.Text = "Picky Hub v8.1 - Optimizat pentru Power Your City"
status.TextColor3 = Color3.fromRGB(160,255,180)
status.TextScaled = true
status.TextWrapped = true
status.Font = Enum.Font.Gotham
status.Parent = frame

-- Auto Collect Universal
task.spawn(function()
    while true do
        if config.AutoCollect then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart

                for _, obj in ipairs(workspace:GetDescendants()) do
                    pcall(function()
                        if obj:IsA("ProximityPrompt") and obj.Enabled then
                            obj:InputHoldBegin()
                            task.wait(0.05)
                            obj:InputHoldEnd()
                        end

                        if obj:IsA("BasePart") then
                            local n = obj.Name:lower()
                            if n:find("money") or n:find("cash") or n:find("coin") or n:find("drop") or n:find("funnel") or n:find("energy") then
                                if (root.Position - obj.Position).Magnitude < 80 then
                                    firetouchinterest(root, obj, 0)
                                    task.wait(0.025)
                                    firetouchinterest(root, obj, 1)
                                end
                            end
                        end
                    end)
                end
            end
        end
        task.wait(config.CollectInterval)
    end
end)

-- Auto Sell (adaptat pentru butonul Sell din joc)
task.spawn(function()
    while true do
        if config.AutoSell then
            -- Caută butonul Sell în GUI
            for _, obj in ipairs(player.PlayerGui:GetDescendants()) do
                pcall(function()
                    if obj:IsA("TextButton") and obj.Text:lower():find("sell") then
                        local pos = obj.AbsolutePosition
                        VirtualInput:SendMouseButtonEvent(pos.X + 40, pos.Y + 20, 0, true, game, 1)
                        task.wait(0.1)
                        VirtualInput:SendMouseButtonEvent(pos.X + 40, pos.Y + 20, 0, false, game, 1)
                    end
                end)
            end
        end
        task.wait(2.8)
    end
end)

-- Auto Negotiate
task.spawn(function()
    while true do
        if config.AutoNegotiate then
            for _, obj in ipairs(player.PlayerGui:GetDescendants()) do
                pcall(function()
                    if obj:IsA("TextButton") and (obj.Text:lower():find("negotiate") or obj.Text:lower():find("accept")) then
                        local pos = obj.AbsolutePosition
                        VirtualInput:SendMouseButtonEvent(pos.X + 30, pos.Y + 25, 0, true, game, 1)
                        task.wait(0.12)
                        VirtualInput:SendMouseButtonEvent(pos.X + 30, pos.Y + 25, 0, false, game, 1)
                    end
                end)
            end
        end
        task.wait(1.2)
    end
end)

-- Rare Detector
RunService.RenderStepped:Connect(function()
    if not config.RareDetector then return end
    for _, v in ipairs(player.PlayerGui:GetDescendants()) do
        if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text then
            local txt = v.Text
            local l = txt:lower()
            if not detectedRares[txt] then
                if (selectedRarities.Legendary and l:find("legendary")) or
                   (selectedRarities.Epic and l:find("epic")) or
                   (selectedRarities.Mythic and l:find("mythic")) then
                    detectedRares[txt] = true
                    status.Text = "🔥 RARE DETECTED!\n" .. txt
                    status.TextColor3 = Color3.fromRGB(255, 215, 0)
                    StarterGui:SetCore("SendNotification", {Title = "Picky Hub - RARE!", Text = txt, Duration = 15})
                    
                    local s = Instance.new("Sound")
                    s.SoundId = "rbxassetid://131057514"
                    s.Volume = 0.9
                    s.Parent = workspace
                    s:Play()
                    game.Debris:AddItem(s, 6)
                end
            end
        end
    end
end)

print("✅ Picky Hub v8.1 - Final Version Loaded")
StarterGui:SetCore("SendNotification", {Title = "Picky Hub v8.1", Text = "Script complet pentru Power Your City!", Duration = 8})
