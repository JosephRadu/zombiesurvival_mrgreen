include('shared.lua')

ENT.SpawnTime = 0

Used = false



function ENT:Initialize()
	self.SpawnTime = CurTime()
	self:DestroyShadow() 
	Used = false
end

local vOffset = Vector(84, 0, 6)
local vOffset2 = Vector(0, 0, 0)
local aOffset = Angle(0, 90, 180)
local aOffset2 = Angle(45, 90,90)
local vOffsetEE = Vector(0, 0, 0)

function ENT:Draw()
	if self.SpawnTime + 5 < CurTime() then
		self:DrawModel()
		self:DrawShadow(true)
		
		if not MySelf:IsValid() then return end

		local owner = self
		local ang = self:LocalToWorldAngles(aOffset)
		
		self:RenderInfo(self:LocalToWorld(vOffset), ang, owner)


	end
end


function ENT:RenderInfo(pos, ang, owner)
	cam.Start3D2D(pos, ang, 0.075)
		draw.RoundedBox(0, -225, -50, 460, 100, color_black_alpha90)
		draw.SimpleText(translate.Get("supply_drop"), "ZS3D2DFont2", 0, 0, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if not Used then
			draw.SimpleText("(USE) WEAPON AVAILABLE", "ZS3D2DFont2Small", 0, 100, COLOR_BLUE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end
	cam.End3D2D()
	
	ang = self:LocalToWorldAngles(Angle(180, 90, 180))
			
	cam.Start3D2D(pos, ang, 0.075)
		draw.RoundedBox(0, -225, -50, 460, 100, color_black_alpha90)
		draw.SimpleText(translate.Get("supply_drop"), "ZS3D2DFont2", 0, 0, COLOR_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if not Used then
			draw.SimpleText("(USE) WEAPON AVAILABLE", "ZS3D2DFont2Small", 0, 100, COLOR_BLUE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end
	cam.End3D2D()
end

net.Receive("zs_canisteruse", function(bool)
	Used = net.ReadBool()
end)
