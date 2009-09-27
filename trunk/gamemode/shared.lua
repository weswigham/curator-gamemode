
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
function Player:HasItems(tbl)
	if tbl then
	
		for k,v in ipairs(tbl) do
			local found = false
			for kz,vz in ipairs(self.ItemList) do
				if string.lower(vz:GetName()) == string.lower(v) then
					found = true
				end
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

if (SERVER) then
function Player:GiveStolenItem(item,entToRemoveOnSell)
	table.insert(self.ItemList,{Item=item,Entity=entToRemoveOnSell})
end

function Player:SellItem(index)
	self:SetNWInt("money",math.ceil(self:GetNWInt("money")+self.ItemList[index]:GetPrice()))
	table.remove(self.ItemList,index)
end

function Player:SendItems()
	for k,v in ipairs(self.ItemList) do
		SendUserMessage("RecieveItems",self,k,glon.encode(v))
	end
end

elseif (CLIENT) then

usermessage.Hook("RecieveItems",function(um)
	local index = um:ReadLong()
	local item = glon.decode(um:ReadString())
	
	LocalPlayer().MyItems = {}
	LocalPlayer().MyItems[index] = item
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
