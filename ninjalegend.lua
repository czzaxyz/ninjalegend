local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
 
local Window = Rayfield:CreateWindow({
    Name = "ROBLOX || NINJA LEGENDS",
    LoadingTitle = "Ninja Legends Hub",
    LoadingSubtitle = "",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "NinjaLegends"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})
 
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rEvents = ReplicatedStorage:WaitForChild("rEvents")
 
local main = Window:CreateTab("Main", 6026568198)
local farm = Window:CreateTab("Auto Farm", 7044284832)
local tp = Window:CreateTab("Teleport", 6035190846)
local egg = Window:CreateTab("Crystal", 6031265976)
local misc = Window:CreateTab("Misc", 6034509993)
local elementsTab = Window:CreateTab("Elements", 6031265976)
local infMoneyTab = Window:CreateTab("Inf Coins and Gems", 6031265976)
 
-- Time / FPS / Ping
local TimeLabel = main:CreateLabel("[GameTime] : Loading...")
 
spawn(function()
    while task.wait() do
        pcall(function()
            local GameTime = math.floor(workspace.DistributedGameTime+0.5)
            local Hour = math.floor(GameTime/(60^2))%24
            local Minute = math.floor(GameTime/(60^1))%60
            local Second = math.floor(GameTime/(60^0))%60
            TimeLabel:Set("[GameTime] : Hours : "..Hour.." Minutes : "..Minute.." Seconds : "..Second)
        end)
    end
end)
 
local FpsLabel = main:CreateLabel("[Fps] : Loading...")
 
spawn(function()
    while true do
        wait(0.1)
        pcall(function()
            local Fps = math.floor(workspace:GetRealPhysicsFPS())
            FpsLabel:Set("[Fps] : "..Fps)
        end)
    end
end)
 
local PingLabel = main:CreateLabel("[Ping] : Loading...")
 
spawn(function()
    while true do
        wait(0.1)
        pcall(function()
            local Ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            PingLabel:Set("[Ping] : "..Ping)
        end)
    end
end)
 
-- Main tab
main:CreateSection("Main")
 
main:CreateButton({
    Name = "Disable Trading",
    Callback = function()
        rEvents.tradingEvent:FireServer("disableTrading")
    end
})
 
main:CreateButton({
    Name = "Enable Trading",
    Callback = function()
        rEvents.tradingEvent:FireServer("enableTrading")
    end
})
 
local function GetPlayerListWithDisplay()
    local list = {}
    local mapping = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            local displayText = v.DisplayName .. " (@" .. v.Name .. ")"
            table.insert(list, displayText)
            mapping[displayText] = v.Name
        end
    end
    return list, mapping
end
 
local PlayerList, PlayerMapping = GetPlayerListWithDisplay()
local TpPlayer = nil
 
local PlayerDropdown = main:CreateDropdown({
    Name = "Select Player",
    Options = PlayerList,
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(Option)
        TpPlayer = PlayerMapping[Option]
    end
})
 
Players.PlayerAdded:Connect(function(plr)
    task.wait(0.5)
    PlayerList, PlayerMapping = GetPlayerListWithDisplay()
    pcall(function() PlayerDropdown:Refresh(PlayerList) end)
end)
 
Players.PlayerRemoving:Connect(function(plr)
    task.wait(0.5)
    PlayerList, PlayerMapping = GetPlayerListWithDisplay()
    if TpPlayer == plr.Name then TpPlayer = nil end
    pcall(function() PlayerDropdown:Refresh(PlayerList) end)
end)
 
main:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        PlayerList, PlayerMapping = GetPlayerListWithDisplay()
        pcall(function() PlayerDropdown:Refresh(PlayerList) end)
        Rayfield:Notify({Title = "Success", Content = "Player list refreshed!", Duration = 2})
    end
})
 
main:CreateButton({
    Name = "Teleport To Player",
    Callback = function()
        if not TpPlayer then
            Rayfield:Notify({Title = "Error", Content = "Select a player first!", Duration = 3})
            return
        end
        local target = Players:FindFirstChild(TpPlayer)
        if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({Title = "Error", Content = "Player/character not found!", Duration = 3})
            return
        end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({Title = "Error", Content = "Your character not found!", Duration = 3})
            return
        end
        pcall(function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, 1)
        end)
        Rayfield:Notify({Title = "Success", Content = "Teleported!", Duration = 2})
    end
})
 
main:CreateSlider({
    Name = "Speed",
    Range = {0, 1000},
    Increment = 1,
    Suffix = "",
    CurrentValue = 16,
    Callback = function(v)
        pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = v end)
    end
})
 
main:CreateSlider({
    Name = "Jump",
    Range = {0, 1000},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Callback = function(v)
        pcall(function() LocalPlayer.Character.Humanoid.JumpPower = v end)
    end
})
 
main:CreateToggle({
    Name = "Disable PopUp Coin & Chi",
    CurrentValue = false,
    Callback = function(state)
        pcall(function()
            LocalPlayer.PlayerGui.statEffectsGui.Enabled = not state
            LocalPlayer.PlayerGui.hoopGui.Enabled = not state
        end)
    end
})
 
main:CreateToggle({
    Name = "Invisibility",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function() LocalPlayer.ninjaEvent:FireServer("goInvisible") end)
        end
    end
})
 
-- Auto Farm tab
farm:CreateSection("Auto Farm")
 
farm:CreateToggle({
    Name = "Auto Swing",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function() LocalPlayer.ninjaEvent:FireServer("swingKatana") end)
        end
    end
})
 
farm:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function()
                game.workspace.sellAreaCircles["sellAreaCircle15"].circleInner.CFrame = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                wait()
                game.workspace.sellAreaCircles["sellAreaCircle15"].circleInner.CFrame = game.Workspace.Part.CFrame
            end)
        end
    end
})
 
farm:CreateToggle({
    Name = "Auto Sell When Full",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function()
                if LocalPlayer.PlayerGui.gameGui.maxNinjitsuMenu.Visible == true then
                    game.workspace.sellAreaCircles["sellAreaCircle15"].circleInner.CFrame = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                    wait()
                    game.workspace.sellAreaCircles["sellAreaCircle15"].circleInner.CFrame = game.Workspace.Part.CFrame
                end
            end)
        end
    end
})
 
farm:CreateToggle({
    Name = "Auto Buy Sword",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function()
                LocalPlayer.ninjaEvent:FireServer("buyAllSwords", "Blazing Vortex Island")
            end)
        end
    end
})
 
farm:CreateToggle({
    Name = "Auto Buy Belts",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function()
                LocalPlayer.ninjaEvent:FireServer("buyAllBelts", "Blazing Vortex Island")
            end)
        end
    end
})
 
farm:CreateToggle({
    Name = "Auto Buy Skills",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function()
                LocalPlayer.ninjaEvent:FireServer("buyAllSkills", "Blazing Vortex Island")
            end)
        end
    end
})
 
farm:CreateToggle({
    Name = "Auto Buy Ranks",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function()
                local oh1 = "buyRank"
                local ranks = game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren()
                for i = 1, #ranks do
                    LocalPlayer.ninjaEvent:FireServer(oh1, ranks[i].Name)
                end
            end)
        end
    end
})
 
farm:CreateToggle({
    Name = "Auto Buy Shurikens",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function()
                LocalPlayer.ninjaEvent:FireServer("buyAllShurikens", "Blazing Vortex Island")
            end)
        end
    end
})
 
farm:CreateToggle({
    Name = "Auto Farm Chi",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function()
                for _, v in pairs(game.Workspace.spawnedCoins.Valley:GetChildren()) do
                    if v.Name == "Blue Chi Crate" then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position)
                        wait(0.3)
                    end
                end
            end)
        end
    end
})
 
farm:CreateToggle({
    Name = "Auto Farm Coin",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function()
                for _, v in pairs(game.Workspace.spawnedCoins.Valley:GetChildren()) do
                    if v.Name == "Purple Coin Crate" then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position)
                        wait(0.3)
                    end
                end
            end)
        end
    end
})
 
farm:CreateToggle({
    Name = "Auto Hoops",
    CurrentValue = false,
    Callback = function(state)
        while state do
            wait()
            pcall(function()
                for _, v in pairs(workspace.Hoops:GetDescendants()) do
                    if v.ClassName == "MeshPart" then
                        v.touchPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    end
                end
            end)
        end
    end
})
 
-- Teleport tab
local ISLAND = {}
for _, v in pairs(game.workspace.islandUnlockParts:GetChildren()) do
    table.insert(ISLAND, v.Name)
end
 
tp:CreateSection("Island")
 
tp:CreateDropdown({
    Name = "Teleports",
    Options = ISLAND,
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(a)
        pcall(function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.islandUnlockParts[a].islandSignPart.CFrame
        end)
    end
})
 
tp:CreateButton({
    Name = "Unlock All Island",
    Callback = function()
        for _, v in pairs(game.workspace.islandUnlockParts:GetChildren()) do
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.islandSignPart.CFrame
            end)
            wait(0.2)
        end
    end
})
 
-- Crystal tab
egg:CreateSection("Crystal")
 
local Crystal = {}
for _, v in pairs(game.workspace.mapCrystalsFolder:GetChildren()) do
    table.insert(Crystal, v.Name)
end
 
egg:CreateDropdown({
    Name = "Select Crystal",
    Options = Crystal,
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(value)
        _G.cryEgg = value
    end
})
 
egg:CreateToggle({
    Name = "Open Crystal",
    CurrentValue = false,
    Callback = function(state)
        _G.cCry = state
        while _G.cCry do
            wait()
            pcall(function()
                rEvents.openCrystalRemote:InvokeServer("openCrystal", _G.cryEgg)
            end)
        end
    end
})
 
egg:CreateToggle({
    Name = "Auto Evolved Pet",
    CurrentValue = false,
    Callback = function(state)
        _G.ePet = state
        while _G.ePet do
            wait()
            pcall(function()
                for _, petFolder in pairs(LocalPlayer.petsFolder:GetChildren()) do
                    for _, pet in pairs(petFolder:GetChildren()) do
                        rEvents.petEvolveEvent:FireServer("evolvePet", pet.Name)
                    end
                end
            end)
        end
    end
})
 
-- Misc tab
misc:CreateSection("Misc")
 
misc:CreateToggle({
    Name = "Inf Double Jump",
    CurrentValue = false,
    Callback = function(state)
        if state then
            pcall(function() LocalPlayer.multiJumpCount.Value = "99999999999999999" end)
        end
    end
})
 
local InfiniteJumpEnabled = false
misc:CreateToggle({
    Name = "Inf Jump",
    CurrentValue = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})
 
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        pcall(function()
            LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end)
    end
end)
 
misc:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})
 
-- Elements tab
elementsTab:CreateSection("Unlock Elements")
 
local elementList = {
    "Shadow Charge", "Electral Chaos", "Blazing Entity", "Shadowfire",
    "Lightning", "Masterful Wrath", "Inferno", "Eternity Storm", "Frost"
}
 
for _, elementName in ipairs(elementList) do
    elementsTab:CreateButton({
        Name = "Get " .. elementName,
        Callback = function()
            pcall(function()
                rEvents.elementMasteryEvent:FireServer(elementName)
            end)
            Rayfield:Notify({
                Title = "Element Unlocked",
                Content = "Attempted to unlock: " .. elementName,
                Duration = 2.5
            })
        end
    })
end
 
-- Inf Coins and Gems tab
infMoneyTab:CreateSection("How to get infinite coins/gems:")
infMoneyTab:CreateLabel("1. Toggle 'Inf Gems' ON below")
infMoneyTab:CreateLabel("2. After you get Inf Gems, LEAVE")
infMoneyTab:CreateLabel("3. Go to 'Elements' tab and select an element")
infMoneyTab:CreateLabel("4. Put a number in Gem conversion")
infMoneyTab:CreateLabel("5. Press 'Confirm Conversion'")
 
infMoneyTab:CreateToggle({
    Name = "Inf Gems",
    CurrentValue = false,
    Callback = function(enabled)
        if enabled then
            task.spawn(function()
                Rayfield:Notify({
                    Title = "Inf Gems Started",
                    Content = "LEAVE BEFORE SELECTING A ELEMENT\nSpam will run forever until you turn it off",
                    Duration = 8
                })
                while enabled do  -- true infinite loop
                    pcall(function()
                        rEvents.zenMasterEvent:FireServer("convertGems", -9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999)
                    end)
                    wait(0.7)  -- safe delay
                end
            end)
        else
            Rayfield:Notify({Title = "Stopped", Content = "Spam loop off", Duration = 2})
        end
    end
})
 
local gemAmountInput = infMoneyTab:CreateInput({
    Name = "Gem Amount to Convert",
    PlaceholderText = "How many gems to turn into coins (huge numbers ok)",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        _G.gemConvertAmount = text
    end
})
 
infMoneyTab:CreateButton({
    Name = "Confirm Conversion",
    Callback = function()
        local num = tonumber(_G.gemConvertAmount or "0")
        if not num or num <= 0 then
            Rayfield:Notify({Title = "Error", Content = "Enter a valid positive number!", Duration = 3})
            return
        end
        if num > 10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 then
            Rayfield:Notify({Title = "Warning", Content = "Number too big! Try smaller amount.", Duration = 4})
            return
        end
        pcall(function()
            rEvents.zenMasterEvent:FireServer("convertGems", num)
        end)
        Rayfield:Notify({
            Title = "Conversion Sent",
            Content = "Converting " .. num .. " gems to coins...",
            Duration = 3
        })
    end
})
 
Rayfield:LoadConfiguration()
