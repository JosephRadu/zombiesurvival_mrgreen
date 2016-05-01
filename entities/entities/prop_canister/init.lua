AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Launched = 0
ENT.Exploded = false
ENT.Active = false
ENT.InitialDrop = false

local playersUsed = {}

function ENT:Initialize()
	playersUsed = {}
	self:PhysicsInit(SOLID_NONE)
	self.Launched = CurTime()
	self:SetPlaybackRate(0.1)
	self:SetModel( "models/props_combine/headcrabcannister01b.mdl" )
end

local ammoTypes = {
"357","pistol","buckshot","ar2","smg1"
}

local possibleWeps = {}

function ENT:Use( activator, caller )
	if not self.Active then return end
	
	if self.InitialDrop then
		if next(possibleWeps) != nil then
		
			if (not table.HasValue(playersUsed, activator)) then
			local wep = activator:Give(table.Random(possibleWeps))
			net.Start("zs_canisteruse")
			net.WriteBool(true)
			net.Send(activator)
			playersUsed[#playersUsed + 1] = activator
			end
		end
	end
	
	if self.InitialDrop then return end
	
	self.InitialDrop = true
	for k,v in pairs(ammoTypes) do
		local newent = ents.Create("prop_ammo")
		if newent:IsValid() then
			newent:SetAmmoType(v)
			newent.PlacedInMap = true
			newent:SetPos(self:GetPos() + Vector(math.random(-8,8),math.random(-8,8),64))
			newent:SetAngles(self:GetAngles())
			newent:Spawn()
			newent:SetAmmo((GAMEMODE.AmmoCache[v] * 2) or 1)
		end
	end

	local humans = table.Count(team.GetPlayers(TEAM_HUMAN))
		
	for k, v in pairs(GAMEMODE.SupplyDropItems) do
		if v.Wave == GAMEMODE:GetWave() then
			local wep = ents.Create("prop_weapon")
			if wep:IsValid() then
				wep:SetPos(self:GetPos() + Vector(math.random(-6,6),math.random(-6,6),64))
				wep:SetAngles(self:GetAngles())
				wep:SetWeaponType(v.Signature)
				wep:SetShouldRemoveAmmo(true)
				wep:Spawn()	
				possibleWeps[#possibleWeps + 1] = v.Signature
			end		
		end
	end
	
	--self.Active = false
	self:ResetSequence("idle_open")
	self:EmitSound("ambient/levels/canals/headcrab_canister_open1.wav")
end

function ENT:Think()

if self.Active then return end
	if self.Launched + 5.2 < CurTime() then
		self:PhysicsInit(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	
		if not self.Exploded then
			local pos = self:GetPos()
			self.Exploded = true
			
			for k,v in pairs(ents.GetAll()) do
				if (v:GetClass() == "env_headcrabcanister") then
					print(self:GetPos():Distance(v:GetPos()))
					if self:GetPos():Distance(v:GetPos()) == 0 then
						v:Remove()
						self.Active = true
						break;
					end
				end
			end
			
		end
	end
end