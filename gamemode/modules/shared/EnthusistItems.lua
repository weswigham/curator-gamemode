--[[-----------------------------------------------------
-------------------Enthusist Item Table-------------------
]]-------------------------------------------------------

local EnthusistItemsByName = {}

Enthusist = {}

function Enthusist.GetItems()
	return EnthusistItemsByName
end 

function Enthusist.AddItem(itemz)
	EnthusistItemsByName[itemz:GetName()] = itemz
end 

function Enthusist.RemoveItem(item)
	local str = ""
	if type(item) == "string" then str = item else str = item:GetName() end
	if EnthusistItemsByName[str] then
		EnthusistItemsByName[str] = nil
	end
end 

function Enthusist.GetItem(name)
	return EnthusistItemsByName[name]
end 

function Enthusist.MakeStandardSpawnFunc(class)
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

function Enthusist.MakeStandardLimitCheckFunc(class)
	local func = function(item) 
		return #ents.FindByClass(class)
	end
	return func
end

function Enthusist.MakeStandardArtCheckFunc(name)
    local func = function(item)
        local i = 0
        for k,v in ipairs(ents.FindByClass("curator_art")) do
            if v.Item:GetName() == name then
                i = i + 1
            end
        end
        return i
    end
    return func
end

Enthusist.AddItem(GetNewItemObject("Modern Art",
"Families can't appreciate this type of art.", 
1000, 
1, 
-2,
10, 
3, 
Enthusist.MakeStandardSpawnFunc("curator_art"),
nil, 
Enthusist.MakeStandardArtCheckFunc("Modern Art"), 
"ModernArtModelHere.mdl"))