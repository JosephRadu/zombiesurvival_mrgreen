include("shared.lua")

local matGlow = Material("sprites/glow04_noz")
local colBlue = Color(100, 100, 255)

function ENT:Draw()
	self:DrawModel()
	local lightpos = self:GetPos() + self:GetUp() * 8 - self:GetRight() * 2
	local size = (CurTime() * 600 % 1) * 800
	render.SetMaterial(matGlow)
	render.DrawSprite(lightpos, size, size, COLOR_RED)
	render.DrawSprite(lightpos, size / 4, size / 4, COLOR_DARKRED)
end

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.BurnSound = CreateSound( self, "Weapon_FlareGun.Burn" )  
end


function ENT:Think()
	
	if self.BurnSound then
		self.BurnSound:PlayEx(1, 85 + math.sin(RealTime())*5) 
	end
	
	self.NextPuff = self.NextPuff or 0

	if self.NextPuff < CurTime() then
		local emitter = self.Emitter
		local pos = self:GetPos()
		emitter:SetPos(pos)

		local particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(VectorRand():GetNormal() * math.Rand(6, 12) +vector_up * math.random(3,6))
		particle:SetDieTime(math.Rand(2, 3))
		particle:SetStartAlpha(math.Rand(200, 220))
		particle:SetEndAlpha(0)
		particle:SetStartAlpha(100)		
		particle:SetStartSize(1)
		particle:SetEndSize(math.Rand(120, 150))
		particle:SetRoll(math.Rand(-20, 20))
		particle:SetColor(255, 20, 20)
		self.NextPuff = CurTime() + 0.1
	end
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self:GetPos()
		dlight.r = 255
		dlight.g = 20
		dlight.b = 20
		dlight.Brightness = 5
		dlight.Size = 128
		dlight.Decay = 1
		dlight.DieTime = CurTime() + 1
		dlight.Style = 0
	end
	
end

function ENT:OnRemove()
	self.Emitter:Finish()
	if self.BurnSound then
		self.BurnSound:Stop() 
	end
end
