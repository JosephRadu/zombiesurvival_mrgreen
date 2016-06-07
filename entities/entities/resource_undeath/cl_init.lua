include("shared.lua")

local matGlow = Material("sprites/glow04_noz")

function ENT:Draw()
	self:DrawModel()
	local lightpos = self:GetPos()
	local size = (CurTime() * 100 % 1) * 30
	render.SetMaterial(matGlow)
	render.DrawSprite(lightpos, size, size, COLOR_GREEN)
	render.DrawSprite(lightpos, 20,20, COLOR_GREEN)
end

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
end

function ENT:Think()
	self.NextPuff = self.NextPuff or 0

	if self.NextPuff < CurTime() then
		local emitter = self.Emitter
		local pos = self:GetPos()
		emitter:SetPos(pos)

		local particle = emitter:Add("zombiesurvival/horderally", pos)
		particle:SetVelocity(VectorRand():GetNormal() * 4 + vector_up * 8)
		particle:SetDieTime(3)
		particle:SetEndAlpha(0)
		particle:SetStartAlpha(200)		
		particle:SetStartSize(2)
		particle:SetEndSize(5)
		particle:SetColor(10, 120, 30)
		self.NextPuff = CurTime() + 1
	end
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self:GetPos()
		dlight.r = 10
		dlight.g = 120
		dlight.b = 30
		dlight.Brightness = 1
		dlight.Size = 64
		dlight.Decay = 1
		dlight.DieTime = CurTime() + 1
		dlight.Style = 1
	end
	
end

function ENT:OnRemove()
	self.Emitter:Finish()
end