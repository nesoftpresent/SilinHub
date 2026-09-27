-- EnderHub | Delta Executor
-- Created By @SilinHubInfo (telegram)
-- Game: 99 Nights in the Forest
-- Version: 2.0

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== ПРОВЕРКА ИГРЫ ==========
local GAME_NAME = "99 Nights in the Forest"
local function IsCorrectGame()
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Name then
        return string.find(info.Name:lower(), "99 nights") ~= nil
    end
    return string.find(game.Name:lower(), "99 nights") ~= nil
end

if not IsCorrectGame() then
    return
end

-- ========== НАСТРОЙКИ ==========
local KEY_CORRECT = "EnderHubOpenYaaY"
local LOAD_TIME = 6
local LANG_WAIT = 10
local HUB_NAME = "EnderHub"

local CONFIG = {
    Key = "",
    Lang = "English",
    Fly = false,
    Noclip = false,
    Speed = 20,
    Aimbot = false,
    TriggerBot = false,
    KillAura = false,
    KillAuraRange = 5,
    EspPlayers = false,
    EspPlayersColor = "Green",
    EspMonsters = false,
    EspMonstersColor = "Red",
    EspNPC = false,
    EspNPCColor = "Yellow",
}

-- ========== СОХРАНЕНИЕ ==========
local function SaveConfig()
    if writefile then
        pcall(function()
            writefile("EnderHub_Config.json", HttpService:JSONEncode(CONFIG))
        end)
    end
end

local function LoadConfig()
    if isfile and isfile("EnderHub_Config.json") then
        pcall(function()
            local data = HttpService:JSONDecode(readfile("EnderHub_Config.json"))
            for k, v in pairs(data) do
                CONFIG[k] = v
            end
        end)
    end
end

LoadConfig()

-- ========== УДАЛЕНИЕ СТАРОГО UI ==========
local function CleanupOldUI()
    local old = CoreGui:FindFirstChild("EnderHubUI")
    if old then old:Destroy() end
    local oldBtn = CoreGui:FindFirstChild("EnderHubToggle")
    if oldBtn then oldBtn:Destroy() end
end

CleanupOldUI()

-- ========== ПЕРЕВОДЫ ==========
local L = {
    English = {
        Loading = "EnderHub are loading...",
        WriteKey = "Write key here",
        Use = "Use",
        Wait = "Please Wait",
        General = "General",
        Combat = "Combat",
        Visual = "Visual",
        Language = "Language",
        Devs = "Devs",
        Fly = "Fly",
        Noclip = "Noclip",
        SpeedHack = "SpeedHack",
        Aimbot = "Aimbot",
        TriggerBot = "TriggerBot",
        KillAura = "KillAura",
        Range = "Range (1-10)",
        EspPlayers = "Esp Players",
        EspItems = "Esp Items",
        EspMonsters = "Esp Monsters",
        EspNPC = "Esp NPC",
        InWork = "In work",
        Color = "Color",
        CreatedBy = "Created By @SilinHubInfo (telegram)",
        CreatedByShort = "Created By @SilinHubInfo (tg)",
        Green = "Green", Red = "Red", Yellow = "Yellow", Blue = "Blue",
        Cyan = "Cyan", Orange = "Orange", Lime = "Lime", Scarlet = "Scarlet",
        Demonic = "Demonic", Black = "Black",
    },
    Russia = {
        Loading = "EnderHub загружается...",
        WriteKey = "Введи ключ сюда",
        Use = "Использовать",
        Wait = "Пожалуйста, подождите",
        General = "Общее",
        Combat = "Бой",
        Visual = "Визуал",
        Language = "Язык",
        Devs = "Создатели",
        Fly = "Полёт",
        Noclip = "Ноклип",
        SpeedHack = "Скорость",
        Aimbot = "Аимбот",
        TriggerBot = "Триггербот",
        KillAura = "КиллАура",
        Range = "Радиус (1-10)",
        EspPlayers = "Esp Игроки",
        EspItems = "Esp Предметы",
        EspMonsters = "Esp Монстры",
        EspNPC = "Esp НПС",
        InWork = "В работе",
        Color = "Цвет",
        CreatedBy = "Создано @SilinHubInfo (telegram)",
        CreatedByShort = "Создано @SilinHubInfo (tg)",
        Green = "Зелёный", Red = "Красный", Yellow = "Жёлтый", Blue = "Синий",
        Cyan = "Голубой", Orange = "Оранжевый", Lime = "Салатовый", Scarlet = "Алый",
        Demonic = "Демонический", Black = "Чёрный",
    }
}

local function T(key)
    return L[CONFIG.Lang][key] or key
end

-- ========== ЦВЕТА ==========
local COLORS = {
    Green = Color3.fromRGB(40, 255, 40),
    Red = Color3.fromRGB(255, 40, 40),
    Yellow = Color3.fromRGB(255, 230, 40),
    Blue = Color3.fromRGB(40, 120, 255),
    Cyan = Color3.fromRGB(40, 230, 255),
    Orange = Color3.fromRGB(255, 140, 20),
    Lime = Color3.fromRGB(160, 255, 40),
    Scarlet = Color3.fromRGB(255, 20, 60),
    Demonic = Color3.fromRGB(140, 0, 200),
    Black = Color3.fromRGB(20, 20, 20),
}

local COLOR_ORDER = {"Green","Red","Yellow","Blue","Cyan","Orange","Lime","Scarlet","Demonic","Black"}

-- ========== GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnderHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- ========== ЭКРАН ЗАГРУЗКИ ==========
local LoadFrame = Instance.new("Frame")
LoadFrame.Size = UDim2.new(0, 320, 0, 80)
LoadFrame.Position = UDim2.new(0.5, -160, 0.5, -40)
LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
LoadFrame.BackgroundTransparency = 1
LoadFrame.BorderSizePixel = 0
LoadFrame.Parent = ScreenGui

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 12)
LoadCorner.Parent = LoadFrame

local LoadStroke = Instance.new("UIStroke")
LoadStroke.Color = Color3.fromRGB(140, 60, 220)
LoadStroke.Thickness = 2
LoadStroke.Transparency = 1
LoadStroke.Parent = LoadFrame

local LoadLabel = Instance.new("TextLabel")
LoadLabel.Size = UDim2.new(1, 0, 1, 0)
LoadLabel.BackgroundTransparency = 1
LoadLabel.Text = T("Loading")
LoadLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
LoadLabel.Font = Enum.Font.GothamBold
LoadLabel.TextSize = 20
LoadLabel.TextTransparency = 1
LoadLabel.Parent = LoadFrame

task.spawn(function()
    TweenService:Create(LoadFrame, TweenInfo.new(1.2), {BackgroundTransparency = 0}):Play()
    TweenService:Create(LoadStroke, TweenInfo.new(1.2), {Transparency = 0}):Play()
    TweenService:Create(LoadLabel, TweenInfo.new(1.2), {TextTransparency = 0}):Play()
    task.wait(LOAD_TIME)
    TweenService:Create(LoadFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadStroke, TweenInfo.new(1), {Transparency = 1}):Play()
    TweenService:Create(LoadLabel, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1.2)
    LoadFrame:Destroy()
end)

-- ========== KEY-МЕНЮ ==========
local function BuildKeyMenu()
    local KeyGui = Instance.new("Frame")
    KeyGui.Size = UDim2.new(0, 380, 0, 220)
    KeyGui.Position = UDim2.new(0.5, -190, 0.5, -110)
    KeyGui.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
    KeyGui.BackgroundTransparency = 1
    KeyGui.BorderSizePixel = 0
    KeyGui.Parent = ScreenGui

    local KC = Instance.new("UICorner")
    KC.CornerRadius = UDim.new(0, 14)
    KC.Parent = KeyGui

    local KS = Instance.new("UIStroke")
    KS.Color = Color3.fromRGB(140, 60, 220)
    KS.Thickness = 2
    KS.Transparency = 1
    KS.Parent = KeyGui

    local KTitle = Instance.new("TextLabel")
    KTitle.Size = UDim2.new(1, 0, 0, 50)
    KTitle.Position = UDim2.new(0, 0, 0, 15)
    KTitle.BackgroundTransparency = 1
    KTitle.Text = HUB_NAME
    KTitle.TextColor3 = Color3.fromRGB(200, 130, 255)
    KTitle.Font = Enum.Font.GothamBold
    KTitle.TextSize = 26
    KTitle.TextTransparency = 1
    KTitle.Parent = KeyGui

    local KHint = Instance.new("TextLabel")
    KHint.Size = UDim2.new(1, -40, 0, 20)
    KHint.Position = UDim2.new(0, 20, 0, 70)
    KHint.BackgroundTransparency = 1
    KHint.Text = T("WriteKey")
    KHint.TextColor3 = Color3.fromRGB(180, 140, 220)
    KHint.Font = Enum.Font.Gotham
    KHint.TextSize = 14
    KHint.TextTransparency = 1
    KHint.TextXAlignment = Enum.TextXAlignment.Left
    KHint.Parent = KeyGui

    local KBox = Instance.new("TextBox")
    KBox.Size = UDim2.new(1, -40, 0, 36)
    KBox.Position = UDim2.new(0, 20, 0, 95)
    KBox.BackgroundColor3 = Color3.fromRGB(25, 10, 40)
    KBox.BackgroundTransparency = 1
    KBox.BorderSizePixel = 0
    KBox.Text = ""
    KBox.PlaceholderText = "..."
    KBox.TextColor3 = Color3.fromRGB(230, 210, 255)
    KBox.PlaceholderColor3 = Color3.fromRGB(120, 80, 160)
    KBox.Font = Enum.Font.Gotham
    KBox.TextSize = 15
    KBox.ClearTextOnFocus = false
    KBox.TextTransparency = 1
    KBox.Parent = KeyGui

    local KBC = Instance.new("UICorner")
    KBC.CornerRadius = UDim.new(0, 8)
    KBC.Parent = KBox

    local KBStroke = Instance.new("UIStroke")
    KBStroke.Color = Color3.fromRGB(120, 50, 190)
    KBStroke.Thickness = 1.5
    KBStroke.Transparency = 1
    KBStroke.Parent = KBox

    local KUse = Instance.new("TextButton")
    KUse.Size = UDim2.new(1, -40, 0, 38)
    KUse.Position = UDim2.new(0, 20, 0, 150)
    KUse.BackgroundColor3 = Color3.fromRGB(90, 30, 160)
    KUse.BackgroundTransparency = 1
    KUse.BorderSizePixel = 0
    KUse.Text = T("Use")
    KUse.TextColor3 = Color3.fromRGB(240, 220, 255)
    KUse.Font = Enum.Font.GothamBold
    KUse.TextSize = 16
    KUse.TextTransparency = 1
    KUse.Parent = KeyGui

    local KUC = Instance.new("UICorner")
    KUC.CornerRadius = UDim.new(0, 8)
    KUC.Parent = KUse

    TweenService:Create(KeyGui, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
    TweenService:Create(KS, TweenInfo.new(1), {Transparency = 0}):Play()
    TweenService:Create(KTitle, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(KHint, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(KBox, TweenInfo.new(1), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    TweenService:Create(KBStroke, TweenInfo.new(1), {Transparency = 0}):Play()
    TweenService:Create(KUse, TweenInfo.new(1), {BackgroundTransparency = 0, TextTransparency = 0}):Play()

    KUse.MouseButton1Click:Connect(function()
        if KBox.Text == KEY_CORRECT then
            CONFIG.Key = KBox.Text
            SaveConfig()
            TweenService:Create(KeyGui, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
            TweenService:Create(KTitle, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
            TweenService:Create(KHint, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
            TweenService:Create(KBox, TweenInfo.new(0.6), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(KUse, TweenInfo.new(0.6), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(KS, TweenInfo.new(0.6), {Transparency = 1}):Play()
            task.wait(0.7)
            KeyGui:Destroy()
            task.wait(3)
            BuildMainMenu()
        else
            KBStroke.Color = Color3.fromRGB(220, 30, 30)
            task.wait(0.4)
            KBStroke.Color = Color3.fromRGB(120, 50, 190)
        end
    end)
end

-- ========== ОВЕРЛЕЙ WAIT ==========
local function ShowWaitOverlay(callback)
    local WaitGui = Instance.new("Frame")
    WaitGui.Size = UDim2.new(1, 0, 1, 0)
    WaitGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    WaitGui.BackgroundTransparency = 1
    WaitGui.BorderSizePixel = 0
    WaitGui.ZIndex = 100
    WaitGui.Parent = ScreenGui

    local WLabel = Instance.new("TextLabel")
    WLabel.Size = UDim2.new(1, 0, 1, 0)
    WLabel.BackgroundTransparency = 1
    WLabel.Text = T("Wait") .. "..."
    WLabel.TextColor3 = Color3.fromRGB(200, 130, 255)
    WLabel.Font = Enum.Font.GothamBold
    WLabel.TextSize = 32
    WLabel.TextTransparency = 1
    WLabel.ZIndex = 101
    WLabel.Parent = WaitGui

    TweenService:Create(WaitGui, TweenInfo.new(0.5), {BackgroundTransparency = 0.4}):Play()
    TweenService:Create(WLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    task.wait(LANG_WAIT)
    TweenService:Create(WaitGui, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(WLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.6)
    WaitGui:Destroy()
    if callback then callback() end
end

-- ========== FLY (ФИКС) ==========
local flyConn, flyBody, flyHumanoid
local function ToggleFly(state)
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyBody then flyBody:Destroy() flyBody = nil end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if state then
        flyHumanoid = hum
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        flyBody = Instance.new("BodyVelocity")
        flyBody.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBody.Velocity = Vector3.zero
        flyBody.Parent = hrp

        flyConn = RunService.RenderStepped:Connect(function()
            if not char.Parent then return end
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then
                flyBody.Velocity = dir.Unit * 80
            else
                flyBody.Velocity = Vector3.zero
            end
        end)
    else
        if flyHumanoid then
            pcall(function() flyHumanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end
end

-- ========== NOCLIP ==========
local noclipConn
local function ToggleNoclip(state)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if not state then return end
    noclipConn = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end
    end)
end

-- ========== SPEED ==========
local function ApplySpeed(val)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
end

-- ========== ESP ==========
local espPlayersFolder = Instance.new("Folder")
espPlayersFolder.Name = "EnderHubEspPlayers"
espPlayersFolder.Parent = CoreGui

local espMonstersFolder = Instance.new("Folder")
espMonstersFolder.Name = "EnderHubEspMonsters"
espMonstersFolder.Parent = CoreGui

local espNPCFolder = Instance.new("Folder")
espNPCFolder.Name = "EnderHubEspNPC"
espNPCFolder.Parent = CoreGui

local MONSTER_NAMES = {"Deer", "Owl", "Ram", "Bat", "Cat", "Elk", "Rabbit", "Wolf", "Bear", "Alpha Wolf"}
local NPC_NAMES = {"PeltTrader", "FurnitureTrader", "ShiftySalesman", "Trader", "Merchant", "NPC"}

local function CreateHighlight(folder, instance, colorName)
    if not instance then return end
    local name = instance.Name
    if folder:FindFirstChild(name) then return end
    local hl = Instance.new("Highlight")
    hl.Name = name
    hl.FillColor = COLORS[colorName] or COLORS.Red
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Adornee = instance
    hl.Parent = folder
end

local function RefreshPlayersESP()
    espPlayersFolder:ClearAllChildren()
    if not CONFIG.EspPlayers then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            CreateHighlight(espPlayersFolder, p.Character, CONFIG.EspPlayersColor)
        end
    end
end

local function RefreshMonstersESP()
    espMonstersFolder:ClearAllChildren()
    if not CONFIG.EspMonsters then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            for _, mname in ipairs(MONSTER_NAMES) do
                if string.find(obj.Name:lower(), mname:lower()) then
                    CreateHighlight(espMonstersFolder, obj, CONFIG.EspMonstersColor)
                    break
                end
            end
        end
    end
end

local function RefreshNPCESP()
    espNPCFolder:ClearAllChildren()
    if not CONFIG.EspNPC then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            for _, nname in ipairs(NPC_NAMES) do
                if string.find(obj.Name:lower(), nname:lower()) then
                    CreateHighlight(espNPCFolder, obj, CONFIG.EspNPCColor)
                    break
                end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        if CONFIG.EspPlayers then
            CreateHighlight(espPlayersFolder, c, CONFIG.EspPlayersColor)
        end
    end)
end)

-- ========== COMBAT ==========
local aimbotConn, triggerConn, auraConn

local function GetClosestPlayer(maxDist)
    local closest, dist = nil, maxDist or math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - Camera.CFrame.Position).Magnitude
                if d < dist then dist = d closest = p end
            end
        end
    end
    return closest
end

local function ToggleAimbot(state)
    if aimbotConn then aimbotConn:Disconnect() aimbotConn = nil end
    if not state then return end
    aimbotConn = RunService.RenderStepped:Connect(function()
        local target = GetClosestPlayer(300)
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
            end
        end
    end)
end

local function ToggleTriggerBot(state)
    if triggerConn then triggerConn:Disconnect() triggerConn = nil end
    if not state then return end
    triggerConn = RunService.RenderStepped:Connect(function()
        local target = GetClosestPlayer(50)
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    local pos = Vector2.new(screenPoint.X, screenPoint.Y)
                    if (pos - center).Magnitude < 30 then
                        pcall(function()
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end)
                    end
                end
            end
        end
    end)
end

local function ToggleKillAura(state)
    if auraConn then auraConn:Disconnect() auraConn = nil end
    if not state then return end
    auraConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local targetHrp = p.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
                if targetHrp and targetHum and targetHum.Health > 0 then
                    local d = (targetHrp.Position - hrp.Position).Magnitude
                    if d <= CONFIG.KillAuraRange then
                        pcall(function()
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                                if tool:FindFirstChild("Handle") then
                                    tool.Handle.CFrame = targetHrp.CFrame
                                end
                            end
                        end)
                    end
                end
            end
        end
    end)
end

-- ========== ГЛАВНОЕ МЕНЮ ==========
function BuildMainMenu()
    local Main = Instance.new("Frame")
    Main.Name = "MainMenu"
    Main.Size = UDim2.new(0, 580, 0, 400)
    Main.Position = UDim2.new(0.5, -290, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(12, 4, 22)
    Main.BackgroundTransparency = 1
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    local MC = Instance.new("UICorner")
    MC.CornerRadius = UDim.new(0, 14)
    MC.Parent = Main

    local MS = Instance.new("UIStroke")
    MS.Color = Color3.fromRGB(140, 60, 220)
    MS.Thickness = 2
    MS.Transparency = 1
    MS.Parent = Main

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(20, 8, 35)
    Header.BackgroundTransparency = 1
    Header.BorderSizePixel = 0
    Header.Parent = Main

    local HC = Instance.new("UICorner")
    HC.CornerRadius = UDim.new(0, 14)
    HC.Parent = Header

    local HLogo = Instance.new("TextLabel")
    HLogo.Size = UDim2.new(1, -20, 0, 28)
    HLogo.Position = UDim2.new(0, 20, 0, 6)
    HLogo.BackgroundTransparency = 1
    HLogo.Text = HUB_NAME
    HLogo.TextColor3 = Color3.fromRGB(200, 130, 255)
    HLogo.Font = Enum.Font.GothamBold
    HLogo.TextSize = 22
    HLogo.TextXAlignment = Enum.TextXAlignment.Left
    HLogo.TextTransparency = 1
    HLogo.Parent = Header

    local HSub = Instance.new("TextLabel")
    HSub.Size = UDim2.new(1, -20, 0, 16)
    HSub.Position = UDim2.new(0, 20, 0, 34)
    HSub.BackgroundTransparency = 1
    HSub.Text = T("CreatedBy")
    HSub.TextColor3 = Color3.fromRGB(140, 100, 180)
    HSub.Font = Enum.Font.Gotham
    HSub.TextSize = 11
    HSub.TextXAlignment = Enum.TextXAlignment.Left
    HSub.TextTransparency = 1
    HSub.Parent = Header

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -80)
    Sidebar.Position = UDim2.new(0, 10, 0, 70)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 7, 32)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(0, 10)
    SC.Parent = Sidebar

    local SList = Instance.new("UIListLayout")
    SList.Padding = UDim.new(0, 6)
    SList.SortOrder = Enum.SortOrder.LayoutOrder
    SList.Parent = Sidebar

    local SPad = Instance.new("UIPadding")
    SPad.PaddingTop = UDim.new(0, 10)
    SPad.PaddingLeft = UDim.new(0, 8)
    SPad.PaddingRight = UDim.new(0, 8)
    SPad.Parent = Sidebar

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -190, 1, -80)
    Content.Position = UDim2.new(0, 180, 0, 70)
    Content.BackgroundColor3 = Color3.fromRGB(18, 7, 32)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.Parent = Main

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(0, 10)
    CC.Parent = Content

    local function MakeLightning(parent)
        for i = 1, 3 do
            local ln = Instance.new("Frame")
            ln.Size = UDim2.new(0, 2, 0, 60)
            ln.Position = UDim2.new(1, -30 - i*20, 0, 20 + i*30)
            ln.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
            ln.BackgroundTransparency = 0.7
            ln.BorderSizePixel = 0
            ln.Rotation = 20 + i*5
            ln.Parent = parent
        end
    end
    MakeLightning(Main)

    TweenService:Create(Main, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(MS, TweenInfo.new(0.8), {Transparency = 0}):Play()
    TweenService:Create(Header, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Content, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(HLogo, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    TweenService:Create(HSub, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    local tabButtons = {}
    local currentTab = "General"

    local function ClearContent()
        for _, c in ipairs(Content:GetChildren()) do
            if not c:IsA("UICorner") then c:Destroy() end
        end
    end

    local function MakeToggle(parent, labelKey, state, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 50)
        row.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
        row.BorderSizePixel = 0
        row.Parent = parent
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 8) rc.Parent = row

        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1, -80, 0, 22)
        name.Position = UDim2.new(0, 12, 0, 6)
        name.BackgroundTransparency = 1
        name.Text = T(labelKey)
        name.TextColor3 = Color3.fromRGB(220, 190, 255)
        name.Font = Enum.Font.GothamBold
        name.TextSize = 14
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.Parent = row

        local stateLbl = Instance.new("TextLabel")
        stateLbl.Size = UDim2.new(1, -80, 0, 14)
        stateLbl.Position = UDim2.new(0, 12, 0, 28)
        stateLbl.BackgroundTransparency = 1
        stateLbl.Text = state and "ON" or "OFF"
        stateLbl.TextColor3 = state and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
        stateLbl.Font = Enum.Font.Gotham
        stateLbl.TextSize = 11
        stateLbl.TextXAlignment = Enum.TextXAlignment.Left
        stateLbl.Parent = row

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 50, 0, 26)
        btn.Position = UDim2.new(1, -62, 0.5, -13)
        btn.BackgroundColor3 = state and Color3.fromRGB(90, 30, 160) or Color3.fromRGB(40, 15, 70)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = row
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 13) bc.Parent = btn

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 20, 0, 20)
        dot.Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        dot.BackgroundColor3 = Color3.fromRGB(230, 210, 255)
        dot.BorderSizePixel = 0
        dot.Parent = btn
        local dc = Instance.new("UICorner") dc.CornerRadius = UDim.new(1, 0) dc.Parent = dot

        btn.MouseButton1Click:Connect(function()
            state = not state
            stateLbl.Text = state and "ON" or "OFF"
            stateLbl.TextColor3 = state and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
            btn.BackgroundColor3 = state and Color3.fromRGB(90, 30, 160) or Color3.fromRGB(40, 15, 70)
            TweenService:Create(dot, TweenInfo.new(0.15), {
                Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            }):Play()
            callback(state)
            SaveConfig()
        end)
    end

    local function MakeInput(parent, labelKey, value, minV, maxV, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 60)
        row.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
        row.BorderSizePixel = 0
        row.Parent = parent
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 8) rc.Parent = row

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -24, 0, 20)
        lbl.Position = UDim2.new(0, 12, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text = T(labelKey) .. " (" .. minV .. "-" .. maxV .. ")"
        lbl.TextColor3 = Color3.fromRGB(220, 190, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -24, 0, 28)
        box.Position = UDim2.new(0, 12, 0, 28)
        box.BackgroundColor3 = Color3.fromRGB(20, 8, 40)
        box.BorderSizePixel = 0
        box.Text = tostring(value)
        box.TextColor3 = Color3.fromRGB(230, 210, 255)
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.Parent = row
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = box

        box.FocusLost:Connect(function()
            local n = tonumber(box.Text)
            if n then
                n = math.clamp(n, minV, maxV)
                box.Text = tostring(n)
                callback(n)
                SaveConfig()
            else
                box.Text = tostring(value)
            end
        end)
    end

    local function MakeColorRow(parent, labelKey, currentColorKey, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 80)
        row.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
        row.BorderSizePixel = 0
        row.Parent = parent
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 8) rc.Parent = row

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -24, 0, 20)
        lbl.Position = UDim2.new(0, 12, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text = T(labelKey)
        lbl.TextColor3 = Color3.fromRGB(220, 190, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local grid = Instance.new("Frame")
        grid.Size = UDim2.new(1, -24, 0, 44)
        grid.Position = UDim2.new(0, 12, 0, 28)
        grid.BackgroundTransparency = 1
        grid.Parent = row

        local gl = Instance.new("UIGridLayout")
        gl.CellSize = UDim2.new(0, 22, 0, 22)
        gl.CellPadding = UDim2.new(0, 4, 0, 4)
        gl.SortOrder = Enum.SortOrder.LayoutOrder
        gl.Parent = grid

        for i, cname in ipairs(COLOR_ORDER) do
            local sq = Instance.new("TextButton")
            sq.Size = UDim2.new(0, 22, 0, 22)
            sq.BackgroundColor3 = COLORS[cname]
            sq.BorderSizePixel = 0
            sq.Text = ""
            sq.LayoutOrder = i
            sq.Parent = grid
            local sc = Instance.new("UICorner") sc.CornerRadius = UDim.new(0, 4) sc.Parent = sq

            if cname == currentColorKey then
                local sel = Instance.new("UIStroke")
                sel.Color = Color3.fromRGB(255, 255, 255)
                sel.Thickness = 2
                sel.Parent = sq
            end

            sq.MouseButton1Click:Connect(function()
                for _, other in ipairs(grid:GetChildren()) do
                    if other:IsA("TextButton") then
                        local s = other:FindFirstChildOfClass("UIStroke")
                        if s then s:Destroy() end
                    end
                end
                local sel = Instance.new("UIStroke")
                sel.Color = Color3.fromRGB(255, 255, 255)
                sel.Thickness = 2
                sel.Parent = sq
                callback(cname)
                SaveConfig()
            end)
        end
    end

    local function BuildGeneral()
        ClearContent()
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 10)
        list.Parent = Content
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 14)
        pad.PaddingLeft = UDim.new(0, 14)
        pad.PaddingRight = UDim.new(0, 14)
        pad.Parent = Content

        MakeToggle(Content, "Fly", CONFIG.Fly, function(s) CONFIG.Fly = s ToggleFly(s) end)
        MakeToggle(Content, "Noclip", CONFIG.Noclip, function(s) CONFIG.Noclip = s ToggleNoclip(s) end)
        MakeInput(Content, "SpeedHack", CONFIG.Speed, 20, 150, function(v) CONFIG.Speed = v ApplySpeed(v) end)
    end

    local function BuildCombat()
        ClearContent()
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 10)
        list.Parent = Content
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 14)
        pad.PaddingLeft = UDim.new(0, 14)
        pad.PaddingRight = UDim.new(0, 14)
        pad.Parent = Content

        MakeToggle(Content, "Aimbot", CONFIG.Aimbot, function(s) CONFIG.Aimbot = s ToggleAimbot(s) end)
        MakeToggle(Content, "TriggerBot", CONFIG.TriggerBot, function(s) CONFIG.TriggerBot = s ToggleTriggerBot(s) end)
        MakeToggle(Content, "KillAura", CONFIG.KillAura, function(s) CONFIG.KillAura = s ToggleKillAura(s) end)
        MakeInput(Content, "Range", CONFIG.KillAuraRange, 1, 10, function(v) CONFIG.KillAuraRange = v end)
    end

    local function BuildVisual()
        ClearContent()
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 10)
        list.Parent = Content
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 14)
        pad.PaddingLeft = UDim.new(0, 14)
        pad.PaddingRight = UDim.new(0, 14)
        pad.Parent = Content

        MakeToggle(Content, "EspPlayers", CONFIG.EspPlayers, function(s) CONFIG.EspPlayers = s RefreshPlayersESP() end)
        MakeColorRow(Content, "EspPlayers", CONFIG.EspPlayersColor, function(c) CONFIG.EspPlayersColor = c RefreshPlayersESP() end)

        local inWork = Instance.new("Frame")
        inWork.Size = UDim2.new(1, 0, 0, 50)
        inWork.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
        inWork.BorderSizePixel = 0
        inWork.Parent = Content
        local iwc = Instance.new("UICorner") iwc.CornerRadius = UDim.new(0, 8) iwc.Parent = inWork
        local iwl = Instance.new("TextLabel")
        iwl.Size = UDim2.new(1, 0, 1, 0)
        iwl.BackgroundTransparency = 1
        iwl.Text = T("EspItems") .. " — " .. T("InWork")
        iwl.TextColor3 = Color3.fromRGB(150, 100, 200)
        iwl.Font = Enum.Font.GothamBold
        iwl.TextSize = 13
        iwl.Parent = inWork

        MakeToggle(Content, "EspMonsters", CONFIG.EspMonsters, function(s) CONFIG.EspMonsters = s RefreshMonstersESP() end)
        MakeColorRow(Content, "EspMonsters", CONFIG.EspMonstersColor, function(c) CONFIG.EspMonstersColor = c RefreshMonstersESP() end)

        MakeToggle(Content, "EspNPC", CONFIG.EspNPC, function(s) CONFIG.EspNPC = s RefreshNPCESP() end)
        MakeColorRow(Content, "EspNPC", CONFIG.EspNPCColor, function(c) CONFIG.EspNPCColor = c RefreshNPCESP() end)
    end

    local function BuildLanguage()
        ClearContent()
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 10)
        list.Parent = Content
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 14)
        pad.PaddingLeft = UDim.new(0, 14)
        pad.PaddingRight = UDim.new(0, 14)
        pad.Parent = Content

        local function LangBtn(name, code)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 42)
            b.BackgroundColor3 = CONFIG.Lang == code and Color3.fromRGB(90, 30, 160) or Color3.fromRGB(40, 15, 70)
            b.BorderSizePixel = 0
            b.Text = name
            b.TextColor3 = Color3.fromRGB(230, 210, 255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 15
            b.Parent = Content
            local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 8) bc.Parent = b
            b.MouseButton1Click:Connect(function()
                if CONFIG.Lang == code then return end
                CONFIG.Lang = code
                SaveConfig()
                ShowWaitOverlay(function()
                    Main:Destroy()
                    BuildMainMenu()
                end)
            end)
        end

        LangBtn("English", "English")
        LangBtn("Russia / Русский", "Russia")
    end

    local function BuildDevs()
        ClearContent()
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = T("CreatedByShort")
        lbl.TextColor3 = Color3.fromRGB(200, 130, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 18
        lbl.Parent = Content
    end

    local function SwitchTab(tabName)
        currentTab = tabName
        for name, btn in pairs(tabButtons) do
            if name == tabName then
                btn.BackgroundColor3 = Color3.fromRGB(90, 30, 160)
            else
                btn.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
            end
        end
        if tabName == "General" then BuildGeneral()
        elseif tabName == "Combat" then BuildCombat()
        elseif tabName == "Visual" then BuildVisual()
        elseif tabName == "Language" then BuildLanguage()
        elseif tabName == "Devs" then BuildDevs()
        end
    end

    local function MakeTab(labelKey, tabName)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
        btn.BorderSizePixel = 0
        btn.Text = T(labelKey)
        btn.TextColor3 = Color3.fromRGB(220, 190, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Parent = Sidebar
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 7) bc.Parent = btn
        tabButtons[tabName] = btn
        btn.MouseButton1Click:Connect(function() SwitchTab(tabName) end)
    end

    MakeTab("General", "General")
    MakeTab("Combat", "Combat")
    MakeTab("Visual", "Visual")
    MakeTab("Language", "Language")
    MakeTab("Devs", "Devs")

    SwitchTab("General")

    -- Кнопка закрытия
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Name = "EnderHubToggle"
    toggleBtn.Size = UDim2.new(0, 60, 0, 60)
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -30)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Image = "https://i.postimg.cc/jjK8WrRv/diting-result-d5d4d45cbaa511f1b5fa420a27eb69d1-1.jpg"
    toggleBtn.Active = true
    toggleBtn.Draggable = true
    toggleBtn.Parent = ScreenGui

    local tc = Instance.new("UICorner") tc.CornerRadius = UDim.new(0, 10) tc.Parent = toggleBtn
    local ts = Instance.new("UIStroke") ts.Color = Color3.fromRGB(220, 30, 40) ts.Thickness = 2 ts.Parent = toggleBtn

    local menuVisible = true
    toggleBtn.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        if menuVisible then
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.32)
            Main.Visible = false
        end
    end)

    task.spawn(function()
        if CONFIG.Fly then ToggleFly(true) end
        if CONFIG.Noclip then ToggleNoclip(true) end
        ApplySpeed(CONFIG.Speed)
        RefreshPlayersESP()
        RefreshMonstersESP()
        RefreshNPCESP()
        if CONFIG.Aimbot then ToggleAimbot(true) end
        if CONFIG.TriggerBot then ToggleTriggerBot(true) end
        if CONFIG.KillAura then ToggleKillAura(true) end
    end)
end

-- ========== СТАРТ ==========
task.spawn(function()
    task.wait(LOAD_TIME + 3)
    if CONFIG.Key == KEY_CORRECT then
        BuildMainMenu()
    else
        BuildKeyMenu()
    end
end)
