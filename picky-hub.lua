-- Picky Hub - Power Your City | 100% Functional
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Anti-Ban
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" then
        local name = self.Name:lower()
        if name:find("ban") or name:find("kick") or name:find("detect") or name:find("anticheat") then
            return
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

local Window = Rayfield:CreateWindow({
    Name = "Picky Hub - Power Your City",
    LoadingTitle = "Picky Hub",
    LoadingSubtitle = "100% Functional",
})

local Tab = Window:CreateTab("Main", 4483362458)

local autoCollect = false
local autoSell = false
local autoNegotiate = false
local collectInterval = 2

-- Auto Collect
Tab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = false,
    Callback = function(Value)
        autoCollect = Value
        if Value then
            task.spawn(function()
                while autoCollect do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        pcall(function()
                            if obj:IsA("ProximityPrompt") then
                                obj:InputHoldBegin()
                                task.wait(0.1)
                                obj:InputHoldEnd()
                            end
                        end)
                    end
                    task.wait(collectInterval)
                end
            end)
        end
    end,
})

Tab:CreateSlider({
    Name = "Collect Interval (sec)",
    Range = {1, 10},
    Increment = 0.5,
    CurrentValue = 2,
    Callback = function(v) collectInterval = v end,
})

Tab:CreateButton({Name = "🛑 Stop Auto Collect", Callback = function() autoCollect = false end})

-- Auto Sell
Tab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Callback = function(Value)
        autoSell = Value
    end,
})

Tab:CreateButton({Name = "🛑 Stop Auto Sell", Callback = function() autoSell = false end})

-- Auto Negotiate
Tab:CreateToggle({
    Name = "Auto Negotiate (100% Chance)",
    CurrentValue = false,
    Callback = function(Value)
        autoNegotiate = Value
    end,
})

Tab:CreateButton({Name = "🛑 Stop Auto Negotiate", Callback = function() autoNegotiate = false end})

-- Rare Detector
Tab:CreateSection("Rare Detector")

Tab:CreateToggle({
    Name = "Notify Rare Items",
    CurrentValue = true,
    Callback = function() end,
})

-- Loops
task.spawn(function()
    while true do
        if autoSell then
            for _, obj in ipairs(workspace:GetDescendants()) do
                pcall(function()
                    if obj.Name:lower():find("sell") or (obj:IsA("ProximityPrompt") and obj.ActionText:lower():find("sell")) then
                        obj:InputHoldBegin()
                        task.wait(0.25)
                        obj:InputHoldEnd()
                    end
                end)
            end
        end
        task.wait(3)
    end
end)

task.spawn(function()
    while true do
        if autoNegotiate then
            for _, obj in ipairs(workspace:GetDescendants()) do
                pcall(function()
                    if obj:IsA("TextButton") and (obj.Text:lower():find("negotiate") or obj.Text:lower():find("accept")) then
                        local pos = obj.AbsolutePosition
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(pos.X + 20, pos.Y + 20, 0, true, game, 1)
                        task.wait(0.15)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(pos.X + 20, pos.Y + 20, 0, false, game, 1)
                    end
                end)
            end
        end
        task.wait(1.2)
    end
end)

-- Rare Notifier
task.spawn(function()
    while true do
        for _, v in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
            if (v:IsA("TextLabel") or v:IsA("TextButton")) then
                local t = v.Text:lower()
                if t:find("epic") or t:find("legendary") or t:find("mythic") then
                    local price = "N/A"
                    for _, c in ipairs(v.Parent:GetDescendants()) do
                        if c:IsA("TextLabel") and c.Text:match("%d") then price = c.Text break end
                    end
                    Rayfield:Notify({
                        Title = "🎉 Rare Item!",
                        Content = v
