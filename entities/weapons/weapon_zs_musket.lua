AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Musket"
	SWEP.Description = ""
	SWEP.Slot = 3
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false

	SWEP.ViewModelBoneMods = {
		["v_weapon.scout_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	
	SWEP.VElements = {
		["Musket5+"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(-0.593, -0.166, 2.266), angle = Angle(-26.39, -91.479, -180), size = Vector(0.606, 0.611, 0.356), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Musket"] = { type = "Model", model = "models/props_phx/construct/wood/wood_boardx1.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(-0.639, -2.669, -11.393), angle = Angle(-90.265, -1.737, 1.827), size = Vector(0.398, 0.342, 0.34), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Musket3"] = { type = "Model", model = "models/props_phx/gears/bevel12.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(-0.058, -2.794, -1.846), angle = Angle(-180, 0, -180), size = Vector(0.172, 0.172, 0.172), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/items/w_grenadesheet", skin = 0, bodygroup = {} },
		["MusketBolt"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "v_weapon.scout_Bolt", rel = "", pos = Vector(-0.949, 0.832, -2.416), angle = Angle(-180, 104.464, 4.921), size = Vector(0.358, 0.351, 0.389), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Musket4"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(0.086, -1.818, -15.693), angle = Angle(-94.935, -56.438, 42.4), size = Vector(0.56, 0.237, 0.212), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/items/w_grenadesheet", skin = 0, bodygroup = {} },
		["Musket3+"] = { type = "Model", model = "models/Mechanics/gears2/pinion_20t1.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(-0.087, -3.056, 0.018), angle = Angle(-119.059, -94.483, 86.836), size = Vector(0.078, 0.165, 0.071), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/items/w_grenadesheet", skin = 0, bodygroup = {} },
		["MusketMag"] = { type = "Model", model = "models/props_interiors/Radiator01a.mdl", bone = "v_weapon.scout_Clip", rel = "", pos = Vector(-0.125, -0.255, 0.319), angle = Angle(0, 0.72, 0), size = Vector(0.082, 0.032, 0.082), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/onfire", skin = 0, bodygroup = {} },
		["Musket2"] = { type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(0.006, -3.369, -12.969), angle = Angle(-180, -180, 0.101), size = Vector(0.5, 0.5, 1.784), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Musket5"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "v_weapon.scout_Parent", rel = "", pos = Vector(0.01, -3.342, -17.098), angle = Angle(0, -91.479, -180), size = Vector(0.5, 0.335, 0.981), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["Musket4"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.309, 0.221, -4.253), angle = Angle(0, 0, 0), size = Vector(0.56, 0.237, 0.212), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/items/w_grenadesheet", skin = 0, bodygroup = {} },
		["Musket5+"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.05, 0.97, -2.174), angle = Angle(93.925, 180, 2.303), size = Vector(0.815, 1.343, 0.61), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Musket5"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.535, 0.505, -4.665), angle = Angle(94.612, 179.673, 2.286), size = Vector(0.5, 0.419, 0.93), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Musket2"] = { type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.555, 0.245, -5.502), angle = Angle(87.372, 0, 0), size = Vector(0.5, 0.708, 1.784), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Musket"] = { type = "Model", model = "models/props_phx/construct/wood/wood_boardx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.029, 0.957, -4.694), angle = Angle(-3.567, -1.193, -78.295), size = Vector(0.398, 0.386, 0.476), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}	
	
	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(1.75, 1, -5)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"
SWEP.ViewModel			= "models/weapons/cstrike/c_snip_scout.mdl"

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("weapons/scout/scout_fire-1.wav")
SWEP.Primary.Damage = 100
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.ReloadDelay = 0.4
SWEP.UseHands = true
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 10

SWEP.ConeMax = 0.1
SWEP.ConeMin = 0.015

SWEP.WalkSpeed = SPEED_SLOW

SWEP.IronSightsPos = Vector(-6.72, -10.947, 3.599)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 120, 85)
end

