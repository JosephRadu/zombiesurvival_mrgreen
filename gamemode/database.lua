hook.Add( 'Initialize', 'noSQL', function()
	util.AddNetworkString( "unlockitem" )
	util.AddNetworkString( "sendplayerdata" )
	
	if ( !file.IsDir("noSQL","DATA") ) then
		file.CreateDir("noSQL")
	end 
end )

function GM:PlayerUnlockItem(pl,item)
	GAMEMODE:SendPlayerData(pl)
end

function GM:SendPlayerData(pl)
	net.Start( "sendplayerdata" )
		net.WriteFloat(pl.XP_Commando)
		net.WriteFloat(pl.XP_Engineer)
		net.WriteFloat(pl.XP_Support)
		net.WriteFloat(pl.XP_Berserker)
		net.WriteTable(pl.Items)
	net.Send(pl)
end



//So this shit exists, but does it for the player?
hook.Add( 'PlayerInitialSpawn', 'noSQL Read Data', function( pl )
	GAMEMODE:ReadData( pl )
end )

//Empty data here :v
function GM:GetBlankStats( pl )
	local data = {
		[ 'playername' ] = pl:Nick(),
		[ 'steamid' ] = pl:SteamID(),
		[ 'playtime' ] = 0,
		[ 'items' ] = {},
		[ 'xp' ] = 
		{
			[ 'commando' ] = 0,
			[ 'support' ] = 0,
			[ 'engineer' ] = 0,
			[ 'berserker' ] = 0
		}
	}
		
	return data
end

function GM:WriteBlank( pl )

	local path = "noSQL/player_"..string.Replace( string.sub( pl:SteamID(), 1 ), ":", "-" )..".txt"
	local data = util.TableToJSON( self:GetBlankStats( pl ) )

	file.Write( path, data )

end

function GM:ReadData( pl )
	local path = "noSQL/player_"..string.Replace( string.sub( pl:SteamID(), 1 ), ":", "-" )..".txt"
	if ( !file.Exists( path , "DATA") ) then
		GAMEMODE:WriteBlank( pl )
		for _, v in pairs( player.GetAll() ) do 
			if IsValid( v ) then
				v:ChatPrint( "Welcome "..pl:Nick().." as they have joined for the first time!" )
			end
		end
	end
	fileData = util.JSONToTable( file.Read( path ) )
	pl.DataTable = table.Copy( fileData )
	
	pl.XP_Commando = 0
	pl.XP_Support = 0
	pl.XP_Engineer = 0
						
	for k, v in pairs( pl.DataTable ) do
		if( k == 'items' ) then
			pl.Items = v
		end
		if ( k == 'playtime' ) then
			pl.PlayTime = v
		end
		if ( k == 'xp' ) then
			for p, j in pairs( v ) do
				if( p == 'commando' ) then
					pl.XP_Commando = j
				end
				if ( p == 'support' ) then
					pl.XP_Support = j
				end
				if ( p == 'engineer' ) then
					pl.XP_Engineer = j
				end
				if ( p == 'berserker' ) then
					pl.XP_Berserker = j
				end
			end
		end
	end
	
	GAMEMODE:SendPlayerData(pl)
	
end

function GM:SaveData( pl )
	local path = "noSQL/player_"..string.Replace( string.sub( pl:SteamID(), 1 ), ":", "-" )..".txt"
		local data = {
			[ 'playername' ] = pl:Nick(),
			[ 'steamid' ] = pl:SteamID(),
			[ 'playtime' ] = 0,
			[ 'items' ] = pl:GetItems(),
			[ 'xp' ] = 
				{
					[ 'commando' ] = pl:GetXPCommando(),
					[ 'support' ] = pl:GetXPSupport(),
					[ 'engineer' ] = pl:GetXPEngineer(),
					[ 'berserker' ] = pl:GetXPBerserker()
				},
		}
	local newData =  util.TableToJSON( data )
	file.Write( path, newData )
end

function GM:GetTableLength( dbTable )
	local count = 0
		for k, v in pairs( dbTable ) do
			count = count + 1
		end
	if ( count > 1 ) then
		return true
	end
	return false
end

concommand.Add( 'testDB', function( pl, cmd, args )
	for k, v in pairs( player.GetAll() ) do
		if ( !IsValid( v ) ) then continue end
		if ( v:Nick() == args[ 1 ] ) then
			local path = "noSQL/player_"..string.Replace( string.sub( pl:SteamID(), 1 ), ":", "-" )..".txt"
				PrintTable( util.JSONToTable( file.Read( path ) ) )
			break;
		end
	end

end )

concommand.Add( "unlockitem", function( pl, cmd, args )
	
	if string.match(args[1],"commando") then
		if tonumber(args[2]) > pl:GetXPCommando() then
			return
		else
			pl:GiveXP(tonumber(args[2]) * -1, "commando")
		end
	end

	pl:UnlockItem(args[ 1 ])
	GAMEMODE:SaveData(pl)
	
end )

concommand.Add( "givexp", function( pl, cmd, args )
	if( args[ 1 ] && IsValid( pl ) ) then
		pl:GiveXP( tonumber( args[ 1 ] ) )
	end
end )

concommand.Add( "readfile", function( pl )
	GAMEMODE:ReadData( pl )
end )

concommand.Add( "saveData", function( pl )
	GAMEMODE:SaveData( pl )
end )

concommand.Add( "setClass", function( pl, cmd, args )
	pl.CurrentClass = tostring(args[1])
end )

