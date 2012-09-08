ITEM.Name = "First Aid Kit"
ITEM.Class = "firstaidkit"
ITEM.Description = "Hold near patient then press actuator"
ITEM.Model = "models/Items/healthkit.mdl"
ITEM.Purchaseable = true
ITEM.Price = 25
ITEM.ItemGroup = 3
ITEM.Unusable = true
ITEM.RightClick = {
	["Revive"] = "UseItem"
}


function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove()

end

function ITEM:UseItem(ply)
	

	local id = self:GetNWString("id")

	if !TIRA.GetUData(id , "lastrevive") then
		TIRA.SetUData(id , "lastrevive", -99999) 
	end

	if !ply.ReviveCooldown then
		ply.ReviveCooldown = -99999
	end

	if (ply.ReviveCooldown + 120) > os.time() then
		TIRA.SendChat(ply, "Please wait " .. math.floor(ply.ReviveCooldown + 120 - os.time()) .. " seconds until you can revive again." )
		return
	end

	if (TIRA.GetUData(id , "lastrevive") + 120) > os.time() then
		TIRA.SendChat(ply, "Please wait " .. math.floor(TIRA.GetUData(id , "lastrevive")+ 120 - os.time())  .. " seconds for this unit to be usable again." )
		return
	end

	if ply:GetNWInt("deathmode",0) > 0 then
		TIRA.SendChat(ply, "*beep* Anabolic Steroids Injected")
		ply:Spawn()
		if ValidEntity(ply.rag) then
			ply:SetPos(ply.rag:GetPos() + Vector( 0, 0, 30 ))
			ply.rag:Remove()
			ply.rag = nil
		else
			ply:SetPos(self:GetPos() + Vector( 0, 0, 30 ))
		end
		ply:SetHealth(15)
		ply.ReviveCooldown = os.time()
		TIRA.SetUData(id, "lastrevive", os.time()) 
		return
	else
		for _, pl in pairs(ents.FindInSphere(self:GetPos(), 100)) do
			if ValidEntity(pl) and pl:IsTiraPlayer() and pl:GetNWInt("deathmode",0) > 0 then
				pl:Spawn()
				pl:SetHealth()
				pl:SetPos(ply:CalcDrop() + Vector( 0, 0, 6 ))
				TIRA.SendChat(ply, "*beep* Anabolic Steroids Injected")
				TIRA.SendChat(pl, "*beep* Anabolic Steroids Injected")
				if ValidEntity( pl.rag ) then
					pl.rag:Remove()
				end
				pl.rag = nil
				ply.ReviveCooldown = os.time()
				TIRA.SetUData(id, "lastrevive", os.time()) 
				return
			end
		end
	end

	TIRA.SendChat(ply, "*beep* No target found")

end