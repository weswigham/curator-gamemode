
GM.Name 	= "Curator"
GM.Author 	= "Levybreak + find me"
GM.Email 	= "-snip-"
GM.Website 	= "N/A"

function PointOn3DBezierCurve(dis,pt1,pt2,pt3) --my poor attempt at a bezier curve algorthm. I think dis is distance along the curve, pt1 is start, pt2 is control, and pt3 is end.
	local out1 = ((1-dis)^2)*pt1.x+2*(1-dis)*dis*pt2.x+(dis^2)*pt3.x
	local out2 = ((1-dis)^2)*pt1.y+2*(1-dis)*dis*pt2.y+(dis^2)*pt3.y
	local out3 = ((1-dis)^2)*pt1.z+2*(1-dis)*dis*pt2.z+(dis^2)*pt3.z
	return Vector(out1,out2,out3)
end
