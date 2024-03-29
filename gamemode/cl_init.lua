include( 'shared.lua' )
include( 'cl_scoreboard.lua' )


for _, file in ipairs( file.Find( "../gamemodes/"..GM.Folder:gsub( "gamemodes/", "" ).."/gamemode/modules/client/*.lua" ) ) do
	include( "modules/client/"..file )
end

for _, file in ipairs( file.Find( "../gamemodes/"..GM.Folder:gsub( "gamemodes/", "" ).."/gamemode/modules/shared/*.lua" ) ) do
	include( "modules/shared/"..file )
end


for _, file in ipairs( file.Find( "../lua/"..GM.Folder:gsub( "gamemodes/", "" ).."/gamemode/modules/client/*.lua" ) ) do
	include( "modules/client/"..file )
end

for _, file in ipairs( file.Find( "../lua/"..GM.Folder:gsub( "gamemodes/", "" ).."/gamemode/modules/shared/*.lua" ) ) do
	include( "modules/shared/"..file )
end	

for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/client/*.lua" ) ) do
	include( "modules/client/"..file )
end

for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/shared/*.lua" ) ) do
	include( "modules/shared/"..file )
end

for _, file in ipairs( file.Find( "../lua_temp/curator/gamemode/modules/client/*.lua")) do
	include( "modules/client/"..file )
end

for _, file in ipairs( file.Find( "../lua_temp/curator/gamemode/modules/shared/*.lua")) do
	include( "modules/shared/"..file )
end



function GM:Initialize()
	self.BaseClass.Initialize( self )
	LocalPlayer().ItemList = {}
	
	util.Effect("CuratorNodeEffect",EffectData())
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
local ThiefItier = (ScrH()/5)+50
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

	if LocalPlayer():Team() == TEAM_DEAD then return end
	
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
		local stufftodraw = Bezier.TableOfPointsOnQuadraticCurve(BGCol,60,4,ThiefItier,ThiefItier,ThiefHealthStart,ThiefHealthControl,ThiefHealthEnd)
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
		
		if LocalPlayer():GetNWInt("Detection") < 750 then
			local tbl = {}
			tbl["x"] = 5
			tbl["y"] = 5
			tbl["w"] = 10
			tbl["h"] = ((ScrH()-(ScrH()/5))-10)*(LocalPlayer():GetNWInt("Detection")/1000) --yes, it's a number out of 1000. It's more accurate.
			tbl["color"] = DetectionCol
			tbl["texture"] = draw.NoTexture()
			draw.TexturedQuad(tbl)
		else
			local tbl = {}
			tbl["x"] = 5
			tbl["y"] = 5
			tbl["w"] = 10
			tbl["h"] = ((ScrH()-(ScrH()/5))-10)*(LocalPlayer():GetNWInt("Detection")/1000)
			tbl["color"] = LerpColor(math.sin(CurTime()*10),DetectionCol,HPCol)
			tbl["texture"] = draw.NoTexture()
			draw.TexturedQuad(tbl)
		end
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
	local EndTime = AlarmTimestamp - 25
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
	timer.Simple(25,function() 
		hook.Remove("HUDPaint","AlarmWarning")
	end)
end)

usermessage.Hook("YouBeenArrested",function(um)
	local ArrestTimestamp = RoundTimer.GetCurrentTime()
	local EndTime = ArrestTimestamp - 45
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
	local Duration = 3
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
	timer.Simple(3,function() 
		hook.Remove("HUDPaint","Stealing")
		if LocalPlayer().Inventory then
			LocalPlayer().Inventory:UpdateItems()
			LocalPlayer().Inventory:Close()
		end
	end)
end)

usermessage.Hook("OpenThiefBuyMenu",function(um)
	if not ValidEntity(LocalPlayer().BuyMenu) then
		LocalPlayer().BuyMenu = vgui.Create("ThiefShop")
	else
		LocalPlayer().BuyMenu:Remove()
	end
end)

local function KeyRelease(ply, code)
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
hook.Add("KeyRelease","CuratorKeyPressed",KeyRelease)


local AllowedElements = { 	"CHudChat",
							"CHudCrosshair",
							"CHudGMod",
							"CHudVoiceStatus",
							"CHudVoiceSelfStatus"
						}
function GM:HUDShouldDraw(element)
	return table.HasValue(AllowedElements,element) or (element == "CHudWeaponSelection" and not LocalPlayer():GetNWBool("Curator"))
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
	else
		gui.EnableScreenClicker(true)
	end

	return false
end
hook.Add("OnSpawnMenuOpen", "OpenInventory", OpenInventory)

local function CloseInventory()
	if ValidEntity(LocalPlayer().Inventory) then
		LocalPlayer().Inventory:Close()
	else
		gui.EnableScreenClicker(false)
	end
end
hook.Add("OnSpawnMenuClose", "CloseInventory", CloseInventory)


local function SetupCMenu(msg)
	if ValidEntity(CMenu) then CMenu:SetVisible(false) CMenu:Remove() CMenu = nil MainP:Remove() MainP = nil end
	--if ValidEntity(CMenu) then CMenu:SetVisible(false) CMenu:Remove() CMenu = nil end
	CMenu = vgui.Create("CuratorSpawnM")
	CMenu:SetSize(134, 152)
	CMenu:SetPos(5, 5)
end
usermessage.Hook("SetupCuratorSpawnMenu", SetupCMenu)

local function RecieveCuratorEntItem(um)
	local idx = um:ReadLong()
	local itm = um:ReadString()
	local itpe = um:ReadString()
	local ent = ents.GetByIndex(idx)
	local item = _G[itpe].GetItem(itm)
	
	if ent and ent:IsValid() and item then
		ent.Item = item
		ent.IType = itpe
	end
end
usermessage.Hook("RecieveCuratorEntItem",RecieveCuratorEntItem)

usermessage.Hook("RecieveNodeGuardPos",function(um)
	local pos = um:ReadVector()
	if LocalPlayer():GetNWBool("Curator") then
		if not LocalPlayer().NodePositions then LocalPlayer().NodePositions = {} end
		LocalPlayer().NodePositions[tostring(pos)] = pos
	end
end)

usermessage.Hook("KillGuardNodeAt",function(um)
	local pos = um:ReadVector()
	if not LocalPlayer().NodePositions then return end
	LocalPlayer().NodePositions[tostring(pos)] = nil
end)

local yaw = Angle(0,2.5,0)
local AddAng = Angle(0,0,0)
local StdRot = Angle(90,0,0)
--[[local snd = Sound("music/hl2_song29.mp3")
local duration = SoundDuration(snd)
local NextEndTime = 0

concommand.Add("StopRepeatingBGMusic",function(ply,cmd,args) NextEndTime = math.huge end)
concommand.Add("StartupBGMusic",function(ply,cmd,args) if NextEndTime == math.huge then NextEndTime = CurTime() end  end)]]

function GM:Think()
	--[[
	if NextEndTime <= CurTime() then
		NextEndTime = CurTime() + duration
		surface.PlaySound( snd )
	end
	]]
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
			if input.IsKeyDown(KEY_LBRACKET) or input.IsKeyDown(KEY_N) then
				AddAng = AddAng - yaw
			elseif input.IsKeyDown(KEY_RBRACKET) or input.IsKeyDown(KEY_M) then
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
    if LocalPlayer().GhostIsActive and mc == 107 and LocalPlayer().GhostIsBeingMoved then
		LocalPlayer().GhostIsBeingMoved = false
        LocalPlayer().GhostIsActive = false
        local item = LocalPlayer().GhostItem
        RunConsoleCommand("CuratorMoveDone",LocalPlayer().GhostEntIndex,tostring(LocalPlayer().Ghost:GetAngles()),tostring(LocalPlayer().Ghost:GetPos()))
        LocalPlayer().Ghost:Remove()
        LocalPlayer().Ghost = nil
        LocalPlayer().GhostItem = nil
        LocalPlayer().GhostModel = nil
        LocalPlayer().GhostType = nil
		LocalPlayer().GhostEntIndex = nil
		AddAng = Angle(0,0,0)
	elseif LocalPlayer().GhostIsActive and mc == 107 then
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
		LocalPlayer().GhostIsBeingMoved = false
		LocalPlayer().GhostEntIndex = nil
		AddAng = Angle(0,0,0)
	elseif mc == 108 and LocalPlayer():GetNWBool("Curator") then
		local tr = LocalPlayer():GetEyeTrace()
		if tr.Entity and string.find(tr.Entity:GetClass(),"curator_") and not string.find(tr.Entity:GetClass(),"junk") then
			local MenuButtonOptions = DermaMenu()
			MenuButtonOptions:AddOption("Remove", function() Derma_Query("Are you sure you want to remove this?\nYou will recieve 25% of its original price.","Confirmation Dialogue","Yes",function() RunConsoleCommand("CuratorSellOff",tr.Entity:EntIndex()) end,"No",function() end) end )
			MenuButtonOptions:AddOption("Move", function() Derma_Query("Are you sure you'd like to move this object?","Confirmation Dialogue","Yes",function()
				if tr.Entity.Item then
					LocalPlayer().GhostIsBeingMoved = true
					LocalPlayer().GhostEntIndex = tr.Entity:EntIndex()
					LocalPlayer().GhostIsActive = true
					LocalPlayer().GhostModel = tr.Entity:GetModel()
					if (not LocalPlayer().Ghost) or not LocalPlayer().Ghost:IsValid() then
						LocalPlayer().Ghost = ClientsideModel(LocalPlayer().GhostModel, RENDERGROUP_OPAQUE)
					end
					LocalPlayer().Ghost:SetModel(LocalPlayer().GhostModel or "")
					LocalPlayer().Ghost:SetNoDraw(false)
					LocalPlayer().GhostItem = tr.Entity.Item
					LocalPlayer().GhostType = tr.Entity.IType
				else
					print("NO ITEM FOUND: ALL YOUR BASE ARE BELONG TO US. ~ CATS")
				end
			end,"No",function() end) end )
			if tr.Entity.IType and tr.Entity.IType == "Security" then
				MenuButtonOptions:AddOption("Harden (EMP Protection)", function() Derma_Query("Are you sure you want to harden this?\nIt's costs anywhere from $500 to 1/2 the item's original cost!","Confirmation Dialogue","Yes",function() RunConsoleCommand("CuratorHardenSecurity",tr.Entity:EntIndex()) end,"No",function() end) end )
			end
			MenuButtonOptions:AddOption("Close", function() end )
			MenuButtonOptions:Open()
			return
		end
    end
end 

concommand.Add("OpenEndGameWindow", function()
	local CurCash = 0
	local ThiefCash = 0
	local Winner = ""
	for k,v in ipairs(player.GetAll()) do
		if v:GetNWBool("Curator") then
			CurCash = v:GetNWInt("money") + v:GetNWInt("liquid")
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
		
		local BottomX,BottomY = 20,(ScrH()-100)/2+100
		local BottomW,BottomH = ScrW()-40,ScrH()-((ScrH()-100)/2+100)-30
		draw.RoundedBox(20,BottomX,BottomY,BottomW,BottomH,BGCol)
			
		local tIDFont = "TargetID"
		surface.SetFont(tIDFont)
		
		local fntw,fnth = surface.GetTextSize(tIDFont)
		
		
		draw.SimpleText("Thief Stats",tIDFont,ScrW()/2,95-fnth,HPCol,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
				
				
		local MaxNumPlayersShown = math.floor(((ScrH()-100)/2-30)/(fnth+4))
		
		local thieves = player.GetAll( )
		local removal = nil
		local curator = nil
		for k,v in ipairs(thieves) do
			if v:GetNWBool("Curator") then
				removal = k
				curator = v
				break
			end
		end
		if removal then
			table.remove(thieves,removal)
		end
		
		
		for i=1,MaxNumPlayersShown do
			if thieves[i] and i ~= MaxNumPlayersShown then
				local dat = thieves[i]
				draw.SimpleText(dat:Nick(),tIDFont,24,100+((fnth+4)*i),team.GetColor(dat:Team()),TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText("$"..dat:GetNWInt("money"),tIDFont,ScrW()-44,100+((fnth+4)*i),team.GetColor(dat:Team()),TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			elseif i == MaxNumPlayersShown then
				local Text = "Total Cash: $"..ThiefCash
				local ox,oy = surface.GetTextSize(Text)
				draw.SimpleText(Text,tIDFont,ScrW()-ox-24,95+((fnth+4)*i),HPCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			end
		end
		
		do --Curator endgame stuff, the extra layer makes it indent better, and gives it it's own set of local variables.
			draw.SimpleText("Curator Stats",tIDFont,ScrW()/2,BottomY-fnth,team.GetColor(curator:Team()),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
			draw.SimpleText(curator:Nick(),tIDFont,BottomX+20,BottomY+20,team.GetColor(curator:Team()),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("Money: $"..math.Round(curator:GetNWInt("money")),tIDFont,BottomX+20,(BottomY+20)+(fnth+4),team.GetColor(curator:Team()),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("Liquid: $"..math.Round(curator:GetNWInt("liquid")),tIDFont,BottomX+20,(BottomY+20)+((fnth+4)*2),team.GetColor(curator:Team()),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("Total: $"..math.Round(curator:GetNWInt("liquid")+curator:GetNWInt("money")),tIDFont,BottomX+20,(BottomY+20)+((fnth+4)*3),team.GetColor(curator:Team()),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText("Amount of Art at Endgame: "..#ents.FindByClass("curator_art"),tIDFont,BottomX+20,(BottomY+20)+((fnth+4)*5),team.GetColor(curator:Team()),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			local securityAmt = 0
			securityAmt = securityAmt + #ents.FindByClass("curator_camera")
			securityAmt = securityAmt + #ents.FindByClass("curator_pressureplate")
			securityAmt = securityAmt + #ents.FindByClass("curator_turret")
			securityAmt = securityAmt + #ents.FindByClass("curator_laser")
			securityAmt = securityAmt + #ents.FindByClass("curator_laser_grid")

			draw.SimpleText("Amount of Security at Endgame: "..securityAmt,tIDFont,BottomX+20,(BottomY+20)+((fnth+4)*6),team.GetColor(curator:Team()),TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end
	
	hook.Remove("HUDPaint","Stealing")
	hook.Remove("HUDPaint","Freed")
	hook.Remove("HUDPaint","Arrested")
	hook.Remove("HUDPaint","AlarmWarning")
	WorldSound("TV.Tune",ply:GetPos(),165,100)
	LocalPlayer().NodePositions = {}
end)

concommand.Add("CloseEndGameWindow", function()
	local ply = LocalPlayer()
    if ValidEntity(ply.Endgame) then
        ply.Endgame:Remove()
    end
	hook.Remove("HUDPaint","Stealing")
	hook.Remove("HUDPaint","Freed")
	hook.Remove("HUDPaint","Arrested")
	hook.Remove("HUDPaint","AlarmWarning")
end)

usermessage.Hook("RecieveLadder",function(um)
	local maxs = um:ReadVector()
	local mins = um:ReadVector()
	if not CuratorLadderTable then CuratorLadderTable = {} end
	table.insert(CuratorLadderTable,{Max = maxs, Min = mins})
end)

local RedCol = Color(255,0,0,255)

local CuratorIconHelp = {"These are the Curator Spawn Menu Icons,",
"You click on one of these to open up (or", 
"close) its designated subcategory.",
"The Lock - Security Features",
"The 3 People - Family-Based Art (least)",
"The Top Hat and Cane Guy - Fancy Art (most)",
"The 1 Person - Enthusist Art (middle)",
"",
"Shift Toggles Your Mouse.",
"",
"Right Clicking on a spawn icon shows", 
"detailed information on that item.",
"",
"Right clicking on an object you've spawned",
"gives you the options to either move, remove,",
"or harden it. Moving takes 7 seconds, removing",
"gives 25% of the original price, and hardening",
"protects that security feature from EMPs."}

local CuratorHappinessHelp = {"This the museum's customer happiness",
"bar. There are 3 different types:",
"Family (Yellow) - Pays the least",
"Enthusist (Blue) - Pays Middle Ammount",
"Collector/Fancy (Green) - Pays the most.",
"The money your earn each minute on payday",
"is determined by these 3 values, the higher",
"the better!"}

local CuratorTimerHelp = {"This is the timer. It shows the ammount of ",
"time remaining in the round. Your payday",
"is every minute on the minute. Happiness",
"decreases a bit on each payday."}

local CuratorSpawnMenuHelp = {"This is the spawn menu area, Once you've ",
"selected an icon on the left, the items from",
"that category that you can spawn show up here."}

local ThiefDetectionHelp = {"This is your detection bar, when it is ",
"filled, the museum alarm goes off!",
"Security cameras, lasers, and",
"pressure plates all increase your",
"detection! (It fills from top to",
"bottom, FYI)"}

local ThiefHPHelp = {"This is your HPBar, when it's empty,",
"You're dead."}

local ThiefStealingHelp = {"This is your stealing progress bar area;",
"It appears when you are stealing something.",
"Stealing takes 3 seconds. (And another useful ",
"tidbit of information: Security features take",
"5 seconds to active, 7 seconds to recover from",
"an EMP, and the museum alarm arrests everybody",
"in the museum after 10 seconds! Being arrested",
"removes you form the game for 60 seconds!)"}

local ThiefTimerHelp = {"This is the round timer, a round", 
"is 10 minutes long, normally."}

usermessage.Hook("OpenHelp",function(um)
	local ply = LocalPlayer()
	if not ply.Open then
		ply.Open = true
		if ply:GetNWBool("Curator") or util.tobool(um:ReadLong()) then
			HelpMenu("Curator")
		else
			HelpMenu()
		end
		hook.Add("HUDPaint","CuratorHUDPaintHelp",function() 
			if ply:GetNWInt("Curator") then --Curator Help Stuff
				surface.SetDrawColor( 255,0,0,255 )
				surface.DrawOutlinedRect(5,5, 134, 152 )
				surface.DrawOutlinedRect(4,4, 136, 154 )
				surface.DrawOutlinedRect(3,3, 138, 156 )
				
				
				local tIDFont = "TargetID"
				surface.SetFont(tIDFont)
		
				local fntw,fnth = surface.GetTextSize(tIDFont)
				
				surface.DrawLine(141,159,5,160+(fnth))
				
				for k,v in ipairs(CuratorIconHelp) do
					draw.SimpleText(v,tIDFont,5,160+(fnth*k),RedCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				end
				
				surface.DrawOutlinedRect(144,5, 532, 136 )
				surface.DrawOutlinedRect(143,4, 534, 138 )
				surface.DrawOutlinedRect(142,3, 536, 140 )
				surface.DrawLine(142+536,143,ScrW()/2,145+fnth)

				
				for k,v in ipairs(CuratorSpawnMenuHelp) do
					draw.SimpleText(v,tIDFont,ScrW()/2, 145+(fnth*k),RedCol,TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
				
				surface.DrawOutlinedRect(0,ScrH()-(ScrH()/5), ScrW()/4, ScrH()/5 )
				surface.DrawOutlinedRect(0,ScrH()-(ScrH()/5)-1, ScrW()/4+1, ScrH()/5+2 )
				surface.DrawOutlinedRect(0,ScrH()-(ScrH()/5)-2, ScrW()/4+2, ScrH()/5+4 )
				surface.DrawLine(ScrW()/4,ScrH()-(ScrH()/5),ScrW()/4+10,ScrH()-(ScrH()/3.8)+fnth)
				
				for k,v in ipairs(CuratorHappinessHelp) do
					draw.SimpleText(v,tIDFont,ScrW()/4+10, ScrH()-(ScrH()/3.8)+(fnth*k),RedCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				end
				
				surface.DrawOutlinedRect(ScrW()-ScrW()/6,1,ScrW()/6,ScrH()/10*9)
				surface.DrawOutlinedRect(ScrW()-ScrW()/6-1,0,ScrW()/6+2,ScrH()/10*9+2)
				surface.DrawOutlinedRect(ScrW()-ScrW()/6-2,0,ScrW()/6+4,ScrH()/10*9+4)
				surface.DrawLine(ScrW()-(fntw*8), 300+(fnth),ScrW()-ScrW()/6,1)
				
				for k,v in ipairs(CuratorTimerHelp) do
					draw.SimpleText(v,tIDFont,ScrW()-(fntw*8), 300+(fnth*k),RedCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				end
			else --Thief help stuff
				surface.SetDrawColor( 255,0,0,255 )
				
				local tIDFont = "TargetID"
				surface.SetFont(tIDFont)
		
				local fntw,fnth = surface.GetTextSize(tIDFont)
				
				for k,v in ipairs(ThiefDetectionHelp) do
					draw.SimpleText(v,tIDFont,35,160+(fnth*k),RedCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				end
				
				surface.DrawOutlinedRect((ScrW()/2)-75,0,150,30)
				
				for k,v in ipairs(ThiefStealingHelp) do
					draw.SimpleText(v,tIDFont,ScrW()/2, 5+(fnth*k),RedCol,TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
				
				for k,v in ipairs(ThiefHPHelp) do
					draw.SimpleText(v,tIDFont,ScrW()/10, ScrH()-(ScrH()/5)+(fnth*k),RedCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				end
				
				for k,v in ipairs(ThiefTimerHelp) do
					draw.SimpleText(v,tIDFont,ScrW()-(fntw*6), 300+(fnth*k),RedCol,TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				end
			end
		end)
	else
		ply.Open = nil
		hook.Remove("HUDPaint","CuratorHUDPaintHelp")
		if ply.DHelp and ValidEntity(ply.DHelp) then HelpMenu() else ply.DHelp = nil end
	end
end)

local CuratorHelpCategories = {}
CuratorHelpCategories["Basic"] = {"WELCOME TO CURATOR!",
"",
"As the Curator your goal is to create a thiving",
"museum and to protectect it from thieves!",
"",
"As little note: If you have no art in play, you",
"lose $100 per think."}
CuratorHelpCategories["Controls"] = {"Controls:",
"",
"W - Forward",
"A - Left",
"S - Back",
"D - Right",
"Space - Up (Normal controls while in noclip, essentially.)",
"Shift - Toggle Between Cursor Mode and Freelook Mode",
"[ Or N - Rotate an object attached to your mouse",
"] Or M - Rotate an object attached to your mouse in the opposite direction",
"F1 - Open/Close Help HUD/Menu (But you already knew that, right?)"}
CuratorHelpCategories["Spawning Objects"] = {"How to spawn an object:",
"",
"1. Click on the item's spawn icon.",
"2. Position the object in the world using your mouse.",
"3. Use [ and ] to rotate the object if desired.",
"4. Left click to spawn the object."}
CuratorHelpCategories["Advanced"] = {"Advanced Gameplay Information:",
"",
"- You can right click on an object to get a popup menu of ",
"   options for it.",
"- These options are Remove, Move, if it's a secutity item, Harden, and Close.",
"- Remove removes the object and returns 25% of its original cost to you.",
"- Move allows you to move the object. It attaches the object to your cursor",
"   as if you were spawning an object normally. Once you have clicked on a",
"   location, a ghost will appear at that location, and the object itself",
"   will move there in 7 seconds.",
"- Harden allows you to harden the device's electronics, thus protecting",
"   it form EMP effects. (This is still WIP and does not do anything)",
"- Close closes the menu.",
"",
"- Gamemode Thread: http://www.facepunch.com/showthread.php?t=821918",
"- Gamemode Coding Competition Entry, Sept/Oct. 2009",
"- By LevyBreak (And The Curator Spawn Menu by Find Me)"}

local ThiefHelpCategories = {}
ThiefHelpCategories["Basic"] = {"WELCOME TO CURATOR!",
"",
"As a thief, your goal is to make a dishonest living",
"by stealing from the museum run by the Curator!",
"",
"You can fund your first break in by collecting junk from around the map and",
"selling it to the shop. It is also reccomended you read the rest of this help",
"menu as well."}
ThiefHelpCategories["Controls"] = {"Controls:",
"",
"W - Forward",
"A - Left",
"S - Back",
"D - Right",
"Space - Jump (All normal controls, AFAIK)",
"Q - Open Up A Quick List of Your Current Inventory",
"Use - Pick up Art/Junk, Activate Events, Standard Use Usage.",
"F1 - Open/Close Help HUD/Menu (But you already knew that, right?)"}
ThiefHelpCategories["The Shop"] = {"The Shop:",
"",
"- Is the seedy guy near your spawn.",
"- Press your 'Use' key on it to use it. (Duh)",
"- The top is items for sale, the bottom is items you have",
"- You can right click on an item to see more detailed information on it."}
ThiefHelpCategories["Weapon List"] = {"Pocket EMP:",
"",
"- Left Click Activates, temporarily disables any (unhardened) security within a 700 unit radius.",
"- Single Use Only",
"",
"Grappling Hook:",
"",
"- Primary Fire Throws the hook, it only latches onto areas your HUD shows with a green O.",
"- Alternate Fire Retrieves the hook so you can throw it again.",
"- Once hooked, hold Shift-W to be drawn in. The farther away you are, the more force you are draw in with.",
"- Swinging can be a good strategy if you do not have enough space to simply over-speed up.",
"",
"Crowbar:",
"- Does not hurt other players, just a required item for some events.",
"",
"Polymer Shield:",
"- Alternate Fire Toggles It.",
"- Protects from turret shots.",
"- It will only stay out while the weapon is out.",
"- Some people say it's slow-moving, so sorry in advance."}
ThiefHelpCategories["Events"] = {"Events are triggers placed into the map by the mapper",
"that trigger actions in the map (like opening a door) when the user has",
"the required items.",
"If you press use on it and do nto have the required items, you will be told.",
"If you use it and it has already been used this round, you will be told.",
"If you use it and have the proper items it will activate."}
ThiefHelpCategories["Advanced"] = {"Useful Tactics at the Thief:",
"",
"- Props you steal still give the Curator money until you sell them.",
"- Learn the map. If you come in through a one-way entrance, be sure to have the tools to make an exit.",
"- Your win/loss is based on the money your team in total has, so be a team player.",
"- The above is true, but bragging rights for having the most money is always nice.",
"- Dying is better than being arrested, So if the alarm is going off, and you know you won't make it,",
"   stand in front of a turret. You may lose your stolen items, but you won't be withheld form the",
"   game for 60 seconds.",
"- In the event you are arrested, you spectate the Curator, so you can inform your friends of his plans!",
"- There is no substitute for experience. There is no 'I-Win' item to buy.",
"- The Curator gets 10% liquid for all art he has remaining at the end fo the round times the number of ",
"   thieves there are. Take this into account before thinking you cannot lose.",
"",
"- Gamemode Thread: http://www.facepunch.com/showthread.php?t=821918",
"- Gamemode Coding Competition Entry, Sept/Oct. 2009",
"- By LevyBreak (And The Curator Spawn Menu by Find Me)"}

function HelpMenu(deftab)
	local ply = LocalPlayer()
	if not ply.DHelp then
		local sizeX = ScrW()/2
		local sizeY = ScrH()/2
		
		ply.DHelp = vgui.Create("DFrame")
		ply.DHelp:SetTitle("Help")
		ply.DHelp:SetSize(sizeX,sizeY)
		ply.DHelp:SetPos((ScrW()/2)-sizeX/2,(ScrH()/2)-sizeY/2)
		ply.DHelp:MakePopup()
		
		local PropertySheet = vgui.Create( "DPropertySheet", ply.DHelp )
		PropertySheet:SetPos( 5, 30 )
		PropertySheet:SetSize( sizeX-10, sizeY-35 )
 
		local SheetItemOne = vgui.Create( "DPanelList" )
		SheetItemOne:SetSpacing(1)
		SheetItemOne:SetAutoSize(false)
		SheetItemOne:EnableVerticalScrollbar(true)
		
		for k,v in pairs(CuratorHelpCategories) do
			local Subcategory = vgui.Create("DCollapsibleCategory")
			Subcategory:SetLabel(k)
			if k == "Basic" then
				Subcategory:SetExpanded(1)
			else
				Subcategory:SetExpanded(0)
			end
			local SubList = vgui.Create("DPanelList")
			SubList:SetAutoSize(true)
			SubList:SetSpacing(2)
			for kz,vz in ipairs(v) do
				local Lbl = vgui.Create("DLabel")
				Lbl:SetText(vz)
				Lbl:SizeToContents()
				SubList:AddItem(Lbl)
			end
			Subcategory:SetContents(SubList)
			SheetItemOne:AddItem(Subcategory)
		end

		local SheetItemTwo = vgui.Create( "DPanelList" )
		SheetItemTwo:SetSpacing(1)
		SheetItemTwo:SetAutoSize(false)
		SheetItemTwo:EnableVerticalScrollbar(true)
		
		for k,v in pairs(ThiefHelpCategories) do
			local Subcategory = vgui.Create("DCollapsibleCategory")
			Subcategory:SetLabel(k)
			if k == "Basic" then
				Subcategory:SetExpanded(1)
			else
				Subcategory:SetExpanded(0)
			end
			local SubList = vgui.Create("DPanelList")
			SubList:SetAutoSize(true)
			SubList:SetSpacing(2)
			for kz,vz in ipairs(v) do
				local Lbl = vgui.Create("DLabel")
				Lbl:SetText(vz)
				Lbl:SizeToContents()
				SubList:AddItem(Lbl)
			end
			Subcategory:SetContents(SubList)
			SheetItemTwo:AddItem(Subcategory)
		end
 
		if deftab and deftab == "Curator" then
			PropertySheet:AddSheet( "Curator", SheetItemOne, "gui/silkicons/user", false, false, "Curator Help Information" )
			PropertySheet:AddSheet( "Thieves", SheetItemTwo, "gui/silkicons/group", false, false, "Thief Help Information" )
		else
			PropertySheet:AddSheet( "Thieves", SheetItemTwo, "gui/silkicons/group", false, false, "Thief Help Information" )
			PropertySheet:AddSheet( "Curator", SheetItemOne, "gui/silkicons/user", false, false, "Curator Help Information" )
		end
		
		SheetItemOne:StretchToParent()
		SheetItemTwo:StretchToParent()

	else
		ply.DHelp:Close()
		ply.DHelp = nil
	end
end
--[[
local function FadingShouldCollide(e1,e2)
	if (e1:IsPlayer() or e2:IsPlayer()) and (string.find(e1:GetClass(),"hook") or string.find(e2:GetClass(),"hook")) then
		return false
	else
		return true
	end
end
hook.Add("ShouldCollide","CuratorFadingShouldCollide",FadingShouldCollide)]]

local Vec = FindMetaTable("Vector")

function Vec:IsInLadder()
	for k,v in ipairs(CuratorLadderTable) do
		if self:IsPosInBounds(v.Max,v.Min) then
			return true
		end
	end
	return false
end 

function Vec:IsPosInBounds(maxvals,offset)
	if self.x > offset.x and self.y > offset.y and self.z > offset.z and self.x < maxvals.x and self.y < maxvals.y and self.z < maxvals.z then 
		return true 
	end
	return false
end 

-- Almost over 1000 lines of cl_init.lua!
-- Maybe I can just comment in these last 30 lines?
-- Is that possible?
-- I mean, 30 lines of nothing by comments?
-- I can try, I suppose.
-- So, How to begin...
-- I think I'll do some credits.
-- Detailed ones.
-- I thank:
-- Find Me for the following:
--  The Curator Spawn Menu
--  The Thief Q Menu (Slightly Modified)
--  The Server Half of the Round Timer System (Slightly Modified)
-- Google, for icons and textures.
-- Myself, for everything else.
-- I know, it may seem impossible;
-- But yes, this was only done in a month.
-- Including Find Me's Part.
-- Seriously, it was.
-- And it's all either his or my code.
-- It's all original code you haters!
-- Aside from the redistributable datastream fix...
-- I suppose i should thank Lexic (I think) for that.
-- Not sure why I include it since I don't sue datastream anywhere.
-- I gues it was incase I did, lol.
-- I hope some of my convinience functions in this will be useful to some people.
-- Really, I do.
-- Being useful is fun. And nice.
-- Did you know? I'm a Boy Scout. And only in high school
-- (Algebra 2) to boot.
-- That bezier crap took a long time for me to think
-- up the first interation of.
-- Haha! W00t! 1000 lines!
-- So, about that EMP effect... cool, isn't it? Made the texture myself, too.
-- Well, it's going beyond 1000 lines thanks to additions to the help stuff.
-- So now the "Haha! W00t! 1000 lines!" line isn't on line 1000.
-- Didn't expect it to last that long.