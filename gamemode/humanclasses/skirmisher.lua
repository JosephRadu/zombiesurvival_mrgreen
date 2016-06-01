CLASS.Name = "Skirmisher"

CLASS.Health = 110
CLASS.BonusSpeed = 0

CLASS.CallBack = function(pl)
	pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 3, "buckshot", true)
end