local player = game.Players.Localplayer
local character = player.Character or player.CharacterAdded:wait()

function teleportToOrbSpawns()
    local orbSpawns = workspace.GameAssets.GlobalAssets.OrbSpawns:GetChildren()

    for _, spawn in ipairs(orbSpawns) do
        if spawn:IsA("BasePart") then
            character:SetPrimaryPartCFrame(spawn.CFrame)
            wait(0.5) -- Đơik một chút trước khi teleport đến vị trí tiếp theo
        end
    end
end

teleportToOrbSpawns()