include("shared.lua")

local matGlow = Material("sprites/glow04_noz")

function ENT:Draw()
	self:DrawModel()
	local lightpos = self:GetPos()
	local size = (CurTime() * 0.5 % 1) * 20
	render.SetMaterial(matGlow)
	render.DrawSprite(lightpos, size, size, COLOR_WHITE)
	render.DrawSprite(lightpos, 16,16, COLOR_WHITE)
end
