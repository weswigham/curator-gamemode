include( 'shared.lua' )

for _, file in ipairs( file.Find( "../lua/" .. GM.Folder:gsub( "gamemodes/", "" ) .. "/gamemode/modules/client/*.lua" ) ) do
	include( "modules/client/" .. file )
end

for _, file in ipairs( file.Find( "../lua/" .. GM.Folder:gsub( "gamemodes/", "" ) .. "/gamemode/modules/shared/*.lua" ) ) do
	include( "modules/shared/" .. file )
end	


function GM:Initialize()

end

local Font = "HUDNumber5"
local BGCol = Color(0,0,0,150)
local MoneyCol = Color(100,200,100,250)
local TimeCol = Color(200,200,100,250)
local StartPt = Bezier.2DPoint(ScrW(),ScrH()-(ScrH()/10))
local EndPt = Bezier.2DPoint(ScrW(),ScrH()-(ScrH()/10))
local ControlPt = Bezier.2DPoint(ScrW()-(ScrW()/5),ScrH()/2)

function GM:HUDPaint()

	GAMEMODE:HUDDrawTargetID()
	GAMEMODE:DrawDeathNotice( 0.9, 0.1 )
	
	local Time = string.ToMinutesSeconds(RoundTimer.GetCurrentTime())
	local Muny = "$"..math.floor(LocalPlayer():GetNWInt("money"))
	
	surface.SetFont(Font)
	local offx,offy = surface.GetTextSize(Muny)
	
	draw.WordBox( 10, ScrW()-(offx+20),ScrH()-(offy+20), Muny, Font, BGCol, MoneyCol)
	
	local stufftodraw = Bezier.TableOfPointsOnQuadraticCurve(BGCol,20,1,500,500,StartPt,ControlPt,EndPt)
	for k,v in pairs(stufftodraw) do
		draw.TexturedQuad(v)
	end
	
	local str = "Round Time Remaining- "..Time
	local offx,offy = surface.GetTextSize(str)
	
	draw.WordBox( 10, ScrW()-(offx+20), offy+20, str, Font, BGCol, TimeCol)

	
	local dist = (RoundTimer.GetCurrentTime()/RoundTimer.RoundTime)*500
	local stufftodraw2 = Bezier.TableOfPointsOnQuadraticCurve(TimeCol,10,1,500,dist,StartPt,ControlPt,EndPt)
	for k,v in pairs(stufftodraw2) do
		draw.TexturedQuad(v)
	end
end
