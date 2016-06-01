local PANEL = {}

function PANEL:Init()
	self.m_Text = vgui.Create("DLabel", self)
	self:SetTextFont("ZSHUDFontTiny")
	self.m_Text.Paint = self.TextPaint
	self:InvalidateLayout()
end

local SUPPLY_DROP_STATUS = "online"

function PANEL:SetTextFont(font)
	self.m_Text.Font = font
	self.m_Text:SetFont(font)
	self:InvalidateLayout()
end

function PANEL:PerformLayout()	
	self.m_Text:SetWide(self:GetWide())
	self.m_Text:SizeToContentsY()
	self.m_Text:AlignTop(4)
end

function PANEL:TextPaint()
	if MySelf:IsValid() then
		draw.SimpleText("Supply drop: " .. SUPPLY_DROP_STATUS, self.Font, 0, 0, COLOR_DARKRED)
	end
	return true
end

function PANEL:Paint()
	return true
end

net.Receive("zs_supplydropstatus", function()
	SUPPLY_DROP_STATUS = net.ReadString()
	
	if SUPPLY_DROP_STATUS == "launched" then
		surface.PlaySound(table.Random(GAMEMODE.Announcer.SUPPLY_DROP_LAUNCHED))
	elseif SUPPLY_DROP_STATUS == "online" then
		surface.PlaySound(table.Random(GAMEMODE.Announcer.SUPPLY_DROP_ONLINE))
	elseif SUPPLY_DROP_STATUS == "inbound" then
		surface.PlaySound(table.Random(GAMEMODE.Announcer.SUPPLY_DROP_INBOUND))		
	end	
	
	--GAMEMODE:CenterNotify({killicon = "default"}, " ", COLOR_CYAN, "Supply drop " .. SUPPLY_DROP_STATUS, {killicon = "default"})	
end)

vgui.Register("SupplyDrop", PANEL, "DPanel")

