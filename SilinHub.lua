-- SilinHub | Delta Executor
-- Created By @SilinHubInfo (telegram)
-- Version: 1.0

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========== НАСТРОЙКИ ==========
local KEY_CORRECT = "silinhublolxd"
local LOAD_TIME = 6
local LANG_WAIT = 10

local CONFIG = {
    Key = "",
    Lang = "English",
    Fly = false,
    Noclip = false,
    Speed = 20,
    Esp = false,
    EspColor = "Red",
}

-- ========== СОХРАНЕНИЕ ==========
local function SaveConfig()
    if writefile then
        pcall(function()
            writefile("SilinHub_Config.json", HttpService:JSONEncode(CONFIG))
        end)
    end
end

local function LoadConfig()
    if isfile and isfile("SilinHub_Config.json") then
        pcall(function()
            local data = HttpService:JSONDecode(readfile("SilinHub_Config.json"))
            for k, v in pairs(data) do
                CONFIG[k] = v
            end
        end)
    end
end

LoadConfig()

-- ========== УДАЛЕНИЕ СТАРОГО UI ==========
local function CleanupOldUI()
    local old = CoreGui:FindFirstChild("SilinHubUI")
    if old then old:Destroy() end
end

CleanupOldUI()

-- ========== ПЕРЕВОДЫ ==========
local L = {
    English = {
        Loading = "SilinHub are loading...",
        WriteKey = "Write key here",
        Use = "Use",
        Wait = "Please Wait",
        General = "General",
        ControlEurope = "ControlEurope",
        Esp = "Esp",
        Upgrade = "Upgrade",
        Language = "Language",
        Devs = "Devs",
        Fly = "Fly",
        Noclip = "Noclip",
        SpeedHack = "SpeedHack",
        SpeedMin = "Min: 20",
        SpeedMax = "Max: 150",
        EspColor = "Esp Color",
        Red = "Red", Green = "Green", Blue = "Blue", Yellow = "Yellow", Orange = "Orange",
        InWork = "In work",
        CreatedBy = "Created By @SilinHubInfo (telegram)",
        CreatedByShort = "Created By @SilinHubInfo (tg)",
    },
    Russia = {
        Loading = "SilinHub загружается...",
        WriteKey = "Введи ключ сюда",
        Use = "Использовать",
        Wait = "Пожалуйста, подождите",
        General = "Общее",
        ControlEurope = "ControlEurope",
        Esp = "Esp",
        Upgrade = "Прокачка",
        Language = "Язык",
        Devs = "Создатели",
        Fly = "Полёт",
        Noclip = "Ноклип",
        SpeedHack = "Скорость",
        SpeedMin = "Мин: 20",
        SpeedMax = "Макс: 150",
        EspColor = "Цвет Esp",
        Red = "Красный", Green = "Зелёный", Blue = "Синий", Yellow = "Жёлтый", Orange = "Оранжевый",
        InWork = "В работе",
        CreatedBy = "Создано @SilinHubInfo (telegram)",
        CreatedByShort = "Создано @SilinHubInfo (tg)",
    }
}

local function T(key)
    return L[CONFIG.Lang][key] or key
end

-- ========== ГЛАВНЫЙ GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SilinHubUI"
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

-- Плавное появление
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

-- ========== ФУНКЦИЯ СОЗДАНИЯ МЕНЮ КЛЮЧА ==========
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
    KTitle.Text = "SilinHub"
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

    -- Появление
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
            -- Закрытие
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

-- ========== ОВЕРЛЕЙ "PLEASE WAIT" ==========
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

-- ========== ЛОГИКА FLY ==========
local flyConn, flyBody
local function ToggleFly(state)
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyBody then flyBody:Destroy() flyBody = nil end
    if not state then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flyBody = Instance.new("BodyVelocity")
    flyBody.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBody.Velocity = Vector3.zero
    flyBody.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function()
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
end

-- ========== ЛОГИКА NOCLIP ==========
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

-- ========== ЛОГИКА SPEED ==========
local function ApplySpeed(val)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
end

-- ========== ЛОГИКА ESP ==========
local espFolder = Instance.new("Folder")
espFolder.Name = "SilinHubESP"
espFolder.Parent = CoreGui

local ESP_COLORS = {
    Red = Color3.fromRGB(255, 40, 40),
    Green = Color3.fromRGB(40, 255, 40),
    Blue = Color3.fromRGB(40, 120, 255),
    Yellow = Color3.fromRGB(255, 230, 40),
    Orange = Color3.fromRGB(255, 140, 20),
}

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    if espFolder:FindFirstChild(plr.Name) then return end
    local hl = Instance.new("Highlight")
    hl.Name = plr.Name
    hl.FillColor = ESP_COLORS[CONFIG.EspColor] or ESP_COLORS.Red
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Adornee = plr.Character
    hl.Parent = espFolder
    plr.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        if espFolder:FindFirstChild(plr.Name) then
            espFolder[plr.Name].Adornee = c
        end
    end)
end

local function RefreshESP()
    espFolder:ClearAllChildren()
    if not CONFIG.Esp then return end
    for _, p in ipairs(Players:GetPlayers()) do
        CreateESP(p)
    end
end

local function UpdateESPColor()
    for _, hl in ipairs(espFolder:GetChildren()) do
        if hl:IsA("Highlight") then
            hl.FillColor = ESP_COLORS[CONFIG.EspColor] or ESP_COLORS.Red
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    if CONFIG.Esp then CreateESP(p) end
end)

-- ========== ГЛАВНОЕ МЕНЮ ==========
function BuildMainMenu()
    local Main = Instance.new("Frame")
    Main.Name = "MainMenu"
    Main.Size = UDim2.new(0, 560, 0, 380)
    Main.Position = UDim2.new(0.5, -280, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(12, 4, 22)
    Main.BackgroundTransparency = 1
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local MC = Instance.new("UICorner")
    MC.CornerRadius = UDim.new(0, 14)
    MC.Parent = Main

    local MS = Instance.new("UIStroke")
    MS.Color = Color3.fromRGB(140, 60, 220)
    MS.Thickness = 2
    MS.Transparency = 1
    MS.Parent = Main

    -- Шапка
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
    HLogo.Text = "SilinHub"
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

    -- Левая панель вкладок
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, -80)
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

    -- Контент
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -180, 1, -80)
    Content.Position = UDim2.new(0, 170, 0, 70)
    Content.BackgroundColor3 = Color3.fromRGB(18, 7, 32)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.Parent = Main

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(0, 10)
    CC.Parent = Content

    -- Молнии (декор)
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

    -- Появление
    TweenService:Create(Main, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(MS, TweenInfo.new(0.8), {Transparency = 0}):Play()
    TweenService:Create(Header, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Content, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    TweenService:Create(HLogo, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    TweenService:Create(HSub, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    -- Переменные для пересборки
    local pages = {}
    local tabButtons = {}
    local currentTab = "General"

    local function ClearContent()
        for _, c in ipairs(Content:GetChildren()) do
            if not c:IsA("UICorner") then c:Destroy() end
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

        -- Fly
        local flyBtn = Instance.new("TextButton")
        flyBtn.Size = UDim2.new(1, 0, 0, 40)
        flyBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 70)
        flyBtn.BorderSizePixel = 0
        flyBtn.Text = T("Fly") .. ": " .. (CONFIG.Fly and "ON" or "OFF")
        flyBtn.TextColor3 = CONFIG.Fly and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
        flyBtn.Font = Enum.Font.Gotham
        flyBtn.TextSize = 14
        flyBtn.Parent = Content
        local fc = Instance.new("UICorner") fc.CornerRadius = UDim.new(0, 8) fc.Parent = flyBtn
        flyBtn.MouseButton1Click:Connect(function()
            CONFIG.Fly = not CONFIG.Fly
            flyBtn.Text = T("Fly") .. ": " .. (CONFIG.Fly and "ON" or "OFF")
            flyBtn.TextColor3 = CONFIG.Fly and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
            ToggleFly(CONFIG.Fly)
            SaveConfig()
        end)

        -- Noclip
        local ncBtn = Instance.new("TextButton")
        ncBtn.Size = UDim2.new(1, 0, 0, 40)
        ncBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 70)
        ncBtn.BorderSizePixel = 0
        ncBtn.Text = T("Noclip") .. ": " .. (CONFIG.Noclip and "ON" or "OFF")
        ncBtn.TextColor3 = CONFIG.Noclip and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
        ncBtn.Font = Enum.Font.Gotham
        ncBtn.TextSize = 14
        ncBtn.Parent = Content
        local ncc = Instance.new("UICorner") ncc.CornerRadius = UDim.new(0, 8) ncc.Parent = ncBtn
        ncBtn.MouseButton1Click:Connect(function()
            CONFIG.Noclip = not CONFIG.Noclip
            ncBtn.Text = T("Noclip") .. ": " .. (CONFIG.Noclip and "ON" or "OFF")
            ncBtn.TextColor3 = CONFIG.Noclip and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
            ToggleNoclip(CONFIG.Noclip)
            SaveConfig()
        end)

        -- SpeedHack
        local spFrame = Instance.new("Frame")
        spFrame.Size = UDim2.new(1, 0, 0, 80)
        spFrame.BackgroundColor3 = Color3.fromRGB(40, 15, 70)
        spFrame.BorderSizePixel = 0
        spFrame.Parent = Content
        local spc = Instance.new("UICorner") spc.CornerRadius = UDim.new(0, 8) spc.Parent = spFrame

        local spTitle = Instance.new("TextLabel")
        spTitle.Size = UDim2.new(1, 0, 0, 24)
        spTitle.Position = UDim2.new(0, 0, 0, 4)
        spTitle.BackgroundTransparency = 1
        spTitle.Text = T("SpeedHack")
        spTitle.TextColor3 = Color3.fromRGB(220, 190, 255)
        spTitle.Font = Enum.Font.GothamBold
        spTitle.TextSize = 14
        spTitle.Parent = spFrame

        local spBox = Instance.new("TextBox")
        spBox.Size = UDim2.new(1, -20, 0, 32)
        spBox.Position = UDim2.new(0, 10, 0, 34)
        spBox.BackgroundColor3 = Color3.fromRGB(25, 8, 45)
        spBox.BorderSizePixel = 0
        spBox.Text = tostring(CONFIG.Speed)
        spBox.TextColor3 = Color3.fromRGB(230, 210, 255)
        spBox.Font = Enum.Font.Gotham
        spBox.TextSize = 14
        spBox.Parent = spFrame
        local spbc = Instance.new("UICorner") spbc.CornerRadius = UDim.new(0, 6) spbc.Parent = spBox

        spBox.FocusLost:Connect(function()
            local n = tonumber(spBox.Text)
            if n then
                n = math.clamp(n, 20, 150)
                CONFIG.Speed = n
                spBox.Text = tostring(n)
                ApplySpeed(n)
                SaveConfig()
            else
                spBox.Text = tostring(CONFIG.Speed)
            end
        end)

        -- Esp
        local espBtn = Instance.new("TextButton")
        espBtn.Size = UDim2.new(1, 0, 0, 40)
        espBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 70)
        espBtn.BorderSizePixel = 0
        espBtn.Text = T("Esp") .. ": " .. (CONFIG.Esp and "ON" or "OFF")
        espBtn.TextColor3 = CONFIG.Esp and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
        espBtn.Font = Enum.Font.Gotham
        espBtn.TextSize = 14
        espBtn.Parent = Content
        local ec = Instance.new("UICorner") ec.CornerRadius = UDim.new(0, 8) ec.Parent = espBtn
        espBtn.MouseButton1Click:Connect(function()
            CONFIG.Esp = not CONFIG.Esp
            espBtn.Text = T("Esp") .. ": " .. (CONFIG.Esp and "ON" or "OFF")
            espBtn.TextColor3 = CONFIG.Esp and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 150, 150)
            RefreshESP()
            SaveConfig()
        end)

        -- Цвета Esp
        local colorTitle = Instance.new("TextLabel")
        colorTitle.Size = UDim2.new(1, 0, 0, 22)
        colorTitle.BackgroundTransparency = 1
        colorTitle.Text = T("EspColor")
        colorTitle.TextColor3 = Color3.fromRGB(200, 160, 240)
        colorTitle.Font = Enum.Font.Gotham
        colorTitle.TextSize = 13
        colorTitle.Parent = Content

        local colorRow = Instance.new("Frame")
        colorRow.Size = UDim2.new(1, 0, 0, 36)
        colorRow.BackgroundTransparency = 1
        colorRow.Parent = Content
        local crl = Instance.new("UIListLayout")
        crl.FillDirection = Enum.FillDirection.Horizontal
        crl.Padding = UDim.new(0, 8)
        crl.Parent = colorRow

        local colorKeys = {"Red", "Green", "Blue", "Yellow", "Orange"}
        for _, key in ipairs(colorKeys) do
            local cbtn = Instance.new("TextButton")
            cbtn.Size = UDim2.new(0, 90, 1, 0)
            cbtn.BackgroundColor3 = ESP_COLORS[key]
            cbtn.BorderSizePixel = 0
            cbtn.Text = T(key)
            cbtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            cbtn.Font = Enum.Font.GothamBold
            cbtn.TextSize = 12
            cbtn.Parent = colorRow
            local cbc = Instance.new("UICorner") cbc.CornerRadius = UDim.new(0, 6) cbc.Parent = cbtn
            cbtn.MouseButton1Click:Connect(function()
                CONFIG.EspColor = key
                UpdateESPColor()
                SaveConfig()
            end)
        end
    end

    local function BuildInWork()
        ClearContent()
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1        lbl.Text = T("InWork")
        lbl.TextColor3 = Color3.fromRGB(150, 100, 200)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 22
        lbl.Parent = Content
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
        elseif tabName == "ControlEurope" then BuildInWork()
        elseif tabName == "Esp" then BuildInWork()
        elseif tabName == "Upgrade" then BuildInWork()
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
    MakeTab("ControlEurope", "ControlEurope")
    MakeTab("Esp", "Esp")
    MakeTab("Upgrade", "Upgrade")
    MakeTab("Language", "Language")
    MakeTab("Devs", "Devs")

    SwitchTab("General")

    -- Применяем сохранённые настройки
    task.spawn(function()
        if CONFIG.Fly then ToggleFly(true) end
        if CONFIG.Noclip then ToggleNoclip(true) end
        ApplySpeed(CONFIG.Speed)
        RefreshESP()
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
