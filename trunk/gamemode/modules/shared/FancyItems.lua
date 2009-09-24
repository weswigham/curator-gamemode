--[[-----------------------------------------------------
-------------------Fancy Item Table-------------------
]]-------------------------------------------------------

local FancyItemsByName = {}

Fancy = {}

function Fancy.GetItems()
	return FancyItemsByName
end 

function Fancy.AddItem(itemz)
	FancyItemsByName[itemz:GetName()] = itemz
end 

function Fancy.RemoveItem(item)
	local str = ""
	if type(item) == "string" then str = item else str = item:GetName() end
	if FancyItemsByName[str] then
		FancyItemsByName[str] = nil
	end
end 

function Fancy.GetItem(name)
	return FancyItemsByName[name]
end 

function Fancy.MakeStandardSpawnFunc(class)
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

function Fancy.MakeStandardLimitCheckFunc(class)
	local func = function(item) 
		return #ents.FindByClass(class)
	end
	return func
end

function Fancy.MakeStandardArtCheckFunc(name)
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

Fancy.AddItem(GetNewItemObject("Mona Lisa",
"It's incredible. Collectors love this.", 
1000, 
1, 
-4,
2, 
8, 
Fancy.MakeStandardSpawnFunc("curator_art"),
nil, 
Fancy.MakeStandardArtCheckFunc("Mona Lisa"), 
"MonaLisaModelHere.mdl"))