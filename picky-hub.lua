-- Picky Hub - Power Your City | Versiune Simplă (fără Rayfield)
print("✅ Picky Hub - Power Your City loaded (Simple Version)")

local autoCollect = false
local autoSell = false
local autoNegotiate = false
local collectInterval = 2

-- Toggle Auto Collect (poți activa din consolă)
game.Players.LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower() == ".collect on" then
        autoCollect = true
        print("Auto Collect ON")
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
    elseif msg:lower() == ".collect off" then
        autoCollect = false
        print("Auto Collect OFF")
    elseif msg:lower() == ".sell on" then
        autoSell = true
        print("Auto Sell ON")
    elseif msg:lower() == ".sell off" then
        autoSell = false
        print("Auto Sell OFF")
    elseif msg:lower() == ".neg on" then
        autoNegotiate = true
        print("Auto Negotiate ON")
    elseif msg:lower() == ".neg off" then
        autoNegotiate = false
        print("Auto Negotiate OFF")
    end
end)

-- Auto Sell
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

-- Auto Negotiate
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

print("Comenzi disponibile:")
print(".collect on / off")
print(".sell on / off")
print(".neg on / off")
