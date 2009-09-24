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

Enthusist.AddItem(GetNewItemObject("Survailance Camera","Affords Basic Protection against intruders.",1000,7,-1,0,0,Enthusist.MakeStandardSpawnFunc("curator_camera"),nil,Enthusist.MakeStandardLimitCheckFunc("curator_camera"),"models/props_combine/combinecamera001.mdl"))