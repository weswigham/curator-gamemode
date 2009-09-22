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
	local func = function(item,pos,normal) 
		local ent = ents.Create(class)
		ent:SetPos(pos)
		ent:SetAngles(normal:Angle())
		ent.Item = item
		ent:SetModel(item:GetModel())
		ent:Spawn()
	end
	return func
end

Security.AddItem(GetNewItemObject("Survailance Camera","Affords Basic Protection against intruders.",1000,7,-1,0,0,Security.MakeStandardSpawnFunc("curator_camera"),nil,"models/props_combine/combinecamera001.mdl"))