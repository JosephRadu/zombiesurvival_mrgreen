AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Defender' Assault Rifle"
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.VElements = {
		["4"] = { type = "Model", model = "models/props_junk/ravenholmsign.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.801, -4.5, 0), angle = Angle(0, -8.183, 75.973), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -6, -2), angle = Angle(90, 180, 0), size = Vector(0.5, 0.6, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["5"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "v_weapon.AK47_Bolt", rel = "", pos = Vector(-0.519, 0, -2.597), angle = Angle(0, 90, 0), size = Vector(0.2, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["barrel+"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -4, -14), angle = Angle(90, -57.273, 12.857), size = Vector(0.6, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["barrel"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -4.2, -18.182), angle = Angle(0, 0, 87.662), size = Vector(0.6, 1.728, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["7"] = { type = "Model", model = "models/props_c17/pulleywheels_small01.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -4.676, 1.557), angle = Angle(0, 90, 0), size = Vector(0.2, 0.2, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["2"] = { type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -4, -5.715), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["6"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.AK47_Bolt", rel = "", pos = Vector(0, 0, -3.636), angle = Angle(0, 0, 0), size = Vector(0.05, 0.05, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["3"] = { type = "Model", model = "models/props_phx/construct/wood/wood_boardx1.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.7, -4, 0), angle = Angle(-90, 0, 0), size = Vector(0.1, 0.3, 0.1), color = Color(200, 170, 148, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
		["1+"] = { type = "Model", model = "models/props_c17/pulleywheels_small01.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1, -1.558, -3.636), angle = Angle(-15.195, 90, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1, -4.676, 7.791), angle = Angle(80.649, 90, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["1++"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1, -6.901, 23), angle = Angle(180, 0, 101.688), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.HUD3DBone = "v_weapon.AK47_Parent"
	SWEP.HUD3DPos = Vector(-1, -4.5, -4)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_AK47.Clipout")
SWEP.Primary.Sound			= Sound("weapons/ak47/ak47-1.wav")
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.11

SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.06
SWEP.ConeMin = 0.04

SWEP.WalkSpeed = (SPEED_SLOW + 6)

SWEP.IronSightsPos = Vector(-6.6, 20, 3.1)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(110,115))
end
