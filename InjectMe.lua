local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local TopBarFrame = CoreGui.TopBarApp.TopBarFrame
local PlayerList = CoreGui.PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame

local LeftFrame = TopBarFrame.LeftFrame
local RightFrame = TopBarFrame.RightFrame

local MenuIcon = LeftFrame.MenuIcon
local ChatIcon = LeftFrame.ChatIcon

-- Tick --
local function chatTick()
    if ChatIcon.Background.Icon.Image == "rbxasset://textures/ui/TopBar/chatOff.png" then
        ChatIcon.Background.Icon.Image = "rbxasset://textures/ui/Chat/Chat@2x.png"
    elseif ChatIcon.Background.Icon.Image == "rbxasset://textures/ui/TopBar/chatOn.png" then
        ChatIcon.Background.Icon.Image = "rbxasset://textures/ui/Chat/ChatDown@2x.png"
    end

    if ChatIcon.BadgeContainer:FindFirstChild("Badge") then
        local Badge = ChatIcon.BadgeContainer.Badge

        Badge.Inner.Image = "rbxasset://textures/ui/Chat/MessageCounter.png"
        Badge.Inner.ImageRectOffset = Vector2.new(0, 0)
        Badge.Inner.ImageRectSize = Vector2.new(0, 0)
        Badge.Inner:ClearAllChildren()
        Badge.Position = UDim2.new(-0.36, 15, 0, 2)
        Badge.Inner.ScaleType = Enum.ScaleType.Fit

        if Badge:FindFirstChild("Background") then
            Badge.Background:Destroy()
        end
    end
end

local function onStatsValueChanged(statName, newValue)
    local StatFrame = RightFrame:FindFirstChild(statName .. "StatLabel")

    if not StatFrame then print("[ROBLOX2016] FATAL ERROR! stat:" .. statName .. " is not added to the top bar!") return end

    local StatValueLabel = StatFrame.StatValueLabel
    StatValueLabel.Text = newValue
end

local function containsString(list, str)
    for _, value in ipairs(list) do
        if value == str then
            return true
        end
    end
    return false
end

local alreadyProcesses = {}
-- ImageRectOffset
local FriendIcon = Vector2.new(76, 494)
local FriendRequestIcon = Vector2.new(494, 94)
local BlockedIcon = Vector2.new(480, 252)
local PremiumIcon = Vector2.new(476, 406)
local function playerListTick()
    local ListValues = PlayerList.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame:GetChildren()
    
    PlayerList.ScrollingFrameContainer.Transparency = 1

    for _, value in pairs(ListValues) do

        if value.Name:match("^p_") then -- Is player
            local ChildrenFrame = value.ChildrenFrame

            if not containsString(alreadyProcesses, value.Name) then 
                print("[ROBLOX2016][PlayerList] Processing New Player: " .. value.Name)
                table.insert(alreadyProcesses, value.Name)

                ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Font = Enum.Font.SourceSansBold

                ChildrenFrame.Size = UDim2.new(1, 0, 0, 37)
                ChildrenFrame.Position = UDim2.new(0, 0, 0, 0)
                ChildrenFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                ChildrenFrame.Transparency = 0.6000000238418579
                ChildrenFrame.BorderSizePixel = 0

                local Divider = value:FindFirstChild("Divider")
                if Divider then
                    Divider.BackgroundTransparency = 1
                    Divider.Size = UDim2.new(1, 0, 0, 3)
                end
            end

            local PlayerIcon = ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon

            if PlayerIcon.ImageRectOffset == FriendIcon then
                print("[ROBLOX2016][PlayerList] Player: ".. value.Name .. " is a friend")

                PlayerIcon.ImageRectOffset = Vector2.new(0, 0)
                PlayerIcon.ImageRectSize = Vector2.new(0, 0)
                PlayerIcon.Image = "rbxasset://textures/ui/PlayerList/FriendIcon.png"
            elseif PlayerIcon.ImageRectOffset == FriendRequestIcon then
                print("[ROBLOX2016][PlayerList] Player: " .. value.Name .." sent a friend request")

                PlayerIcon.ImageRectOffset = Vector2.new(0, 0)
                PlayerIcon.ImageRectSize = Vector2.new(0, 0)
                PlayerIcon.Image = "rbxasset://textures/ui/PlayerList/AddFriend.png"
            elseif PlayerIcon.ImageRectOffset == BlockedIcon then
                print("[ROBLOX2016][PlayerList] Player: " .. value.Name .." is blocked")

                PlayerIcon.ImageRectOffset = Vector2.new(0, 0)
                PlayerIcon.ImageRectSize = Vector2.new(0, 0)
                PlayerIcon.Image = "rbxasset://textures/ui/PlayerList/BlockedIcon.png"
            elseif PlayerIcon.ImageRectOffset == PremiumIcon then
                print("[ROBLOX2016][PlayerList] Player: " .. value.Name .." has premium")

                PlayerIcon.ImageRectOffset = Vector2.new(0, 0)
                PlayerIcon.ImageRectSize = Vector2.new(0, 0)
                PlayerIcon.Image = getcustomasset("BaldyROBLOX2016/PremiumIcon.png")
            end
        end

        if value.Name:match("^t_") then -- Is Team
            if containsString(alreadyProcesses, value.Name) then
                print("[ROBLOX2016][PlayerList] Processing Team: " .. value.Name)
                table.insert(alreadyProcesses, value.Name)


                value.NameFrame.BGFrame.OverlayFrame.TeamName.Font = Enum.Font.SourceSans

                value.BackgroundColor3 = Color3.fromRGB(25, 27, 29)
                value.BackgroundTransparency = 0.3

                local Divider = Instance.new("Frame") -- Teams do not have a divider we need to add one
                Divider.Name = "Divider"
                Divider.BackgroundTransparency = 1
                Divider.Parent = value.BackgroundExtender
                Divider.Size = UDim2.new(1, 0, 0, 3)
                Divider.Position = UDim2.new(0, 0, 1, 0)

                local Divider2 = Instance.new("Frame")
                Divider2.Name = "Divider"
                Divider2.BackgroundTransparency = 1
                Divider2.Parent = value.NameFrame
                Divider2.Size = UDim2.new(1, 0, 0, 3)
                Divider2.Position = UDim2.new(0, 0, 1, 0)
            end
        end
    end
end
-- Tick --

-- INIT --
local function addTopBar()
    TopBarFrame.Transparency = 0.6000000238418579
    TopBarFrame.BorderSizePixel = 0
    TopBarFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
end

local function setButtonIcons()
    if MenuIcon.Background:FindFirstChild("StateOverlay") then
        MenuIcon.Background.StateOverlay:Destroy()
    end

    if ChatIcon.Background:FindFirstChild("StateOverlay") then
        ChatIcon.Background.StateOverlay:Destroy()
    end

    MenuIcon.Background.Image = ""
    MenuIcon.Background.Icon.Image = "rbxasset://textures/ui/Menu/Hamburger.png"
    MenuIcon.Size = UDim2.new(0, 50, 0, 36)
    MenuIcon.Background.Position = UDim2.new(-0.1, 0, 1, 0)
    MenuIcon.Background.Icon.Size = UDim2.new(0, 32, 0, 25)

    ChatIcon.Background.Image = ""
    ChatIcon.Background.Position = UDim2.new(-0.36, 0, 1, 0)
    ChatIcon.Size = UDim2.new(0, 50, 0, 36)
    ChatIcon.Background.Icon.Size = UDim2.new(0, 28, 0, 27)

    if RightFrame:FindFirstChild("MoreMenu") then
        RightFrame.MoreMenu:Destroy()
    end
end

local function addHealthBar()
    if RightFrame:FindFirstChild("HealthBar") then
        RightFrame.HealthBar:Destroy()
    end

    local NameHealthContainer = Instance.new("Frame")
    local Username = Instance.new("TextLabel")
    local HealthContainer = Instance.new("Frame")
    local HealthFill = Instance.new("Frame")

    NameHealthContainer.Name = "NameHealthContainer"
    NameHealthContainer.Parent = RightFrame
    NameHealthContainer.BackgroundTransparency = 1.000
    NameHealthContainer.Position = UDim2.new(1, -170, 0.027778089, 0)
    NameHealthContainer.Size = UDim2.new(0, 170, 1, 0)
    NameHealthContainer.Active = false

    Username.Name = "Username"
    Username.Parent = NameHealthContainer
    Username.BackgroundTransparency = 1.000
    Username.Position = UDim2.new(0, 19, 0, 0)
    Username.Size = UDim2.new(1, -14, 0, 22)
    Username.Font = Enum.Font.SourceSansBold
    Username.Text = "Player1"
    Username.TextColor3 = Color3.fromRGB(255, 255, 255)
    Username.TextSize = 14.000
    Username.TextXAlignment = Enum.TextXAlignment.Left
    Username.TextYAlignment = Enum.TextYAlignment.Bottom
    Username.Active = false

    HealthContainer.Name = "HealthContainer"
    HealthContainer.Parent = NameHealthContainer
    HealthContainer.BackgroundColor3 = Color3.fromRGB(228, 236, 246)
    HealthContainer.BorderSizePixel = 0
    HealthContainer.Position = UDim2.new(0, 19, 1, -9)
    HealthContainer.Size = UDim2.new(1, -14, 0, 3)
    HealthContainer.Active = false

    HealthFill.Name = "HealthFill"
    HealthFill.Parent = HealthContainer
    HealthFill.BackgroundColor3 = Color3.fromRGB(27, 252, 107)
    HealthFill.BorderSizePixel = 0
    HealthFill.Size = UDim2.new(1, 0, 1, 0)
    HealthFill.Active = false

    Username.Text = game:GetService("Players").LocalPlayer.Name
end

local function addUserLeaderStatus()
    local player = game.Players.LocalPlayer
    local leaderstats = player:FindFirstChild("leaderstats")

    if leaderstats then

        for _, stat in pairs(leaderstats:GetChildren()) do
            stat.Changed:Connect(function(newValue)
                onStatsValueChanged(stat.Name, newValue)
            end)

            local statName = stat.Name
            local statValue = stat.Value

            local Container = Instance.new("Frame")
            local StatNameLabel = Instance.new("TextLabel")
            local StatValueLabel = Instance.new("TextLabel")

            Container.Name = statName .. "StatLabel"
            Container.Parent = RightFrame
            Container.BackgroundTransparency = 1.000
            Container.Position = UDim2.new(1, -170, 0.027778089, 0)
            Container.Size = UDim2.new(0, 58, 1, 0)

            StatNameLabel.Name = "StatNameLabel"
            StatNameLabel.Parent = Container
            StatNameLabel.BackgroundTransparency = 1.000
            StatNameLabel.Position = UDim2.new(0.13, 0, 0, 0)
            StatNameLabel.Size = UDim2.new(1, -14, 0, 15)
            StatNameLabel.Font = Enum.Font.SourceSansBold
            StatNameLabel.Text = statName
            StatNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            StatNameLabel.TextSize = 14.000
            StatNameLabel.TextXAlignment = Enum.TextXAlignment.Center
            StatNameLabel.TextYAlignment = Enum.TextYAlignment.Bottom

            StatValueLabel.Name = "StatValueLabel"
            StatValueLabel.Parent = Container
            StatValueLabel.BackgroundTransparency = 1.000
            StatValueLabel.Position = UDim2.new(0.13, 0, 0.5, 0)
            StatValueLabel.Size = UDim2.new(1, -14, 0, 15)
            StatValueLabel.Font = Enum.Font.SourceSansBold
            StatValueLabel.Text = statValue
            StatValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            StatValueLabel.TextSize = 14.000
            StatValueLabel.TextXAlignment = Enum.TextXAlignment.Center
            StatValueLabel.TextYAlignment = Enum.TextYAlignment.Bottom
        end
    end
end

local function changePlayerList()
    if PlayerList:FindFirstChild("BottomRoundedRect") then
        PlayerList.BottomRoundedRect:Destroy()
    end

    if PlayerList:FindFirstChild("TopRoundedRect") then
        PlayerList.TopRoundedRect:Destroy()
    end

    if PlayerList:FindFirstChild("TitleBar") then
        PlayerList.TitleBar:Destroy()
    end

    makefolder("BaldyROBLOX2016")
    writefile("BaldyROBLOX2016/PremiumIcon.png", game:HttpGet("https://raw.githubusercontent.com/Baldywaldy09/ROBLOX2016ThemeScript/main/PremiumIcon.png"))
end

-- INIT --
local IsScriptLoaded
local ROBLOX2016Folder
local BaldyScriptsFolder
if not game:FindFirstChild("BaldyScripts") then
    print("[ROBLOX2016] Didnt Find \"BaldyScripts\" Folder | Making folder...")
    BaldyScriptsFolder = Instance.new("Folder")

    BaldyScriptsFolder.Name = "BaldyScripts"
    BaldyScriptsFolder.Parent = game

    print("[ROBLOX2016] Created Folder")
else
    print("[ROBLOX2016] Found folder: \"BaldyScripts\" | Checking for folder: \"ROBLOX2016\"...")
    BaldyScriptsFolder = game.BaldyScripts

    if BaldyScriptsFolder:FindFirstChild("ROBLOX2016") then
        print("[ROBLOX2016] Found folder: \"ROBLOX2016\" | Checking if script is loaded...")
        ROBLOX2016Folder = BaldyScriptsFolder.ROBLOX2016

        if ROBLOX2016Folder:FindFirstChild("IsLoaded") then
            warn("[ROBLOX2016] Script is already loaded! Stopping Loading")
            --IsScriptLoaded = true
        end

    end
end

if IsScriptLoaded then return end

if not ROBLOX2016Folder then
    print("[ROBLOX2016] Didnt Find \"ROBLOX2016\" Folder | Making folder...")

    ROBLOX2016Folder = Instance.new("Folder")
    ROBLOX2016Folder.Name = "ROBLOX2016"
    ROBLOX2016Folder.Parent = BaldyScriptsFolder
end

print("[ROBLOX2016] Marking script as loaded...")
local IsLoaded = Instance.new("BoolValue")
IsLoaded.Name = "IsLoaded"
IsLoaded.Value = true
IsLoaded.Parent = ROBLOX2016Folder
print("[ROBLOX2016] Script marked as loaded")

print("[ROBLOX2016] Loading ROBLOX2016 theme...")
addTopBar()
setButtonIcons()
addHealthBar()
addUserLeaderStatus()
changePlayerList()

local Heartbeat
Heartbeat = RunService.Heartbeat:Connect(function()
    local IsLoaded = game.BaldyScripts.ROBLOX2016.IsLoaded.Value

    if not IsLoaded then
        Heartbeat:Disconnect()
        Heartbeat = nil
        print("[ROBLOX2016] Script marked as unloaded!")
        return
    end

    chatTick()
    playerListTick()
end)

print("[ROBLOX2016] Theme Loaded Enjoy!")
