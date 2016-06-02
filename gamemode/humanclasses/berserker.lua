CLASS.Name = "Berserker"

CLASS.Health = 125
CLASS.BonusSpeed = 5

CLASS.LoadoutDescription = "Regenerative\n+24 pistol ammo"

function CLASS:Loadout(pl)
	pl:GiveAmmo(GAMEMODE.AmmoCache["pistol"] or 24, "pistol", true)
	pl.BuffRegenerative = true
	return true
end
