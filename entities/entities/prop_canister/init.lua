AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Launched = 0
ENT.Exploded = false
ENT.Active = false

function ENT:Initialize()
	self:PhysicsInit(SOLID_NONE)
	self.Launched = CurTime()
	self:SetPlaybackRate(0.1)
	self:SetModel( "models/props_combine/headcrabcannister01b.mdl" )
end

function ENT:Use( activator, caller )
	if not self.Active then return end
	for _, tab in pairs(GAMEMODE.Items) do
		if tab.Category == 1 then
			local wep = ents.Create("prop_weapon")
			if wep:IsValid() then
				wep:SetPos(self:GetPos() + Vector(math.random(-6,6),math.random(-6,6),48))
				wep:SetAngles(self:GetAngles())
				wep:SetWeaponType(tab.SWEP)
				wep:SetShouldRemoveAmmo(false)
				wep:Spawn()
					local phys = wep:GetPhysicsObject()
					wep:SetVelocity(Vector(0,0,200))
					print (phys:GetMass())
				if (math.random(1,4) == 4) then
					break;
				end
			end		
		end
	end
	self.Active = false
	self:ResetSequence("idle_open")
	self:EmitSound("ambient/levels/canals/headcrab_canister_open1.wav")
end

function ENT:Think()

if Active then return end
	if self.Launched + 5.12 < CurTime() then
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
			
		end
	end
end