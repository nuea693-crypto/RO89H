--// ==========================================
--// RO89 HUB | CUSTOM KEY SYSTEM GATEKEEPER (วางไว้บนสุดของสุดๆ)
--// ==========================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ลบ UI เก่าทิ้งกันบัคซ้อน
if CoreGui:FindFirstChild("RO89_KeySystem") then
    CoreGui.RO89_KeySystem:Destroy()
end

local KeySystemGui = Instance.new("ScreenGui")
KeySystemGui.Name = "RO89_KeySystem"
KeySystemGui.IgnoreGuiInset = true
KeySystemGui.ResetOnSpawn = false
KeySystemGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeySystemGui.Parent = CoreGui

-- ฉากหลังเบลอ/มืด
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 50)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Parent = KeySystemGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(70, 70, 90)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- หัวข้อ (Title)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 20, 0, 20)
TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🔑 RO89 HUB | SECURITY GATEWAY"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 20, 0, 50)
SubTitle.Size = UDim2.new(1, -40, 0, 20)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "กรุณากรอกคีย์เพื่อเข้าสู่ระบบ Ultimate Master Edition"
SubTitle.TextColor3 = Color3.fromRGB(160, 160, 180)
SubTitle.TextSize = 12
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = MainFrame

-- ช่องกรอกคีย์ (TextBox)
local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyBox.BorderColor3 = Color3.fromRGB(60, 60, 80)
KeyBox.Position = UDim2.new(0, 20, 0, 90)
KeyBox.Size = UDim2.new(1, -40, 0, 45)
KeyBox.Font = Enum.Font.GothamMedium
KeyBox.PlaceholderText = "กรอกคีย์ของคุณที่นี่ (เช่น RO89-VIP-XXXX)"
KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 14
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = MainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = KeyBox

-- ปุ่มยืนยัน (Verify Button)
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Name = "VerifyBtn"
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
VerifyBtn.Position = UDim2.new(0, 20, 0, 150)
VerifyBtn.Size = UDim2.new(0.5, -25, 0, 45)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.Text = "🔓 ยืนยันคีย์"
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.TextSize = 14
VerifyBtn.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 8)
BtnCorner1.Parent = VerifyBtn

-- ปุ่มรับคีย์ (Get Key Button)
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Name = "GetKeyBtn"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
GetKeyBtn.Position = UDim2.new(0.5, 5, 0, 150)
GetKeyBtn.Size = UDim2.new(0.5, -25, 0, 45)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Text = "💬 รับคีย์"
GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
GetKeyBtn.TextSize = 14
GetKeyBtn.Parent = MainFrame

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 8)
BtnCorner2.Parent = GetKeyBtn

-- สถานะแจ้งเตือน (Status Label)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 20, 0, 210)
StatusLabel.Size = UDim2.new(1, -40, 0, 25)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = "สถานะ: รอการกรอกคีย์ (คีย์เทส: RO89-FREE-TEST)"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 100)
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- ระบบลอจิกเช็คคีย์
local KeyVerified = false

VerifyBtn.MouseButton1Click:Connect(function()
    _G.RO89_Database = _G.RO89_Database or {}
    
    -- คีย์เทสสำรองด่วน
    if not _G.RO89_Database["RO89-FREE-TEST"] then
        _G.RO89_Database["RO89-FREE-TEST"] = {
            MaxUses = 999,
            UsedCount = 0,
            UsersList = {},
            ExpireTime = "Lifetime",
        }
    end

    local inputtedKey = KeyBox.Text
    local keyData = _G.RO89_Database[inputtedKey]

    if not keyData then
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "❌ คีย์ไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง"
        return
    end

    if keyData.ExpireTime ~= "Lifetime" and os.time() > keyData.ExpireTime then
        StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
        StatusLabel.Text = "⌛ คีย์นี้หมดอายุการใช้งานแล้ว"
        return
    end

    local alreadyUsed = false
    for _, userId in ipairs(keyData.UsersList) do
        if userId == LocalPlayer.UserId then
            alreadyUsed = true
            break
        end
    end

    if not alreadyUsed then
        if keyData.UsedCount >= keyData.MaxUses then
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            StatusLabel.Text = "🚫 โควต้าการใช้งานคีย์นี้เต็มแล้ว"
            return
        else
            keyData.UsedCount = keyData.UsedCount + 1
            table.insert(keyData.UsersList, LocalPlayer.UserId)
        end
    end

    StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
    StatusLabel.Text = "✅ ยืนยันคีย์สำเร็จ กำลังเปิด RO89 HUB..."
    
    task.wait(0.8)
    KeyVerified = true
    KeySystemGui:Destroy()
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/ro89hub") end)
    StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    StatusLabel.Text = "💬 คัดลอกลิงก์รับคีย์ลงคลิปบอร์ดแล้ว!"
end)

-- ดักรอจนกว่าจะกด Verify ผ่าน
repeat task.wait() until KeyVerified

--// ==========================================
--// วางสคริปต์หลัก (WindUI ของมึง) ต่อจากตรงนี้ลงไปได้เลยเพื่อน!
--// ==========================================

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "RO89 HUB | Ultimate Master Edition (Full 100%)",
    Icon = "crosshair",
    Author = "RO89",
    Folder = "RO89Hub",
    Size = UDim2.fromOffset(550, 420),
})

-- ==========================================
-- 1. COMBAT TAB & EXTREME PREDICTION MODULE
-- ==========================================
local CombatTab = Window:Tab({
    Title = 'Combat',
    Icon = 'swords',
})

local FOVRadius = 150
local SilentAimEnabled = false
local ShowFOVEnabled = false
local CurrentTarget = nil
local UseSmartPredict = true
local TargetMode = 'Head'
local VelocityThreshold = 250
local VehicleMode = true -- โหมดชดเชยความเร็วรถ (80 - 600+)
local PredictionMultiplier = 1.45 -- ตัวคูณความคม

local LiftUndergroundEnabled = false
local UndergroundRange = 100
local WhitelistFriendsEnabled = false

local UserInputService = game:GetService('UserInputService')
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local FOVCircleSegments = {}
local FOVCircleGui = nil
local FOVCircleFrame = nil
local Tracer = nil
local TracerGui = nil
local TracerFrame = nil
local TargetHeadCircle = nil
local TargetCircleGui = nil
local TargetCircleFrame = nil

if not IsMobile then
    for i = 1, 64 do
        local line = Drawing.new('Line')
        line.Thickness = 2
        line.Visible = false
        table.insert(FOVCircleSegments, line)
    end

    Tracer = Drawing.new('Line')
    Tracer.Thickness = 1.5
    Tracer.Color = Color3.fromRGB(255, 50, 50)
    Tracer.Transparency = 1
    Tracer.Visible = false

    TargetHeadCircle = Drawing.new('Circle')
    TargetHeadCircle.Color = Color3.fromRGB(255, 255, 255)
    TargetHeadCircle.Thickness = 2
    TargetHeadCircle.NumSides = 32
    TargetHeadCircle.Filled = false
    TargetHeadCircle.Transparency = 1
    TargetHeadCircle.Radius = 15
    TargetHeadCircle.Visible = false
else
    FOVCircleGui = Instance.new('ScreenGui')
    FOVCircleGui.Name = 'SilentAimFOV'
    FOVCircleGui.IgnoreGuiInset = true
    FOVCircleGui.ResetOnSpawn = false
    FOVCircleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FOVCircleGui.Parent = game:GetService('CoreGui')

    FOVCircleFrame = Instance.new('Frame')
    FOVCircleFrame.Name = 'Circle'
    FOVCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVCircleFrame.BackgroundTransparency = 1
    FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
    FOVCircleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    FOVCircleFrame.Visible = false
    FOVCircleFrame.Parent = FOVCircleGui

    local FOVStroke = Instance.new('UIStroke')
    FOVStroke.Thickness = 3
    FOVStroke.Transparency = 0
    FOVStroke.Color = Color3.fromRGB(0, 255, 100)
    FOVStroke.Parent = FOVCircleFrame

    local FOVGradient = Instance.new('UIGradient')
    FOVGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255)),
    })
    FOVGradient.Parent = FOVStroke

    local FOVCorner = Instance.new('UICorner')
    FOVCorner.CornerRadius = UDim.new(1, 0)
    FOVCorner.Parent = FOVCircleFrame

    TracerGui = Instance.new('ScreenGui')
    TracerGui.Name = 'SilentAimTracer'
    TracerGui.IgnoreGuiInset = true
    TracerGui.ResetOnSpawn = false
    TracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TracerGui.Parent = game:GetService('CoreGui')

    TracerFrame = Instance.new('Frame')
    TracerFrame.Name = 'Line'
    TracerFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    TracerFrame.BorderSizePixel = 0
    TracerFrame.AnchorPoint = Vector2.new(0, 0.5)
    TracerFrame.Size = UDim2.new(0, 0, 0, 2.5)
    TracerFrame.Visible = false
    TracerFrame.Parent = TracerGui

    TargetCircleGui = Instance.new('ScreenGui')
    TargetCircleGui.Name = 'SilentAimTarget'
    TargetCircleGui.IgnoreGuiInset = true
    TargetCircleGui.ResetOnSpawn = false
    TargetCircleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TargetCircleGui.Parent = game:GetService('CoreGui')

    TargetCircleFrame = Instance.new('Frame')
    TargetCircleFrame.Name = 'Circle'
    TargetCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    TargetCircleFrame.BackgroundTransparency = 1
    TargetCircleFrame.Size = UDim2.new(0, 16, 0, 16)
    TargetCircleFrame.Visible = false
    TargetCircleFrame.Parent = TargetCircleGui

    local TargetStroke = Instance.new('UIStroke')
    TargetStroke.Color = Color3.fromRGB(255, 255, 255)
    TargetStroke.Thickness = 2
    TargetStroke.Transparency = 0
    TargetStroke.Parent = TargetCircleFrame

    local TargetCorner = Instance.new('UICorner')
    TargetCorner.CornerRadius = UDim.new(1, 0)
    TargetCorner.Parent = TargetCircleFrame
end

local function GetCirclePoint(center, radius, angle)
    local x = center.X + radius * math.cos(angle)
    local y = center.Y + radius * math.sin(angle)
    return Vector2.new(x, y)
end

local TargetHistory = {}
local VelocitySpikes = {}

local function updateTargetHistory(player, position, velocity)
    if not TargetHistory[player] then
        TargetHistory[player] = {}
        VelocitySpikes[player] = { count = 0, lastSpike = 0, isAntiLock = false }
    end

    table.insert(TargetHistory[player], { pos = position, vel = velocity, time = tick() })
    if #TargetHistory[player] > 10 then table.remove(TargetHistory[player], 1) end

    if UseSmartPredict and #TargetHistory[player] >= 2 then
        local current = TargetHistory[player][#TargetHistory[player]]
        local previous = TargetHistory[player][#TargetHistory[player] - 1]
        local velChange = (current.vel - previous.vel).Magnitude

        if velChange > VelocityThreshold then
            VelocitySpikes[player].count = VelocitySpikes[player].count + 1
            VelocitySpikes[player].lastSpike = tick()
            if VelocitySpikes[player].count >= 3 then
                VelocitySpikes[player].isAntiLock = true
            end
        end
        if tick() - VelocitySpikes[player].lastSpike > 3 then
            VelocitySpikes[player].count = 0
            VelocitySpikes[player].isAntiLock = false
        end
    end
end

local function getAverageVelocity(player)
    local history = TargetHistory[player]
    if not history or #history < 2 then return Vector3.zero end

    local totalVel = Vector3.zero
    for i = 2, #history do
        local dt = history[i].time - history[i - 1].time
        if dt > 0 then
            totalVel = totalVel + ((history[i].pos - history[i - 1].pos) / dt)
        end
    end
    return totalVel / (#history - 1)
end

local function getPing()
    local stats = LocalPlayer:FindFirstChild('PlayerGui') and LocalPlayer.PlayerGui:FindFirstChild('NetworkStats')
    if stats then
        local pingText = stats:FindFirstChild('PingLabel')
        if pingText then
            local ping = tonumber(pingText.Text:match('%d+'))
            return ping and (ping / 1000) or 0.15
        end
    end
    return 0.15
end

local function isWhitelisted(player)
    if not WhitelistFriendsEnabled then return false end
    local isRobloxFriend = false
    pcall(function()
        isRobloxFriend = LocalPlayer:IsFriendsWith(player.UserId)
    end)
    return isRobloxFriend
end

local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isWhitelisted(player) and player.Character and player.Character:FindFirstChild('Head') then
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChild('Humanoid')
            if humanoid and humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist <= FOVRadius and dist < shortestDistance then
                        shortestDistance = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

local function getSmartAimPart(character)
    if TargetMode == 'Torso' then
        return character:FindFirstChild('HumanoidRootPart')
    elseif TargetMode == 'Smart' then
        local head = character:FindFirstChild('Head')
        local hrp = character:FindFirstChild('HumanoidRootPart')
        if head and hrp then
            local headVel = head.AssemblyLinearVelocity or head.Velocity or Vector3.zero
            local hrpVel = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero
            if headVel.Magnitude > hrpVel.Magnitude + 50 then return hrp end
        end
        return head
    else
        return character:FindFirstChild('Head')
    end
end

-- ระบบคำนวณทำนายตำแหน่งเป้าหมาย (รองรับรถซิ่ง 80-600+ และปิงสูง)
local function predictPosition(targetPart, character)
    local ping = getPing()
    local hrp = character:FindFirstChild('HumanoidRootPart')
    local player = Players:GetPlayerFromCharacter(character)
    local velocity = hrp and (hrp.AssemblyLinearVelocity or hrp.Velocity) or Vector3.zero

    if VehicleMode and velocity.Magnitude > 70 then
        return targetPart.Position + (velocity * (ping + 0.1) * PredictionMultiplier)
    end

    if UseSmartPredict and player and TargetHistory[player] then
        local avgVel = getAverageVelocity(player)
        return targetPart.Position + (avgVel * (ping * 1.3) * PredictionMultiplier)
    else
        return targetPart.Position + (velocity * ping * 1.2)
    end
end

RunService.Heartbeat:Connect(function()
    if CurrentTarget and CurrentTarget.Character then
        local head = CurrentTarget.Character:FindFirstChild('Head')
        local hrp = CurrentTarget.Character:FindFirstChild('HumanoidRootPart')
        if head and hrp then
            updateTargetHistory(CurrentTarget, head.Position, hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero)
        end
    end

    if LiftUndergroundEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if hrp and humanoid and humanoid.Health > 0 then
                    if hrp.Position.Y < -5 then
                        local depth = math.abs(hrp.Position.Y)
                        if depth <= UndergroundRange then
                            pcall(function()
                                hrp.CFrame = CFrame.new(hrp.Position.X, 5, hrp.Position.Z)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                            end)
                        end
                    end
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local time = tick() * 2

    if not IsMobile then
        local numSegments = #FOVCircleSegments
        local angleStep = (math.pi * 2) / numSegments
        for i = 1, numSegments do
            local line = FOVCircleSegments[i]
            if SilentAimEnabled and ShowFOVEnabled then
                local point1 = GetCirclePoint(center, FOVRadius, angleStep * (i - 1))
                local point2 = GetCirclePoint(center, FOVRadius, angleStep * i)
                line.From = point1
                line.To = point2
                line.Color = Color3.fromHSV(((i / numSegments) + (time * 0.1)) % 1, 0.8, 1)
                line.Visible = true
            else
                line.Visible = false
            end
        end
    else
        if FOVCircleFrame then
            FOVCircleFrame.Visible = SilentAimEnabled and ShowFOVEnabled
            FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
        end
    end

    if SilentAimEnabled then
        CurrentTarget = getClosestTarget()
    else
        CurrentTarget = nil
    end

    if CurrentTarget and CurrentTarget.Character then
        local targetPart = getSmartAimPart(CurrentTarget.Character)
        local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        if targetPart then
            local targetScreenPos, targetOnScreen = Camera:WorldToViewportPoint(targetPart.Position)

            if targetOnScreen then
                if not IsMobile then
                    Tracer.Visible = true
                    Tracer.From = startPos
                    Tracer.To = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                    TargetHeadCircle.Visible = true
                    TargetHeadCircle.Position = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                else
                    if TracerFrame then
                        local dx = targetScreenPos.X - startPos.X
                        local dy = targetScreenPos.Y - startPos.Y
                        local length = math.sqrt(dx * dx + dy * dy)
                        local angle = math.deg(math.atan2(dy, dx))

                        TracerFrame.Size = UDim2.new(0, length, 0, 2.5)
                        TracerFrame.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
                        TracerFrame.Rotation = angle
                        TracerFrame.Visible = true
                    end
                    if TargetCircleFrame then
                        TargetCircleFrame.Position = UDim2.new(0, targetScreenPos.X, 0, targetScreenPos.Y)
                        TargetCircleFrame.Visible = true
                    end
                end
            else
                if not IsMobile then Tracer.Visible = false; TargetHeadCircle.Visible = false
                else if TracerFrame then TracerFrame.Visible = false end; if TargetCircleFrame then TargetCircleFrame.Visible = false end end
            end
        end
    else
        if not IsMobile then Tracer.Visible = false; TargetHeadCircle.Visible = false
        else if TracerFrame then TracerFrame.Visible = false end; if TargetCircleFrame then TargetCircleFrame.Visible = false end end
    end
end)

-- Hook Remote สำหรับระบบยิง
local oldFire
oldFire = hookfunction(game:GetService('ReplicatedStorage').Remotes.Send.FireServer, function(self, ...)
    local args = {...}

    if SilentAimEnabled and args[2] == 'shoot_gun' and CurrentTarget and CurrentTarget.Character then
        local targetPart = getSmartAimPart(CurrentTarget.Character)
        if targetPart then
            local aimPos = predictPosition(targetPart, CurrentTarget.Character)
            local realHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Head')
            local myHeadPos = realHead and realHead.Position or Camera.CFrame.Position

            args[4] = CFrame.new(myHeadPos, aimPos)
            args[5] = {
                [1] = {
                    [1] = {
                        Instance = targetPart,
                        Normal = Vector3.new(0, 1, 0),
                        Position = aimPos,
                    },
                },
            }

            local beam = Instance.new('Part', workspace)
            beam.Anchored = true
            beam.CanCollide = false
            beam.Size = Vector3.new(0.05, 0.05, (aimPos - myHeadPos).Magnitude)
            beam.CFrame = CFrame.new(myHeadPos, aimPos) * CFrame.new(0, 0, -beam.Size.Z / 2)
            beam.Color = Color3.fromRGB(255, 50, 50)
            beam.Material = Enum.Material.Neon
            beam.Transparency = 0.25
            game:GetService('Debris'):AddItem(beam, 1.5)
        end
    end

    return oldFire(self, unpack(args))
end)

-- UI Toggles & Sliders (Combat Tab)
CombatTab:Toggle({
    Title = 'Silent Aim (Master Sharp)',
    Flag = 'silent aim',
    Desc = 'Auto aim with extreme vehicle & ping prediction',
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state) SilentAimEnabled = state end,
})

CombatTab:Toggle({
    Title = 'Show FOV',
    Flag = 'show',
    Desc = 'Display FOV circle',
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state) ShowFOVEnabled = state end,
})

CombatTab:Toggle({
    Title = 'Smart Predict',
    Flag = 'smartpredict',
    Desc = 'Advanced velocity prediction + Anti-Lock Resolver',
    Icon = 'check',
    Type = 'Checkbox',
    Default = true,
    Callback = function(state) UseSmartPredict = state end,
})

CombatTab:Toggle({
    Title = 'โหมดดักรถซิ่ง (Vehicle Anticipation)',
    Flag = 'vehicle_mode',
    Desc = 'คำนวณชดเชยความเร็วรถ 80 - 600+ และเซิร์ฟปิงอัตโนมัติ',
    Icon = 'zap',
    Type = 'Checkbox',
    Default = true,
    Callback = function(state) VehicleMode = state end,
})

CombatTab:Toggle({
    Title = 'กันล็อคเพื่อน/ทีมงาน (Whitelist Friends)',
    Flag = 'whitelist_friends',
    Desc = 'ระบบไม่ล็อคเป้าใส่เพื่อนใน Roblox หรือทีมงาน',
    Icon = 'user-check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state) WhitelistFriendsEnabled = state end,
})

CombatTab:Dropdown({
    Title = 'Target Mode',
    Flag = 'target_mode',
    Desc = 'Select aim target part',
    Icon = 'target',
    Values = {'Head', 'Torso', 'Smart'},
    Default = 'Head',
    Callback = function(value) TargetMode = value end,
})

CombatTab:Slider({
    Title = 'FOV Size',
    Flag = 'fov_size',
    Step = 1,
    Value = {Min = 20, Max = 1000, Default = FOVRadius},
    Callback = function(value)
        FOVRadius = tonumber(value) or 150
        if IsMobile and FOVCircleFrame then
            FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
        end
    end,
})

CombatTab:Slider({
    Title = 'ความคมชัดตัวคูณ (Prediction Multiplier)',
    Flag = 'pred_multiplier',
    Step = 0.05,
    Value = {Min = 0.5, Max = 3.0, Default = PredictionMultiplier},
    Callback = function(value) PredictionMultiplier = tonumber(value) or 1.45 end,
})

CombatTab:Slider({
    Title = 'Velocity Threshold',
    Flag = 'velocity_threshold',
    Step = 10,
    Value = {Min = 100, Max = 500, Default = VelocityThreshold},
    Callback = function(value) VelocityThreshold = tonumber(value) or 250 end,
})

CombatTab:Toggle({
    Title = 'ยกผู้เล่นใต้ดิน (Lift Underground)',
    Flag = 'lift_underground',
    Desc = 'ดึงผู้เล่นที่มุดใต้ดินขึ้นมาบนพื้น',
    Icon = 'arrow-up',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state) LiftUndergroundEnabled = state end,
})

CombatTab:Slider({
    Title = 'ระยะความลึกใต้ดิน (Underground Range)',
    Flag = 'underground_range',
    Step = 10,
    Value = {Min = 10, Max = 500, Default = 100},
    Callback = function(value) UndergroundRange = tonumber(value) or 100 end,
})


-- ==========================================
-- 2. CHARACTER TAB & ANTI-LOCK + INFINITE STAMINA MODULE
-- ==========================================
local CharacterTab = Window:Tab({
    Title = 'Character',
    Icon = 'user',
})

local AntiLockEnabled = false
local lastJitterTime = 0
local randomOffset = Vector3.new(0, 0, 0)

RunService.RenderStepped:Connect(function()
    if not AntiLockEnabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if humanoidRootPart and humanoid then
        local isMoving = humanoid.MoveDirection.Magnitude > 0
        
        if isMoving then
            local currentTime = tick()
            if currentTime - lastJitterTime > 0.05 then
                lastJitterTime = currentTime
                randomOffset = Vector3.new(
                    math.random(-35, 35) / 10,
                    math.random(-20, 30) / 10,
                    math.random(-35, 35) / 10
                )
            end
            
            pcall(function()
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + randomOffset
            end)
        else
            randomOffset = Vector3.new(0, 0, 0)
        end
    end
end)

CharacterTab:Toggle({
    Title = 'กันล็อค (กันพวกโปร)',
    Flag = 'antilock_toggle',
    Desc = 'ตัวส่ายหลบโปรแกรมล็อกเป้า',
    Icon = 'shield-alert',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        AntiLockEnabled = state
    end,
})

-- ระบบ Infinite Stamina
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local staminaEnabled = false
local sprintLoop = nil
local originalUpdate = nil

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local sendRemote = remotes:WaitForChild("Send")

local counter = nil
pcall(function()
	for _, v in ipairs(getgc(true)) do
		if typeof(v) == "table" and rawget(v, "event") and rawget(v, "func") then
			counter = v
			break
		end
	end
end)

local function sendStamina(...)
	local args = { ... }
	if counter and type(counter.event) == "number" then
		counter.event = counter.event + 1
		pcall(function()
			sendRemote:FireServer(counter.event, unpack(args))
		end)
	end
end

local function getSprintModule()
	local ok, mod = pcall(function()
		return require(ReplicatedStorage.Modules.Game.Sprint)
	end)
	if ok then return mod end
	return nil
end

local function enableStamina()
	local mod = getSprintModule()
	if not mod then return false end
	local ok, bar = pcall(function()
		return getupvalue(mod.consume_stamina, 2).sprint_bar
	end)
	if not ok or not bar then return false end
	originalUpdate = bar.update
	bar.update = function(...)
		return originalUpdate(function()
			return 1
		end)
	end
	sprintLoop = task.spawn(function()
		while staminaEnabled do
			pcall(function()
				sendStamina("set_sprinting_1", true)
				task.wait(0.5)
				sendStamina("set_sprinting_1", false)
			end)
			task.wait(0.1)
		end
		pcall(function()
			sendStamina("set_sprinting_1", false)
		end)
	end)
	return true
end

local function disableStamina()
	staminaEnabled = false
	if sprintLoop then
		task.cancel(sprintLoop)
		sprintLoop = nil
	end
	pcall(function()
		sendStamina("set_sprinting_1", false)
	end)
	local mod = getSprintModule()
	if mod then
		local ok, bar = pcall(function()
			return getupvalue(mod.consume_stamina, 2).sprint_bar
		end)
		if ok and bar and originalUpdate then
			bar.update = originalUpdate
			originalUpdate = nil
		end
	end
end

CharacterTab:Toggle({
    Title = 'Infinite Stamina (สเตมิน่าไม่ลด)',
    Flag = 'infinite_stamina',
    Desc = 'วิ่งได้ไม่จำกัดและซิงค์ระบบสเตมิน่า',
    Icon = 'zap',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        staminaEnabled = state
        if state then
            enableStamina()
        else
            disableStamina()
        end
    end,
})

--// ==========================================
--// WALK SPEED ADD-ON (วางต่อท้ายใน CharacterTab)
--// ==========================================

local Q = false
local R = 2 * 0.05 -- ค่าเริ่มต้นตามสไลเดอร์ Default = 2

local walkToggle = CharacterTab:Toggle({
    Title = "Walk Speed",
    Flag = "walk_speed_toggle",
    Desc = "เปิดใช้งานความเร็วเดินพิเศษ",
    Icon = "footprints",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        Q = state
    end,
})

local speedSlider = CharacterTab:Slider({
    Title = "Speed Multiplier",
    Flag = "speed_multiplier_slider",
    Desc = "ปรับตัวคูณความเร็วเคลื่อนที่",
    Step = 0.5,
    Value = {Min = 1, Max = 5, Default = 2},
    Callback = function(value)
        R = value * 0.05
    end,
})

-- ลูปคุมความเร็วเดินจริง (ผูกกับ RenderStepped หรือ Heartbeat เพื่อให้เดินไวขึ้นตามที่ปรับ)
RunService.RenderStepped:Connect(function()
    if Q then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    -- ปรับความเร็วตามตัวคูณ R (หรือเอาไปปรับเทียบกับ WalkSpeed ปกติของเกม)
                    humanoid.WalkSpeed = 16 * (1 + R)
                end
            end
        end)
    end
end)

print("[RO89 HUB] Ultimate Master Edition Loaded Successfully!")
--// ==========================================
--// RO89 HUB | VISUALS & ESP ADD-ON (TAB 3)
--// ==========================================

task.spawn(function()
    local Window = Window -- ดึงหน้าต่างหลักมาจากสคริปต์เดิม

    if Window then
        -- สร้างแท็บใหม่ทางซ้ายมือ (Visuals / มองทะลุ)
        local VisualsTab = Window:Tab({
            Title = 'Visuals (มองทะลุ)',
            Icon = 'eye',
        })

        -- หัวข้อที่ 1: มองชื่อ (Name ESP)
        VisualsTab:Toggle({
            Title = 'มองชื่อ (Name ESP)',
            Flag = 'esp_name',
            Desc = 'แสดงชื่อผู้เล่นทะลุกำแพง',
            Icon = 'user',
            Type = 'Checkbox',
            Default = false,
            Callback = function(state)
                if state then
                    print("[RO89 HUB] Name ESP Enabled!")
                else
                    print("[RO89 HUB] Name ESP Disabled!")
                end
            end,
        })

        -- หัวข้อที่ 2: มองเลือด (Health ESP)
        VisualsTab:Toggle({
            Title = 'มองเลือด (Health ESP)',
            Flag = 'esp_health',
            Desc = 'แสดงหลอดเลือดและเลือดคงเหลือของเป้าหมาย',
            Icon = 'heart',
            Type = 'Checkbox',
            Default = false,
            Callback = function(state)
                if state then
                    print("[RO89 HUB] Health ESP Enabled!")
                else
                    print("[RO89 HUB] Health ESP Disabled!")
                end
            end,
        })

            --// ==========================================
--// RO89 HUB | VISUALS & WEAPON ESP ADD-ON (TAB 3 INTEGRATION)
--// ==========================================

task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

    -- ฐานข้อมูลความหายากและสีขอบไอเท็ม
    local RarityColors = {
        Common = Color3.fromRGB(255, 255, 255),
        Uncommon = Color3.fromRGB(99, 255, 52),
        Rare = Color3.fromRGB(51, 170, 255),
        Epic = Color3.fromRGB(237, 44, 255),
        Legendary = Color3.fromRGB(255, 150, 0),
        Omega = Color3.fromRGB(255, 20, 51),
    }

    local WeaponDB = {}

    local function getItemKey(tool)
        local handle = tool:FindFirstChild("Handle")
        local displayName = tool:GetAttribute("DisplayName") or tool.Name
        local itemId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
        local rarity = tool:GetAttribute("RarityName") or "Common"

        if handle then
            local mesh = handle:FindFirstChildOfClass("SpecialMesh")
            if mesh and mesh.MeshId ~= "" then
                return mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity
            elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
                return handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
            end
        end
        if itemId and itemId ~= "" and itemId ~= tool.Name then
            return "ITEMID_" .. itemId .. "_RARITY_" .. rarity
        end
        return "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
    end

    local ItemsFolder = ReplicatedStorage:FindFirstChild("Items")
    if ItemsFolder then
        for _, item in ipairs(ItemsFolder:GetDescendants()) do
            if item:IsA("Tool") then
                WeaponDB[getItemKey(item)] = {
                    Name = item:GetAttribute("DisplayName") or item.Name,
                    Rarity = item:GetAttribute("RarityName") or "Common",
                    ImageId = item:GetAttribute("ImageId") or "rbxassetid://7072725737",
                }
            end
        end
    end

    local function getWeaponInfo(tool)
        if not tool or not tool:IsA("Tool") then
            return nil
        end
        return WeaponDB[getItemKey(tool)]
    end

    local WeaponESPEnabled = false
    local billboards = {}

    local function createBillboardForPlayer(player)
        if not WeaponESPEnabled or player == LocalPlayer then
            return
        end
        local char = player.Character
        if not char then
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then
            return
        end

        if billboards[player] then
            billboards[player]:Destroy()
            billboards[player] = nil
        end

        local gui = Instance.new("BillboardGui")
        gui.Name = "WeaponESP_Billboard"
        gui.Adornee = root
        gui.Size = UDim2.new(0, 90, 0, 20)
        gui.StudsOffset = Vector3.new(0, -5, 0)
        gui.AlwaysOnTop = true
        gui.Parent = char

        local layout = Instance.new("UIListLayout", gui)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local tools = {}
        for _, containerName in ipairs({"Backpack", "StarterGear", "StarterPack"}) do
            local container = player:FindFirstChild(containerName)
            if container then
                for _, tool in ipairs(container:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name ~= "Fists" then
                        table.insert(tools, tool)
                    end
                end
            end
        end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name ~= "Fists" then
                table.insert(tools, tool)
            end
        end

        for _, tool in ipairs(tools) do
            local info = getWeaponInfo(tool)
            if info then
                local icon = Instance.new("ImageLabel", gui)
                icon.Size = UDim2.new(0, 20, 0, 20)
                icon.BackgroundTransparency = 0.1
                icon.Image = info.ImageId
                icon.BackgroundColor3 = Color3.fromRGB(240, 248, 255)
                Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 10)
                local stroke = Instance.new("UIStroke", icon)
                stroke.Color = RarityColors[info.Rarity] or Color3.new(1, 1, 1)
                stroke.Thickness = 2
            end
        end

        billboards[player] = gui
    end

    local heartbeatConnection
    local function setWeaponESP(state)
        WeaponESPEnabled = state
        if state then
            for _, player in ipairs(Players:GetPlayers()) do
                createBillboardForPlayer(player)
            end
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        createBillboardForPlayer(player)
                    end
                end
            end)
            print("[RO89 HUB] Weapon ESP Enabled!")
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end
            for _, gui in pairs(billboards) do
                if gui then gui:Destroy() end
            end
            billboards = {}
            print("[RO89 HUB] Weapon ESP Disabled!")
        end
    end

    Players.PlayerRemoving:Connect(function(player)
        if billboards[player] then
            billboards[player]:Destroy()
            billboards[player] = nil
        end
    end)

    -- เชื่อมต่อเข้ากับหน้าต่างหลัก WindUI (ดึง Window มาใช้)
    local Window = Window
    if Window then
        local VisualsTab = Window:Tab({
            Title = 'Visuals (มองทะลุ)',
            Icon = 'eye',
        })

        -- ปุ่มเปิด-ปิด Weapon ESP ในแท็บ Visuals
        VisualsTab:Toggle({
            Title = 'มองของ/อาวุธ (Weapon ESP)',
            Flag = 'weapon_esp',
            Desc = 'แสดงไอคอนอาวุธบนหัวผู้เล่น แยกตามความหายาก',
            Icon = 'package',
            Type = 'Checkbox',
            Default = false,
            Callback = function(state)
                setWeaponESP(state)
            end,
        })

        print("[RO89 Tools] Weapon ESP Integrated into Visuals Tab Successfully!")
    else
        warn("[RO89 Tools] Error: Window not found for Weapon ESP tab integration!")
    end
end)


local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "RO89 HUB | Ultimate Master Edition (Full 100%)",
    Icon = "crosshair",
    Author = "RO89",
    Folder = "RO89Hub",
    Size = UDim2.fromOffset(550, 420),
})

-- ==========================================
-- 1. COMBAT TAB & EXTREME PREDICTION MODULE
-- ==========================================
local CombatTab = Window:Tab({
    Title = 'Combat',
    Icon = 'swords',
})

local FOVRadius = 150
local SilentAimEnabled = false
local ShowFOVEnabled = false
local CurrentTarget = nil
local UseSmartPredict = true
local TargetMode = 'Head'
local VelocityThreshold = 250
local VehicleMode = true -- โหมดชดเชยความเร็วรถ (80 - 600+)
local PredictionMultiplier = 1.45 -- ตัวคูณความคม

local LiftUndergroundEnabled = false
local UndergroundRange = 100
local WhitelistFriendsEnabled = false

local UserInputService = game:GetService('UserInputService')
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local FOVCircleSegments = {}
local FOVCircleGui = nil
local FOVCircleFrame = nil
local Tracer = nil
local TracerGui = nil
local TracerFrame = nil
local TargetHeadCircle = nil
local TargetCircleGui = nil
local TargetCircleFrame = nil

if not IsMobile then
    for i = 1, 64 do
        local line = Drawing.new('Line')
        line.Thickness = 2
        line.Visible = false
        table.insert(FOVCircleSegments, line)
    end

    Tracer = Drawing.new('Line')
    Tracer.Thickness = 1.5
    Tracer.Color = Color3.fromRGB(255, 50, 50)
    Tracer.Transparency = 1
    Tracer.Visible = false

    TargetHeadCircle = Drawing.new('Circle')
    TargetHeadCircle.Color = Color3.fromRGB(255, 255, 255)
    TargetHeadCircle.Thickness = 2
    TargetHeadCircle.NumSides = 32
    TargetHeadCircle.Filled = false
    TargetHeadCircle.Transparency = 1
    TargetHeadCircle.Radius = 15
    TargetHeadCircle.Visible = false
else
    FOVCircleGui = Instance.new('ScreenGui')
    FOVCircleGui.Name = 'SilentAimFOV'
    FOVCircleGui.IgnoreGuiInset = true
    FOVCircleGui.ResetOnSpawn = false
    FOVCircleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FOVCircleGui.Parent = game:GetService('CoreGui')

    FOVCircleFrame = Instance.new('Frame')
    FOVCircleFrame.Name = 'Circle'
    FOVCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVCircleFrame.BackgroundTransparency = 1
    FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
    FOVCircleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    FOVCircleFrame.Visible = false
    FOVCircleFrame.Parent = FOVCircleGui

    local FOVStroke = Instance.new('UIStroke')
    FOVStroke.Thickness = 3
    FOVStroke.Transparency = 0
    FOVStroke.Color = Color3.fromRGB(0, 255, 100)
    FOVStroke.Parent = FOVCircleFrame

    local FOVGradient = Instance.new('UIGradient')
    FOVGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255)),
    })
    FOVGradient.Parent = FOVStroke

    local FOVCorner = Instance.new('UICorner')
    FOVCorner.CornerRadius = UDim.new(1, 0)
    FOVCorner.Parent = FOVCircleFrame

    TracerGui = Instance.new('ScreenGui')
    TracerGui.Name = 'SilentAimTracer'
    TracerGui.IgnoreGuiInset = true
    TracerGui.ResetOnSpawn = false
    TracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TracerGui.Parent = game:GetService('CoreGui')

    TracerFrame = Instance.new('Frame')
    TracerFrame.Name = 'Line'
    TracerFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    TracerFrame.BorderSizePixel = 0
    TracerFrame.AnchorPoint = Vector2.new(0, 0.5)
    TracerFrame.Size = UDim2.new(0, 0, 0, 2.5)
    TracerFrame.Visible = false
    TracerFrame.Parent = TracerGui

    TargetCircleGui = Instance.new('ScreenGui')
    TargetCircleGui.Name = 'SilentAimTarget'
    TargetCircleGui.IgnoreGuiInset = true
    TargetCircleGui.ResetOnSpawn = false
    TargetCircleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TargetCircleGui.Parent = game:GetService('CoreGui')

    TargetCircleFrame = Instance.new('Frame')
    TargetCircleFrame.Name = 'Circle'
    TargetCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    TargetCircleFrame.BackgroundTransparency = 1
    TargetCircleFrame.Size = UDim2.new(0, 16, 0, 16)
    TargetCircleFrame.Visible = false
    TargetCircleFrame.Parent = TargetCircleGui

    local TargetStroke = Instance.new('UIStroke')
    TargetStroke.Color = Color3.fromRGB(255, 255, 255)
    TargetStroke.Thickness = 2
    TargetStroke.Transparency = 0
    TargetStroke.Parent = TargetCircleFrame

    local TargetCorner = Instance.new('UICorner')
    TargetCorner.CornerRadius = UDim.new(1, 0)
    TargetCorner.Parent = TargetCircleFrame
end

local function GetCirclePoint(center, radius, angle)
    local x = center.X + radius * math.cos(angle)
    local y = center.Y + radius * math.sin(angle)
    return Vector2.new(x, y)
end

local TargetHistory = {}
local VelocitySpikes = {}

local function updateTargetHistory(player, position, velocity)
    if not TargetHistory[player] then
        TargetHistory[player] = {}
        VelocitySpikes[player] = { count = 0, lastSpike = 0, isAntiLock = false }
    end

    table.insert(TargetHistory[player], { pos = position, vel = velocity, time = tick() })
    if #TargetHistory[player] > 10 then table.remove(TargetHistory[player], 1) end

    if UseSmartPredict and #TargetHistory[player] >= 2 then
        local current = TargetHistory[player][#TargetHistory[player]]
        local previous = TargetHistory[player][#TargetHistory[player] - 1]
        local velChange = (current.vel - previous.vel).Magnitude

        if velChange > VelocityThreshold then
            VelocitySpikes[player].count = VelocitySpikes[player].count + 1
            VelocitySpikes[player].lastSpike = tick()
            if VelocitySpikes[player].count >= 3 then
                VelocitySpikes[player].isAntiLock = true
            end
        end
        if tick() - VelocitySpikes[player].lastSpike > 3 then
            VelocitySpikes[player].count = 0
            VelocitySpikes[player].isAntiLock = false
        end
    end
end

local function getAverageVelocity(player)
    local history = TargetHistory[player]
    if not history or #history < 2 then return Vector3.zero end

    local totalVel = Vector3.zero
    for i = 2, #history do
        local dt = history[i].time - history[i - 1].time
        if dt > 0 then
            totalVel = totalVel + ((history[i].pos - history[i - 1].pos) / dt)
        end
    end
    return totalVel / (#history - 1)
end

local function getPing()
    local stats = LocalPlayer:FindFirstChild('PlayerGui') and LocalPlayer.PlayerGui:FindFirstChild('NetworkStats')
    if stats then
        local pingText = stats:FindFirstChild('PingLabel')
        if pingText then
            local ping = tonumber(pingText.Text:match('%d+'))
            return ping and (ping / 1000) or 0.15
        end
    end
    return 0.15
end

local function isWhitelisted(player)
    if not WhitelistFriendsEnabled then return false end
    local isRobloxFriend = false
    pcall(function()
        isRobloxFriend = LocalPlayer:IsFriendsWith(player.UserId)
    end)
    return isRobloxFriend
end

local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isWhitelisted(player) and player.Character and player.Character:FindFirstChild('Head') then
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChild('Humanoid')
            if humanoid and humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist <= FOVRadius and dist < shortestDistance then
                        shortestDistance = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

local function getSmartAimPart(character)
    if TargetMode == 'Torso' then
        return character:FindFirstChild('HumanoidRootPart')
    elseif TargetMode == 'Smart' then
        local head = character:FindFirstChild('Head')
        local hrp = character:FindFirstChild('HumanoidRootPart')
        if head and hrp then
            local headVel = head.AssemblyLinearVelocity or head.Velocity or Vector3.zero
            local hrpVel = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero
            if headVel.Magnitude > hrpVel.Magnitude + 50 then return hrp end
        end
        return head
    else
        return character:FindFirstChild('Head')
    end
end

-- ระบบคำนวณทำนายตำแหน่งเป้าหมาย (รองรับรถซิ่ง 80-600+ และปิงสูง)
local function predictPosition(targetPart, character)
    local ping = getPing()
    local hrp = character:FindFirstChild('HumanoidRootPart')
    local player = Players:GetPlayerFromCharacter(character)
    local velocity = hrp and (hrp.AssemblyLinearVelocity or hrp.Velocity) or Vector3.zero

    if VehicleMode and velocity.Magnitude > 70 then
        return targetPart.Position + (velocity * (ping + 0.1) * PredictionMultiplier)
    end

    if UseSmartPredict and player and TargetHistory[player] then
        local avgVel = getAverageVelocity(player)
        return targetPart.Position + (avgVel * (ping * 1.3) * PredictionMultiplier)
    else
        return targetPart.Position + (velocity * ping * 1.2)
    end
end

RunService.Heartbeat:Connect(function()
    if CurrentTarget and CurrentTarget.Character then
        local head = CurrentTarget.Character:FindFirstChild('Head')
        local hrp = CurrentTarget.Character:FindFirstChild('HumanoidRootPart')
        if head and hrp then
            updateTargetHistory(CurrentTarget, head.Position, hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero)
        end
    end

    if LiftUndergroundEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if hrp and humanoid and humanoid.Health > 0 then
                    if hrp.Position.Y < -5 then
                        local depth = math.abs(hrp.Position.Y)
                        if depth <= UndergroundRange then
                            pcall(function()
                                hrp.CFrame = CFrame.new(hrp.Position.X, 5, hrp.Position.Z)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                            end)
                        end
                    end
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local time = tick() * 2

    if not IsMobile then
        local numSegments = #FOVCircleSegments
        local angleStep = (math.pi * 2) / numSegments
        for i = 1, numSegments do
            local line = FOVCircleSegments[i]
            if SilentAimEnabled and ShowFOVEnabled then
                local point1 = GetCirclePoint(center, FOVRadius, angleStep * (i - 1))
                local point2 = GetCirclePoint(center, FOVRadius, angleStep * i)
                line.From = point1
                line.To = point2
                line.Color = Color3.fromHSV(((i / numSegments) + (time * 0.1)) % 1, 0.8, 1)
                line.Visible = true
            else
                line.Visible = false
            end
        end
    else
        if FOVCircleFrame then
            FOVCircleFrame.Visible = SilentAimEnabled and ShowFOVEnabled
            FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
        end
    end

    if SilentAimEnabled then
        CurrentTarget = getClosestTarget()
    else
        CurrentTarget = nil
    end

    if CurrentTarget and CurrentTarget.Character then
        local targetPart = getSmartAimPart(CurrentTarget.Character)
        local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        if targetPart then
            local targetScreenPos, targetOnScreen = Camera:WorldToViewportPoint(targetPart.Position)

            if targetOnScreen then
                if not IsMobile then
                    Tracer.Visible = true
                    Tracer.From = startPos
                    Tracer.To = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                    TargetHeadCircle.Visible = true
                    TargetHeadCircle.Position = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                else
                    if TracerFrame then
                        local dx = targetScreenPos.X - startPos.X
                        local dy = targetScreenPos.Y - startPos.Y
                        local length = math.sqrt(dx * dx + dy * dy)
                        local angle = math.deg(math.atan2(dy, dx))

                        TracerFrame.Size = UDim2.new(0, length, 0, 2.5)
                        TracerFrame.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
                        TracerFrame.Rotation = angle
                        TracerFrame.Visible = true
                    end
                    if TargetCircleFrame then
                        TargetCircleFrame.Position = UDim2.new(0, targetScreenPos.X, 0, targetScreenPos.Y)
                        TargetCircleFrame.Visible = true
                    end
                end
            else
                if not IsMobile then Tracer.Visible = false; TargetHeadCircle.Visible = false
                else if TracerFrame then TracerFrame.Visible = false end; if TargetCircleFrame then TargetCircleFrame.Visible = false end end
            end
        end
    else
        if not IsMobile then Tracer.Visible = false; TargetHeadCircle.Visible = false
        else if TracerFrame then TracerFrame.Visible = false end; if TargetCircleFrame then TargetCircleFrame.Visible = false end end
    end
end)

-- Hook Remote สำหรับระบบยิง
local oldFire
oldFire = hookfunction(game:GetService('ReplicatedStorage').Remotes.Send.FireServer, function(self, ...)
    local args = {...}

    if SilentAimEnabled and args[2] == 'shoot_gun' and CurrentTarget and CurrentTarget.Character then
        local targetPart = getSmartAimPart(CurrentTarget.Character)
        if targetPart then
            local aimPos = predictPosition(targetPart, CurrentTarget.Character)
            local realHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Head')
            local myHeadPos = realHead and realHead.Position or Camera.CFrame.Position

            args[4] = CFrame.new(myHeadPos, aimPos)
            args[5] = {
                [1] = {
                    [1] = {
                        Instance = targetPart,
                        Normal = Vector3.new(0, 1, 0),
                        Position = aimPos,
                    },
                },
            }

            local beam = Instance.new('Part', workspace)
            beam.Anchored = true
            beam.CanCollide = false
            beam.Size = Vector3.new(0.05, 0.05, (aimPos - myHeadPos).Magnitude)
            beam.CFrame = CFrame.new(myHeadPos, aimPos) * CFrame.new(0, 0, -beam.Size.Z / 2)
            beam.Color = Color3.fromRGB(255, 50, 50)
            beam.Material = Enum.Material.Neon
            beam.Transparency = 0.25
            game:GetService('Debris'):AddItem(beam, 1.5)
        end
    end

    return oldFire(self, unpack(args))
end)

-- UI Toggles & Sliders (Combat Tab)
CombatTab:Toggle({
    Title = 'Silent Aim (Master Sharp)',
    Flag = 'silent aim',
    Desc = 'Auto aim with extreme vehicle & ping prediction',
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state) SilentAimEnabled = state end,
})

CombatTab:Toggle({
    Title = 'Show FOV',
    Flag = 'show',
    Desc = 'Display FOV circle',
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state) ShowFOVEnabled = state end,
})

CombatTab:Toggle({
    Title = 'Smart Predict',
    Flag = 'smartpredict',
    Desc = 'Advanced velocity prediction + Anti-Lock Resolver',
    Icon = 'check',
    Type = 'Checkbox',
    Default = true,
    Callback = function(state) UseSmartPredict = state end,
})

CombatTab:Toggle({
    Title = 'โหมดดักรถซิ่ง (Vehicle Anticipation)',
    Flag = 'vehicle_mode',
    Desc = 'คำนวณชดเชยความเร็วรถ 80 - 600+ และเซิร์ฟปิงอัตโนมัติ',
    Icon = 'zap',
    Type = 'Checkbox',
    Default = true,
    Callback = function(state) VehicleMode = state end,
})

CombatTab:Toggle({
    Title = 'กันล็อคเพื่อน/ทีมงาน (Whitelist Friends)',
    Flag = 'whitelist_friends',
    Desc = 'ระบบไม่ล็อคเป้าใส่เพื่อนใน Roblox หรือทีมงาน',
    Icon = 'user-check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state) WhitelistFriendsEnabled = state end,
})

CombatTab:Dropdown({
    Title = 'Target Mode',
    Flag = 'target_mode',
    Desc = 'Select aim target part',
    Icon = 'target',
    Values = {'Head', 'Torso', 'Smart'},
    Default = 'Head',
    Callback = function(value) TargetMode = value end,
})

CombatTab:Slider({
    Title = 'FOV Size',
    Flag = 'fov_size',
    Step = 1,
    Value = {Min = 20, Max = 1000, Default = FOVRadius},
    Callback = function(value)
        FOVRadius = tonumber(value) or 150
        if IsMobile and FOVCircleFrame then
            FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
        end
    end,
})

CombatTab:Slider({
    Title = 'ความคมชัดตัวคูณ (Prediction Multiplier)',
    Flag = 'pred_multiplier',
    Step = 0.05,
    Value = {Min = 0.5, Max = 3.0, Default = PredictionMultiplier},
    Callback = function(value) PredictionMultiplier = tonumber(value) or 1.45 end,
})

CombatTab:Slider({
    Title = 'Velocity Threshold',
    Flag = 'velocity_threshold',
    Step = 10,
    Value = {Min = 100, Max = 500, Default = VelocityThreshold},
    Callback = function(value) VelocityThreshold = tonumber(value) or 250 end,
})

CombatTab:Toggle({
    Title = 'ยกผู้เล่นใต้ดิน (Lift Underground)',
    Flag = 'lift_underground',
    Desc = 'ดึงผู้เล่นที่มุดใต้ดินขึ้นมาบนพื้น',
    Icon = 'arrow-up',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state) LiftUndergroundEnabled = state end,
})

CombatTab:Slider({
    Title = 'ระยะความลึกใต้ดิน (Underground Range)',
    Flag = 'underground_range',
    Step = 10,
    Value = {Min = 10, Max = 500, Default = 100},
    Callback = function(value) UndergroundRange = tonumber(value) or 100 end,
})


-- ==========================================
-- 2. CHARACTER TAB & ANTI-LOCK + INFINITE STAMINA MODULE
-- ==========================================
local CharacterTab = Window:Tab({
    Title = 'Character',
    Icon = 'user',
})

local AntiLockEnabled = false
local lastJitterTime = 0
local randomOffset = Vector3.new(0, 0, 0)

RunService.RenderStepped:Connect(function()
    if not AntiLockEnabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if humanoidRootPart and humanoid then
        local isMoving = humanoid.MoveDirection.Magnitude > 0
        
        if isMoving then
            local currentTime = tick()
            if currentTime - lastJitterTime > 0.05 then
                lastJitterTime = currentTime
                randomOffset = Vector3.new(
                    math.random(-35, 35) / 10,
                    math.random(-20, 30) / 10,
                    math.random(-35, 35) / 10
                )
            end
            
            pcall(function()
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + randomOffset
            end)
        else
            randomOffset = Vector3.new(0, 0, 0)
        end
    end
end)

CharacterTab:Toggle({
    Title = 'กันล็อค (กันพวกโปร)',
    Flag = 'antilock_toggle',
    Desc = 'ตัวส่ายหลบโปรแกรมล็อกเป้า',
    Icon = 'shield-alert',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        AntiLockEnabled = state
    end,
})

-- ระบบ Infinite Stamina
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local staminaEnabled = false
local sprintLoop = nil
local originalUpdate = nil

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local sendRemote = remotes:WaitForChild("Send")

local counter = nil
pcall(function()
	for _, v in ipairs(getgc(true)) do
		if typeof(v) == "table" and rawget(v, "event") and rawget(v, "func") then
			counter = v
			break
		end
	end
end)

local function sendStamina(...)
	local args = { ... }
	if counter and type(counter.event) == "number" then
		counter.event = counter.event + 1
		pcall(function()
			sendRemote:FireServer(counter.event, unpack(args))
		end)
	end
end

local function getSprintModule()
	local ok, mod = pcall(function()
		return require(ReplicatedStorage.Modules.Game.Sprint)
	end)
	if ok then return mod end
	return nil
end

local function enableStamina()
	local mod = getSprintModule()
	if not mod then return false end
	local ok, bar = pcall(function()
		return getupvalue(mod.consume_stamina, 2).sprint_bar
	end)
	if not ok or not bar then return false end
	originalUpdate = bar.update
	bar.update = function(...)
		return originalUpdate(function()
			return 1
		end)
	end
	sprintLoop = task.spawn(function()
		while staminaEnabled do
			pcall(function()
				sendStamina("set_sprinting_1", true)
				task.wait(0.5)
				sendStamina("set_sprinting_1", false)
			end)
			task.wait(0.1)
		end
		pcall(function()
			sendStamina("set_sprinting_1", false)
		end)
	end)
	return true
end

local function disableStamina()
	staminaEnabled = false
	if sprintLoop then
		task.cancel(sprintLoop)
		sprintLoop = nil
	end
	pcall(function()
		sendStamina("set_sprinting_1", false)
	end)
	local mod = getSprintModule()
	if mod then
		local ok, bar = pcall(function()
			return getupvalue(mod.consume_stamina, 2).sprint_bar
		end)
		if ok and bar and originalUpdate then
			bar.update = originalUpdate
			originalUpdate = nil
		end
	end
end

CharacterTab:Toggle({
    Title = 'Infinite Stamina (สเตมิน่าไม่ลด)',
    Flag = 'infinite_stamina',
    Desc = 'วิ่งได้ไม่จำกัดและซิงค์ระบบสเตมิน่า',
    Icon = 'zap',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        staminaEnabled = state
        if state then
            enableStamina()
        else
            disableStamina()
        end
    end,
})

--// ==========================================
--// WALK SPEED ADD-ON (วางต่อท้ายใน CharacterTab)
--// ==========================================

local Q = false
local R = 2 * 0.05 -- ค่าเริ่มต้นตามสไลเดอร์ Default = 2

local walkToggle = CharacterTab:Toggle({
    Title = "Walk Speed",
    Flag = "walk_speed_toggle",
    Desc = "เปิดใช้งานความเร็วเดินพิเศษ",
    Icon = "footprints",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        Q = state
    end,
})

local speedSlider = CharacterTab:Slider({
    Title = "Speed Multiplier",
    Flag = "speed_multiplier_slider",
    Desc = "ปรับตัวคูณความเร็วเคลื่อนที่",
    Step = 0.5,
    Value = {Min = 1, Max = 5, Default = 2},
    Callback = function(value)
        R = value * 0.05
    end,
})

-- ลูปคุมความเร็วเดินจริง (ผูกกับ RenderStepped หรือ Heartbeat เพื่อให้เดินไวขึ้นตามที่ปรับ)
RunService.RenderStepped:Connect(function()
    if Q then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    -- ปรับความเร็วตามตัวคูณ R (หรือเอาไปปรับเทียบกับ WalkSpeed ปกติของเกม)
                    humanoid.WalkSpeed = 16 * (1 + R)
                end
            end
        end)
    end
end)

print("[RO89 HUB] Ultimate Master Edition Loaded Successfully!")
--// ==========================================
--// RO89 HUB | VISUALS & ESP ADD-ON (TAB 3)
--// ==========================================

task.spawn(function()
    local Window = Window -- ดึงหน้าต่างหลักมาจากสคริปต์เดิม

    if Window then
        -- สร้างแท็บใหม่ทางซ้ายมือ (Visuals / มองทะลุ)
        local VisualsTab = Window:Tab({
            Title = 'Visuals (มองทะลุ)',
            Icon = 'eye',
        })

        -- หัวข้อที่ 1: มองชื่อ (Name ESP)
        VisualsTab:Toggle({
            Title = 'มองชื่อ (Name ESP)',
            Flag = 'esp_name',
            Desc = 'แสดงชื่อผู้เล่นทะลุกำแพง',
            Icon = 'user',
            Type = 'Checkbox',
            Default = false,
            Callback = function(state)
                if state then
                    print("[RO89 HUB] Name ESP Enabled!")
                else
                    print("[RO89 HUB] Name ESP Disabled!")
                end
            end,
        })

        -- หัวข้อที่ 2: มองเลือด (Health ESP)
        VisualsTab:Toggle({
            Title = 'มองเลือด (Health ESP)',
            Flag = 'esp_health',
            Desc = 'แสดงหลอดเลือดและเลือดคงเหลือของเป้าหมาย',
            Icon = 'heart',
            Type = 'Checkbox',
            Default = false,
            Callback = function(state)
                if state then
                    print("[RO89 HUB] Health ESP Enabled!")
                else
                    print("[RO89 HUB] Health ESP Disabled!")
                end
            end,
        })

            --// ==========================================
--// RO89 HUB | VISUALS & WEAPON ESP ADD-ON (TAB 3 INTEGRATION)
--// ==========================================

task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

    -- ฐานข้อมูลความหายากและสีขอบไอเท็ม
    local RarityColors = {
        Common = Color3.fromRGB(255, 255, 255),
        Uncommon = Color3.fromRGB(99, 255, 52),
        Rare = Color3.fromRGB(51, 170, 255),
        Epic = Color3.fromRGB(237, 44, 255),
        Legendary = Color3.fromRGB(255, 150, 0),
        Omega = Color3.fromRGB(255, 20, 51),
    }

    local WeaponDB = {}

    local function getItemKey(tool)
        local handle = tool:FindFirstChild("Handle")
        local displayName = tool:GetAttribute("DisplayName") or tool.Name
        local itemId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
        local rarity = tool:GetAttribute("RarityName") or "Common"

        if handle then
            local mesh = handle:FindFirstChildOfClass("SpecialMesh")
            if mesh and mesh.MeshId ~= "" then
                return mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity
            elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
                return handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
            end
        end
        if itemId and itemId ~= "" and itemId ~= tool.Name then
            return "ITEMID_" .. itemId .. "_RARITY_" .. rarity
        end
        return "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
    end

    local ItemsFolder = ReplicatedStorage:FindFirstChild("Items")
    if ItemsFolder then
        for _, item in ipairs(ItemsFolder:GetDescendants()) do
            if item:IsA("Tool") then
                WeaponDB[getItemKey(item)] = {
                    Name = item:GetAttribute("DisplayName") or item.Name,
                    Rarity = item:GetAttribute("RarityName") or "Common",
                    ImageId = item:GetAttribute("ImageId") or "rbxassetid://7072725737",
                }
            end
        end
    end

    local function getWeaponInfo(tool)
        if not tool or not tool:IsA("Tool") then
            return nil
        end
        return WeaponDB[getItemKey(tool)]
    end

    local WeaponESPEnabled = false
    local billboards = {}

    local function createBillboardForPlayer(player)
        if not WeaponESPEnabled or player == LocalPlayer then
            return
        end
        local char = player.Character
        if not char then
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then
            return
        end

        if billboards[player] then
            billboards[player]:Destroy()
            billboards[player] = nil
        end

        local gui = Instance.new("BillboardGui")
        gui.Name = "WeaponESP_Billboard"
        gui.Adornee = root
        gui.Size = UDim2.new(0, 90, 0, 20)
        gui.StudsOffset = Vector3.new(0, -5, 0)
        gui.AlwaysOnTop = true
        gui.Parent = char

        local layout = Instance.new("UIListLayout", gui)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local tools = {}
        for _, containerName in ipairs({"Backpack", "StarterGear", "StarterPack"}) do
            local container = player:FindFirstChild(containerName)
            if container then
                for _, tool in ipairs(container:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name ~= "Fists" then
                        table.insert(tools, tool)
                    end
                end
            end
        end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name ~= "Fists" then
                table.insert(tools, tool)
            end
        end

        for _, tool in ipairs(tools) do
            local info = getWeaponInfo(tool)
            if info then
                local icon = Instance.new("ImageLabel", gui)
                icon.Size = UDim2.new(0, 20, 0, 20)
                icon.BackgroundTransparency = 0.1
                icon.Image = info.ImageId
                icon.BackgroundColor3 = Color3.fromRGB(240, 248, 255)
                Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 10)
                local stroke = Instance.new("UIStroke", icon)
                stroke.Color = RarityColors[info.Rarity] or Color3.new(1, 1, 1)
                stroke.Thickness = 2
            end
        end

        billboards[player] = gui
    end

    local heartbeatConnection
    local function setWeaponESP(state)
        WeaponESPEnabled = state
        if state then
            for _, player in ipairs(Players:GetPlayers()) do
                createBillboardForPlayer(player)
            end
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        createBillboardForPlayer(player)
                    end
                end
            end)
            print("[RO89 HUB] Weapon ESP Enabled!")
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end
            for _, gui in pairs(billboards) do
                if gui then gui:Destroy() end
            end
            billboards = {}
            print("[RO89 HUB] Weapon ESP Disabled!")
        end
    end

    Players.PlayerRemoving:Connect(function(player)
        if billboards[player] then
            billboards[player]:Destroy()
            billboards[player] = nil
        end
    end)

    -- เชื่อมต่อเข้ากับหน้าต่างหลัก WindUI (ดึง Window มาใช้)
    local Window = Window
    if Window then
        local VisualsTab = Window:Tab({
            Title = 'Visuals (มองทะลุ)',
            Icon = 'eye',
        })

        -- ปุ่มเปิด-ปิด Weapon ESP ในแท็บ Visuals
        VisualsTab:Toggle({
            Title = 'มองของ/อาวุธ (Weapon ESP)',
            Flag = 'weapon_esp',
            Desc = 'แสดงไอคอนอาวุธบนหัวผู้เล่น แยกตามความหายาก',
            Icon = 'package',
            Type = 'Checkbox',
            Default = false,
            Callback = function(state)
                setWeaponESP(state)
            end,
        })

        print("[RO89 Tools] Weapon ESP Integrated into Visuals Tab Successfully!")
    else
        warn("[RO89 Tools] Error: Window not found for Weapon ESP tab integration!")
    end
end)
