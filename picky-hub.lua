loadstring([[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local autoCollectEnabled = true
local collectInterval = 0.35
local lastCollect = 0

-- Anti-Ban Bypass
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "FireServer" then
        local name = self.Name:lower()
        if name:find("ban") or name:find("kick") or name:find("detect") or name:find("anticheat") then
            return
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- GUI Picky Hub
local sg = Instance.new("ScreenGui")
sg.Name = "PickyHub"
sg.ResetOnSpawn = false
sg.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 440)
frame.Position = UDim2.new(0.5, -190, 0, 40)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
frame.Active = true
frame.Draggable = true
frame.Parent = sg

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,60)
title.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
title.Text = "PICKY HUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 16)

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.9,0,0,65)
toggle.Position = UDim2.new(0.05,0,0,80)
toggle.BackgroundColor3 = Color3.fromRGB(35,35,40)
toggle.Text = "AUTO COLLECT: ON"
toggle.TextColor3 = Color3.fromRGB(0, 255, 140)
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBold
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,12)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9,0,0,90)
status.Position = UDim2.new(0.05,0,0,170)
status.BackgroundTransparency = 1
status.Text = "Detector activ\nCaută: Legendary, Epic, Mythic..."
status.TextColor3 = Color3.fromRGB(160, 255, 160)
status.TextScaled = true
status.TextWrapped = true
status.Font = Enum.Font.Gotham
status.Parent = frame

toggle.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    toggle.Text = autoCollectEnabled and "AUTO COLLECT: ON" or "AUTO COLLECT: OFF"
    toggle.TextColor3 = autoCollectEnabled and Color3.fromRGB(0,255,140) or Color3.fromRGB(255, 80, 80)
end)

-- Rare Detector
local function checkRare()
    for _, v in ipairs(player.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            local txt = v.Text:lower()
            if txt:find("legendary") or txt:find("epic") or txt:find("mythic") then
                local itemName = v.Text
                local price = "Preț necunoscut"
                
                local parent = v.Parent
                for _, child in ipairs(parent:GetDescendants()) do
                    if child:IsA("TextLabel") and child.Text:match("%d+[KkM]?") then
                        price = child.Text
                        break
                    end
                end
                
                status.Text = "🔥 RARE ITEM DETECTED!\n" .. itemName .. "\nCost: " .. price
                status.TextColor3 = Color3.fromRGB(255, 215, 0)

                StarterGui:SetCore("SendNotification", {
                    Title = "🎉 Picky Hub - ITEM RAR!",
                    Text = itemName .. "\nCost: " .. price,
                    Duration = 15
                })

                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://131057514"
                sound.Volume = 1
                sound.Parent = workspace
                sound:Play()
                game.Debris:AddItem(sound, 6)

                print("🔔 RARE: " .. itemName .. " | Preț: " .. price)
            end
        end
    end
end

-- Auto Collect
local function collectMoney()
    if not autoCollectEnabled then return end
    if tick() - lastCollect < collectInterval then return end
    lastCollect = tick()

    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                obj:InputHoldBegin()
                task.wait(0.025)
                obj:InputHoldEnd()
            elseif obj:IsA("BasePart") and (obj.Name:lower():find("money") or obj.Name:lower():find("cash") or obj.Name:lower():find("coin") or obj.Name:lower():find("drop")) then
                local root = char.HumanoidRootPart
                firetouchinterest(root, obj, 0)
                task.wait(0.02)
                firetouchinterest(root, obj, 1)
            end
        end)
    end
end

RunService.Heartbeat:Connect(collectMoney)
RunService.RenderStepped:Connect(checkRare)

print("✅ Picky Hub loaded | Auto Collect + Detector (Legendary, Epic, Mythic)")
]])()
