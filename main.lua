-- =========================================================
-- 🔴 REDZ HUB - IN-GAME KEY SYSTEM (V5 CLEAN & FLAT DESIGN)
-- UI Style: Minimalist, Sharp, No Blur, No Neon Glow
-- Platform: Mobile Optimized (PlayerGui + Anti-Crash)
-- =========================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player.Character then player.CharacterAdded:Wait() end
task.wait(1) 

local MyHWID = tostring(player.UserId) .. "_REDZ"
local API_URL = "https://keysystem.redzhubbb.workers.dev"
local SaveFileName = "RedzHub_SavedKey.txt"

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- ==========================================
-- DỌN DẸP UI CŨ & CẮM VÀO PLAYERGUI
-- ==========================================
local guiParent = player:WaitForChild("PlayerGui")

if guiParent:FindFirstChild("RedzKeyUI") then guiParent.RedzKeyUI:Destroy() end
if guiParent:FindFirstChild("RedzNotifyUI") then guiParent.RedzNotifyUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzKeyUI"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "RedzNotifyUI"
NotifyGui.Parent = guiParent
NotifyGui.ResetOnSpawn = false

local function Tween(obj, props, time, style, direction)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- ==========================================
-- THÔNG BÁO GÓC MÀN HÌNH (SẮC NÉT, KHÔNG NHÒE)
-- ==========================================
local function SendNotification(title, desc, duration)
    local NotifFrame = Instance.new("Frame", NotifyGui)
    NotifFrame.Size = UDim2.new(0, 300, 0, 70)
    NotifFrame.Position = UDim2.new(1, 350, 1, -30)
    NotifFrame.AnchorPoint = Vector2.new(1, 1)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28) -- Xám đen sạch sẽ
    NotifFrame.BorderSizePixel = 0
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", NotifFrame)
    Stroke.Color = Color3.fromRGB(50, 50, 55)
    Stroke.Thickness = 1

    local LeftBar = Instance.new("Frame", NotifFrame)
    LeftBar.Size = UDim2.new(0, 4, 1, 0)
    LeftBar.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    LeftBar.BorderSizePixel = 0
    Instance.new("UICorner", LeftBar).CornerRadius = UDim.new(0, 6)

    local LblTitle = Instance.new("TextLabel", NotifFrame)
    LblTitle.BackgroundTransparency = 1
    LblTitle.Position = UDim2.new(0, 20, 0, 12)
    LblTitle.Size = UDim2.new(1, -30, 0, 20)
    LblTitle.Font = Enum.Font.GothamBold
    LblTitle.Text = title
    LblTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    LblTitle.TextSize = 14
    LblTitle.TextXAlignment = Enum.TextXAlignment.Left

    local LblDesc = Instance.new("TextLabel", NotifFrame)
    LblDesc.BackgroundTransparency = 1
    LblDesc.Position = UDim2.new(0, 20, 0, 34)
    LblDesc.Size = UDim2.new(1, -30, 0, 20)
    LblDesc.Font = Enum.Font.GothamMedium
    LblDesc.Text = desc
    LblDesc.TextColor3 = Color3.fromRGB(170, 170, 175)
    LblDesc.TextSize = 12
    LblDesc.TextXAlignment = Enum.TextXAlignment.Left

    Tween(NotifFrame, {Position = UDim2.new(1, -25, 1, -25)}, 0.5, Enum.EasingStyle.Back)
    
    task.delay(duration, function()
        local tOut = Tween(NotifFrame, {Position = UDim2.new(1, 350, 1, -25)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        tOut.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

-- ==========================================
-- GIAO DIỆN CHÍNH (CLEAN & FLAT DESIGN)
-- ==========================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 380, 0, 240)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 25) -- Màu nền nhám sẫm, không trong suốt
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local MainScale = Instance.new("UIScale", MainFrame)
MainScale.Scale = 0.8 
MainFrame.GroupTransparency = 1

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(45, 45, 50) -- Viền xám mỏng sắc nét
UIStroke.Thickness = 1

-- AVATAR RÕ RÀNG
local AvatarImg = Instance.new("ImageLabel", MainFrame)
AvatarImg.Position = UDim2.new(0, 20, 0, 20)
AvatarImg.Size = UDim2.new(0, 48, 0, 48)
AvatarImg.BackgroundTransparency = 1
pcall(function() AvatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
local AvaStroke = Instance.new("UIStroke", AvatarImg)
AvaStroke.Color = Color3.fromRGB(60, 60, 65)
AvaStroke.Thickness = 1

local Title = Instance.new("TextLabel", MainFrame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 85, 0, 25)
Title.Size = UDim2.new(1, -100, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.Text = "REDZ HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local WelcomeText = Instance.new("TextLabel", MainFrame)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Position = UDim2.new(0, 85, 0, 48)
WelcomeText.Size = UDim2.new(1, -100, 0, 15)
WelcomeText.Font = Enum.Font.GothamMedium
WelcomeText.Text = "Welcome, " .. player.DisplayName
WelcomeText.TextColor3 = Color3.fromRGB(150, 150, 155)
WelcomeText.TextSize = 12
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left

-- KHUNG NHẬP KEY (SẠCH SẼ)
local InputFrame = Instance.new("Frame", MainFrame)
InputFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18) -- Nền Input tối hơn xíu tạo độ sâu
InputFrame.Position = UDim2.new(0, 20, 0, 95)
InputFrame.Size = UDim2.new(1, -40, 0, 45)
InputFrame.BorderSizePixel = 0
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)
local InputStroke = Instance.new("UIStroke", InputFrame)
InputStroke.Color = Color3.fromRGB(50, 50, 55)
InputStroke.Thickness = 1

local KeyInput = Instance.new("TextBox", InputFrame)
KeyInput.BackgroundTransparency = 1
KeyInput.Size = UDim2.new(1, -30, 1, 0)
KeyInput.Position = UDim2.new(0, 15, 0, 0)
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.PlaceholderText = "Paste your Key here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 13
KeyInput.ClearTextOnFocus = false
KeyInput.TextXAlignment = Enum.TextXAlignment.Left

-- NÚT BẤM (FLAT DESIGN)
local GetKeyBtn = Instance.new("TextButton", MainFrame)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
GetKeyBtn.Position = UDim2.new(0, 20, 0, 160)
GetKeyBtn.Size = UDim2.new(0.45, 0, 0, 40)
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
GetKeyBtn.TextSize = 12
GetKeyBtn.AutoButtonColor = false
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)
local BtnStroke1 = Instance.new("UIStroke", GetKeyBtn)
BtnStroke1.Color = Color3.fromRGB(55, 55, 60)
BtnStroke1.Thickness = 1

local VerifyBtn = Instance.new("TextButton", MainFrame)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50) -- Đỏ nhám sạch sẽ, không chói
VerifyBtn.Position = UDim2.new(0.55, -20, 0, 160)
VerifyBtn.Size = UDim2.new(0.45, 20, 0, 40)
VerifyBtn.Text = "VERIFY KEY"
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.TextSize = 12
VerifyBtn.AutoButtonColor = false
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)

-- TRẠNG THÁI
local StatusText = Instance.new("TextLabel", MainFrame)
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 20, 0, 215)
StatusText.Size = UDim2.new(1, -40, 0, 15)
StatusText.Font = Enum.Font.GothamMedium
StatusText.Text = "Awaiting verification..."
StatusText.TextColor3 = Color3.fromRGB(120, 120, 125)
StatusText.TextSize = 11

-- ==========================================
-- ANIMATION RÕ RÀNG
-- ==========================================
Tween(MainScale, {Scale = 1}, 0.5, Enum.EasingStyle.Back)
Tween(MainFrame, {GroupTransparency = 0}, 0.3, Enum.EasingStyle.Linear)
SendNotification("System Ready", "UI Loaded Successfully.", 4)

-- Tương tác chuột mượt mà
local function AddHover(btn, defaultColor, hoverColor)
    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = hoverColor}, 0.2) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = defaultColor}, 0.2) end)
    btn.MouseButton1Down:Connect(function() Tween(btn.UIScale, {Scale = 0.95}, 0.1) end)
    btn.MouseButton1Up:Connect(function() Tween(btn.UIScale, {Scale = 1}, 0.1) end)
    Instance.new("UIScale", btn)
end

AddHover(GetKeyBtn, Color3.fromRGB(35, 35, 40), Color3.fromRGB(45, 45, 50))
AddHover(VerifyBtn, Color3.fromRGB(220, 50, 50), Color3.fromRGB(240, 60, 60))

KeyInput.Focused:Connect(function() Tween(InputStroke, {Color = Color3.fromRGB(220, 50, 50)}, 0.3) end)
KeyInput.FocusLost:Connect(function() Tween(InputStroke, {Color = Color3.fromRGB(50, 50, 55)}, 0.3) end)

-- ==========================================
-- LOGIC KIỂM TRA KEY
-- ==========================================
local function ShowStatus(text, color)
    StatusText.Text = text
    StatusText.TextColor3 = color
end

GetKeyBtn.MouseButton1Click:Connect(function()
    local url = API_URL .. "/?hwid=" .. MyHWID .. "&t=" .. tostring(math.floor(tick())) .. "&reset=1"
    if delfile and isfile(SaveFileName) then pcall(function() delfile(SaveFileName) end) end
    KeyInput.Text = ""

    local success = pcall(function() setclipboard(url) end)
    if success then
        ShowStatus("✅ Link Copied!", Color3.fromRGB(50, 220, 150))
        SendNotification("Copied", "Link copied to clipboard.", 4)
    else
        KeyInput.Text = url
        ShowStatus("⚠️ Copy failed. Manually copy the link.", Color3.fromRGB(220, 180, 50))
    end
end)

local function FetchAPI(url)
    if httprequest then
        local success, res = pcall(function() return httprequest({Url = url, Method = "GET", Headers = {["Cache-Control"] = "no-cache"}}) end)
        if success and res and res.Body then return true, res.Body end
    end
    local success, body = pcall(function() return game:HttpGet(url, true) end)
    return success, body
end

local function ExecuteMainScript()
    Tween(MainScale, {Scale = 0.9}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    Tween(MainFrame, {GroupTransparency = 1}, 0.3)
    
    SendNotification("Unlocked", "Loading script (2s)...", 5)
    
    task.wait(0.5)
    ScreenGui:Destroy()

    task.spawn(function() 
        task.wait(2) 
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/obiyeueim/99NIGH/refs/heads/main/dimondfarm.lua?t="..tostring(tick())))()
        end)
        if not success then warn("Execution Error: ", err) end
    end)
end

local function DoVerify()
    local rawText = tostring(KeyInput.Text)
    local cleanText = rawText:gsub("[%c%s]", ""):upper()
    
    if string.find(cleanText, "HTTPS://") then
        ShowStatus("⚠️ Complete the link first.", Color3.fromRGB(220, 80, 80))
        return
    end

    local inputKey = string.match(cleanText, "REDZ%-[%w%-]+")
    local cleanHwid = MyHWID:gsub("[%c%s]", ""):upper()
    
    if not inputKey then
        ShowStatus("⚠️ Invalid Key format.", Color3.fromRGB(220, 180, 50))
        return
    end

    VerifyBtn.Text = "..."
    ShowStatus("Checking...", Color3.fromRGB(150, 150, 200))
    
    task.spawn(function()
        local checkUrl = API_URL .. "/api/verify?hwid=" .. cleanHwid .. "&key=" .. inputKey .. "&t=" .. tostring(tick())
        local success, resBody = FetchAPI(checkUrl)

        if success and resBody then
            local jsonSuccess, data = pcall(function() return HttpService:JSONDecode(resBody) end)
            if jsonSuccess and data.status == "success" then
                if writefile then pcall(function() writefile(SaveFileName, inputKey) end) end
                ShowStatus("✅ Success!", Color3.fromRGB(50, 220, 150))
                Tween(VerifyBtn, {BackgroundColor3 = Color3.fromRGB(40, 180, 100)}, 0.3)
                VerifyBtn.Text = "SUCCESS"
                ExecuteMainScript()
            elseif jsonSuccess and data.status == "expired" then
                if delfile and isfile(SaveFileName) then pcall(function() delfile(SaveFileName) end) end
                ShowStatus("❌ Expired Key.", Color3.fromRGB(220, 50, 50))
                VerifyBtn.Text = "VERIFY KEY"
            else
                ShowStatus("❌ Invalid Key.", Color3.fromRGB(220, 50, 50))
                VerifyBtn.Text = "VERIFY KEY"
            end
        else
            ShowStatus("❌ Server error.", Color3.fromRGB(220, 50, 50))
            VerifyBtn.Text = "VERIFY KEY"
        end
    end)
end

VerifyBtn.MouseButton1Click:Connect(DoVerify)

task.spawn(function()
    if isfile and isfile(SaveFileName) then
        pcall(function() 
            local saved = readfile(SaveFileName)
            if saved and saved ~= "" then
                KeyInput.Text = saved 
                VerifyBtn.Text = "AUTO"
                ShowStatus("Auto-verifying...", Color3.fromRGB(150, 150, 200))
                DoVerify()
            end
        end)
    end
end)
