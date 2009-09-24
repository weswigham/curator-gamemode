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

Fancy.AddItem(GetNewItemObject("Survailance Camera","Affords Basic Protection against intruders.",1000,7,-1,0,0,Fancy.MakeStandardSpawnFunc("curator_camera"),nil,Fancy.MakeStandardLimitCheckFunc("curator_camera"),"models/props_combine/combinecamera001.mdl"))