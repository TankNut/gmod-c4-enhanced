AddCSLuaFile()

if CLIENT then
	language.Add("c4_enhanced_ammo", "Plastic Explosives")
end

game.AddAmmoType({name = "c4_enhanced", maxcarry = 5})

SWEP.PrintName = "C4"
SWEP.Author = "TankNut"
SWEP.Instructions = [[Left Click: Plant C4
Use key: Interact with planted C4

You can only plant C4 on a solid surface.]]

SWEP.ViewModel = Model("models/weapons/cstrike/c_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")

SWEP.UseHands = true

SWEP.Spawnable = true

SWEP.Primary.Ammo = "c4_enhanced"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false

function SWEP:PrimaryAttack()
	if SERVER then
		local ply = self:GetOwner()

		local tr = util.TraceLine({
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 75,
			filter = {ply},
			mask = MASK_SOLID
		})

		if not tr.Hit or not tr.HitWorld then
			return
		end

		local ang = tr.HitNormal:Angle()

		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(tr.HitNormal, 180)

		local dot = tr.HitNormal:Dot(Vector(0, 0, 1))

		if dot == 1 or dot == -1 then
			ang.y = ply:EyeAngles().y
		end

		local ent = ents.Create("ent_c4_enhanced")

		ent:SetPos(tr.HitPos)
		ent:SetAngles(ang)
		ent:Spawn()
		ent:Activate()

		ply:EmitSound("weapons/c4_enhanced/c4_plant_quiet.wav")

		self:TakePrimaryAmmo(1)

		if ply:GetAmmoCount(self.Primary.Ammo) < 1 then
			ply:StripWeapon(self:GetClass())
		end
	end
end

function SWEP:SecondaryAttack()
end

local holdtype = {
	[ACT_MP_STAND_IDLE]					= ACT_HL2MP_IDLE_SLAM,
	[ACT_MP_WALK]						= ACT_HL2MP_WALK_SLAM,
	[ACT_MP_RUN]						= ACT_HL2MP_RUN_SLAM,
	[ACT_MP_CROUCH_IDLE]				= ACT_HL2MP_IDLE_CROUCH_PISTOL,
	[ACT_MP_CROUCHWALK]					= ACT_HL2MP_WALK_CROUCH_PISTOL,
	[ACT_MP_ATTACK_STAND_PRIMARYFIRE]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM,
	[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM,
	[ACT_MP_JUMP]						= ACT_HL2MP_JUMP_SLAM,
	[ACT_RANGE_ATTACK1]					= ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM,
	[ACT_MP_SWIM]						= ACT_HL2MP_SWIM_SLAM
}

function SWEP:TranslateActivity(act)
	return holdtype[act] or -1
end

if CLIENT then
	function SWEP:GetViewModelPosition(pos, ang)
		return LocalToWorld(Vector(-5, -1, -1), Angle(), pos, ang)
	end
end
