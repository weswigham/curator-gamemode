--[[-----------------------------------------------------
-------------------Thief Item Table-------------------
]]-------------------------------------------------------

local ThiefItemsByName = {}

Thief = {}

function Thief.GetItems()
	return ThiefItemsByName
end 

function Thief.AddItem(itemz)
	ThiefItemsByName[itemz:GetName()] = itemz
end 

function Thief.RemoveItem(item)
	local str = ""
	if type(item) == "string" then str = item else str = item:GetName() end
	if ThiefItemsByName[str] then
		ThiefItemsByName[str] = nil
	end
end 

function Thief.GetItem(name)
	return ThiefItemsByName[name]
end 

local zeroAng = Angle(0,0,0)

function Thief.MakeStandardSpawnFunc(class)
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

function Thief.MakeStandardLimitCheckFunc(class)
	local func = function(item) 
		return #ents.FindByClass(class)
	end
	return func
end

function Thief.MakeStandardJunkCheckFunc(name)
    local func = function(item)
        local i = 0
        for k,v in ipairs(ents.FindByClass("curator_junk")) do
            if v.Item:GetName() == name then
                i = i + 1
            end
        end
        return i
    end
    return func
end

Thief.AddItem(GetNewItemObject("Lockpick",
"Opens (some) locked doors.", 
500, 
-1, 
0,
0, 
0, 
nil,
nil, 
nil, 
"models/props_c17/Frame002a.mdl"))

Thief.AddItem(GetNewItemObject("Crowbar",
"Beats shit down, maaan.", 
500, 
-1, 
0,
0, 
0, 
nil,
nil, 
nil, 
"models/props_c17/Frame002a.mdl"))

Thief.AddItem(GetNewItemObject("Rope",
"Helps ya in.", 
500, 
-1, 
0,
0, 
0, 
nil,
nil, 
nil, 
"models/props_c17/Frame002a.mdl"))

Thief.AddItem(GetNewItemObject("Explosive",
"Opens large, reinforced locked doors.", 
1500, 
-1, 
0,
0, 
0, 
nil,
nil, 
nil, 
"models/props_c17/Frame002a.mdl"))
