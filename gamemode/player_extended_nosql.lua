local meta = FindMetaTable( "Player" )

if (!meta) then return end

function meta:GetXPCommando()
	return self.XP_Commando
end

function meta:GetXPSupport()
	return self.XP_Support
end

function meta:GetXPEngineer()
	return self.XP_Engineer
end

function meta:GetXPBerserker()
	return self.XP_Berserker
end

function meta:SetClass(class)
	self.CurrentClass = class
end

function meta:GetClass()
	return self.CurrentClass
end

function meta:GetScrap()
	return self.Scrap
end

function meta:GiveScrap(amount)
	self.Scrap = math.Clamp(self.Scrap + amount,0,LIMIT_SCRAP)
	GAMEMODE:SaveData(self)
end

function meta:GiveXP( amount , class )
	
	local curClass = self:GetClass()
	if class != nil then
		curClass = class
	end
	
	if (curClass == 'Commando') then
		self.XP_Commando = math.Clamp(self.XP_Commando + amount,0,LIMIT_XP)
	elseif (curClass == 'Support') then
		self.XP_Support = math.Clamp(self.XP_Support + amount,0,LIMIT_XP)
	elseif (curClass == 'Engineer') then
		self.XP_Engineer = math.Clamp(self.XP_Engineer + amount,0,LIMIT_XP)
	elseif (curClass == 'Berserker') then
		self.XP_Berserker = math.Clamp(self.XP_Berserker + amount,0,LIMIT_XP)
	end

	GAMEMODE:SaveData(self)
end

function meta:UnlockItem(item)
	self.Items[#self.Items + 1] = tostring(item)
	GAMEMODE:PlayerUnlockItem(self,item)
	GAMEMODE:SendPlayerData(self)
end

function meta:GetItems()
	return self.Items
end
