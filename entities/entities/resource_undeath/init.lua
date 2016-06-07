AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.PrecacheSound("ambient/levels/prison/inside_battle_zombie1.wav")
util.PrecacheSound("ambient/levels/prison/inside_battle_zombie2.wav")
util.PrecacheSound("ambient/levels/prison/inside_battle_zombie3.wav")

function ENT:Initialize()
	self.m_Health = 50
	self.IgnorePickupCount = self.IgnorePickupCount or false
	self.Forced = self.Forced or false
	self.NeverRemove = self.NeverRemove or false
	self.IgnoreUse = self.IgnoreUse or false
	self.Created = CurTime()
	self:SetUseType(SIMPLE_USE)
	
	self:SetModel("models/props/cs_italy/orange.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS   )	
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(COLOR_GREEN)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(4)
		phys:SetVelocity(Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200)))
	end
	
	self:ItemCreated()
end

function ENT:Use(activator, caller)
	if self.IgnoreUse then return end
	
	if activator:GetResource("undeath") == LIMIT_UNDEATH then
		return	
	end
	activator:CenterNotify(Color(120, 130, 245), {font = "ZSHUDFont"}, "+1 Essence of undeath")
	activator:GiveResource("undeath")

	self:EmitSound("ambient/levels/prison/inside_battle_zombie"..math.random(1,3)..".wav" )	
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
	if self.Created + 40 < CurTime() then
		self:Remove()
	end
end