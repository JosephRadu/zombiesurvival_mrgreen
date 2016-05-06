AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.CleanupPriority = 2

util.PrecacheSound("items/gift_pickup.wav")

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
		phys:SetVelocity(Vector(math.Rand(-300,300),math.Rand(-300,300),math.Rand(-300,300)))
	end
	
	self:ItemCreated()
end

function ENT:Use(activator, caller)
	if self.IgnoreUse then return end
	
	if activator:GetScrap() == LIMIT_SCRAP then
	
		self:EmitSound("items/gift_pickup.wav" )
		activator:AddPoints(1)	
	else
		self:EmitSound("items/gift_pickup.wav" )
		activator:GiveScrap(1)
	end
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
