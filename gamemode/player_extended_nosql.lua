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

function meta:CallHumanFunction(funcname, ...)
	if self:Team() == TEAM_HUMAN then
		local tab = self:GetHumanClassTable()
		if tab[funcname] then
			return tab[funcname](tab, self, ...)
		end
	end
end

function meta:GetHumanClassTable()
	return GAMEMODE.HumanClasses[self:GetClass()]
end

function meta:SetClass(class)
	self.CurrentClass = class
	
	for k,v in pairs(GAMEMODE.HumanClasses) do
		if (v.Name == class ) then
			
			self:SetMaxHealth(math.max(1, v.Health)) self:SetHealth(self:GetMaxHealth())
			self.HumanSpeedAdder = (self.HumanSpeedAdder or 0) + v.BonusSpeed
			
			self:CallHumanFunction("Loadout")

			self:ResetSpeed()
		end
	end
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

function meta:GetClassXP()
	local curClass = self:GetClass()

	if (curClass == 'Skirmisher') then
		return self:GetXPCommando()
	elseif (curClass == 'Carpenter') then
		return self:GetXPSupport()
	elseif (curClass == 'Rogue') then
		return self:GetXPEngineer()
	elseif (curClass == 'Berserker') then
		return self:GetXPBerserker()
	end			
end

function meta:GiveXP( amount , class )
	local curClass = self:GetClass()
	if class != nil then
		curClass = class
	end
	
	if (curClass == 'Skirmisher') then
		self.XP_Commando = math.Clamp(self.XP_Commando + amount,0,LIMIT_XP)
	elseif (curClass == 'Carpenter') then
		self.XP_Support = math.Clamp(self.XP_Support + amount,0,LIMIT_XP)
	elseif (curClass == 'Rogue') then
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

function meta:CashOut()
	local giveXP = math.floor(self:GetPoints() / 20)
	self:GiveXP(giveXP)
	self:TakePoints(self:GetPoints())
	print("Cashed out for " .. giveXP .. "XP!")
end
