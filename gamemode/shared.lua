
GM.Name 	= "Curator"
GM.Author 	= "Levybreak + find me"
GM.Email 	= "-snip-"
GM.Website 	= "N/A"

local Entity = FindMetaTable("Entity")
function Entity:IsPosInBounds(pos)
	local offset = self:LocalToWorld(self:OBBMins())
	local maxvals = self:LocalToWorld(self:OBBMaxs())
	if pos.x > offset.x and pos.y > offset.y and pos.z > offset.z and pos.x < maxvals.x and pos.y < maxvals.y and pos.z < maxvals.z then 
		return true 
	end
	return false
end

local Player = FindMetaTable("Player")

if (SERVER) then

function Player:HasItems(tbl)
	if tbl then
		for k,v in ipairs(tbl) do
			local found = false
			for kz,vz in ipairs(self.ItemList) do
				if string.lower(vz.Item:GetName()) == string.lower(v) then
					found = true
				end
				print(string.lower(v),string.lower(vz.Item:GetName()),found)
			end
			if found == false then 
				return false 
			end
		end
		
		return true
	else 
		return false 
	end
end 

function Player:GiveStolenItem(item,entToRemoveOnSell)
	table.insert(self.ItemList,{Item=item,Entity=entToRemoveOnSell})
	self:SendItems()
end

function Player:SellItem(index)
	if not self.ItemList[tonumber(index)] then self:ChatPrint("Wait, you don't have anything in that item slot...Hmmm") return end
	self:SetNWInt("money",math.ceil(self:GetNWInt("money")+self.ItemList[tonumber(index)].Item:GetPrice()))
	if self.ItemList[tonumber(index)].Entity then self.ItemList[tonumber(index)].Entity:Remove() end 
	table.remove(self.ItemList,tonumber(index))
end

function Player:SendItems()
	for k,v in pairs(self.ItemList) do
		SendUserMessage("RecieveItems",self,k,v.Item:GetName())
	end
	if self.ItemList == {} then
		SendUserMessage("RecieveItems",self,1,"Empty")
	end
end

function Player:GetItems()
	return self.ItemList or {}
end

function Player:BuyItem(name)
	local item = Thief.GetItem(name)
	if item then
		if self:GetNWInt("money") >= item:GetPrice() then
			if #self.ItemList >= 5 then
				self:ChatPrint("You don't have any free inventory slots!")
			else
				self:SetNWInt("money",self:GetNWInt("money")-item:GetPrice())
				table.insert(self.ItemList,{Item=item})
			end
		else
			self:ChatPrint("You don't have enought cash to buy "..name..".")
		end
	else
		self:ChatPrint("Item "..name.." doesn't appear to exist.")
	end
end

elseif (CLIENT) then

function Player:GetItems()
	return self.MyItems or {}
end

usermessage.Hook("RecieveItems",function(um)
	local index = um:ReadLong()
	local item = um:ReadString()
	if item ~= "Empty" then
		for k,v in ipairs({"Family","Fancy","Enthusist","Thief","Security","Junk"}) do
			if _G[v].GetItem(item) then item = _G[v].GetItem(item) end
		end
	
		if index == 1 then
			LocalPlayer().MyItems = {}
		end
		LocalPlayer().MyItems[index] = item
	
		if LocalPlayer().BuyMenu and ValidEntity(LocalPlayer().BuyMenu) and ValidEntity(LocalPlayer().BuyMenu.BG) then LocalPlayer().BuyMenu.BG:OldClose() LocalPlayer().BuyMenu:InvalidateLayout() end
		if Inventory and ValidEntity(Inventory) then Inventory:InvalidateLayout() end
	else
		LocalPlayer().MyItems = {}
		if LocalPlayer().BuyMenu and ValidEntity(LocalPlayer().BuyMenu) and ValidEntity(LocalPlayer().BuyMenu.BG) then LocalPlayer().BuyMenu.BG:OldClose() LocalPlayer().BuyMenu:InvalidateLayout() end
		if LocalPlayer().Inventory and ValidEntity(LocalPlayer().Inventory) then LocalPlayer().Inventory:InvalidateLayout() end
	end
end)
end

function Entity:IsInCone(p1,p2,Radius)
	local dist = p1:Distance(p2)
	local v1 = p2-p1
	v1:Normalize()

	local v2 = self:GetPos()-p1
	v2:Normalize()

	return (v1:Dot(v2) >= (math.atan2(Radius,dist)*2))
end

function ents.FindInConeFix(p1,p2,Radius)
	local tbl = {}
	local dist = p1:Distance(p2)
	local v1 = p2-p1
	v1:Normalize()
	for k,v in ipairs(ents.GetAll()) do
		local v2 = v:GetPos()-p1
		v2:Normalize()
		if v1:Dot(v2) >= (math.atan2(Radius,dist)*2) then
			table.insert(tbl,v)
		end
	end
	return tbl
end

function player.FindInCone(p1,p2,Radius)
	local tbl = {}
	local dist = p1:Distance(p2)
	local v1 = p2-p1
	v1:Normalize()
	for k,v in ipairs(player.GetAll()) do
		local v2 = v:GetPos()-p1
		v2:Normalize()
		if v1:Dot(v2) >= (math.atan2(Radius,dist)*2) then
			table.insert(tbl,v)
		end
	end
	return tbl
end


team.SetUp(1,"Curator",Color(255,255,255,255))
TEAM_CURATOR = 1
team.SetUp(2,"Thieves",Color(255,70,60,255))
TEAM_THIEF = 2
team.SetUp(3,"Dead",Color(175,175,175,255))
TEAM_DEAD = 3
team.SetUp(4,"Arrested",Color(100,100,200,255))
TEAM_JAILED = 4
