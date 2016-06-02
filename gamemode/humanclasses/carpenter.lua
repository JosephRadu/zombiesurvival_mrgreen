CLASS.Name = "Carpenter"

CLASS.Health = 120
CLASS.BonusSpeed = -10

CLASS.LoadoutDescription = "Muscular\n+8 buckshot ammo"

function CLASS:Loadout(pl)
	pl:GiveAmmo(GAMEMODE.AmmoCache["buckshot"] or 8, "buckshot", true)
	pl.BuffMuscular = true
	pl:DoMuscularBones()
	return true
end
