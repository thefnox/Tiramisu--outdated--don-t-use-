RCLICK.Name = "Lock"
RCLICK.SubMenu = "Door"

function RCLICK.Condition(target)

if TIRA.IsDoor(target) then return true end

end

function RCLICK.Click(target,ply)

	ply:ConCommand("rp_lockdoor " .. target:EntIndex())

end