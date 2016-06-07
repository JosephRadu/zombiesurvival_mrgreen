AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.PrecacheSound("ambient/levels/canals/toxic_slime_sizzle1.wav")
util.PrecacheSound("ambient/levels/canals/toxic_slime_sizzle2.wav")
util.PrecacheSound("ambient/levels/canals/toxic_slime_sizzle3.wav")
util.PrecacheSound("ambient/levels/canals/toxic_slime_sizzle4.wav")

function ENT:Initialize()
	self.m_Health = 50
	self.IgnorePickupCount = self.IgnorePickupCount or false
	self.Forced = self.Forced or false
	self.NeverRemove = self.NeverRemove or false
	self.IgnoreUse = self.IgnoreUse or false
	
	self.Created = CurTime()

	self:SetUseType(SIMPLE_USE)
	
	self:SetModel("models/props_junk/glassjug01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS   )	
	--self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(80,85,100))

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
	
		if activator:GetResource("ichor") == LIMIT_ICHOR then
			return	
		end
		activator:GiveResource("ichor")
		activator:CenterNotify(COLOR_GREEN, {font = "ZSHUDFont"}, "+1 Ichor")
		
		self:EmitSound("ambient/levels/canals/toxic_slime_sizzle"..math.random(1,4)..".wav")	
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