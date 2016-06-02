CLASS.Name = "Skirmisher"

CLASS.Health = 110
CLASS.BonusSpeed = 0

CLASS.LoadoutDescription = "+24 pistol ammo"

function CLASS:Loadout(pl)
	pl:GiveAmmo(GAMEMODE.AmmoCache["pistol"] or 24, "pistol", true)
	return true
end
