if not getgenv().EnableTeleport then return end
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- ĐẾM NGƯỜI TRONG 1 ZONE
local function getPlayerCountInZone(zoneName)
    local zone = workspace:WaitForChild("PartyZones", 10):FindFirstChild(zoneName)
    if not zone then return math.huge end
    local hitbox = zone:FindFirstChild("Hitbox")
    if not hitbox then return math.huge end

    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and (hrp.Position - hitbox.Position).Magnitude <= 15 then
            count += 1
        end
    end
    return count
end

-- TELEPORT ĐẾN ZONE
local function teleportTo(zoneName)
    local zone = workspace:WaitForChild("PartyZones", 10):FindFirstChild(zoneName)
    if not zone then return end
    local hitbox = zone:FindFirstChild("Hitbox")
    if not hitbox then return end

    local hrp = getHRP()
    if hrp then
        hrp.CFrame = CFrame.new(hitbox.Position + Vector3.new(0, getgenv().YOffset or 5, 0))
        print("[✅ Teleported to]:", zoneName)
    end
end

-- KIỂM TRA XEM CÓ ĐANG Ở TRONG ZONE NÀO ĐÓ KHÔNG
local function isInZone(zoneName)
    local zone = workspace:WaitForChild("PartyZones", 10):FindFirstChild(zoneName)
    if not zone then return false end
    local hitbox = zone:FindFirstChild("Hitbox")
    if not hitbox then return false end

    local hrp = getHRP()
    if not hrp then return false end

    return (hrp.Position - hitbox.Position).Magnitude <= 15
end

-- KIỂM TRA VÀ TELEPORT
task.spawn(function()
    local zoneList = {}

    for zoneName, _ in pairs(getgenv().TargetPlayersPerZone) do
        table.insert(zoneList, zoneName)
    end
    table.sort(zoneList, function(a, b) return a < b end) -- Sort nếu cần

    while getgenv().EnableTeleport do
        local hasTeleported = false

        for _, zoneName in ipairs(zoneList) do
            local target = getgenv().TargetPlayersPerZone[zoneName]
            local current = getPlayerCountInZone(zoneName)

            print(string.format("[%s] %d / %d", zoneName, current, target))

            if current < target then
                if not isInZone(zoneName) then
                    teleportTo(zoneName)
                    hasTeleported = true
                end
                break
            end
        end

        if not hasTeleported then
            print("[🕒 Waiting for empty slot...]")
        end

        task.wait(getgenv().TeleportInterval or 5)
    end
end)
