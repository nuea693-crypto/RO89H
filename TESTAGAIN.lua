--// ==========================================
--// RO89 HUB | ULTIMATE MASTER EDITION (FULL 100% NO CUT)
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

print("[RO89 HUB] Ultimate Master Edition Loaded Successfully!")
--// ==========================================
--// RO89 HUB | ULTIMATE MASTER EDITION (FULL 100% NO CUT)
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


--// ==========================================
--// RO89 HUB | CHARACTER TAB MODULE (FULL FEATURES)
--// ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- สมมติว่า Window คือตัวแปรหน้าต่าง WindUI ของมึง
local CharacterTab = Window:Tab({
    Title = 'Character',
    Icon = 'user',
})

-- 1. ระบบกันล็อค (Anti-Lock)
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
                randomOffset = Vector3.new(math.random(-35, 35)/10, math.random(-20, 30)/10, math.random(-35, 35)/10)
            end
            pcall(function() humanoidRootPart.CFrame = humanoidRootPart.CFrame + randomOffset end)
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

-- 2. ระบบ Infinite Stamina
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

-- 3. ระบบ Walk Speed
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild('Humanoid')
local SpeedAmount = 35
local EnabledSpeed = false

local SprintModuleRef = nil
pcall(function()
    SprintModuleRef = require(ReplicatedStorage:WaitForChild('Modules'):WaitForChild('Game'):WaitForChild('Sprint'))
end)

local function speedConfig()
    return {
        SpeedModifies = EnabledSpeed,
        SpeedAmount = SpeedAmount,
    }
end

task.spawn(function()
    while task.wait(0.1) do
        if Humanoid and Humanoid.Parent then
            if speedConfig().SpeedModifies then
                pcall(function()
                    local net = require(ReplicatedStorage:WaitForChild('Modules'):WaitForChild('Core'):WaitForChild('Net'))
                    net.send('set_sprinting_1', true)
                    if SprintModuleRef and SprintModuleRef.sprinting then
                        SprintModuleRef.sprinting.set(true)
                    end
                    Humanoid:SetAttribute('TargetWalkSpeed', speedConfig().SpeedAmount)
                    Humanoid.WalkSpeed = speedConfig().SpeedAmount
                end)
            else
                pcall(function()
                    Humanoid:SetAttribute('TargetWalkSpeed', 8)
                    Humanoid.WalkSpeed = 8
                end)
            end
        end
    end
end)

CharacterTab:Toggle({
    Title = 'Walk Speed',
    Flag = 'walk_speed_toggle',
    Icon = 'footprints',
    Type = 'Checkbox',
    Default = false,
    Callback = function(Value)
        EnabledSpeed = Value
    end,
})

CharacterTab:Slider({
    Title = 'Speed Value',
    Flag = 'speed_value',
    Step = 1,
    Value = {
        Min = 8,
        Max = 45,
        Default = SpeedAmount,
    },
    Callback = function(Value)
        SpeedAmount = Value
        if Humanoid and EnabledSpeed then
            Humanoid.WalkSpeed = Value
        end
    end,
})

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild('Humanoid')
end)

print("[RO89 HUB] Character Tab Loaded Successfully!")
