--[[-----------------------------------------------------
-------------------Family Item Table-------------------
]]-------------------------------------------------------

local FamilyItemsByName = {}

Family = {}

function Family.GetItems()
	return FamilyItemsByName
end 

function Family.AddItem(itemz)
	FamilyItemsByName[itemz:GetName()] = itemz
end 

function Family.RemoveItem(item)
	local str = ""
	if type(item) == "string" then str = item else str = item:GetName() end
	if FamilyItemsByName[str] then
		FamilyItemsByName[str] = nil
	end
end 

function Family.GetItem(name)
	return FamilyItemsByName[name]
end 

function Family.MakeStandardSpawnFunc(class)
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

function Family.MakeStandardLimitCheckFunc(class)
	local func = function(item) 
		return #ents.FindByClass(class)
	end
	return func
end

Family.AddItem(GetNewItemObject("Survailance Camera","Affords Basic Protection against intruders.",1000,7,-1,0,0,Family.MakeStandardSpawnFunc("curator_camera"),nil,Family.MakeStandardLimitCheckFunc("curator_camera"),"models/props_combine/combinecamera001.mdl"))