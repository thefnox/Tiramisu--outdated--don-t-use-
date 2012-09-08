hook.Add( "KeyPress", "TiramisuHandleDoors", function( ply, key )
	if( key == IN_USE ) then
		local entity = ply:GetEyeTrace( ).Entity
		if ValidEntity( entity ) then
			if(TIRA.IsDoor(entity)) then
				local doorgroup = TIRA.GetDoorGroup(entity) or 0
				local group = TIRA.GetGroup( TIRA.GetCharField( ply, "activegroup" ))
				local groupdoor = 0
				if group and group:CharInGroup(ply) then
					groupdoor = tonumber(group:GetField( "doorgroup" )) or 0
				end
				if entity:GetClass() == "func_door" and doorgroup == groupdoor then --lol
					entity:Fire( "open", "", 0 )
				end
			end
			if( entity:GetClass() == "item_prop" ) then
				ply:ConCommand( "rp_pickup " .. tostring( entity:EntIndex() ) )
			end
		end
	end
end)

--rp_admin adddoor doorgroup [title] [number of building it belongs to] [purchaseable 1/0]. All arguments in brackets are optional.
--Setting two doors to have the same building number means that BOTH doors will be purchased when either of them is owned.
function Admin_AddDoor(ply, cmd, args)
	
	local tr = ply:GetEyeTrace()
	local trent = tr.Entity
	
	if(!TIRA.IsDoor(trent)) then ply:PrintMessage(3, "You must be looking at a door!") return end

	if(table.getn(args) < 1) then ply:PrintMessage(3, "Specify a doorgroup!") return end

	local pos = trent:GetPos()
	local Door = {}
	Door["pos"] = trent:GetPos()
	Door["class"] = trent:GetClass()
	Door["title"] = args[2] or ""
	Door["doorgroup"] = tonumber(args[1])
	Door["building"] = tonumber(args[3])
	Door["purchaseable"] = util.tobool( args[4] )

	table.insert(TIRA.Doors, Door)
	
	TIRA.SendChat(ply, "Door group added to door")

	trent.doorgroup = Door["doorgroup"]
	trent.building = Door["building"]
	trent.purchaseable = Door["purchaseable"]
	trent.title = Door["title"]
	TIRA.SetDoorTitle( trent, Door["title"] )
	
	TIRA.SaveDoors()
	
end

function Admin_SetDoorGroup(ply, cmd, args)
	
	local ent = ents.GetByIndex( args[1] )

	if(table.getn(args) < 2) then ply:PrintMessage(3, "Specify a doorgroup!") return end

	ent.doorgroup = tonumber(args[2])

	for k, v in pairs( TIRA.Doors ) do
		if v["class"] == ent:GetClass() and v["pos"] == ent:GetPos() then
			v["doorgroup"] = tonumber(args[2])
			TIRA.SendChat(ply, "Door group set to " .. args[2])
			TIRA.SaveDoors()
			return --The whole function ends here.
		end
	end

	local Door = {}
	Door["pos"] = ent:GetPos()
	Door["class"] = ent:GetClass()
	Door["title"] = ""
	Door["doorgroup"] = tonumber(args[2])
	Door["building"] = 0
	Door["purchaseable"] = false

	table.insert(TIRA.Doors, Door)
	
	TIRA.SendChat(ply, "Door group set to " .. args[2])
	TIRA.SaveDoors()
	
end

function Admin_SetDoorBuilding(ply, cmd, args)
	
	local ent = ents.GetByIndex( args[1] )

	if(table.getn(args) < 2) then ply:PrintMessage(3, "Specify a building!") return end

	ent.building = tonumber(args[2])

	for _, Door in pairs( TIRA.Doors ) do
		if Door[ "pos" ] == ent:GetPos() then
			Door["building"] = tonumber(args[2])
			TIRA.SendChat(ply, "Door building set to " .. args[2])
			TIRA.SaveDoors()
			return --The whole function ends here.
		end
	end

	local Door = {}
	Door["pos"] = ent:GetPos()
	Door["class"] = ent:GetClass()
	Door["title"] = ""
	Door["doorgroup"] = 0
	Door["building"] = tonumber(args[2])
	Door["purchaseable"] = false

	table.insert(TIRA.Doors, Door)
	
	TIRA.SendChat(ply, "Door building set to " .. args[2])
	TIRA.SaveDoors()
	
end

function Admin_SetDoorTitle(ply, cmd, args)
	
	local ent = ents.GetByIndex( args[1] )

	if(#args < 2) then ply:PrintMessage(3, "Specify a title!") return end

	table.remove(args, 1)
	ent.title = table.concat( args, " " )
	TIRA.SetDoorTitle( ent, ent.title )

	for _, Door in pairs( TIRA.Doors ) do
		if Door[ "pos" ] == ent:GetPos() then
			Door["title"] = ent.title
			TIRA.SendChat(ply, "Door title set to " .. ent.title)
			TIRA.SaveDoors()
			return --The whole function ends here.
		end
	end

	local Door = {}
	Door["pos"] = ent:GetPos()
	Door["class"] = ent:GetClass()
	Door["title"] = ent.title
	Door["doorgroup"] = 0
	Door["building"] = 0
	Door["purchaseable"] = false

	table.insert(TIRA.Doors, Door)
	
	TIRA.SendChat(ply, "Door title set to " .. ent.title)
	TIRA.SaveDoors()
	
end

function Admin_SetDoorPurchaseable(ply, cmd, args)
	
	local ent = ents.GetByIndex( args[1] )

	if(table.getn(args) < 2) then ply:PrintMessage(3, "Specify if purchaseable!") return end

	if args[2] == "true" then
		args[2] = true
	else
		args[2] = false
	end
	
	ent.purchaseable = args[2]

	for _, Door in pairs( TIRA.Doors ) do
		if Door[ "pos" ] == ent:GetPos() then
			Door["purchaseable"] = args[2]
			TIRA.SendChat(ply, "Door purchaseable status set to " .. args[2] )
			TIRA.SaveDoors()
			return --The whole function ends here.
		end
	end

	local Door = {}
	Door["pos"] = ent:GetPos()
	Door["class"] = ent:GetClass()
	Door["title"] = ""
	Door["doorgroup"] = 0
	Door["building"] = 0
	Door["purchaseable"] = args[2]

	table.insert(TIRA.Doors, Door)
	
	TIRA.SendChat(ply, "Door purchaseable status set to " .. tostring(args[2]) )
	TIRA.SaveDoors()
	
end

function PLUGIN.Init()

	TIRA.AdminCommand( "adddoor", Admin_AddDoor, "Add group permissions to a door", true, true, 4 )
	TIRA.AdminCommand( "setdoorgroup", Admin_SetDoorGroup, "Set door group access", true, true, 4 )
	TIRA.AdminCommand( "setdoorbuilding", Admin_SetDoorBuilding, "Assign a door to a building", true, true, 4 )
	TIRA.AdminCommand( "setdoortitle", Admin_SetDoorTitle, "Set a door's default title", true, true, 4 )
	TIRA.AdminCommand( "setdoorpurchaseable", Admin_SetDoorPurchaseable, "Set a door's purchaseable status", true, true, 4 )
	
end