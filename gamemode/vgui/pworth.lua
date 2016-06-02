hook.Add("SetWave", "CloseWorthOnWave1", function(wave)
	if wave > 0 then
		if pWorth and pWorth:Valid() then
			pWorth:Close()
		end

		hook.Remove("SetWave", "CloseWorthOnWave1")
	end
end)

local classButton = {}
local classFrames = {}

local classList = {}
local lists = {}

UnlockedItems = {}

XP = {}
SCRAP = 0

net.Receive("sendplayerdata", function()

	XP[CLASS_COMMANDO] = net.ReadFloat()
	XP[CLASS_ENGINEER] = net.ReadFloat()
	XP[CLASS_SUPPORT] = net.ReadFloat()
	XP[CLASS_BERSERKER] = net.ReadFloat()
	SCRAP = net.ReadFloat()
	UnlockedItems = net.ReadTable()
	MakepWorth()
end)

local Types = {}

local cvarDefaultCart = CreateClientConVar("zs_defaultcart", "", true, false)

local function DefaultDoClick(btn)
	if cvarDefaultCart:GetString() == btn.Name then
		RunConsoleCommand("zs_defaultcart", "")
		surface.PlaySound("buttons/button11.wav")
	else
		RunConsoleCommand("zs_defaultcart", btn.Name)
		surface.PlaySound("buttons/button14.wav")
	end

	timer.Simple(0.1, MakepWorth)
end

local WorthRemaining = 0
local WorthButtons = {}
local function CartDoClick(self, silent, force)
	local id = self.ID
	local tab = FindStartingItem(id)
	if not tab then return end

	if self.On then
		self.On = nil
		self:SetImage("icon16/cart_add.png")
		if not silent then
			surface.PlaySound("buttons/button18.wav")
		end
		self:SetTooltip("Add to cart")
		WorthRemaining = WorthRemaining + tab.Worth
	else
		if WorthRemaining < tab.Worth and not force then
			surface.PlaySound("buttons/button8.wav")
			return
		end
		self.On = true
		self:SetImage("icon16/cart_delete.png")
		if not silent then
			surface.PlaySound("buttons/button17.wav")
		end
		self:SetTooltip("Remove from cart")
		WorthRemaining = WorthRemaining - tab.Worth
	end

	pWorth.WorthLab:SetText("Worth: ".. WorthRemaining)
	if WorthRemaining <= 0 then
		pWorth.WorthLab:SetTextColor(COLOR_RED)
		pWorth.WorthLab:InvalidateLayout()
	elseif WorthRemaining <= GAMEMODE.StartingWorth * 0.25 then
		pWorth.WorthLab:SetTextColor(COLOR_YELLOW)
		pWorth.WorthLab:InvalidateLayout()
	else
		pWorth.WorthLab:SetTextColor(COLOR_LIMEGREEN)
		pWorth.WorthLab:InvalidateLayout()
	end
	pWorth.WorthLab:SizeToContents()
end

local function SetClass(class)

	local classString = nil
	
	if class == CLASS_COMMANDO then
		classString = "skirmisher"
	elseif class == CLASS_SUPPORT then
		classString = "carpenter"
	elseif class == CLASS_ENGINEER then
		classString = "rogue"	
	elseif class == CLASS_BERSERKER then
		classString = "berserker"			
	end

	RunConsoleCommand("setClass", classString)
end

local classSelected = nil

local function Checkout(tobuy)
	local classSelected = nil
	for k,v in pairs (classButton) do
		if v.Active then
			classSelected = v.Class
			
			break
		end
	end
	SetClass(classSelected)
	if tobuy and #tobuy > 0 then
		gamemode.Call("SuppressArsenalUpgrades", 1)

		RunConsoleCommand("worthcheckout", unpack(tobuy))

		if pWorth and pWorth:Valid() then
			pWorth:Close()
		end
	else
		surface.PlaySound("buttons/combine_button_locked.wav")
	end
end

local function CheckoutDoClick(self)
	local tobuy = {}
	
	for _, btn in pairs(WorthButtons) do
		if btn and btn.On and btn.ID then
			table.insert(tobuy, btn.ID)
		end
	end
	Checkout(tobuy)
end

GM.SavedCarts = {}
hook.Add("Initialize", "LoadCarts", function()
	if file.Exists(GAMEMODE.CartFile, "DATA") then
		GAMEMODE.SavedCarts = Deserialize(file.Read(GAMEMODE.CartFile)) or {}
	end
end)

local function ClearCartDoClick()
	for _, btn in ipairs(WorthButtons) do
		if btn.On then
			btn:DoClick(true, true)
		end
	end

	surface.PlaySound("buttons/button11.wav")
end

local function LoadCart(cartid, silent)
	if GAMEMODE.SavedCarts[cartid] then
		MakepWorth()

		classButton[GAMEMODE.SavedCarts[cartid][3]]:DoClick()
		for _, id in pairs(GAMEMODE.SavedCarts[cartid][2]) do
			for __, btn in pairs(WorthButtons) do
				if btn and (btn.ID == id or GAMEMODE.ClassItems[id] and GAMEMODE.ClassItems[id].Class == btn.ID) then
					btn:DoClick(true, true, true)
				end
			end
		end
		
		if not silent then
			surface.PlaySound("buttons/combine_button1.wav")
		end
	end
end

local function LoadDoClick(self)
	LoadCart(self.ID)
end

local function SaveCurrentCart(name)
	local tobuy = {}
	for _, btn in pairs(WorthButtons) do
		if btn and btn.On and btn.ID then
			table.insert(tobuy, btn.ID)
		end
	end

	for i, cart in ipairs(GAMEMODE.SavedCarts) do
		if string.lower(cart[1]) == string.lower(name) then
			cart[1] = name
			cart[2] = tobuy
			cart[3] = classSelected
			file.Write(GAMEMODE.CartFile, Serialize(GAMEMODE.SavedCarts))
			print("Saved cart "..tostring(name))

			LoadCart(i, true)
			return
		end
	end

	GAMEMODE.SavedCarts[#GAMEMODE.SavedCarts + 1] = {name, tobuy, classSelected}

	file.Write(GAMEMODE.CartFile, Serialize(GAMEMODE.SavedCarts))
	print("Saved cart "..tostring(name))

	LoadCart(#GAMEMODE.SavedCarts, true)
end

local function SaveDoClick(self)
	Derma_StringRequest("Save cart", "Enter a name for this cart.", "Name", 
	function(strTextOut) SaveCurrentCart(strTextOut) end,
	function(strTextOut) end,
	"OK", "Cancel")
end

local function DeleteDoClick(self)
	if GAMEMODE.SavedCarts[self.ID] then
		table.remove(GAMEMODE.SavedCarts, self.ID)
		file.Write(GAMEMODE.CartFile, Serialize(GAMEMODE.SavedCarts))
		surface.PlaySound("buttons/button19.wav")
		MakepWorth()
	end
end

local function QuickCheckDoClick(self)
	if GAMEMODE.SavedCarts[self.ID] then
		Checkout(GAMEMODE.SavedCarts[self.ID][2])
	end
end

function MakepWorth()
	if pWorth and pWorth:Valid() then
		pWorth:Remove()
		pWorth = nil
	end

	local maxworth = GAMEMODE.StartingWorth
	WorthRemaining = maxworth

	local wid, hei = math.min(ScrW(), 1024), ScrH() * 0.7

	local frame = vgui.Create("DFrame")
	pWorth = frame
	pScrap = frame
	frame:SetSize(wid, hei)
	frame:SetDeleteOnClose(true)
	frame:SetKeyboardInputEnabled(false)
	frame:SetTitle(" ")

	local propertysheet = vgui.Create("DPropertySheet", frame)
	propertysheet:StretchToParent(4, 24, 4, 50)
	propertysheet.Paint = function() end

	local panfont = "ZSHUDFontSmall"
	local panhei = 40

	local defaultcart = cvarDefaultCart:GetString()
	local classPanel = {}
	
	classDescriptionFrame = vgui.Create("DEXRoundedPanel",frame)
	classDescriptionFrame:SetText("")
	classDescriptionFrame:SetPos(10, hei * 0.5 )
	classDescriptionFrame:SetSize( wid * 0.18, hei * 0.33 )
	
	classDescription = vgui.Create("DLabel",classDescriptionFrame)
	classDescription:SetFont("ZSHUDFontSmallest")
	classDescription:SetText("")
	classDescription:SetPos(10,0)
	classDescription:SetSize( wid * 0.18, hei * 0.33 )

		
	for classid, classname in ipairs(GAMEMODE.Classes) do
		local xpAmount = (XP[classid] or 0)
		classButton[classid] = vgui.Create( "DButton", propertysheet )
		classButton[classid]:SetText(classname .. "\n" .. xpAmount .. "/" .. LIMIT_XP .. " XP" )
		classButton[classid]:AlignLeft()
		classButton[classid].Class = classid
		classButton[classid]:SetTextColor( Color( 255, 255, 255 ) )
		classButton[classid]:SetPos(10, -50 + classid * 50 )
		classButton[classid]:SetSize( wid * 0.18, 50 )
		classButton[classid].Paint = function( self, w, h )
			if classButton[classid].Active then
				outline = COLOR_LIMEGREEN		
			elseif self.Hovered then
				outline = self.On and COLOR_GREEN or COLOR_GRAY
			else
				outline = self.On and COLOR_DARKGREEN or COLOR_DARKGRAY
			end
			draw.RoundedBox(8, 0, 0, w, h, outline)
			draw.RoundedBox(4, 4, 4, w - 8, h - 8, color_black)
		end
		
		classButton[classid]:SetFont("ZSHUDFontSmallest")
		classPanel[classid] = vgui.Create("DPanel",frame)
		classPanel[classid]:SetSize(wid * 0.67, hei * 0.8)
		classPanel[classid]:SetKeyboardInputEnabled(false)
		classPanel[classid]:SetPos(216,26)
		classPanel[classid]:SetVisible(false)
		
		classPanel[classid]:SetBackgroundColor(Color(255,255,255,255))
		classPanel[classid]:SetAlpha(255)
		
		local classSheet = vgui.Create("DPropertySheet",classPanel[classid])
		classSheet:SetSize(wid * 0.67, hei * 0.8)
		classSheet:SetKeyboardInputEnabled(false)
		classSheet:SetPos(0,0)		
		classSheet.Paint = function() end
		
		local list = vgui.Create("DPanelList", classSheet)
		classSheet:AddSheet("Favorites", list, "icon16/heart.png", false, false)
		list:EnableVerticalScrollbar(true)
		list:SetWide(classSheet:GetWide() - 16)
		list:SetSpacing(2)
		list:SetPadding(2)

		local savebutton = EasyButton(nil, "Save the current cart", 0, 10)
		savebutton.DoClick = SaveDoClick
		list:AddItem(savebutton)		
		
		for i, savetab in ipairs(GAMEMODE.SavedCarts) do
			if savetab[3] != classButton[classid].Class then continue end
		
			local cartpan = vgui.Create("DEXRoundedPanel")
			cartpan:SetCursor("pointer")
			cartpan:SetSize(list:GetWide(), panhei)

			local cartname = savetab[1]

			local x = 8

			if defaultcart == cartname then
				local defimage = vgui.Create("DImage", cartpan)
				defimage:SetImage("icon16/heart.png")
				defimage:SizeToContents()
				defimage:SetMouseInputEnabled(true)
				defimage:SetTooltip("This is your default cart.\nIf you join the game late then you'll spawn with this cart.")
				defimage:SetPos(x, cartpan:GetTall() * 0.5 - defimage:GetTall() * 0.5)
				x = x + defimage:GetWide() + 4
			end

			local cartnamelabel = EasyLabel(cartpan, cartname, panfont)
			cartnamelabel:SetPos(x, cartpan:GetTall() * 0.5 - cartnamelabel:GetTall() * 0.5)

			x = cartpan:GetWide() - 20

			local checkbutton = vgui.Create("DImageButton", cartpan)
			checkbutton:SetImage("icon16/accept.png")
			checkbutton:SizeToContents()
			checkbutton:SetTooltip("Purchase this saved cart.")
			x = x - checkbutton:GetWide() - 8
			checkbutton:SetPos(x, cartpan:GetTall() * 0.5 - checkbutton:GetTall() * 0.5)
			checkbutton.ID = i
			checkbutton.DoClick = QuickCheckDoClick

			local loadbutton = vgui.Create("DImageButton", cartpan)
			loadbutton:SetImage("icon16/folder_go.png")
			loadbutton:SizeToContents()
			loadbutton:SetTooltip("Load this saved cart.")
			x = x - loadbutton:GetWide() - 8
			loadbutton:SetPos(x, cartpan:GetTall() * 0.5 - loadbutton:GetTall() * 0.5)
			loadbutton.ID = i
			loadbutton.DoClick = LoadDoClick

			local defaultbutton = vgui.Create("DImageButton", cartpan)
			defaultbutton:SetImage("icon16/heart.png")
			defaultbutton:SizeToContents()
			if cartname == defaultcart then
				defaultbutton:SetTooltip("Remove this cart as your default.")
			else
				defaultbutton:SetTooltip("Make this cart your default.")
			end
			x = x - defaultbutton:GetWide() - 8
			defaultbutton:SetPos(x, cartpan:GetTall() * 0.5 - defaultbutton:GetTall() * 0.5)
			defaultbutton.Name = cartname
			defaultbutton.DoClick = DefaultDoClick

			local deletebutton = vgui.Create("DImageButton", cartpan)
			deletebutton:SetImage("icon16/bin.png")
			deletebutton:SizeToContents()
			deletebutton:SetTooltip("Delete this saved cart.")
			x = x - deletebutton:GetWide() - 8
			deletebutton:SetPos(x, cartpan:GetTall() * 0.5 - loadbutton:GetTall() * 0.5)
			deletebutton.ID = i
			deletebutton.DoClick = DeleteDoClick

			list:AddItem(cartpan)
		end		
		
		for classcategoryid, classcategory in ipairs(GAMEMODE.ClassItemCategories) do
			local list = vgui.Create("DPanelList", classSheet)
			list:SetPaintBackground(false)
			classSheet:AddSheet(classcategory,list, GAMEMODE.ItemCategoryIcons[classcategoryid], false, false)
			list:EnableVerticalScrollbar(true)
			list:SetWide(classSheet:GetWide() - 16)
			list:SetSpacing(1)
			list:SetPadding(1)
			for i, tab in ipairs(GAMEMODE.ClassItems) do
				
				if tab.ItemType == classcategoryid and (tab.Class == classid) then
					local button = vgui.Create("ZSWorthButton")
					button:SetWorthID(i)
					list:AddItem(button)
					WorthButtons[i] = button
					
					if (tab.XP or tab.Scrap)and CheckUnlockedItem(tab.Signature) then
						tab.Unlocked = true
					end
				end
			end
		end

		classButton[classid].DoClick = function()
			classSelected = classButton[classid].Class
		
			for k,v in pairs (classButton) do
				v.Active = false
			end
			classButton[classid].Active = true
		
			surface.PlaySound("ui/buttonclick.wav")
			for k, v in pairs (classPanel) do
				v:SetVisible(false)
				if k == classid then
					classPanel[classid]:SetVisible(true)
					classDescription:SetText("Attributes:\n" ..   GAMEMODE.HumanClasses[classname].Health .. " Health\n" ..  GAMEMODE.HumanClasses[classname].BonusSpeed .. " Bonus speed\n" .. "\nAdvantages:\n" .. GAMEMODE.HumanClasses[classname].LoadoutDescription)
					
				end
			end
			
			for _, btn in ipairs(WorthButtons) do
				if btn.On then
					btn:DoClick(true, true)
				end
			end
		end

	end

	for k,v in pairs (classButton) do
		if v.Class == classSelected then
			v:SetVisible(true)		
			v:DoClick()
		end
	end
			
	local worthlab = EasyLabel(frame, "Worth: "..tostring(WorthRemaining), "ZSHUDFontSmall", COLOR_LIMEGREEN)
	worthlab:SetPos(8, frame:GetTall() - worthlab:GetTall() - 8)
	frame.WorthLab = worthlab
	
	local scraplab = EasyLabel(frame, (" Scrap: ".. SCRAP .."/"..LIMIT_SCRAP), "ZSHUDFontSmall", COLOR_DARKGREEN)
	scraplab:SetPos(8, frame:GetTall() - scraplab:GetTall() - 48)
	frame.ScrapLab = scraplab

	local checkout = vgui.Create("DButton", frame)
	checkout:SetFont("ZSHUDFontSmall")
	checkout:SetText("Checkout")
	checkout:SizeToContents()
	checkout:SetSize(130, 30)
	checkout:AlignBottom(8)
	checkout:CenterHorizontal()
	checkout.DoClick = CheckoutDoClick

	local clearbutton = vgui.Create("DButton", frame)
	clearbutton:SetText("Clear")
	clearbutton:SetSize(64, 16)
	clearbutton:AlignRight(8)
	clearbutton:AlignBottom(8)
	clearbutton.DoClick = ClearCartDoClick

	frame:Center()
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.5, 0)
	frame:MakePopup()

	return frame
end

function CheckUnlockedItem(itemSpecified)
	--if (UnlockedItems) then
		for k, v in pairs(UnlockedItems) do
			if ( v == itemSpecified) then
				return true
			end
		end
	--end
	return false
end


local PANEL = {}
PANEL.m_ItemID = 0
PANEL.RefreshTime = 1
PANEL.NextRefresh = 0

function PANEL:Init()
	self:SetFont("DefaultFontSmall")
end

function PANEL:Think()
	if CurTime() >= self.NextRefresh then
		self.NextRefresh = CurTime() + self.RefreshTime
		self:Refresh()
	end
end

function PANEL:Refresh()
	local count = GAMEMODE:GetCurrentEquipmentCount(self:GetItemID())
	if count == 0 then
		self:SetText(" ")
	else
		self:SetText(count)
	end

	self:SizeToContents()
end

function PANEL:SetItemID(id) self.m_ItemID = id end
function PANEL:GetItemID() return self.m_ItemID end

vgui.Register("ItemAmountCounter", PANEL, "DLabel")

PANEL = {}

function PANEL:Init()
	self:SetText("")

	self:DockPadding(4, 4, 4, 4)
	self:SetTall(48)

	local mdlframe = vgui.Create("DEXRoundedPanel", self)
	mdlframe:SetWide(self:GetTall())
	mdlframe:Dock(LEFT)
	mdlframe:DockMargin(0, 0, 20, 0)

	self.ModelPanel = vgui.Create("DModelPanel", mdlframe)
	self.ModelPanel:Dock(FILL)
	self.ModelPanel:DockPadding(0, 0, 0, 0)
	self.ModelPanel:DockMargin(0, 0, 0, 0)

	self.NameLabel = EasyLabel(self, "", "ZSHUDFontSmall")
	self.NameLabel:SetContentAlignment(4)
	self.NameLabel:Dock(FILL)

	self.PriceLabel = EasyLabel(self, "", "ZSHUDFontTiny")
	self.PriceLabel:SetWide(80)
	self.PriceLabel:SetContentAlignment(6)
	self.PriceLabel:Dock(RIGHT)
	self.PriceLabel:DockMargin(8, 0, 4, 0)

	self.ItemCounter = vgui.Create("ItemAmountCounter", self)

	self:SetWorthID(nil)
end

function PANEL:SetWorthID(id)
	self.ID = id

	local tab = FindStartingItem(id)
	
	if not tab then
		self.ModelPanel:SetVisible(false)
		self.ItemCounter:SetVisible(false)
		self.NameLabel:SetText("")
		return
	end

	local mdl = tab.Model or (weapons.GetStored(tab.SWEP) or tab).WorldModel
	if mdl then
		self.ModelPanel:SetModel(mdl)
		local mins, maxs = self.ModelPanel.Entity:GetRenderBounds()
		self.ModelPanel:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5))
		self.ModelPanel:SetLookAt((mins + maxs) / 2)
		self.ModelPanel:SetVisible(true)
	else
		self.ModelPanel:SetVisible(false)
	end

	if tab.SWEP or tab.Countables then
		self.ItemCounter:SetItemID(id)
		self.ItemCounter:SetVisible(true)
	else
		self.ItemCounter:SetVisible(false)
	end

	if tab.Worth then
		self.PriceLabel:SetText(tostring(tab.Worth).." Worth")
	else
		self.PriceLabel:SetText("")
	end

	self:SetTooltip(tab.Description)

	if tab.NoClassicMode and GAMEMODE:IsClassicMode() or tab.NoZombieEscape and GAMEMODE.ZombieEscape then
		self:SetAlpha(160)
	else
		self:SetAlpha(255)
	end
	
	self.NameLabel:SetText(tab.Name or "")
	if tab.XP and not tab.Unlocked then
		self:SetAlpha(100)
		self.NameLabel:SetText(tab.Name .. " (" .. tab.XP .. " XP)")
	end
	
	if tab.Scrap and not tab.Unlocked then
		self:SetAlpha(100)
		self.NameLabel:SetText(tab.Name .. " (" .. tab.Scrap .. " Scrap)")
	end
	
end

local function UnlockItem(tab,self)
	surface.PlaySound("buttons/button9.wav")
	Derma_Query("Unlock " .. tostring(tab.Name) .. " for " .. tostring(tab.XP) .. " XP?","",
	"Yes",function() if XP[tab.Class] != nil and XP[tab.Class] >= tab.XP then RunConsoleCommand("unlockitem", tab.Signature, tab.XP) surface.PlaySound("buttons/button6.wav") else surface.PlaySound("buttons/button11.wav") Derma_Message( "not enuf xp", "", ":(" ) end end,
	"No", function() return end) 
end

local function UnlockScrapItem(tab,self)
	surface.PlaySound("buttons/button9.wav")
	Derma_Query("Unlock " .. tostring(tab.Name) .. " for " .. tostring(tab.Scrap) .. " Scrap?","",
	"Yes",function() if SCRAP != nil and SCRAP >= tab.Scrap then RunConsoleCommand("unlockscrapitem", tab.Signature, tab.Scrap) surface.PlaySound("buttons/button6.wav") else surface.PlaySound("buttons/button11.wav") Derma_Message( "not enuf scrap", "", ":(" ) end end,
	"No", function() return end) 
	pScrap.ScrapLab:SetText(" Scrap: ".. SCRAP .."/" .. LIMIT_SCRAP)	
end

function PANEL:Paint(w, h)
	local outline
	if self.Hovered then
		outline = self.On and COLOR_GREEN or COLOR_GRAY
	else
		outline = self.On and COLOR_DARKGREEN or COLOR_DARKGRAY
	end

	draw.RoundedBox(8, 0, 0, w, h, outline)
	draw.RoundedBox(4, 4, 4, w - 8, h - 8, color_black)
end

function PANEL:DoClick(silent, force, auto)
	local id = self.ID
	local tab = FindStartingItem(id)
	
	if not tab then return end

	if tab.XP and not tab.Unlocked and not auto then
		UnlockItem(tab,self)
		return
	end
	
	if tab.Scrap and not tab.Unlocked and not auto then
		UnlockScrapItem(tab,self)
		return
	end

	if self.On then
		self.On = nil
		if not silent then
			surface.PlaySound("buttons/button18.wav")
		end
		WorthRemaining = WorthRemaining + tab.Worth
	else
		if WorthRemaining < tab.Worth and not force then
			surface.PlaySound("buttons/button8.wav")
			return
		end
		self.On = true
		if not silent then
			surface.PlaySound("buttons/button17.wav")
		end
		WorthRemaining = WorthRemaining - tab.Worth
	end
					
	pWorth.WorthLab:SetText("Worth: ".. WorthRemaining)
	if WorthRemaining <= 0 then
		pWorth.WorthLab:SetTextColor(COLOR_RED)
		pWorth.WorthLab:InvalidateLayout()
	elseif WorthRemaining <= GAMEMODE.StartingWorth * 0.25 then
		pWorth.WorthLab:SetTextColor(COLOR_YELLOW)
		pWorth.WorthLab:InvalidateLayout()
	else
		pWorth.WorthLab:SetTextColor(COLOR_LIMEGREEN)
		pWorth.WorthLab:InvalidateLayout()
	end
	pWorth.WorthLab:SizeToContents()
end

vgui.Register("ZSWorthButton", PANEL, "DButton")
