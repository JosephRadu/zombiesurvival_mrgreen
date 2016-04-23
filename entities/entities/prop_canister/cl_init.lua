include('shared.lua')

ENT.SpawnTime = 0

function ENT:Initialize()
	self.SpawnTime = CurTime()
	self:DestroyShadow() 
end

function ENT:Draw()
	if self.SpawnTime + 5 < CurTime() then
		self:DrawModel()
		self:DrawShadow(true)
	end
end

