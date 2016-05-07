include('shared.lua')

ENT.SpawnTime = 0

local Used = false
local Wave = 0
local SpawnTime = 0
ENT.Launched = CurTime()

function ENT:Initialize()
	EntSpawnTime = math.Round(CurTime())
	self:DestroyShadow() 
	Wave = GAMEMODE:GetWave()
	self.Launched = CurTime()	
	Used = false
	self.SpawnTime = CurTime()
end

local vOffset = Vector(84, 0, 6)
local vOffset2 = Vector(84, 0, 6)
local aOffset = Angle(0, 90, 180)
local aOffset2 = Angle(0, 270,360)
local vOffsetEE = Vector(0, 0, 0)

function ENT:Draw()
	if self.SpawnTime + 5 < CurTime() then
		self:DrawModel()
		self:DrawShadow(true)
		
		if not MySelf:IsValid() then return end

		local owner = self
		local ang = self:LocalToWorldAngles(aOffset)
		
		self:RenderInfo(self:LocalToWorld(vOffset), ang, owner)
			self:RenderInfo(self:LocalToWorld(vOffset2), self:LocalToWorldAngles(aOffset2), owner)
	end
end

function ENT:RenderInfo(pos, ang, owner)
	cam.Start3D2D(pos, ang, 0.075)
		draw.RoundedBox(0, -225, -50, 460, 100, color_black_alpha90)
		draw.SimpleText(translate.Get("supply_drop"), "ZS3D2DFont2", 0, 0, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.SimpleText(math.Round(self.Launched + 80 - CurTime(),2), "ZS3D2DFont2", 0, -100, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		if not Used and Wave != 0 then
			draw.SimpleText("(USE) WEAPON AVAILABLE", "ZS3D2DFont2Small", 0, 100, COLOR_BLUE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end
	cam.End3D2D()
end

net.Receive("zs_canisteruse", function(bool)
	Used = net.ReadBool()
end)
