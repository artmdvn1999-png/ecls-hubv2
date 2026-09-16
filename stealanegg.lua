-- Kiểm tra game đã load xong chưa
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("ECLS_StealAnEgg_Hub") then
    CoreGui.ECLS_StealAnEgg_Hub:Destroy()
end

-- Hệ thống Ngôn ngữ (Language Dictionary)
local currentLang = "VN"
local texts = {
    VN = {
        loadTitle = "ECLS HUB - TẢI HỆ THỐNG",
        loadStatus = "Đang chuẩn bị tài nguyên... (5s)",
        loadBtn = "TIẾP TỤC",
        mainTitle = "ECLS HUB - Pro Edition",
        
        -- Các Tab
        tabPlayer = "👤 Player",
        tabMain = "⚡ Main",
        tabSpeed = "🚀 Speed",
        tabLang = "🌐 Ngôn Ngữ",
        tabUpdate = "📜 Update",
        
        -- Tab Player
        playerInfoTitle = "--- THÔNG TIN NGƯỜI CHƠI ---",
        serverHopBtn = "🌐 Đổi Server Ít Người / Ping Thấp",
        
        -- Tab Main
        refreshBtn = "🔄 Làm Mới Danh Sách Trứng",
        stealBtn = "⚡ Bắt Đầu Steal & Mang Về",
        espEgg = "ESP Trứng (Weight & Value/s)",
        
        -- Tab Speed
        speedRunToggle = "Bật Tốc Độ Chạy",
        speedRunBox = "Nhập tốc độ chạy (Mặc định: 16)",
        flySpeedBox = "Nhập tốc độ bay Steal (Mặc định: 0.4)",
        
        -- Tab Lang
        langTitleText = "  [ CHỌN NGÔN NGỮ HỆ THỐNG ]",
        btnVN = "🇻🇳 Tiếng Việt (Vietnamese)",
        btnEN = "🇬🇧 English (Tiếng Anh)",
        
        -- Tab Update
        updateInfoText = "THÔNG TIN CẬP NHẬT (VERSION 4.0):\n\n1. Bổ sung Tab Ngôn Ngữ riêng biệt để đổi Tiếng Việt / Tiếng Anh dễ dàng.\n2. Chia menu thành các mục: Player, Main, Speed, Ngôn Ngữ, Update.\n3. Tối ưu hóa hệ thống Steal trứng và tính năng Server Hop mượt mà hơn.",
    },
    EN = {
        loadTitle = "ECLS HUB - LOADING",
        loadStatus = "Preparing resources... (5s)",
        loadBtn = "CONTINUE",
        mainTitle = "ECLS HUB - Pro Edition",
        
        -- Tabs
        tabPlayer = "👤 Player",
        tabMain = "⚡ Main",
        tabSpeed = "🚀 Speed",
        tabLang = "🌐 Language",
        tabUpdate = "📜 Update",
        
        -- Tab Player
        playerInfoTitle = "--- PLAYER INFORMATION ---",
        serverHopBtn = "🌐 Server Hop (Low Players/Ping)",
        
        -- Tab Main
        refreshBtn = "🔄 Refresh Spawn List",
        stealBtn = "⚡ Start Steal & Bring Home",
        espEgg = "ESP Eggs (Weight & Value/s)",
        
        -- Tab Speed
        speedRunToggle = "Enable Walk Speed",
        speedRunBox = "Enter walk speed (Default: 16)",
        flySpeedBox = "Enter Fly Speed (Default: 0.4)",
        
        -- Tab Lang
        langTitleText = "  [ SELECT SYSTEM LANGUAGE ]",
        btnVN = "🇻🇳 Tiếng Việt (Vietnamese)",
        btnEN = "🇬🇧 English (English)",
        
        -- Tab Update
        updateInfoText = "UPDATE LOG (VERSION 4.0):\n\n1. Added a dedicated Language Tab to easily switch between VN and EN.\n2. Organized menu into: Player, Main, Speed, Language, Update.\n3. Optimized auto steal and server hop features.",
    }
}

local function getTxt(key)
    return texts[currentLang][key] or key
end

-- Tạo ScreenGui chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ECLS_StealAnEgg_Hub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ==================== 1. NÚT HUB BẬT/TẮT MENU ====================
local ToggleHubBtn = Instance.new("TextButton")
ToggleHubBtn.Name = "ToggleHubBtn"
ToggleHubBtn.Parent = ScreenGui
ToggleHubBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
ToggleHubBtn.BorderSizePixel = 0
ToggleHubBtn.Position = UDim2.new(0, 20, 0.4, 0)
ToggleHubBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleHubBtn.Font = Enum.Font.GothamBold
ToggleHubBtn.Text = "Hub"
ToggleHubBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleHubBtn.TextSize = 14
ToggleHubBtn.Active = true
ToggleHubBtn.Draggable = true
ToggleHubBtn.Visible = false

local HubCorner = Instance.new("UICorner")
HubCorner.CornerRadius = UDim.new(1, 0)
HubCorner.Parent = ToggleHubBtn

local HubStroke = Instance.new("UIStroke")
HubStroke.Color = Color3.fromRGB(90, 90, 110)
HubStroke.Thickness = 2
HubStroke.Parent = ToggleHubBtn

-- ==================== 2. MÀN HÌNH LOADING ====================
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Parent = ScreenGui
LoadingFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
LoadingFrame.Size = UDim2.new(0, 320, 0, 180)
LoadingFrame.Active = true
LoadingFrame.Draggable = true

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 12)
LoadingCorner.Parent = LoadingFrame

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Parent = LoadingFrame
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Position = UDim2.new(0, 0, 0, 20)
LoadingTitle.Size = UDim2.new(1, 0, 0, 30)
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.Text = getTxt("loadTitle")
LoadingTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
LoadingTitle.TextSize = 18

local LoadingStatus = Instance.new("TextLabel")
LoadingStatus.Parent = LoadingFrame
LoadingStatus.BackgroundTransparency = 1
LoadingStatus.Position = UDim2.new(0, 0, 0, 60)
LoadingStatus.Size = UDim2.new(1, 0, 0, 30)
LoadingStatus.Font = Enum.Font.Gotham
LoadingStatus.Text = getTxt("loadStatus")
LoadingStatus.TextColor3 = Color3.fromRGB(160, 160, 160)
LoadingStatus.TextSize = 14

local ContinueBtn = Instance.new("TextButton")
ContinueBtn.Name = "ContinueBtn"
ContinueBtn.Parent = LoadingFrame
ContinueBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ContinueBtn.BorderSizePixel = 0
ContinueBtn.Position = UDim2.new(0.5, -100, 0, 110)
ContinueBtn.Size = UDim2.new(0, 200, 0, 40)
ContinueBtn.Font = Enum.Font.GothamBold
ContinueBtn.Text = "Vui lòng đợi..."
ContinueBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
ContinueBtn.TextSize = 14
ContinueBtn.Active = false

local ContinueCorner = Instance.new("UICorner")
ContinueCorner.CornerRadius = UDim.new(0, 8)
ContinueCorner.Parent = ContinueBtn

-- ==================== 3. GIAO DIỆN MENU CHÍNH ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -200)
MainFrame.Size = UDim2.new(0, 480, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = getTxt("mainTitle")
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Thanh Tab (Player, Main, Speed, Ngôn Ngữ, Update)
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.Size = UDim2.new(1, -20, 0, 35)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

local contentPages = {}
local function createTabPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Parent = MainFrame
    page.Active = true
    page.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    page.BorderSizePixel = 0
    page.Position = UDim2.new(0, 10, 0, 85)
    page.Size = UDim2.new(1, -20, 1, -95)
    page.CanvasSize = UDim2.new(0, 0, 0, 550)
    page.ScrollBarThickness = 5
    page.Visible = false

    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    
    contentPages[name] = page
    return page
end

local playerPage = createTabPage("Player")
local mainPage = createTabPage("Main")
local speedPage = createTabPage("Speed")
local langPage = createTabPage("Lang")
local updatePage = createTabPage("Update")

local tabButtons = {}
local function createTabButton(name, textKey)
    local btn = Instance.new("TextButton")
    btn.Parent = TabBar
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0.19, 0, 1, 0)
    btn.Font = Enum.Font.GothamBold
    btn.Text = getTxt(textKey)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 11

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(contentPages) do p.Visible = false end
        for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(45, 45, 55) end
        contentPages[name].Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 110)
    end)
    
    tabButtons[name] = btn
end

createTabButton("Player", "tabPlayer")
createTabButton("Main", "tabMain")
createTabButton("Speed", "tabSpeed")
createTabButton("Lang", "tabLang")
createTabButton("Update", "tabUpdate")

contentPages["Player"].Visible = true
tabButtons["Player"].BackgroundColor3 = Color3.fromRGB(0, 150, 110)

-- Loading countdown
task.spawn(function()
    for i = 5, 1, -1 do
        LoadingStatus.Text = "Đang khởi tạo tài nguyên... (" .. i .. "s)"
        task.wait(1)
    end
    LoadingStatus.Text = "Sẵn sàng!"
    ContinueBtn.Text = getTxt("loadBtn")
    ContinueBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ContinueBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 95)
    ContinueBtn.Active = true
end)

ContinueBtn.MouseButton1Click:Connect(function()
    if ContinueBtn.Active then
        LoadingFrame.Visible = false
        MainFrame.Visible = true
        ToggleHubBtn.Visible = true
    end
end)

ToggleHubBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Hàm phụ trợ tạo UI thành phần
local function createToggleInPage(page, nameKey, callback)
    local Row = Instance.new("Frame")
    Row.Parent = page
    Row.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
    Row.BorderSizePixel = 0
    Row.Size = UDim2.new(1, 0, 0, 42)

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 8)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Parent = Row
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Size = UDim2.new(0, 300, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = getTxt(nameKey)
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBg = Instance.new("TextButton")
    ToggleBg.Parent = Row
    ToggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleBg.BorderSizePixel = 0
    ToggleBg.Position = UDim2.new(1, -55, 0.5, -12)
    ToggleBg.Size = UDim2.new(0, 45, 0, 24)
    ToggleBg.Text = ""

    local BgCorner = Instance.new("UICorner")
    BgCorner.CornerRadius = UDim.new(1, 0)
    BgCorner.Parent = ToggleBg

    local Circle = Instance.new("Frame")
    Circle.Parent = ToggleBg
    Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Circle.BorderSizePixel = 0
    Circle.Position = UDim2.new(0, 3, 0.5, -9)
    Circle.Size = UDim2.new(0, 18, 0, 18)

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local toggled = false
    ToggleBg.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            ToggleBg.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
            Circle:TweenPosition(UDim2.new(1, -21, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        else
            ToggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            Circle:TweenPosition(UDim2.new(0, 3, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        end
        callback(toggled)
    end)
end

local function createTextBoxInPage(page, placeholderKey, callback)
    local Box = Instance.new("TextBox")
    Box.Parent = page
    Box.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
    Box.BorderSizePixel = 0
    Box.Size = UDim2.new(1, 0, 0, 38)
    Box.Font = Enum.Font.Gotham
    Box.PlaceholderText = getTxt(placeholderKey)
    Box.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    Box.Text = ""
    Box.TextColor3 = Color3.fromRGB(240, 240, 240)
    Box.TextSize = 13

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 8)
    BoxCorner.Parent = Box

    Box.FocusLost:Connect(function(enterPressed)
        if enterPressed then callback(Box.Text) end
    end)
end

-- ==================== MỤC 1: PLAYER ====================
local PlayerInfoLabel = Instance.new("TextLabel")
PlayerInfoLabel.Parent = playerPage
PlayerInfoLabel.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
PlayerInfoLabel.Size = UDim2.new(1, 0, 0, 110)
PlayerInfoLabel.Font = Enum.Font.GothamBold
PlayerInfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerInfoLabel.TextSize = 13
PlayerInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
PlayerInfoLabel.Text = "  [ THÔNG TIN NGƯỜI CHƠI ]\n  Tên: " .. LocalPlayer.Name .. "\n  ID: " .. LocalPlayer.UserId .. "\n  Thời gian chơi: 0 giây\n  Tiền/giây ($/s): Đang cập nhật..."

local PlayerCorner = Instance.new("UICorner")
PlayerCorner.CornerRadius = UDim.new(0, 8)
PlayerCorner.Parent = PlayerInfoLabel

local loginTick = tick()
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            local playTime = math.floor(tick() - loginTick)
            local mins = math.floor(playTime / 60)
            local secs = playTime % 60
            local moneyRate = 0
            if LocalPlayer:FindFirstChild("leaderstats") then
                for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
                    if string.find(string.lower(stat.Name), "sec") or string.find(string.lower(stat.Name), "rate") then
                        moneyRate = stat.Value
                    end
                end
            end
            PlayerInfoLabel.Text = "  [ THÔNG TIN NGƯỜI CHƠI ]\n  Tên: " .. LocalPlayer.Name .. "\n  Thời gian chơi: " .. mins .. " phút " .. secs .. " giây\n  Tiền/giây ($/s): " .. tostring(moneyRate)
        end)
    end
end)

local ServerHopBtn = Instance.new("TextButton")
ServerHopBtn.Parent = playerPage
ServerHopBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 80)
ServerHopBtn.BorderSizePixel = 0
ServerHopBtn.Size = UDim2.new(1, 0, 0, 38)
ServerHopBtn.Font = Enum.Font.GothamBold
ServerHopBtn.Text = getTxt("serverHopBtn")
ServerHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ServerHopBtn.TextSize = 13

local HopCorner = Instance.new("UICorner")
HopCorner.CornerRadius = UDim.new(0, 8)
HopCorner.Parent = ServerHopBtn

ServerHopBtn.MouseButton1Click:Connect(function()
    ServerHopBtn.Text = "Đang tìm server ít người / ping tốt..."
    pcall(function()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local body = HttpService:JSONDecode(req)
        if body and body.data then
            for _, s in ipairs(body.data) do
                if type(s) == "table" and s.playing and s.maxPlayers and s.id then
                    if s.playing < s.maxPlayers - 1 then table.insert(servers, s) end
                end
            end
        end
        if #servers > 0 then
            table.sort(servers, function(a, b) return a.playing < b.playing end)
            local selectedServer = servers[math.random(1, math.min(3, #servers))]
            ServerHopBtn.Text = "Đang chuyển server..."
            TeleportService:TeleportToPlaceInstance(game.PlaceId, selectedServer.id, LocalPlayer)
        else
            ServerHopBtn.Text = "Không tìm thấy server phù hợp!"
            task.wait(2)
            ServerHopBtn.Text = getTxt("serverHopBtn")
        end
    end)
end)


-- ==================== MỤC 2: MAIN ====================
local selectedEggInstance = nil
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Parent = mainPage
RefreshBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Size = UDim2.new(1, 0, 0, 38)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.Text = getTxt("refreshBtn")
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 13

local RefCorner = Instance.new("UICorner")
RefCorner.CornerRadius = UDim.new(0, 8)
RefCorner.Parent = RefreshBtn

local DropdownFrame = Instance.new("ScrollingFrame")
DropdownFrame.Parent = mainPage
DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
DropdownFrame.BorderSizePixel = 0
DropdownFrame.Size = UDim2.new(1, 0, 0, 130)
DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownFrame.ScrollBarThickness = 4

local DropdownList = Instance.new("UIListLayout")
DropdownList.Parent = DropdownFrame
DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
DropdownList.Padding = UDim.new(0, 4)

local function updateSpawnList()
    for _, child in pairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    selectedEggInstance = nil
    local eggsFolder = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("Collectibles") or Workspace
    local count = 0
    for _, egg in pairs(eggsFolder:GetDescendants()) do
        if egg:IsA("Model") and egg.PrimaryPart then
            count = count + 1
            local weight = egg:GetAttribute("Weight") or math.random(50, 300)
            local val = egg:GetAttribute("ValuePerSec") or math.random(20, 150)
            
            local itemBtn = Instance.new("TextButton")
            itemBtn.Parent = DropdownFrame
            itemBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
            itemBtn.BorderSizePixel = 0
            itemBtn.Size = UDim2.new(1, -4, 0, 32)
            itemBtn.Font = Enum.Font.GothamMedium
            itemBtn.Text = "🥚 " .. egg.Name .. " | W: " .. tostring(weight) .. " | $" .. tostring(val) .. "/s"
            itemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            itemBtn.TextSize = 12
            
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 6)
            itemCorner.Parent = itemBtn
            
            itemBtn.MouseButton1Click:Connect(function()
                for _, b in pairs(DropdownFrame:GetChildren()) do
                    if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(48, 48, 58) end
                end
                itemBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 110)
                selectedEggInstance = egg
            end)
        end
    end
    DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, count * 36)
end

RefreshBtn.MouseButton1Click:Connect(function() updateSpawnList() end)

local function getSafeZone()
    local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases")
    if plotsFolder 
