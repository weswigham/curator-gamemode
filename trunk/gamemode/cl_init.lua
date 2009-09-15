include( 'shared.lua' )

for _, file in ipairs( file.Find( "../lua/" .. GM.Folder:gsub( "gamemodes/", "" ) .. "/gamemode/modules/client/*.lua" ) ) do
	include( "modules/client/" .. file )
end

for _, file in ipairs( file.Find( "../lua/" .. GM.Folder:gsub( "gamemodes/", "" ) .. "/gamemode/modules/shared/*.lua" ) ) do
	include( "modules/shared/" .. file )
end	


function GM:Initialize()

end


function PointOn2DBezierCurve(dis,pt1,pt2,pt3) --my poor attempt at a bezier curve algorthm. I think dis is distance along the curve, pt1 is start, pt2 is control, and pt3 is end.
	local out1 = ((1-dis)^2)*pt1.x+2*(1-dis)*dis*pt2.x+(dis^2)*pt3.x
	local out2 = ((1-dis)^2)*pt1.y+2*(1-dis)*dis*pt2.y+(dis^2)*pt3.y
	return out1,out2
end

function TableOfPointsOnCurve(col,w,h,itier,dist,pt1,pt2,pt3) --Color, width, height, iterations(smoothness), distance(is a part of iterations), start point, control point, end point
	local outtable = {}
	local start = 1/itier
	dist = math.Clamp(dist,1,itier)
	for i=1,dist do
		local x,y = PointOn2DBezierCurve(start,pt1,pt2,pt3)
		local tbl = {}
		tbl["x"] = x
		tbl["y"] = y
		tbl["w"] = w
		tbl["h"] = h
		tbl["color"] = col
		tbl["texture"] = draw.NoTexture()
		table.insert(outtable,tbl)
		start = start + 1/itier
	end
	return outtable
end

function GM:HUDPaint()

	GAMEMODE:HUDDrawTargetID()
	GAMEMODE:HUDDrawPickupHistory()
	GAMEMODE:DrawDeathNotice( 0.85, 0.1 )
end
