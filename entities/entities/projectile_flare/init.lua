AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local ShootSoundFire = Sound( "Airboat.FireGunHeavy" )
local ShootSoundFail = Sound( "WallHealth.Deny" )
local YawIncrement = 20
local PitchIncrement = 10

ENT.dropPossible = true
ENT.skyHit = false
ENT.descending = false
ENT.supplyCalled = false

function ENT:Initialize()
	self.DieTime = CurTime() + 24
	self:SetModel("models/weapons/w_grenade.mdl")
	self:PhysicsInit(SOLID_VPHYSICS )
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMaterial("models/debug/debugwhite")
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(1.5)
		phys:SetMaterial("metal")
	end
	
	if LAST_CANISTER_DROP + 60 > CurTime() then
		self.dropPossible = false
	end
end

function ENT:Think()

	if self.DieTime < CurTime() then
		self.Entity:Remove()
		return
	end
	
	if not self.descending then 
		if self:GetVelocity().z < -230 then
			self.descending = true
		end
	end
	
	if self.descending then
		local phys = self:GetPhysicsObject()
		phys:SetVelocity(Vector(0,0,-150))
	end
	
	if not self.skyHit then return end
	
	if self.supplyCalled then return end
	
	if not self.dropPossible then return end
	
	if self.DieTime - 2 - math.random(6,8) < CurTime() then
		self.supplyCalled = true
	else return end
	
	LAST_CANISTER_DROP = CurTime()
	
	local tr = util.TraceLine( {
	start = self:GetPos(),
	endpos = self:GetPos() - Vector(0,0,10000),
	filter = function( ent ) end
	} )
		
	if (SERVER) then
		local aBasePos = tr.HitPos
		local ent = ents.Create( "env_headcrabcanister" )
		ent:SetPos( aBasePos )
		ent:SetAngles( Angle(math.random(255,285),math.random(-10,10),0) )
		ent:SetKeyValue( "HeadcrabType", 0 )
		ent:SetKeyValue( "HeadcrabCount", 0 )
		ent:SetKeyValue( "FlightSpeed", 4000 )
		ent:SetKeyValue( "FlightTime", 5 )
		ent:SetKeyValue( "Damage", 1000 )
		ent:SetKeyValue( "DamageRadius", 36 )
		ent:SetKeyValue( "SmokeLifetime", 0 )
		ent:SetKeyValue( "StartingHeight",  1000 )
		local iSpawnFlags = 8192 + 16384 
		ent:SetKeyValue( "spawnflags", iSpawnFlags )
		
		ent:Spawn()
		canister = ents.Create("prop_canister")
		canister:SetAngles(ent:GetAngles())
		canister:SetPos(aBasePos)
		canister:Spawn()
		canister:SetUseType(SIMPLE_USE)
		
		ent:Input("FireCanister", self.Owner, self.Owner)
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
