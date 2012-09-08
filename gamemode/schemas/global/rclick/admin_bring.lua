RCLICK.Name = "Bring"
RCLICK.SubMenu = "Admin"

function RCLICK.Condition(target)

	if ( !target or target:IsWorld() ) and LocalPlayer():GetNWInt( "TiramisuAdminLevel", 0 ) > 2 then return true end

end

function RCLICK.Click(target,ply)
 	
 	local tbl = {}
 	local newtbl 

	for k, v in ipairs( player.GetAll() ) do
		table.insert( tbl, v:Nick() )
	end

	TIRA.ChoiceRequest( "Bring a player", "Choose what player to bring", tbl,
	function( text )
		if TIRA.FindPlayer(text) then
			ply:ConCommand("rp_admin bring \""  .. text .. "\"" )
		end
	end,
	function() end, "Accept", "Cancel")

end