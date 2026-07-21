-- Picky Hub - Power Your City | Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Picky Hub - Power Your City",
    LoadingTitle = "Picky Hub",
    LoadingSubtitle = "Auto Collect + Detector",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PickyHub_Config",
        FileName = "PowerYourCity"
    }
})

local Tab = Window:CreateTab("Main", 4483362458)

local autoCollect = true
local selectedRarities = {Epic = true, Legendary = true, Mythic = true}

local function getRoot()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
end

local function autoCollectFunc()
    while autoCollect do
        local root = getRoot()
        if root then
            for _, obj in ipairs(workspace:GetDescendants()) do
                pcall(function()
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        obj:InputHoldBegin()
                        task.wait(0.03)
                        obj:InputHoldEnd()
                    elseif obj:IsA("BasePart") and (obj.Name:lower():find("money") or obj.Name:lower():find("cash") or obj.Name:lower():find("coin") or obj.Name:lower():find("drop")) then
                        firetouchinterest(root, obj, 0)
                        task.wait(0.02)
                        firetouchinterest(root, obj, 1)
                    end
                end)
            end
        end
        task.wait(0.35)
    end
end

Tab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = true,
    Flag = "AutoCollectFlag",
    Callback = function(Value)
        autoCollect = Value
        if Value then task.spawn(autoCollectFunc) end
    end,
})

Tab:CreateSection("Rare Notifications")

Tab:CreateToggle({
    Name = "Notify Epic",
    CurrentValue = true,
    Flag = "EpicFlag",
    Callback = function(v) selectedRarities.Epic = v end,
})

Tab:CreateToggle({
    Name = "Notify Legendary",
    CurrentValue = true,
    Flag = "LegendaryFlag",
    Callback = function(v) selectedRarities.Legendary = v end,
})

Tab:CreateToggle({
    Name = "Notify Mythic",
    CurrentValue = true,
    Flag = "MythicFlag",
    Callback = function(v) selectedRarities.Mythic = v end,
})

Tab:CreateButton({
    Name = "Stop All",
    Callback = function()
        autoCollect = false
        Rayfield:Notify({Title = "Stopped", Content = "All features disabled", Duration = 5})
    end,
})

-- Detector
task.spawn(function()
    while true do
        for _, gui in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
            if (gui:IsA("TextLabel") or gui:IsA("TextButton")) then
                local txt = gui.Text:lower()
                local rarity = nil
                if txt:find("epic") and selectedRarities.Epic then rarity = "Epic"
                elseif txt:find("
