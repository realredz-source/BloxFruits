-- =========================================================
-- 🔴 REDZ HUB PREMIUM - IN-GAME KEY SYSTEM (V3 MAX - ANTI NIL)
-- UI: Dark Neon + Avatar + Custom Notification
-- Feature: 1 Account = 1 Key
-- Script: Load dimondfarm.lua (Advanced Error Catcher)
-- =========================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local MyHWID = tostring(player.UserId) .. "_REDZ"
local API_URL = "https://keysystem.redzhubbb.workers.dev"
local SaveFileName = "RedzHub_SavedKey.txt"

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- ==========================================
-- CLEANUP OLD UI
-- ==========================================
local guiParent = pcall(function() return gethui() end) and gethui() or CoreGui
if not guiParent:FindFirstChild("RobloxGui") then guiParent = player:WaitForChild("PlayerGui") end

if guiParent:FindFirstChild("RedzKeyUI") then guiParent.RedzKeyUI:Destroy() end
if guiParent:FindFirstChild("RedzNotifyUI") then guiParent.RedzNotifyUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzKeyUI"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false

local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "RedzNotifyUI"
NotifyGui.Parent = guiParent
NotifyGui.ResetOnSpawn = false

local function Tween(obj, props, time, style)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- ==========================================
-- CUSTOM NOTIFICATION SYSTEM
-- ==========================================
local function SendNotification(title, desc, duration)
    local NotifFrame = Instance.new("Frame", NotifyGui)
    NotifFrame.Size = UDim2.new(0, 280, 0, 70)
    NotifFrame.Position = UDim2.new(1, 300, 1, -30)
    NotifFrame.AnchorPoint = Vector2.new(1, 1)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 12)
    NotifFrame.BorderSizePixel = 0
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", NotifFrame)
    Stroke.Color = Color3.fromRGB(255, 40, 40)
    Stroke.Thickness = 1.5

    local Glow = Instance.new("ImageLabel", NotifFrame)
    Glow.Size = UDim2.new(1, 40, 1, 40)
    Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://1316045217"
    Glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
    Glow.ImageTransparency = 0.5
    Glow.ZIndex = -1

    local Icon = Instance.new("ImageLabel", NotifFrame)
    Icon.Size = UDim2.new(0, 30, 0, 30)
    Icon.Position = UDim2.new(0, 15, 0.5, 0)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://7733658504" 
    Icon.ImageColor3 = Color3.fromRGB(255, 40, 40)

    local LblTitle = Instance.new("TextLabel", NotifFrame)
    LblTitle.BackgroundTransparency = 1
    LblTitle.Position = UDim2.new(0, 55, 0, 12)
    LblTitle.Size = UDim2.new(1, -65, 0, 20)
    LblTitle.Font = Enum.Font.GothamBold
    LblTitle.Text = title
    LblTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    LblTitle.TextSize = 14
    LblTitle.TextXAlignment = Enum.TextXAlignment.Left

    local LblDesc = Instance.new("TextLabel", NotifFrame)
    LblDesc.BackgroundTransparency = 1
    LblDesc.Position = UDim2.new(0, 55, 0, 34)
    LblDesc.Size = UDim2.new(1, -65, 0, 20)
    LblDesc.Font = Enum.Font.GothamMedium
    LblDesc.Text = desc
    LblDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
    LblDesc.TextSize = 12
    LblDesc.TextXAlignment = Enum.TextXAlignment.Left

    local TimeBarBg = Instance.new("Frame", NotifFrame)
    TimeBarBg.Size = UDim2.new(1, 0, 0, 3)
    TimeBarBg.Position = UDim2.new(0, 0, 1, 0)
    TimeBarBg.AnchorPoint = Vector2.new(0, 1)
    TimeBarBg.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
    TimeBarBg.BorderSizePixel = 0
    Instance.new("UICorner", TimeBarBg).CornerRadius = UDim.new(0, 8)

    local TimeBar = Instance.new("Frame", TimeBarBg)
    TimeBar.Size = UDim2.new(1, 0, 1, 0)
    TimeBar.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
    TimeBar.BorderSizePixel = 0
    Instance.new("UICorner", TimeBar).CornerRadius = UDim.new(0, 8)

    Tween(NotifFrame, {Position = UDim2.new(1, -20, 1, -20)}, 0.6, Enum.EasingStyle.Back)
    TweenService:Create(TimeBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

    task.delay(duration, function()
        local tOut = Tween(NotifFrame, {Position = UDim2.new(1, 300, 1, -20)}, 0.5, Enum.EasingStyle.Back)
        tOut.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

-- ==========================================
-- MAIN UI DESIGN
-- ==========================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 30)
MainFrame.Size = UDim2.new(0, 380, 0, 250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 1 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 40, 40)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 1

local Shadow = Instance.new("ImageLabel", MainFrame)
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
Shadow.Size = UDim2.new(1, 45, 1, 45)
Shadow.ZIndex = -1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(255, 0, 0)
Shadow.ImageTransparency = 1

local AvatarImg = Instance.new("ImageLabel", MainFrame)
AvatarImg.Position = UDim2.new(0, 20, 0, 20)
AvatarImg.Size = UDim2.new(0, 50, 0, 50)
AvatarImg.BackgroundTransparency = 1
AvatarImg.ImageTransparency = 1
pcall(function() AvatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
local AvaStroke = Instance.new("UIStroke", AvatarImg)
AvaStroke.Color = Color3.fromRGB(255, 40, 40)
AvaStroke.Thickness = 1.5
AvaStroke.Transparency = 1

local Title = Instance.new("TextLabel", MainFrame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 85, 0, 20)
Title.Size = UDim2.new(1, -100, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "REDZ HUB PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 40, 40)
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextTransparency = 1

local WelcomeText = Instance.new("TextLabel", MainFrame)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Position = UDim2.new(0, 85, 0, 43)
WelcomeText.Size = UDim2.new(1, -100, 0, 15)
WelcomeText.Font = Enum.Font.GothamMedium
WelcomeText.Text = "Welcome, " .. player.DisplayName
WelcomeText.TextColor3 = Color3.fromRGB(180, 180, 180)
WelcomeText.TextSize = 12
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
WelcomeText.TextTransparency = 1

local NoteText = Instance.new("TextLabel", MainFrame)
NoteText.BackgroundTransparency = 1
NoteText.Position = UDim2.new(0, 85, 0, 60)
NoteText.Size = UDim2.new(1, -100, 0, 15)
NoteText.Font = Enum.Font.Gotham
NoteText.Text = "🔒 Key is uniquely linked to your Account."
NoteText.TextColor3 = Color3.fromRGB(255, 100, 100)
NoteText.TextSize = 10
NoteText.TextXAlignment = Enum.TextXAlignment.Left
NoteText.TextTransparency = 1

local InputFrame = Instance.new("Frame", MainFrame)
InputFrame.BackgroundColor3 = Color3.fromRGB(25, 18, 18)
InputFrame.Position = UDim2.new(0, 20, 0, 95)
InputFrame.Size = UDim2.new(1, -40, 0, 45)
InputFrame.BackgroundTransparency = 1
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 8)
local InputStroke = Instance.new("UIStroke", InputFrame)
InputStroke.Color = Color3.fromRGB(255, 40, 40)
InputStroke.Transparency = 1

local KeyInput = Instance.new("TextBox", InputFrame)
KeyInput.BackgroundTransparency = 1
KeyInput.Size = UDim2.new(1, -20, 1, 0)
KeyInput.Position = UDim2.new(0, 10, 0, 0)
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.PlaceholderText = "Paste your REDZ Key here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(130, 90, 90)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 13
KeyInput.ClearTextOnFocus = false
KeyInput.TextTransparency = 1
KeyInput.TextXAlignment = Enum.TextXAlignment.Left

local GetKeyBtn = Instance.new("TextButton", MainFrame)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 20)
GetKeyBtn.Position = UDim2.new(0, 20, 0, 155)
GetKeyBtn.Size = UDim2.new(0.46, 0, 0, 40)
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
GetKeyBtn.TextSize = 12
GetKeyBtn.BackgroundTransparency = 1
GetKeyBtn.TextTransparency = 1
GetKeyBtn.AutoButtonColor = false
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)
local BtnStroke = Instance.new("UIStroke", GetKeyBtn)
BtnStroke.Color = Color3.fromRGB(255, 40, 40)
BtnStroke.Transparency = 1

local VerifyBtn = Instance.new("TextButton", MainFrame)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
VerifyBtn.Position = UDim2.new(0.54, -20, 0, 155)
VerifyBtn.Size = UDim2.new(0.46, 20, 0, 40)
VerifyBtn.Text = "VERIFY"
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.TextSize = 12
VerifyBtn.BackgroundTransparency = 1
VerifyBtn.TextTransparency = 1
VerifyBtn.AutoButtonColor = false
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)

local StatusText = Instance.new("TextLabel", MainFrame)
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 20, 0, 210)
StatusText.Size = UDim2.new(1, -40, 0, 20)
StatusText.Font = Enum.Font.GothamMedium
StatusText.Text = "System is ready."
StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusText.TextSize = 11
StatusText.TextTransparency = 1

SendNotification("🚀 INITIALIZING", "Loading Hub data...", 4)

Tween(MainFrame, {BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.6)
Tween(UIStroke, {Transparency = 0.4}, 0.6)
Tween(Shadow, {ImageTransparency = 0.5}, 0.6)
task.wait(0.2)
Tween(AvatarImg, {ImageTransparency = 0}, 0.4)
Tween(AvaStroke, {Transparency = 0.2}, 0.4)
Tween(Title, {TextTransparency = 0}, 0.4)
Tween(WelcomeText, {TextTransparency = 0}, 0.4)
Tween(NoteText, {TextTransparency = 0}, 0.4)
Tween(InputFrame, {BackgroundTransparency = 0}, 0.4)
Tween(InputStroke, {Transparency = 0.5}, 0.4)
Tween(KeyInput, {TextTransparency = 0}, 0.4)
Tween(GetKeyBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.4)
Tween(BtnStroke, {Transparency = 0}, 0.4)
Tween(VerifyBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.4)
Tween(StatusText, {TextTransparency = 0}, 0.4)

local function AddHover(btn, defaultColor, hoverColor)
    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = hoverColor}, 0.2) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = defaultColor}, 0.2) end)
end
AddHover(GetKeyBtn, Color3.fromRGB(35, 20, 20), Color3.fromRGB(55, 30, 30))
AddHover(VerifyBtn, Color3.fromRGB(255, 40, 40), Color3.fromRGB(255, 70, 70))

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
        ShowStatus("✅ Link Copied! 1 Account = 1 Key.", Color3.fromRGB(0, 255, 150))
        SendNotification("📋 LINK COPIED", "1 Account = 1 Key. Please get your own!", 4)
    else
        KeyInput.Text = url
        ShowStatus("⚠️ Copy blocked. Manually copy link above!", Color3.fromRGB(255, 200, 0))
    end
    Tween(GetKeyBtn, {Size = UDim2.new(0.46, -4, 0, 36)}, 0.1)
    task.wait(0.1)
    Tween(GetKeyBtn, {Size = UDim2.new(0.46, 0, 0, 40)}, 0.1)
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
    Tween(MainFrame, {Position = UDim2.new(0.5, 0, 0.5, -20), BackgroundTransparency = 1}, 0.4)
    Tween(UIStroke, {Transparency = 1}, 0.3)
    Tween(Shadow, {ImageTransparency = 1}, 0.3)
    for _, child in ipairs(MainFrame:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextBox") or child:IsA("TextButton") then
            Tween(child, {TextTransparency = 1, BackgroundTransparency = 1}, 0.3)
        elseif child:IsA("UIStroke") then
            Tween(child, {Transparency = 1}, 0.3)
        elseif child:IsA("ImageLabel") then
            Tween(child, {ImageTransparency = 1}, 0.3)
        end
    end
    
    SendNotification("✅ VERIFIED SUCCESSFULLY", "Executing Farm Script (Waiting 2s)...", 5)
    task.wait(0.5)
    ScreenGui:Destroy()

    -- 🔥 BỘ PHẬN TẢI SCRIPT NÂNG CẤP (BẮT ĐƯỢC LỖI TỪ GITHUB) 🔥
    task.spawn(function() 
        repeat task.wait() until game:IsLoaded()
        task.wait(2) 
        
        local targetUrl = "https://raw.githubusercontent.com/obiyeueim/99NIGH/refs/heads/main/dimondfarm.lua?t=" .. tostring(tick())
        local success, result = pcall(function()
            return game:HttpGet(targetUrl)
        end)
        
        if success and result and result ~= "" then
            local func, loadErr = loadstring(result)
            if func then
                local execSuccess, execErr = pcall(func)
                if not execSuccess then
                    warn("❌ LỖI KHI CHẠY SCRIPT: ", execErr)
                end
            else
                -- In thẳng ra F9 nếu file Github bị lỗi cú pháp
                warn("❌ LỖI CÚ PHÁP TỪ FILE GITHUB CỦA BẠN: ", loadErr)
                print(">>> Vui lòng kiểm tra lại nội dung file 'dimondfarm.lua' trên Github. Có thể lúc nén code bị lỗi hoặc copy thiếu chữ.")
            end
        else
            warn("❌ KHÔNG THỂ TẢI FILE (Link Github sai hoặc mất mạng)")
        end
    end)
end

local function DoVerify()
    local rawText = tostring(KeyInput.Text)
    local cleanText = rawText:gsub("[%c%s]", ""):upper()
    
    Tween(VerifyBtn, {Size = UDim2.new(0.46, -4, 0, 36)}, 0.1)
    task.wait(0.1)
    Tween(VerifyBtn, {Size = UDim2.new(0.46, 20, 0, 40)}, 0.1)
    
    if string.find(cleanText, "HTTPS://") then
        ShowStatus("⚠️ Please complete the link on browser first.", Color3.fromRGB(255, 100, 100))
        return
    end

    local inputKey = string.match(cleanText, "REDZ%-[%w%-]+")
    local cleanHwid = MyHWID:gsub("[%c%s]", ""):upper()
    
    if not inputKey then
        ShowStatus("⚠️ Invalid Key! Format must be REDZ-...", Color3.fromRGB(255, 180, 0))
        return
    end

    VerifyBtn.Text = "..."
    ShowStatus("Authenticating to Server...", Color3.fromRGB(150, 150, 255))
    
    task.spawn(function()
        local checkUrl = API_URL .. "/api/verify?hwid=" .. cleanHwid .. "&key=" .. inputKey .. "&t=" .. tostring(tick())
        local success, resBody = FetchAPI(checkUrl)

        if success and resBody then
            local jsonSuccess, data = pcall(function() return HttpService:JSONDecode(resBody) end)
            if jsonSuccess and data.status == "success" then
                if writefile then pcall(function() writefile(SaveFileName, inputKey) end) end
                ShowStatus("✅ Access Granted!", Color3.fromRGB(0, 255, 150))
                Tween(VerifyBtn, {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}, 0.3)
                VerifyBtn.Text = "SUCCESS"
                ExecuteMainScript()
            elseif jsonSuccess and data.status == "expired" then
                if delfile and isfile(SaveFileName) then pcall(function() delfile(SaveFileName) end) end
                ShowStatus("❌ Key Expired! Get a new one.", Color3.fromRGB(255, 80, 80))
                VerifyBtn.Text = "VERIFY"
            else
                ShowStatus("❌ Invalid Key for this device.", Color3.fromRGB(255, 80, 80))
                VerifyBtn.Text = "VERIFY"
            end
        else
            ShowStatus("❌ Server Error. Please try again.", Color3.fromRGB(255, 80, 80))
            VerifyBtn.Text = "VERIFY"
        end
    end)
end

VerifyBtn.MouseButton1Click:Connect(DoVerify)

-- ==========================================
-- AUTO VERIFY
-- ==========================================
task.spawn(function()
    if isfile and isfile(SaveFileName) then
        pcall(function() 
            local saved = readfile(SaveFileName)
            if saved and saved ~= "" then
                KeyInput.Text = saved 
                VerifyBtn.Text = "AUTO"
                ShowStatus("Auto-verifying your saved key...", Color3.fromRGB(150, 150, 255))
                DoVerify()
            end
        end)
    end
end)
