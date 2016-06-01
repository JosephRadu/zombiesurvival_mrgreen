function GM:RegisterHumanClasses()
	self.HumanClasses = {}

	local included = {}

	local classes = file.Find(self.FolderName.."/gamemode/humanclasses/*.lua", "LUA")
	table.sort(classes)
	for i, filename in ipairs(classes) do
		AddCSLuaFile("humanclasses/"..filename)
		CLASS = {}
		include("humanclasses/"..filename)
		if CLASS.Name then
			self:RegisterHumanClass(CLASS.Name, CLASS)
		else
			ErrorNoHalt("CLASS "..filename.." has no 'Name' member!")
		end
		included[filename] = CLASS
		CLASS = nil
	end

	for k, v in pairs(self.HumanClasses) do
		local base = v.Base
		if base then
			base = base..".lua"
			if included[base] then
				table.Inherit(v, included[base])
			else
				ErrorNoHalt("CLASS "..tostring(v.Name).." uses base class "..base.." but it doesn't exist!")
			end
		end

		if v.Unlocked or v.Wave == 0 then
			v.UnlockedNotify = true
		end
	end
end

function GM:RegisterHumanClass(name, tab)
	local gm = GAMEMODE or GM
	
	table.insert(gm.HumanClasses, tab)
	tab.Index = #gm.HumanClasses
	if CLIENT then
		tab.Icon = tab.Icon or "zombiesurvival/killicons/genericundead"
	end

	if tab.IsDefault then
		gm.DefaultHumanClass = tab.Index
	end

	tab.TranslationName = tab.TranslationName or tab.Name
	gm.HumanClasses[name] = tab
end

GM:RegisterHumanClasses()