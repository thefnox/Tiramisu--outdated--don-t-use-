-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_binds.lua
-- Changes what keys do.
-------------------------------

CAKE.ContextEnabled = false;

local function ToggleThirdperson( um )

	if CAKE.Thirdperson:GetBool() then
		RunConsoleCommand( "rp_thirdperson", "0" )
	else
		RunConsoleCommand( "rp_thirdperson", "1" )
	end

end
usermessage.Hook( "togglethirdperson", ToggleThirdperson)

local function ToggleInventory( um )

	CAKE.SetActiveTab( "Inventory" )

end
usermessage.Hook( "toggleinventory", ToggleInventory)

function GM:PlayerBindPress( ply, bind, pressed )

	if( LocalPlayer( ):GetNWInt( "charactercreate" ) == 1 ) then
	
		if( bind == "+forward" or bind == "+back" or bind == "+moveleft" or bind == "+moveright" or bind == "+jump" or bind == "+duck" ) then return true; end -- Disable ALL movement keys.
	
	end
	
	if( bind == "+use" ) then
	
		local trent = LocalPlayer( ):GetEyeTrace( ).Entity;
		
		if( trent != nil and trent:IsValid( ) and CAKE.IsDoor( trent ) ) then
		
			LocalPlayer( ):ConCommand( "rp_opendoor" );
			
		end
		
	end

end

function GM:ScoreboardShow( )

	CAKE.ContextEnabled = true;
	CAKE.MenuOpen = true
	gui.EnableScreenClicker( true )
	HiddenButton:SetVisible( true );

	if QuickMenu then
		QuickMenu:Remove()
		Quickmenu = nil
	end

	QuickMenu = vgui.Create("DFrame");
	QuickMenu:SetSize( 130, 400 )
	QuickMenu:SetPos( ScrW() + 130, 200 )
	QuickMenu:SetTitle( "" )
	QuickMenu:SetDraggable( false ) -- Draggable by mouse?
	QuickMenu:ShowCloseButton( false ) -- Show the close button?
	QuickMenu.Paint = function() end

	local lastpos = 0
	for k, v in pairs( CAKE.MenuTabs ) do
		lastpos = lastpos + 27
		local label = vgui.Create( "DButton", QuickMenu )
		label:SetText( k )
		label:SetSize( 120, 25 )
		label:SetTextColor( Color( 255, 255, 255 ) )
		label.DoClick = function()
			CAKE.SetActiveTab(k)
		end
		label:SetPos( 5, lastpos)
		label:SetExpensiveShadow( 1, Color( 10, 10, 10, 255 ) )
	end

	VitalsMenu = vgui.Create( "DFrame" )
	VitalsMenu:SetSize( 340, 230 )
	VitalsMenu:SetTitle( "" )
	VitalsMenu:SetVisible( true )
	VitalsMenu:SetDraggable( false )
	VitalsMenu:ShowCloseButton( false )
	VitalsMenu:SetDeleteOnClose( true )
	VitalsMenu:SetPos( -340, 200 )
	VitalsMenu.Paint = function()
	end

	local PlayerInfo = vgui.Create( "DPanelList", VitalsMenu )
	PlayerInfo:SetSize( 340, 200 )
	PlayerInfo:SetPos( 0, 23 )
	PlayerInfo:SetPadding(10);
	PlayerInfo:SetSpacing(10);
	PlayerInfo:EnableHorizontal(false);
	function PlayerInfo:Paint()
	end

	local icdata = vgui.Create( "DForm" );
	icdata:SetPadding(4);
	icdata:SetName(LocalPlayer():Nick() or "");

	local FullData = vgui.Create("DPanelList");
	FullData:SetSize(0, 84);
	FullData:SetPadding(10);

	local DataList = vgui.Create("DPanelList");
	DataList:SetSize(0, 64);

	local spawnicon = vgui.Create( "SpawnIcon");
	spawnicon:SetModel(LocalPlayer():GetNWString( "model", LocalPlayer():GetModel()) );
	spawnicon:SetSize( 64, 64 );
	DataList:AddItem(spawnicon);

	local DataList2 = vgui.Create( "DPanelList" )

	local label2 = vgui.Create("DLabel");
	label2:SetText("Title: " .. LocalPlayer():GetNWString("title", ""));
	DataList2:AddItem(label2);

	local label3 = vgui.Create("DLabel");
	label3:SetText("Title 2: " .. LocalPlayer():GetNWString("title2", ""));
	DataList2:AddItem(label3);

	local label4 = vgui.Create("DLabel");
	label4:SetText( CurrencyTable.name .. ": " .. LocalPlayer():GetNWString("money", "0" ));
	DataList2:AddItem(label4);

	local Divider = vgui.Create("DHorizontalDivider");
	Divider:SetLeft(spawnicon);
	Divider:SetRight(DataList2);
	Divider:SetLeftWidth(64);
	Divider:SetHeight(64);

	DataList:AddItem(spawnicon);
	DataList:AddItem(DataList2);
	DataList:AddItem(Divider);

	FullData:AddItem(DataList)

	icdata:AddItem(FullData)

	local vitals = vgui.Create( "DForm" );
	vitals:SetPadding(4);
	vitals:SetName("Vital Signs");

	local VitalData = vgui.Create("DPanelList");
	VitalData:SetAutoSize(true)
	VitalData:SetPadding(10);
	vitals:AddItem(VitalData);

	local healthstatus = ""
	local hp = LocalPlayer():Health();

	if(!LocalPlayer():Alive()) then healthstatus = "Dead";
	elseif(hp > 95) then healthstatus = "Healthy";
	elseif(hp > 50 and hp < 95) then healthstatus = "OK";
	elseif(hp > 30 and hp < 50) then healthstatus = "Near Death";
	elseif(hp > 1 and hp < 30) then healthstatus = "Death Imminent"; end

	local health = vgui.Create("DLabel");
	health:SetText("Vitals: " .. healthstatus);
	VitalData:AddItem(health);

	PlayerInfo:AddItem(icdata)
	PlayerInfo:AddItem(vitals)

	local posx, posy
	timer.Create( "quickmenuscrolltimer", 0.01, 0, function()
		if QuickMenu then
			posx, posy = QuickMenu:GetPos( )
			QuickMenu:SetPos( Lerp( 0.2, posx, ScrW() - 150 ), 200 )
			if VitalsMenu then
				posx, posy = VitalsMenu:GetPos( )
				VitalsMenu:SetPos( Lerp( 0.2, posx, 20 ), 200)
			end
		else
			timer.Destroy( "quickmenuscrolltimer" )
		end
	end )
	
end

function GM:ScoreboardHide( )

	CAKE.MenuOpen = false
	CAKE.ContextEnabled = false;
	gui.EnableScreenClicker( false );
	HiddenButton:SetVisible( false );

	local posx, posy
	if QuickMenu then
		QuickMenu:Remove()
		QuickMenu = nil
	end
	if VitalsMenu then
		VitalsMenu:Remove()
		VitalsMenu = nil
	end
	
end

function GM:StartChat( )

	LocalPlayer( ):ConCommand( "rp_openedchat" );
	
end

function GM:FinishChat( )

	LocalPlayer( ):ConCommand( "rp_closedchat" );
	
end