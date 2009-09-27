include( 'shared.lua' )



for _, file in ipairs( file.Find( "../gamemodes/"..GM.Folder:gsub( "gamemodes/", "" ).."/gamemode/modules/client/*.lua" ) ) do
	include( "modules/client/"..file )
end

for _, file in ipairs( file.Find( "../gamemodes/"..GM.Folder:gsub( "gamemodes/", "" ).."/gamemode/modules/shared/*.lua" ) ) do
	include( "modules/shared/"..file )
end

--if not SinglePlayer() then
	--[[for _, file in ipairs( file.Find( "../lua/"..GM.Folder:gsub( "gamemodes/", "" ).."/gamemode/modules/client/*.lua" ) ) do
		include( "modules/client/"..file )
	end

	for _, file in ipairs( file.Find( "../lua/"..GM.Folder:gsub( "gamemodes/", "" ).."/gamemode/modules/shared/*.lua" ) ) do
		include( "modules/shared/"..file )
	end	]]
--[[else
	for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/client/*.lua" ) ) do
		include( "modules/client/"..file )
	end

	for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/shared/*.lua" ) ) do
		include( "modules/shared/"..file )
	end	
end]]


function GM:Initialize()
	self.BaseClass.Initialize( self )
	LocalPlayer().ItemList = {}
end


local MaxHealth = 100

local Font = "HUDNumber5"
local Font2 = "CenterPrintText"

local BGCol = Color(0,0,0,150)
local MoneyCol = Color(100,200,100,250)
local TimeCol = Color(200,200,100,250)
local HPCol = Color(240,50,50,250)
local DetectionCol = Color(30,30,200,250)
local WhiteCol = Color(255,255,255,255)

local offsetConstant = 10

local TimerItier = ScrH()-(ScrH()/5)
local StartPt = Bezier.Point(ScrW(),ScrH()-(ScrH()/10))
local EndPt = Bezier.Point(ScrW(),ScrH()/10)
local ControlPt = Bezier.Point(ScrW()-(ScrW()/5),ScrH()/2)
local MovingStartPt = Bezier.Point(ScrW(),(ScrH()-(ScrH()/10))-offsetConstant)
local MovingEndPt = Bezier.Point(ScrW(),(ScrH()/10)+offsetConstant)
local MovingControlPt = Bezier.Point((ScrW()-(ScrW()/5)+offsetConstant),ScrH()/2)

local offsetConstant = 5
local ThiefItier = ScrH()/5
local ThiefHealthStart = Bezier.Point(ScrW()/5,ScrH())
local ThiefHealthEnd = Bezier.Point(0,ScrH()-(ScrH()/5))
local ThiefHealthControl = Bezier.Point(0,ScrH())
local ThiefHealthMovingEnd = Bezier.Point(offsetConstant,ScrH()-(ScrH()/5))
local ThiefHealthMovingStart = Bezier.Point((ScrW()/5)+offsetConstant,ScrH())
local ThiefHealthMovingControl = Bezier.Point(offsetConstant,ScrH())

local HappinessBar1Color = Color(170,170,90,250)
local HapB2Col = Color(20,20,200,250)
local HapB3Col = Color(40,170,40,250)

local move = 20
local HapB2MovingEnd = Bezier.Point(offsetConstant+move,ScrH()-(ScrH()/5))
local HapB2MovingStart = Bezier.Point((ScrW()/5)+offsetConstant+move,ScrH())
local HapB2MovingControl = Bezier.Point(offsetConstant+move,ScrH())

local move = 40
local HapB3MovingEnd = Bezier.Point(offsetConstant+move,ScrH()-(ScrH()/5))
local HapB3MovingStart = Bezier.Point((ScrW()/5)+offsetConstant+move,ScrH())
local HapB3MovingControl = Bezier.Point(offsetConstant+move,ScrH())


function GM:HUDPaint()

	GAMEMODE:HUDDrawTargetID()
	GAMEMODE:DrawDeathNotice( 0.9, 0.1 )
	
	--Stuff Everyone draws
	
	local Time = string.ToMinutesSeconds(RoundTimer.GetCurrentTime())
	surface.SetFont(Font)
	
	
	-- Timer Arch BG
	local stufftodraw = Bezier.TableOfPointsOnQuadraticCurve(BGCol,20,1,TimerItier,TimerItier,StartPt,ControlPt,EndPt)
	for k,v in pairs(stufftodraw) do
		draw.TexturedQuad(v)
	end
	
	--Timer Text
	local offx,offy = surface.GetTextSize(Time)
	
	draw.WordBox( 10, ScrW()-(offx+20), 0, Time, Font, BGCol, TimeCol)

	--Timer Arch FG
	local dist = (RoundTimer.GetCurrentTime()/RoundTimer.RoundTime)*TimerItier
	local stufftodraw2 = Bezier.TableOfPointsOnQuadraticCurve(TimeCol,10,1,TimerItier,dist,MovingStartPt,MovingControlPt,MovingEndPt)
	for k,v in pairs(stufftodraw2) do
		draw.TexturedQuad(v)
	end
	

	if LocalPlayer():GetNWBool("Curator") then
	--Curator Stuff
	
		--Happiness Bar 1 BG
		local stufftodraw = Bezier.TableOfPointsOnQuadraticCurve(BGCol,60,3,ThiefItier,ThiefItier,ThiefHealthStart,ThiefHealthControl,ThiefHealthEnd)
		for k,v in pairs(stufftodraw) do
			draw.TexturedQuad(v)
		end
	
		local ply = LocalPlayer()
		--Happiness Bar 1 FG
		local dist = (ply:GetNWInt("Happ1")/100)*ThiefItier
		local stufftodraw2 = Bezier.TableOfPointsOnQuadraticCurve(HappinessBar1Color,10,3,ThiefItier,dist,ThiefHealthMovingStart,ThiefHealthMovingControl,ThiefHealthMovingEnd)
		for k,v in pairs(stufftodraw2) do
			draw.TexturedQuad(v)
			if k == #stufftodraw2 then
				draw.SimpleText(math.ceil(ply:GetNWInt("Happ1")),Font2,v.x+5,v.y-40,HappinessBar1Color,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end


		--Happiness Bar 2 FG
		local dist = (ply:GetNWInt("Happ2")/100)*ThiefItier
		local stufftodraw2 = Bezier.TableOfPointsOnQuadraticCurve(HapB2Col,10,3,ThiefItier,dist,HapB2MovingStart,HapB2MovingControl,HapB2MovingEnd)
		for k,v in pairs(stufftodraw2) do
			draw.TexturedQuad(v)
			if k == #stufftodraw2 then
				draw.SimpleText(math.ceil(ply:GetNWInt("Happ2")),Font2,v.x+5,v.y-30,HapB2Col,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end


		--Happiness Bar 3 FG
		local dist = (ply:GetNWInt("Happ3")/100)*ThiefItier
		local stufftodraw2 = Bezier.TableOfPointsOnQuadraticCurve(HapB3Col,10,3,ThiefItier,dist,HapB3MovingStart,HapB3MovingControl,HapB3MovingEnd)
		for k,v in pairs(stufftodraw2) do
			draw.TexturedQuad(v)
			if k == #stufftodraw2 then
				draw.SimpleText(math.ceil(ply:GetNWInt("Happ3")),Font2,v.x+5,v.y-20,HapB3Col,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	else
	--Thief Stuff
	
		--HPBar BG
		local stufftodraw = Bezier.TableOfPointsOnQuadraticCurve(BGCol,20,3,ThiefItier,ThiefItier,ThiefHealthStart,ThiefHealthControl,ThiefHealthEnd)
		for k,v in pairs(stufftodraw) do
			draw.TexturedQuad(v)
		end
	
	
		--HPBar FG
		local dist = (LocalPlayer():Health()/MaxHealth)*ThiefItier
		local stufftodraw2 = Bezier.TableOfPointsOnQuadraticCurve(HPCol,10,3,ThiefItier,dist,ThiefHealthMovingStart,ThiefHealthMovingControl,ThiefHealthMovingEnd)
		for k,v in pairs(stufftodraw2) do
			draw.TexturedQuad(v)
		end
	
		local Muny = "$"..math.floor(LocalPlayer():GetNWInt("money"))
	
		surface.SetFont(Font)
		local offx,offy = surface.GetTextSize(Muny)
	
		draw.WordBox( 10, ScrW()-(offx+20),ScrH()-(offy+20), Muny, Font, BGCol, MoneyCol)
		
		--Detection Bar
		local tbl = {}
		tbl["x"] = 0
		tbl["y"] = 0
		tbl["w"] = 20
		tbl["h"] = ScrH()-(ScrH()/5)
		tbl["color"] = BGCol
		tbl["texture"] = draw.NoTexture()
		draw.TexturedQuad(tbl)
		
		local tbl = {}
		tbl["x"] = 5
		tbl["y"] = 5
		tbl["w"] = 10
		tbl["h"] = ((ScrH()-(ScrH()/5))-10)*(LocalPlayer():GetNWInt("Detection")/1000) --yes, it's a number out of 1000. It's more accurate.
		tbl["color"] = DetectionCol
		tbl["texture"] = draw.NoTexture()
		draw.TexturedQuad(tbl)
	end
end

function LerpColor(frac,from,to)
	local col = Color(
		Lerp(frac,from.r,to.r),
		Lerp(frac,from.g,to.g),
		Lerp(frac,from.b,to.b),
		Lerp(frac,from.a,to.a)
	)
	return col
end


usermessage.Hook("StartAlarmCountdown",function(um)
	local AlarmTimestamp = RoundTimer.GetCurrentTime()
	local EndTime = AlarmTimestamp - 15
	hook.Add("HUDPaint","AlarmWarning",function()
		local Time = string.ToMinutesSeconds(math.Clamp(RoundTimer.GetCurrentTime()-EndTime,0,120))
		surface.SetFont(Font)
		local offx,offy = surface.GetTextSize(Time)
		
		draw.WordBox( 5, (ScrW()/2)-(offx/2)-5, (ScrH()-offy)-5, Time, Font, BGCol, LerpColor(math.sin(CurTime()*10),HPCol,TimeCol))
		
		local Text = "Someone has triggered the alarm!"
		local Text2 = "Get out of the museum NOW!"
		local ox,oy = surface.GetTextSize(Text)
		local ox2,oy2 = surface.GetTextSize(Text2)
		
		draw.SimpleText(Text,Font,(ScrW()/2)-(ox/2),ScrH()-(offy+5)-oy-oy2-10,HPCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		draw.SimpleText(Text2,Font,(ScrW()/2)-(ox2/2),ScrH()-(offy+5)-oy2-10,HPCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end)
	timer.Simple(15,function() 
		hook.Remove("HUDPaint","AlarmWarning")
	end)
end)

usermessage.Hook("YouBeenArrested",function(um)
	local ArrestTimestamp = RoundTimer.GetCurrentTime()
	local EndTime = ArrestTimestamp - 60
	hook.Add("HUDPaint","Arrested",function()
		local Time = string.ToMinutesSeconds(math.Clamp(RoundTimer.GetCurrentTime()-EndTime,0,120))
		surface.SetFont(Font)
		local offx,offy = surface.GetTextSize(Time)
		
		draw.WordBox( 5, (ScrW()/2)-(offx/2)-5, (ScrH()-offy)-5, Time, Font, BGCol, TimeCol)
		
		local Text = "Oh no, you got caught in the museum!"
		local Text2 = "Better luck next time."
		
		local ox,oy = surface.GetTextSize(Text)
		local ox2,oy2 = surface.GetTextSize(Text2)
		
		draw.SimpleText(Text,Font,(ScrW()/2)-(ox/2),ScrH()-(offy+5)-oy-oy2-10,HPCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		draw.SimpleText(Text2,Font,(ScrW()/2)-(ox2/2),ScrH()-(offy+5)-oy2-10,HPCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end)
end)

usermessage.Hook("YouveBeenReleased",function(um)
	hook.Remove("HUDPaint","Arrested")
	hook.Add("HUDPaint","Freed",function()
		surface.SetFont(Font)
		
		local Text = "You've been released from prison!"
		local Text2 = "Time to resume your life of crime!"
		local ox,oy = surface.GetTextSize(Text)
		local ox2,oy2 = surface.GetTextSize(Text2)
		
		draw.SimpleText(Text,Font,(ScrW()/2)-(ox/2),ScrH()-10-oy-oy2-10,HPCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		draw.SimpleText(Text2,Font,(ScrW()/2)-(ox2/2),ScrH()-10-oy2-10,HPCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end)
	timer.Simple(5,function() 
		hook.Remove("HUDPaint","Freed")
	end)
end)

usermessage.Hook("StealingProgressBar",function(um)
	local StartTheft = CurTime()
	local Duration = 5
	hook.Add("HUDPaint","Stealing",function()
		local frac = (CurTime()-StartTheft)/Duration
		local tIDFont = "TargetID"
		surface.SetFont(tIDFont)
		
		local SizeX = 150
		local SizeY = 30
		
		local tbl = {}
		tbl["x"] = (ScrW()/2)-(SizeX/2)
		tbl["y"] = 0
		tbl["w"] = SizeX
		tbl["h"] = SizeY
		tbl["color"] = BGCol
		tbl["texture"] = draw.NoTexture()
		draw.TexturedQuad(tbl)
		
		local tbl = {}
		tbl["x"] = (ScrW()/2)-(SizeX/2)+3
		tbl["y"] = 3
		tbl["w"] = (SizeX-6)*frac
		tbl["h"] = SizeY-6
		tbl["color"] = DetectionCol
		tbl["texture"] = draw.NoTexture()
		draw.TexturedQuad(tbl)
		
		local Text = "Stealing..."
		
		draw.SimpleText(Text,tIDFont,(ScrW()/2),15,WhiteCol,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
	timer.Simple(5,function() 
		hook.Remove("HUDPaint","Stealing")
	end)
end)

usermessage.Hook("OpenThiefBuyMenu",function(um)
	if not ValidEntity(LocalPlayer().BuyMenu) then
		LocalPlayer().BuyMenu = vgui.Create("ThiefShop")
	else
		LocalPlayer().BuyMenu:Remove()
	end
end)

local function KeyPressed(ply, code)
	if ply:GetNWBool("Curator") and code == IN_SPEED then
		if not ply.Enabled then ply.Enabled = false end
		ply.Enabled = !ply.Enabled
		if ply.Enabled == false then
			RememberCursorPosition()
		else
			RestoreCursorPosition()
		end
		gui.EnableScreenClicker(ply.Enabled)
	end
end
hook.Add("KeyPress","CuratorKeyPressed",KeyPressed)


local AllowedElements = { 	"CHudChat",
							"CHudCrosshair",
							"CHudGMod",
							"CHudVoiceStatus",
							"CHudVoiceSelfStatus"
						}
function GM:HUDShouldDraw(element)
	return table.HasValue(AllowedElements,element)
end 

local function OpenInventory()
	if not LocalPlayer():GetNWBool("Curator") then
		if ValidEntity(LocalPlayer().Inventory) then
			LocalPlayer().Inventory:Open()
		else
			LocalPlayer().Inventory = vgui.Create("InvPanel")
			LocalPlayer().Inventory:SetPos(20, ScrH()/2-(133+32))
			LocalPlayer().Inventory:SetSize(88, (268+64))
			LocalPlayer().Inventory:Open()
		end
	end

	return false
end
hook.Add("OnSpawnMenuOpen", "OpenInventory", OpenInventory)

function CloseInventory()
	if ValidEntity(LocalPlayer().Inventory) then
		LocalPlayer().Inventory:Close()
	end
end
hook.Add("OnSpawnMenuClose", "CloseInventory", CloseInventory)


function SetupCMenu(msg)
	 if ValidEntity(CMenu) then CMenu:SetVisible(false) CMenu:Remove() CMenu = nil end
	CMenu = vgui.Create("CuratorSpawnM")
	CMenu:SetSize(134, 152)
	CMenu:SetPos(5, 5)
end
usermessage.Hook("SetupCuratorSpawnMenu", SetupCMenu)

local yaw = Angle(0,1,0)
local AddAng = Angle(0,0,0)

function GM:Think()
	if LocalPlayer().GhostIsActive then
		local tr = LocalPlayer():GetEyeTrace()
		if tr and tr.Hit and (not tr.HitSkybox) and tr.HitWorld and not tr.HitNoDraw then
			if (not LocalPlayer().Ghost) or not LocalPlayer().Ghost:IsValid() then
				LocalPlayer().Ghost = ClientsideModel(LocalPlayer().GhostModel, RENDERGROUP_OPAQUE)
			end
			LocalPlayer().Ghost:SetModel(LocalPlayer().GhostModel or "")
			LocalPlayer().Ghost:SetPos(tr.HitPos+(tr.HitNormal*LocalPlayer().GhostItem:GetPosOffset()))
			LocalPlayer().Ghost:SetAngles(tr.HitNormal:Angle()+LocalPlayer().GhostItem:AngularOffset()+AddAng)
			LocalPlayer().Ghost:SetNoDraw(false)
			if input.IsKeyDown(KEY_LBRACKET) then
				AddAng = AddAng - yaw
			elseif input.IsKeyDown(KEY_RBRACKET) then
				AddAng = AddAng + yaw
			end
		elseif LocalPlayer().Ghost and LocalPlayer().Ghost:IsValid() then
			LocalPlayer().Ghost:SetNoDraw(true)
		end
	elseif LocalPlayer().Ghost and LocalPlayer().Ghost:IsValid() then
		LocalPlayer().Ghost:SetNoDraw(true)
	end
end 

function GM:GUIMousePressed(mc)
    if LocalPlayer().GhostIsActive and mc == 107 then
        LocalPlayer().GhostIsActive = false
        local item = LocalPlayer().GhostItem
        RunConsoleCommand("curator_spawn_object",LocalPlayer().GhostType,item:GetName(),tostring(LocalPlayer().Ghost:GetAngles()),tostring(LocalPlayer().Ghost:GetPos()))
        LocalPlayer().Ghost:Remove()
        LocalPlayer().Ghost = nil
        LocalPlayer().GhostItem = nil
        LocalPlayer().GhostModel = nil
        LocalPlayer().GhostType = nil
		AddAng = Angle(0,0,0)
	elseif LocalPlayer().GhostIsActive and mc == 108 then
		LocalPlayer().GhostIsActive = false
		if LocalPlayer().Ghost then LocalPlayer().Ghost:Remove() end
        LocalPlayer().Ghost = nil
        LocalPlayer().GhostItem = nil
        LocalPlayer().GhostModel = nil
        LocalPlayer().GhostType = nil
		AddAng = Angle(0,0,0)
    end
end 

concommand.Add("OpenEndGameWindow", function()
	local CurCash = 0
	local ThiefCash = 0
	local Winner = ""
	for k,v in ipairs(player.GetAll()) do
		if v:GetNWBool("Curator") then
			CurCash = v:GetNWInt("money")
		else
			ThiefCash = ThiefCash + v:GetNWInt("money")
		end
	end
	if CurCash >= ThiefCash then
		Winner = "The Curator has won!"
	else
		Winner = "The Thieves have won!"
	end
    local ply = LocalPlayer()
    ply.Endgame = vgui.Create("DPanel")
    ply.Endgame:SetPos(0,0)
    ply.Endgame:SetSize(ScrW(),ScrH())
	ply.Endgame.PaintOver = function()
		draw.SimpleText(Winner,Font,(ScrW()/2),40,WhiteCol,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.RoundedBox(20,20,100,ScrW()-40,(ScrH()-100)/2-30,BGCol)
		draw.RoundedBox(20,20,(ScrH()-100)/2+30,ScrW()-40,ScrH()-160,BGCol)
	end
	
	WorldSound("TV.Tune",ply:GetPos(),165,100)
end)

concommand.Add("CloseEndGameWindow", function()
	local ply = LocalPlayer()
    if ValidEntity(ply.Endgame) then
        ply.Endgame:Remove()
    end
end)