-- =========================================================
-- 🔴 BẢN TEST KIỂM CHỨNG UI - KHÔNG LOAD DIMONDFARM
-- =========================================================
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local MyHWID = tostring(player.UserId) .. "_REDZ"
local API_URL = "https://keysystem.redzhubbb.workers.dev"
local SaveFileName = "RedzHub_SavedKey.txt"

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local guiParent = player:WaitForChild("PlayerGui")

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

local function Tween(obj, props, time)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

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
    Tween(NotifFrame, {Position = UDim2.new(1, -20, 1, -20)}, 0.6)
    task.delay(duration, function()
        local tOut = Tween(NotifFrame, {Position = UDim2.new(1, 300, 1, -20)}, 0.5)
        tOut.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

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

local Title = Instance.new("TextLabel", MainFrame)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 85, 0, 25)
Title.Size = UDim2.new(1, -100, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "REDZ HUB PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 40, 40)
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextTransparency = 1

local InputFrame = Instance.new("Frame", MainFrame)
InputFrame.BackgroundColor3 = Color3.fromRGB(25, 18, 18)
InputFrame.Position = UDim2.new(0, 20, 0, 95)
InputFrame.Size = UDim2.new(1, -40, 0, 45)
InputFrame.BackgroundTransparency = 1
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 8)

local KeyInput = Instance.new("TextBox", InputFrame)
KeyInput.BackgroundTransparency = 1
KeyInput.Size = UDim2.new(1, -20, 1, 0)
KeyInput.Position = UDim2.new(0, 10, 0, 0)
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.PlaceholderText = "Paste your REDZ Key here..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 13
KeyInput.TextTransparency = 1
KeyInput.TextXAlignment = Enum.TextXAlignment.Left

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

Tween(MainFrame, {BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.6)
Tween(UIStroke, {Transparency = 0.4}, 0.6)
Tween(Title, {TextTransparency = 0}, 0.4)
Tween(InputFrame, {BackgroundTransparency = 0}, 0.4)
Tween(KeyInput, {TextTransparency = 0}, 0.4)
Tween(VerifyBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.4)
Tween(StatusText, {TextTransparency = 0}, 0.4)

local function ShowStatus(text, color)
    StatusText.Text = text
    StatusText.TextColor3 = color
end

local function FetchAPI(url)
    if httprequest then
        local success, res = pcall(function() return httprequest({Url = url, Method = "GET"}) end)
        if success and res and res.Body then return true, res.Body end
    end
    return pcall(function() return game:HttpGet(url, true) end)
end

VerifyBtn.MouseButton1Click:Connect(function()
    local inputKey = string.match(KeyInput.Text:upper(), "REDZ%-[%w%-]+")
    if not inputKey then return ShowStatus("⚠️ Invalid Key!", Color3.fromRGB(255, 180, 0)) end
    ShowStatus("Authenticating...", Color3.fromRGB(150, 150, 255))
    
    task.spawn(function()
        local success, resBody = FetchAPI(API_URL .. "/api/verify?hwid=" .. MyHWID .. "&key=" .. inputKey)
        if success and resBody then
            local jsonSuccess, data = pcall(function() return HttpService:JSONDecode(resBody) end)
            if jsonSuccess and data.status == "success" then
                ShowStatus("✅ Access Granted!", Color3.fromRGB(0, 255, 150))
                Tween(MainFrame, {BackgroundTransparency = 1}, 0.4)
                for _, child in ipairs(MainFrame:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("TextBox") or child:IsA("TextButton") then
                        Tween(child, {TextTransparency = 1, BackgroundTransparency = 1}, 0.3)
                    end
                end
                task.wait(0.5)
                ScreenGui:Destroy()
                -- ĐÂY LÀ CHỖ TUI NGẮT DIMONDFARM ĐỂ CHỨNG MINH UI KHÔNG LỖI
                SendNotification("🎉 TEST THÀNH CÔNG", "Giao diện Key System hoạt động hoàn hảo 100%!", 10)
            else
                ShowStatus("❌ Invalid Key.", Color3.fromRGB(255, 80, 80))
            end
        end
    end)
end)
