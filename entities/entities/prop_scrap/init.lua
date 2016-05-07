AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")

function ENT:Initialize()
	self.m_Health = 50
	self.IgnorePickupCount = self.IgnorePickupCount or false
	self.Forced = self.Forced or false
	self.NeverRemove = self.NeverRemove or false
	self.IgnoreUse = self.IgnoreUse or false

	self:SetUseType(SIMPLE_USE)
	
	self:SetModel("models/weapons/w_bugbait.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS   )	
	self:SetMaterial("models/debug/debugwhite")

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(2)
		phys:SetVelocity(Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200)))
	end
	
	self:ItemCreated()
end

function ENT:Use(activator, caller)
	if self.IgnoreUse then return end
	
	if activator:GetScrap() == LIMIT_SCRAP then
		activator:AddPoints(1)	
	else
		activator:GiveScrap(1)
	end
		self:EmitSound("physics/metal/metal_grenade_impact_hard"..math.random(1,2)..".wav" )	
	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	if self.NeverRemove then return end
	self:TakePhysicsDamage(dmginfo)
	self.m_Health = self.m_Health - dmginfo:GetDamage()
	if self.m_Health <= 0 then
		self:RemoveNextFrame()
	end
end
