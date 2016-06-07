include("shared.lua")

local matGlow = Material("sprites/glow04_noz")

function ENT:Draw()
	self:DrawModel()
	local lightpos = self:GetPos() + self:GetUp() * 4
	local size = (CurTime() * 0.2 % 1) * 20
	render.SetMaterial(matGlow)
	render.DrawSprite(lightpos, size, size, Color(100,230,80))
	render.DrawSprite(lightpos, 16,16, Color(100,230,80))
end
