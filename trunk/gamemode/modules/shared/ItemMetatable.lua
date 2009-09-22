--[[-----------------------------------------------------
---------------------Item Meta Table---------------------
]]-------------------------------------------------------


local Item = {}

Item.__index = Item

AccessorFunc(Item,"m_sName","Name", FORCE_STRING ) --gotta love this acessor func shit. Makes this a piece of cake.
AccessorFunc(Item,"m_sInfo","Information", FORCE_STRING )
AccessorFunc(Item,"m_nCost","Price", FORCE_NUMBER )
AccessorFunc(Item,"m_nLimit","Limit", FORCE_NUMBER )
AccessorFunc(Item,"m_nHappiness1","FamilyHappiness", FORCE_NUMBER )
AccessorFunc(Item,"m_nHappiness2","EnthusistHappiness", FORCE_NUMBER )
AccessorFunc(Item,"m_nHappiness3","CollectorHappiness", FORCE_NUMBER )
AccessorFunc(Item,"OnSpawn","OnSpawnFunc")
AccessorFunc(Item,"OnRemove","OnRemoveFunc")
AccessorFunc(Item,"m_sModel","Model", FORCE_STRING )
AccessorFunc(Item,"m_sTexture","Texture", FORCE_STRING )

function Item:CopyTo(item)
	item:SetName(self:GetName() or "")
	item:SetInformation(self:GetInformation() or "")
	item:SetPrice(self:GetPrice() or 1000)
	item:SetLimit(self:GetLimt() or -1)
	item:SetFamilyHappiness(self:GetFamilyHappiness() or 0)
	item:SetEnthusistHappiness(self:GetEnthusistHappiness() or 0)
	item:SetCollectorHappiness(self:GetCollectorHappiness() or 0)
	item:SetOnSpawnFunc(self:GetOnSpawnFunc() or (function() end))
	item:SetOnRemoveFunc(self:GetOnRemoveFunc() or (function() end))
	item:SetModel(self:GetModel() or "")
	item:SetTexture(self:GetTexture() or "")
end


function GetNewItemObject(name,info,price,limit,fhap,ehap,colhap,spawnfunc,removefunc,modl,tex)
	local tmp = {}
	setmetatable(tmp,Item)
	tmp:SetName(name or "")
	tmp:SetInformation(info or "")
	tmp:SetPrice(price or 1000)
	tmp:SetLimit(limit or -1)
	tmp:SetFamilyHappiness(fhap or 0)
	tmp:SetEnthusistHappiness(ehap or 0)
	tmp:SetCollectorHappiness(colhap or 0)
	tmp:SetOnSpawnFunc(spawnfunc or (function() end))
	tmp:SetOnRemoveFunc(removefunc or (function() end))
	tmp:SetModel(modl or "")
	tmp:SetTexture(tex or "")
	return tmp
end 