--<|> Important <|>--
local Important = {
    ["Active"] = false,
    ["AntiAnchor"] = true,
    ["AntiFling"] = true,
    ["Barrage"] = false,
    ["LoadedAnimations"] = {},
    ["Stand"] = "Star Platinum",
    ["Summoned"] = false,
    ["Whitelist"] = game.HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/theplantman/Stand-Master/main/Whitelisted.json")),
    ["Whitelisted"] = false
}
function Important:GetDiscord()
    for Index, String in pairs(Important["Whitelist"]) do
        if Important["Eid"] and Index == Important["Eid"] then
            return String
        end
    end
end
function Important:CheckCharacter(Character)
    if Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health ~= 0 and Character:FindFirstChild("HumanoidRootPart") then
        return true
    end
end
function Important:Magnitude(Position, Range, Visualize)
    local Players = {}
    if Important:CheckCharacter(game.Players.LocalPlayer.Character) then
        local Hitbox = Instance.new("Part")
        Hitbox.Parent = game.Workspace
        Hitbox.Anchored = true
        Hitbox.Size = Vector3.new(Range or 15, Range or 15, Range or 15)
        Hitbox.CanCollide = false
        Hitbox.CastShadow = false
        Hitbox.Position = Position or game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        Hitbox.BrickColor = BrickColor.new("Really red")
        Hitbox.Material = Enum.Material.ForceField
        Hitbox.Shape = Enum.PartType.Ball
        game.Debris:AddItem(Hitbox, 0.5)
        if not Visualize then
            Hitbox.Transparency = 1
        end
        for Index, Model in pairs(game.Workspace.Entities:GetChildren()) do
            if Model ~= game.Players.LocalPlayer.Character and Important:CheckCharacter(Player) and (Hitbox.Position - Model.HumanoidRootPart.Position).Magnitude <= Hitbox.Size.X / 2 then
                Players[Model] = Model
            end
        end
    end
    return Players
end
function Important:GetStandScript()
    if Important:CheckCharacter(game.Players.LocalPlayer.Character) then
        local function Check(String, Type)
            if Type == "Whitelisted" then
                local WhitelistedLocalScripts = {
                    "Clean&Misc.",
                    "MrPresidentAnimation",
                    "clientTS",
                    "DimensionLighting",
                    "QualityScript",
                    "Animate",
                    "UnStun",
                    "DismAnimation",
                    "SP3_Effect",
                }
                for Index, LocalScript in pairs(WhitelistedLocalScripts) do
                    if LocalScript == String then
                        return true
                    end
                end
            else
                for Index, LocalScript in pairs(game.Lighting:GetChildren()) do
                    if LocalScript.ClassName == "LocalScript" and LocalScript.Name == String then
                        return LocalScript.Name
                    end
                end
            end
        end
        for Index, LocalScript in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if LocalScript.ClassName == "LocalScript" and not Check(LocalScript.Name, "Whitelisted") and Check(LocalScript.Name, "LocalScript") then
                return game.Players.LocalPlayer.Character[Check(LocalScript.Name, "LocalScript")]
            end
        end
    end
end
function Important:OnSpawn()
    if Important:CheckCharacter(game.Players.LocalPlayer.Character) and Important:GetScript() then
        Important:GetStandScript().Disabled = true
        game.ReplicatedStorage.BurnDamage:FireServer(game.Players.LocalPlayer.Character.Humanoid, CFrame.new(), 0 * math.huge, 0, Vector3.new(), "rbxassetid://241837157", 0, Color3.new(), "", 0, 0)
        for Index, Unknown in pairs(game.Players.LocalPlayer.Character.Stand:GetDescendants()) do
            if Unknown.Name ~= "StandHumanoidRootPart" and Unknown.ClassName:match("Part") and Unknown ~= "ParticleEmitter" or Unknown.ClassName == "UnionOperation" or Unknown.ClassName == "Decal" or Unknown.ClassName == "Texture" then
                game.ReplicatedStorage.Transparency:FireServer(Unknown, 1)
            end
        end
    end
end
function Important:InputToString(GameProccessed, Input)
    local StringInput
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        StringInput = "LMB"
    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
        StringInput = "RMB"
    else
        StringInput = Input.KeyCode.Name
    end
    if not GameProccessed and StringInput then
        return StringInput
    end
end
function Important:LoadAnimation(Id, Name)
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://" .. Id
    local Loaded = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Animation)
    if Important["LoadedAnimations"][Name] then
        Important["LoadedAnimations"][Name]:Stop()
    end
    Important["LoadedAnimations"][Name] = Loaded
    return Loaded
end
return Important
