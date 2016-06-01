CLASS.Name = "Carpenter"

CLASS.Health = 120
CLASS.BonusSpeed = -10

CLASS.CallBack = function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 3, "buckshot", true) end