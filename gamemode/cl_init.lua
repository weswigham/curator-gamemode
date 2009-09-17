include( 'shared.lua' )

if not SinglePlayer() and not LocalPlayer():IsListenServerHost() then
	for _, file in ipairs( file.Find( "../lua/"..GM.Folder:gsub( "gamemodes/", "" ).."/gamemode/modules/client/*.lua" ) ) do
		include( "modules/client/"..file )
	end

	for _, file in ipairs( file.Find( "../lua/"..GM.Folder:gsub( "gamemodes/", "" ).."/gamemode/modules/shared/*.lua" ) ) do
		include( "modules/shared/"..file )
	end	
else
	for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/client/*.lua" ) ) do
		include( "modules/client/"..file )
	end

	for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/shared/*.lua" ) ) do
		include( "modules/shared/"..file )
	end	
end


function GM:Initialize()

end

local function SecurityIcon()

end

local function FamilyIcon()

end

local function FancyIcon()

end

local function EnthusistIcon()

end

local MaxHealth = 100

local Font = "HUDNumber5"

local BGCol = Color(0,0,0,150)
local MoneyCol = Color(100,200,100,250)
local TimeCol = Color(200,200,100,250)
local HPCol = Color(240,50,50,250)

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

local CuratorBoxSize = math.min(ScrW(),ScrH())/2.5
local CuratorBoxIconPos = CuratorBoxSize/8
local CuratorBoxSizeQuarter = CuratorBoxSize/4

local CuratorSecurityIcon = vgui.Create("DImageButton")
CuratorSecurityIcon:SetImage("CuratorHUD/lock")
CuratorSecurityIcon:SetSize(CuratorBoxIconPos,CuratorBoxIconPos)
CuratorSecurityIcon:SetPos(0,0)
CuratorSecurityIcon.DoClick = function() if LocalPlayer():GetNWBool("Curator") then SecurityIcon() end end

local CuratorFamilyIcon = vgui.Create("DImageButton")
CuratorFamilyIcon:SetImage("CuratorHUD/family")
CuratorFamilyIcon:SetSize(CuratorBoxIconPos,CuratorBoxIconPos)
CuratorFamilyIcon:SetPos(CuratorBoxSizeQuarter,0)
CuratorFamilyIcon.DoClick = function() if LocalPlayer():GetNWBool("Curator") then FamilyIcon() end end

local CuratorFancyIcon = vgui.Create("DImageButton")
CuratorFancyIcon:SetImage("CuratorHUD/fancy")
CuratorFancyIcon:SetSize(CuratorBoxIconPos,CuratorBoxIconPos)
CuratorFancyIcon:SetPos(0,CuratorBoxSizeQuarter)
CuratorFancyIcon.DoClick = function() if LocalPlayer():GetNWBool("Curator") then FancyIcon() end end

local CuratorEnthusistIcon = vgui.Create("DImageButton")
CuratorEnthusistIcon:SetImage("CuratorHUD/person")
CuratorEnthusistIcon:SetSize(CuratorBoxIconPos,CuratorBoxIconPos)
CuratorEnthusistIcon:SetPos(CuratorBoxSizeQuarter,CuratorBoxSizeQuarter)
CuratorEnthusistIcon.DoClick = function() if LocalPlayer():GetNWBool("Curator") then EnthusistIcon() end end

local function DisableIcons()
	CuratorSecurityIcon:SetVisible(false)

	CuratorFamilyIcon:SetVisible(false)

	CuratorFancyIcon:SetVisible(false)

	CuratorEnthusistIcon:SetVisible(false)
end

local function EnableIcons()
	CuratorSecurityIcon:SetVisible(true)

	CuratorFamilyIcon:SetVisible(true)
	
	CuratorFancyIcon:SetVisible(true)

	CuratorEnthusistIcon:SetVisible(true)
end

function GM:HUDPaint()

	GAMEMODE:HUDDrawTargetID()
	GAMEMODE:DrawDeathNotice( 0.9, 0.1 )
	
	--Stuff Everyone draws
	
	local Time = string.ToMinutesSeconds(RoundTimer.GetCurrentTime())
	local Muny = "$"..math.floor(LocalPlayer():GetNWInt("money"))
	
	surface.SetFont(Font)
	local offx,offy = surface.GetTextSize(Muny)
	
	draw.WordBox( 10, ScrW()-(offx+20),ScrH()-(offy+20), Muny, Font, BGCol, MoneyCol)
	
	
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
	
		--Quuck Menu (Top Left)
		draw.RoundedBox(20,-CuratorBoxSize/2,-CuratorBoxSize/2,CuratorBoxSize,CuratorBoxSize,BGCol)
		
		--Icon Positions
		EnableIcons()
		
	
	else
	--Thief Stuff
	
		DisableIcons()
	
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
	
	
	end
end

local function KeyPressed(ply, code)
	if ply:GetNWBool("Curator") and code == IN_SPEED then
		if not ply.Enabled then ply.Enabled = false end
		ply.Enabled = !ply.Enabled
		gui.EnableScreenClicker(ply.Enabled)
	end
end
hook.Add("KeyPressed","CuratorKeyPressed",KeyPressed)


local AllowedElements = { 	"CHudChat",
							"CHudCrosshair",
							"CHudGMod",
							"CHudVoiceStatus",
							"CHudVoiceSelfStatus"
						}
function GM:HUDShouldDraw(element)
	return table.HasValue(AllowedElements,element)
end 