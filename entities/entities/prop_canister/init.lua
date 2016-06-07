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
			newent:SetAmmo((GAMEMODE.AmmoCache[v] * 3) or 1)
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
				wep:SetShouldRemoveAmmo(false)
				wep:Spawn()	
				wep.IsPreplaced = true
				possibleWeps[#possibleWeps + 1] = v.Signature
			end		
		end
	end
	--self.Active = false
	self:ResetSequence("idle_open")
	self:EmitSound("ambient/levels/canals/headcrab_canister_open1.wav")
end

function ENT:Think()	
	if self.Active then 
		if self.Launched + 80 < CurTime() then
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			util.Effect("Explosion", effectdata)
			
			local scrapAmount = 5
			for i=1, scrapAmount do
				local ent = ents.Create("projectile_scrap")
				if ent:IsValid() then
					ent:SetPos(self:GetPos() + Vector(0,0,16))
					ent:Spawn()
				end	
			end
		
			self:Remove()
		end
		return
	end	
	
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
					if self:GetPos():Distance(v:GetPos()) == 0 then
						v:Remove()
						self.Active = true
						break;
					end
				end
			end
			
			timer.Simple( 3, 	function() net.Start("zs_supplydropstatus")
				net.WriteString("online")
			net.Broadcast()	end  ) 

		end
	end
	
	if SERVER then
		if self.Active then
			net.Start("zs_supplydropstatus")
			net.WriteString("offline")
			net.Broadcast()	
		end
	end		
end