include("shared.lua")

local matGlow = Material("sprites/glow04_noz")

function ENT:Draw()
	self:DrawModel()
	local lightpos = self:GetPos()
	local size = (CurTime() * 0.4 % 1) * 40
	render.SetMaterial(matGlow)
	render.DrawSprite(lightpos, size, size, Color(20,100,80))
	render.DrawSprite(lightpos, 20,20, Color(20,100,80))
end
