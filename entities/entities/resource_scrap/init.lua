AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.PrecacheSound("physics/metal/metal_popcan_impact_hard1.wav")
util.PrecacheSound("physics/metal/metal_popcan_impact_hard2.wav")
util.PrecacheSound("physics/metal/metal_popcan_impact_hard3.wav")

function ENT:Initialize()
	self.m_Health = 50
	self.IgnorePickupCount = self.IgnorePickupCount or false
	self.Forced = self.Forced or false
	self.NeverRemove = self.NeverRemove or false
	self.IgnoreUse = self.IgnoreUse or false
	self.Created = CurTime()
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
	
	if activator:GetResource("scrap") == LIMIT_SCRAP then
		return	
	else
		activator:CenterNotify(Color(245, 245, 245), {font = "ZSHUDFont"}, "+1 Scrap")
		activator:GiveResource("scrap")
	end 
		self:EmitSound("physics/metal/metal_popcan_impact_hard"..math.random(1,3)..".wav" )	
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

function ENT:Think()
	if self.Created + 20 < CurTime() then
		self:Remove()
	end
end