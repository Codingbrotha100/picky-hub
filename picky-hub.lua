-- Picky Hub - Power Your City | Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Picky Hub - Power Your City",
    LoadingTitle = "Loading Picky Hub",
    LoadingSubtitle = "Auto Collect + Rare Detector",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PickyHub",
        FileName = "Config"
    }
})

local Tab = Window:CreateTab("Main", 4483362458)

local autoCollect = true

local function getRoot()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
end

local function startAutoCollect()
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
    Callback = function(Value)
        autoCollect = Value
        if Value then task.spawn(startAutoCollect) end
    end,
})

Tab:CreateSection("Rare Item Detector")

Tab:CreateToggle({Name = "Notify Epic", CurrentValue = true, Callback = function() end})
Tab:CreateToggle({Name = "Notify Legendary", CurrentValue = true, Callback = function() end})
Tab:CreateToggle({Name = "Notify Mythic", CurrentValue = true, Callback = function() end})

Tab:CreateButton({
    Name = "STOP ALL",
    Callback = function()
        autoCollect = false
        Rayfield:Notify({Title = "Picky Hub", Content = "All features stopped", Duration = 5})
    end,
})

-- Detector
task.spawn(function()
    while true do
        for _, v in ipairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                local t = v.Text:lower()
                if t:find("epic") or t:find("legendary") or t:find("mythic") then
                    Rayfield:Notify({
                        Title = "🎉 Rare Item Found!",
                        Content = v.Text,
                        Duration = 8
                    })
                    task.wait(10)
                end
            end
        end
        task.wait(3)
    end
end)

Rayfield:LoadConfiguration()
print("✅ Picky Hub loaded successfully!")
