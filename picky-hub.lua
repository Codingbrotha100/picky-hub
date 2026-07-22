-- Picky Hub Pro v3.1 - Power Your City | Final Optimised
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Picky Hub - Power Your City",
    LoadingTitle = "Picky Hub v3.1",
    LoadingSubtitle = "Full Auto Farm",
    ConfigurationSaving = {Enabled = true, FolderName = "PickyHub", FileName = "Final"}
})

local Tab = Window:CreateTab("Main", 4483362458)

local autoCollect = false
local autoSell = false
local autoNegotiate = false
local autoBuyPanels = false
local autoBuyBatteries = false
local autoRebirth = false
local rareDetector = true

Tab:CreateToggle({Name = "Auto Collect", CurrentValue = false, Callback = function(v) autoCollect = v end})
Tab:CreateToggle({Name = "Auto Sell", CurrentValue = false, Callback = function(v) autoSell = v end})
Tab:CreateToggle({Name = "Auto Negotiate", CurrentValue = false, Callback = function(v) autoNegotiate = v end})
Tab:CreateToggle({Name = "Auto Buy Panels", CurrentValue = false, Callback = function(v) autoBuyPanels = v end})
Tab:CreateToggle({Name = "Auto Buy Batteries", CurrentValue = false, Callback = function(v) autoBuyBatteries = v end})
Tab:CreateToggle({Name = "Auto Rebirth", CurrentValue = false, Callback = function(v) autoRebirth = v end})
Tab:CreateToggle({Name = "Rare Detector", CurrentValue = true, Callback = function(v) rareDetector = v end})

Tab:CreateSlider({Name = "WalkSpeed", Range = {16, 150}, Increment = 2, CurrentValue = 60, Callback = function(v)
    pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)
end})

Rayfield:Notify({Title = "Picky Hub v3.1", Content = "Loaded! Succes la farm!", Duration = 6})

-- Auto Collect
task.spawn(function()
    while true do
        if autoCollect then
            for _, obj in ipairs(workspace:GetDescendants()) do
                pcall(function()
                    if obj:IsA("ProximityPrompt") then
                        obj:InputHoldBegin()
                        task.wait(0.05)
                        obj:InputHoldEnd()
                    end
                end)
            end
        end
        task.wait(0.35)
    end
end)

-- Auto Sell
task.spawn(function()
    while true do
        if autoSell then
            for _, obj in ipairs(workspace:GetDescendants()) do pcall(function()
                if obj.Name:lower():find("sell") or (obj:IsA("ProximityPrompt") and obj.ActionText:lower():find("sell")) then
                    obj:InputHoldBegin() task.wait(0.18) obj:InputHoldEnd()
                end
            end) end
        end
        task.wait(1.6)
    end
end)

-- Auto Negotiate
task.spawn(function()
    while true do
        if autoNegotiate then
            for _, obj in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do pcall(function()
                if obj:IsA("TextButton") and (obj.Text:lower():find("negotiate") or obj.Text:lower():find("accept")) then
                    local pos = obj.AbsolutePosition
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(pos.X+25, pos.Y+25, 0, true, game, 1)
                    task.wait(0.1)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(pos.X+25, pos.Y+25, 0, false, game, 1)
                end
            end) end
        end
        task.wait(0.9)
    end
end)

-- Auto Buy Panels & Batteries
task.spawn(function()
    while true do
        if autoBuyPanels or autoBuyBatteries then
            for _, v in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                pcall(function()
                    if v:IsA("TextButton") and v.Text:find("%d") then
                        local txt = v.Text:lower()
                        if (autoBuyPanels and txt:find("panel")) or (autoBuyBatteries and txt:find("battery")) then
                            v:Activate()
                        end
                    end
                end)
            end
        end
        task.wait(2.8)
    end
end)

-- Auto Rebirth (verifică minim Panel + Battery)
task.spawn(function()
    while true do
        if autoRebirth then
            local hasPanel = false
            local hasBattery = false
            for _, v in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    local t = v.Text:lower()
                    if t:find("panel") then hasPanel = true end
                    if t:find("battery") then hasBattery = true end
                end
            end
            if hasPanel and hasBattery then
                for _, v in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                    if v:IsA("TextButton") and v.Text:lower():find("rebirth") then
                        v:Activate()
                        Rayfield:Notify({Title = "♻️ Rebirth", Content = "Auto Rebirth triggered!", Duration = 6})
                    end
                end
            end
        end
        task.wait(10)
    end
end)

-- Rare Detector + Notificare
game:GetService("RunService").RenderStepped:Connect(function()
    if not rareDetector then return end
    for _, v in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
        if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text then
            local txt = v.Text
            local l = txt:lower()
            if l:find("legendary") or l:find("epic") or l:find("mythic") or l:find("fusion") then
                Rayfield:Notify({Title = "🔥 RARE ITEM!", Content = txt, Duration = 10})
                local sound = Instance.new("Sound", workspace)
                sound.SoundId = "rbxassetid://131057514"
                sound.Volume = 0.5
                sound:Play()
                game.Debris:AddItem(sound, 4)
            end
        end
    end
end)

print("✅ Picky Hub v3.1 Final Loaded!")
