util.AddNetworkString("C4EnhancedOpenMenu")
util.AddNetworkString("C4EnhancedClickMenu")
util.AddNetworkString("C4EnhancedSet")
util.AddNetworkString("C4EnhancedArm")
util.AddNetworkString("C4EnhancedPickup")

local convarMin = GetConVar("c4_enhanced_mintimer")
local convarMax = GetConVar("c4_enhanced_maxtimer")

local function check(ent, ply)
	if not IsValid(ent) or ent:GetClass() != "ent_c4_enhanced" then
		return false
	end

	if ply:GetEyeTrace().Entity != ent then
		return false
	end

	if ent:IsArmed() then
		return false
	end

	return true
end

net.Receive("C4EnhancedClickMenu", function(_, ply)
	local ent = net.ReadEntity()

	if not check(ent, ply) then
		return
	end

	ent:EmitSound("weapons/c4_enhanced/key_press" .. math.random(1, 7) .. ".wav")
end)

net.Receive("C4EnhancedSet", function(_, ply)
	local ent = net.ReadEntity()

	if not check(ent, ply) then
		return
	end

	ent:SetTimer(math.Clamp(net.ReadUInt(12), convarMin:GetInt(), convarMax:GetInt()))
	ent:EmitSound("weapons/c4_enhanced/c4_beep2.wav")
end)

net.Receive("C4EnhancedArm", function(_, ply)
	local ent = net.ReadEntity()

	if not check(ent, ply) then
		return
	end

	ent:StartTimer(ply)
end)

net.Receive("C4EnhancedPickup", function(_, ply)
	local ent = net.ReadEntity()

	if not check(ent, ply) then
		return
	end

	ent:Remove()

	ply:EmitSound("weapons/c4_enhanced/c4_draw.wav")

	if ply:HasWeapon("weapon_c4_enhanced") then
		ply:GiveAmmo(1, "c4_enhanced")
	else
		ply:Give("weapon_c4_enhanced")
	end
end)
