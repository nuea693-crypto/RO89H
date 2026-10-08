--// ==========================================
--// RO89 HUB | ULTIMATE COMBAT EDITION (WINDUI)
--// ==========================================

-- โหลด WindUI Library และสร้างหน้าต่างหลักอัตโนมัติ (ป้องกัน Error กรณีไม่ได้สร้างมาก่อน)
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "RO89 HUB | แจกดีมั้ยพี่ๆ🔫💸",
    Icon = "crosshair",
    Author = "RO89",
    Folder = "RO89Hub",
    Size = UDim2.fromOffset(550, 400),
})

local CombatTab = Window:Tab({
    Title = 'Combat',
    Icon = 'swords',
})

local FOVRadius = 120
local SilentAimEnabled = false
local ShowFOVEnabled = false
local CurrentTarget = nil
local UseSmartPredict = true
local TargetMode = 'Head'
local VelocityThreshold = 250

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
    Tracer.Color = Color3.fromRGB(124, 252, 0)
    Tracer.Transparency = 1
    Tracer.Visible = false

    TargetHeadCircle = Drawing.new('Circle')
    TargetHeadCircle.Color = Color3.fromRGB(255, 250, 250)
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
    FOVStroke.Color = Color3.fromRGB(124, 252, 0)
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
    TracerFrame.BackgroundColor3 = Color3.fromRGB(124, 252, 0)
    TracerFrame.BorderSizePixel = 0
    TracerFrame.AnchorPoint = Vector2.new(0, 0.5)
    TracerFrame.Size = UDim2.new(0, 0, 0, 2)
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
    TargetCircleFrame.Size = UDim2.new(0, 30, 0, 30)
    TargetCircleFrame.Visible = false
    TargetCircleFrame.Parent = TargetCircleGui

    local TargetStroke = Instance.new('UIStroke')
    TargetStroke.Color = Color3.fromRGB(255, 250, 250)
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
    if #TargetHistory[player] > 8 then table.remove(TargetHistory[player], 1) end

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

    if UseSmartPredict and VelocitySpikes[player] and VelocitySpikes[player].isAntiLock then
        local velocities = {}
        for i = 2, #history do
            local dt = history[i].time - history[i - 1].time
            if dt > 0 then
                table.insert(velocities, (history[i].pos - history[i - 1].pos) / dt)
            end
        end
        if #velocities > 0 then
            table.sort(velocities, function(a, b) return a.Magnitude < b.Magnitude end)
            return velocities[math.ceil(#velocities / 2)]
        end
    end

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
            return ping and ping / 1000 or 0.2
        end
    end
    return 0.2
end

local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild('Head') then
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChild('Humanoid')
            local isDead = humanoid and humanoid.Health <= 0

            if not isDead then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local screenPos = Vector2.new(pos.X, pos.Y)
                    local distFromCenter = (screenPos - center).Magnitude

                    if distFromCenter <= FOVRadius then
                        local distance3D = (head.Position - LocalPlayer.Character.Head.Position).Magnitude
                        if distance3D < shortestDistance then
                            shortestDistance = distance3D
                            closest = player
                        end
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

local function predictPosition(targetPart, character)
    local ping = getPing()
    local hrp = character:FindFirstChild('HumanoidRootPart')
    local player = Players:GetPlayerFromCharacter(character)

    if UseSmartPredict and player and TargetHistory[player] then
        local avgVel = getAverageVelocity(player)
        if VelocitySpikes[player] and VelocitySpikes[player].isAntiLock then
            return targetPart.Position + (avgVel * ping * 0.75)
        else
            return targetPart.Position + (avgVel * ping * 1.45)
        end
    else
        local velocity = hrp and (hrp.AssemblyLinearVelocity or hrp.Velocity) or Vector3.zero
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
        local myHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Head')

        if targetPart and myHead then
            local myScreenPos, myOnScreen = Camera:WorldToViewportPoint(myHead.Position)
            local targetScreenPos, targetOnScreen = Camera:WorldToViewportPoint(targetPart.Position)

            if targetOnScreen then
                if not IsMobile then
                    Tracer.Visible = true
                    Tracer.From = Vector2.new(myScreenPos.X, myScreenPos.Y)
                    Tracer.To = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                    TargetHeadCircle.Visible = true
                    TargetHeadCircle.Position = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                else
                    if TracerFrame then
                        local dx, dy = targetScreenPos.X - myScreenPos.X, targetScreenPos.Y - myScreenPos.Y
                        TracerFrame.Size = UDim2.new(0, math.sqrt(dx * dx + dy * dy), 0, 2)
                        TracerFrame.Position = UDim2.new(0, myScreenPos.X, 0, myScreenPos.Y)
                        TracerFrame.Rotation = math.deg(math.atan2(dx, dy))
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

-- UI Toggles & Sliders
CombatTab:Toggle({
    Title = 'Silent Aim',
    Flag = 'silent aim',
    Desc = 'Auto aim to target with Smart Prediction',
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
        FOVRadius = tonumber(value) or 120
        if IsMobile and FOVCircleFrame then
            FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
        end
    end,
})

CombatTab:Slider({
    Title = 'Velocity Threshold',
    Flag = 'velocity_threshold',
    Step = 10,
    Value = {Min = 100, Max = 500, Default = VelocityThreshold},
    Callback = function(value) VelocityThreshold = tonumber(value) or 250 end,
})

print("[RO89 HUB] Combat Tab & Ultra Smart Silent Aim Loaded Successfully!")
