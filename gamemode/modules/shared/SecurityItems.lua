--[[-----------------------------------------------------
-------------------Security Item Table-------------------
]]-------------------------------------------------------

local SecurityItemsByName = {}

Security = {}

function Security.GetItems()
	return SecurityItemsByName
end 

function Security.AddItem(itemz)
	SecurityItemsByName[itemz:GetName()] = itemz
end 

function Security.RemoveItem(item)
	local str = ""
	if type(item) == "string" then str = item else str = item:GetName() end
	if SecurityItemsByName[str] then
		SecurityItemsByName[str] = nil
	end
end 

function Security.GetItem(name)
	return SecurityItemsByName[name]
end 

function Security.MakeStandardSpawnFunc(class)
	local func = function(item,ply,pos,ang) 
		local ent = ents.Create(class)
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent.Item = item:CopyTo(GetNewItemObject())
		ent:SetModel(item:GetModel())
		ent:Spawn()
        AccessorFunc(ent,"t_pOwner","Player")
        ent:SetPlayer(ply)
	end
	return func
end

function Security.MakeStandardLimitCheckFunc(class)
	local func = function(item) 
		return #ents.FindByClass(class)
	end
	return func
end

local StdRot = Angle(90,0,0)

Security.AddItem(GetNewItemObject("Survailance Camera",
"Affords Basic Protection against intruders.",
1000,
7,
-1,
0,
0,
Security.MakeStandardSpawnFunc("curator_camera"),
nil,
Security.MakeStandardLimitCheckFunc("curator_camera"),
"models/props_combine/combinecamera001.mdl"):SetAngularOffset(Angle(35,0,0)):SetPosOffset(4))

Security.AddItem(GetNewItemObject("Pressure Plates",
"Sensitive to thives walking on it.",
1500,
3,
0,
0,
0,
Security.MakeStandardSpawnFunc("curator_pressureplate"),
nil,
Security.MakeStandardLimitCheckFunc("curator_pressureplate"),
"models/props_junk/TrashDumpster02b.mdl"):SetAngularOffset(StdRot))

Security.AddItem(GetNewItemObject("Laser Emitter",
"Detects (and hurts) thieves.",
500,
10,
0,
0,
0,
Security.MakeStandardSpawnFunc("curator_laser"),
nil,
Security.MakeStandardLimitCheckFunc("curator_laser"),
"models/props_combine/combine_mine01.mdl"):SetAngularOffset(StdRot))

Security.AddItem(GetNewItemObject("Laser Grid",
"Detects (and hurts) thieves. A step above the emitter.",
2500,
4,
0,
0,
0,
Security.MakeStandardSpawnFunc("curator_laser_grid"),
nil,
Security.MakeStandardLimitCheckFunc("curator_laser_grid"),
"models/props_combine/combine_mine01.mdl"):SetAngularOffset(StdRot))

Security.AddItem(GetNewItemObject("Turret",
"Okay, this is overkill. Literally.",
4500,
2,
-2,
-2,
-1,
Security.MakeStandardSpawnFunc("curator_turret"),
nil,
Security.MakeStandardLimitCheckFunc("curator_turret"),
"models/Combine_turrets/Floor_turret.mdl"):SetAngularOffset(StdRot))