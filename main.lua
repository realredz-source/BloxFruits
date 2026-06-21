-- =========================================================
-- 🔴 REDZ HUB - MODERN IN-GAME KEY SYSTEM (AVATAR EDITION)
-- Theme: Deep Dark Gray & Crimson Red
-- Fix: Avatar Load API & Multi-Hyphen Key Regex
-- =========================================================

repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- CẤU HÌNH API ĐÃ ĐƯỢC GẮN CHUẨN XÁC
local API_URL = "https://keysystem.redzhubbb.workers.dev" 
local MyHWID = tostring(player.UserId) .. "_REDZ"
local SaveFileName = "RedzHub_PremiumKey.txt"

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- DỌN DẸP UI CŨ
local guiParent = game:GetService("CoreGui") or player:FindFirstChild("PlayerGui")
if guiParent:FindFirstChild("RedzModernUI") then guiParent.RedzModernUI:Destroy() end
if guiParent:FindFirstChild("RedzNotifyUI") then guiParent.RedzNotifyUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzModernUI"
ScreenGui.Parent = guiParent
ScreenGui.ResetOnSpawn = false

local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "RedzNotifyUI"
NotifyGui.Parent = guiParent
NotifyGui.ResetOnSpawn = false

-- ==========================================
-- HỆ THỐNG TOAST NOTIFICATION
-- ==========================================
local function SendToast(title, desc, duration)
    local Toast = Instance.new("Frame", NotifyGui)
    Toast.Size = UDim2.new(0, 260, 0, 60)
    Toast.Position = UDim2.new(1, 300, 1, -40)
    Toast.AnchorPoint = Vector2.new(1, 1)
    Toast.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    Toast.BorderSizePixel = 0
    Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", Toast)
    Stroke.Color = Color3.fromRGB(229, 9, 20)
    Stroke.Thickness = 1

    local LblTitle = Instance.new("TextLabel", Toast)
    LblTitle.BackgroundTransparency = 1
    LblTitle.Position = UDim2.new(0, 15, 0, 10)
    LblTitle.Size = UDim2.new(1, -25, 0, 16)
    LblTitle.Font = Enum.Font.GothamBold
    LblTitle.Text = title
    LblTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    LblTitle.TextSize = 13
    LblTitle.TextXAlignment = Enum.TextXAlignment.Left

    local LblDesc = Instance.new("TextLabel", Toast)
    LblDesc.BackgroundTransparency = 1
    LblDesc.Position = UDim2.new(0, 15, 0, 30)
    LblDesc.Size = UDim2.new(1, -25, 0, 16)
    LblDesc.Font = Enum.Font.GothamMedium
    LblDesc.Text = desc
    LblDesc.TextColor3 = Color3.fromRGB(170, 170, 170)
    LblDesc.TextSize = 11
    LblDesc.TextXAlignment = Enum.TextXAlignment.Left

    local TweenIn = TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, -40)})
    TweenIn:Play()
    task.delay(duration, function()
        local TweenOut = TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 1, -40)})
        TweenOut:Play()
        TweenOut.Completed:Wait()
        Toast:Destroy()
    end)
end

-- ==========================================
-- THIẾT KẾ UI CHÍNH (DARK/RED THEME + AVATAR)
-- ==========================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 360, 0, 220)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(229, 9, 20)
MainStroke.Thickness = 1.5

-- 🖼️ AVATAR 
local AvatarFrame = Instance.new("Frame", MainFrame)
AvatarFrame.Size = UDim2.new(0, 50, 0, 50)
AvatarFrame.Position = UDim2.new(0, 20, 0, 20)
AvatarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Instance.new("UICorner", AvatarFrame).CornerRadius = UDim.new(1, 0)

local AvatarImg = Instance.new("ImageLabel", AvatarFrame)
AvatarImg.Size = UDim2.new(1, 0, 1, 0)
AvatarImg.BackgroundTransparency = 1
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

pcall(function()
    local content = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    AvatarImg.Image = content
end)

local AvaStroke = Instance.new("UIStroke", AvatarFrame)
AvaStroke.Color = Color3.fromRGB(229, 9, 20)
AvaStroke.Thickness = 1.5

-- TIÊU ĐỀ REDZ HUB
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0, 200, 0, 25)
Title.Position = UDim2.new(0, 85, 0, 22)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.Text = "REDZ HUB"
Title.TextColor3 = Color3.fromRGB(229, 9, 20)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

-- TÊN NGƯỜI CHƠI
local WelcomeText = Instance.new("TextLabel", MainFrame)
WelcomeText.Size = UDim2.new(0, 200, 0, 15)
WelcomeText.Position = UDim2.new(0, 85, 0, 48)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Font = Enum.Font.GothamMedium
WelcomeText.Text = "Welcome, " .. player.DisplayName
WelcomeText.TextColor3 = Color3.fromRGB(200, 200, 200)
WelcomeText.TextSize = 12
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left

-- Ô NHẬP KEY
local InputFrame = Instance.new("Frame", MainFrame)
InputFrame.Size = UDim2.new(1, -40, 0, 40)
InputFrame.Position = UDim2.new(0, 20, 0, 90)
InputFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)
local InputStroke = Instance.new("UIStroke", InputFrame)
InputStroke.Color = Color3.fromRGB(50, 50, 55)

local KeyBox = Instance.new("TextBox", InputFrame)
KeyBox.Size = UDim2.new(1, -20, 1, 0)
KeyBox.Position = UDim2.new(0, 10, 0, 0)
KeyBox.BackgroundTransparency = 1
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderText = "Nhập Key Premium vào đây..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 13
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.TextXAlignment = Enum.TextXAlignment.Left

-- NÚT GET KEY
local GetBtn = Instance.new("TextButton", MainFrame)
GetBtn.Size = UDim2.new(0.46, 0, 0, 36)
GetBtn.Position = UDim2.new(0, 20, 0, 145)
GetBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
GetBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
GetBtn.Font = Enum.Font.GothamBold
GetBtn.TextSize = 13
GetBtn.Text = "LẤY KEY"
Instance.new("UICorner", GetBtn).CornerRadius = UDim.new(0, 6)
local GetBtnStroke = Instance.new("UIStroke", GetBtn)
GetBtnStroke.Color = Color3.fromRGB(229, 9, 20)

-- NÚT VERIFY
local VerifyBtn = Instance.new("TextButton", MainFrame)
VerifyBtn.Size = UDim2.new(0.46, 0, 0, 36)
VerifyBtn.Position = UDim2.new(1, -20, 0, 145)
VerifyBtn.AnchorPoint = Vector2.new(1, 0)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(229, 9, 20)
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 13
VerifyBtn.Text = "XÁC MINH"
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)

-- TRẠNG THÁI (STATUS)
local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, -40, 0, 20)
Status.Position = UDim2.new(0, 20, 0, 190)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.Text = "Đang chờ nhập Key..."
Status.TextColor3 = Color3.fromRGB(120, 120, 120)
Status.TextSize = 11

local function UpdateStatus(txt, clr)
    Status.Text = txt
    Status.TextColor3 = clr or Color3.fromRGB(150, 150, 150)
end

-- ==========================================
-- HÀM LOAD SCRIPT DIMONDFARM.LUA
-- ==========================================
local function LoadMainScript()
    UpdateStatus("Đang tải hệ thống (Vui lòng đợi)...", Color3.fromRGB(100, 255, 100))
    task.wait(0.5)
    ScreenGui:Destroy() 
    
    task.spawn(function()
        local url = "https://raw.githubusercontent.com/obiyeueim/99NIGH/refs/heads/main/dimondfarm.lua?t="..tostring(tick())
        local success, code = pcall(function() return game:HttpGet(url) end)
        
        if success and code then
            local runFunc, err = loadstring(code)
            if runFunc then runFunc() else warn("Lỗi Loadstring:", err) end
        else
            SendToast("❌ LỖI TẢI XUỐNG", "Mạng lag, không thể tải Script!", 5)
        end
    end)
end

-- ==========================================
-- LOGIC KẾT NỐI API & XÁC MINH KEY
-- ==========================================
local function FetchAPI(url)
    if httprequest then
        local suc, res = pcall(function() return httprequest({Url = url, Method = "GET"}) end)
        if suc and res and res.Body then return res.Body end
    end
    local suc, res = pcall(function() return game:HttpGet(url, true) end)
    if suc then return res end
    return nil
end

GetBtn.MouseButton1Click:Connect(function()
    local link = API_URL .. "/?hwid=" .. MyHWID .. "&t=" .. tostring(tick())
    pcall(setclipboard, link)
    SendToast("Đã copy Link!", "Hãy dán vào Chrome/Safari để lấy Key.", 4)
    UpdateStatus("Đã copy link! Mở trình duyệt để lấy Key.", Color3.fromRGB(100, 200, 255))
end)

VerifyBtn.MouseButton1Click:Connect(function()
    local keyRaw = KeyBox.Text
    local keyClean = string.match(keyRaw:upper(), "REDZ%-[%w%-]+")
    
    if not keyClean then 
        return UpdateStatus("Sai định dạng! Key phải có dạng REDZ-...", Color3.fromRGB(255, 100, 100)) 
    end
    
    UpdateStatus("Đang kiểm tra Key...", Color3.fromRGB(255, 200, 100))
    VerifyBtn.Text = "..."

    task.spawn(function()
        local checkUrl = API_URL .. "/api/verify?hwid=" .. MyHWID .. "&key=" .. keyClean .. "&nocache=" .. tostring(tick())
        local resBody = FetchAPI(checkUrl)

        if resBody then
            local suc, data = pcall(function() return HttpService:JSONDecode(resBody) end)
            
            if suc and data then
                if data.status == "success" then
                    if writefile then pcall(function() writefile(SaveFileName, keyClean) end) end
                    VerifyBtn.Text = "THÀNH CÔNG"
                    SendToast("🚀 KÍCH HOẠT", "Xác minh thành công. Tải hệ thống...", 4)
                    LoadMainScript()
                else
                    UpdateStatus("Key sai hoặc đã hết hạn!", Color3.fromRGB(229, 9, 20))
                    VerifyBtn.Text = "XÁC MINH"
                end
            else
                warn("Lỗi JSON Decode: Server trả về ->", resBody)
                UpdateStatus("LỖI LINK WEB: Dữ liệu trả về không hợp lệ!", Color3.fromRGB(229, 9, 20))
                VerifyBtn.Text = "XÁC MINH"
            end
        else
            UpdateStatus("Lỗi kết nối máy chủ! Vui lòng thử lại.", Color3.fromRGB(229, 9, 20))
            VerifyBtn.Text = "XÁC MINH"
        end
    end)
end)

-- ==========================================
-- AUTO VERIFY MƯỢT MÀ
-- ==========================================
task.spawn(function()
    if isfile and isfile(SaveFileName) then
        local savedKey = ""
        pcall(function() savedKey = readfile(SaveFileName) end)
        
        savedKey = string.match(savedKey:upper(), "REDZ%-[%w%-]+")
        if savedKey then
            KeyBox.Text = savedKey
            UpdateStatus("Đang tự động xác minh...", Color3.fromRGB(255, 200, 100))
            VerifyBtn.Text = "AUTO"
            task.wait(1.5)
            for _, conn in pairs(getconnections(VerifyBtn.MouseButton1Click)) do
                conn.Function()
            end
        end
    end
end)
