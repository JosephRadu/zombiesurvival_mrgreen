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

function meta:SetClass(class)
	self.CurrentClass = class
end

function meta:GiveXP( amount , class )
	
	local curClass = self.CurrentClass
	if class != nil then
		curClass = class
	end
	
	if (curClass == 'commando') then
		self.XP_Commando = self.XP_Commando + amount
	elseif (curClass == 'support') then
		self.XP_Support = self.XP_Support + amount
	elseif (curClass == 'engineer') then
		self.XP_Engineer = self.XP_Engineer + amount
	end

	--GAMEMODE:UpdatePlayerStats( self, self.m_CurentXP )
end

function meta:UnlockItem(item)
	self.Items[#self.Items + 1] = tostring(item)
	GAMEMODE:PlayerUnlockItem(self,item)
	GAMEMODE:SendPlayerData(self)
end

function meta:GetItems()
	return self.Items
end
