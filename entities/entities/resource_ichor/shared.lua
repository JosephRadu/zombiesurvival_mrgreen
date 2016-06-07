ENT.Type = "anim"

function ENT:HumanHoldable(pl)
	return pl:KeyDown(GAMEMODE.UtilityKey)
end
ENT.Created = 0