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

function Thief.MakeWeaponFunc(class)
	local func = function(item,ply) 
		ply:Give(class)
	end
	return func
end

function Thief.MakeDestroyFunc(class)
	local func = function(item,ply) 
		ply:StripWeapon(class)
	end
	return func
end

function Thief.MakeStandardLimitCheckFunc(class)
	local func = function(item) 
		return #ents.FindByClass(class)
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
"models/props_c17/FurnitureDrawer001a_Shard01.mdl"))

Thief.AddItem(GetNewItemObject("Crowbar",
"Beats shit down, maaan.", 
750, 
-1, 
0,
0, 
0, 
Thief.MakeWeaponFunc("weapon_crowbar"),
Thief.MakeDestroyFunc("weapon_crowbar"), 
nil, 
"models/Weapons/w_crowbar.mdl"))

Thief.AddItem(GetNewItemObject("Rope",
"Helps ya in.", 
250, 
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
1250, 
-1, 
0,
0, 
0, 
nil,
nil, 
nil, 
"models/Combine_Helicopter/helicopter_bomb01.mdl"))

Thief.AddItem(GetNewItemObject("Pocket EMP",
"Single Use only EMP. Range = 30ft", 
1250, 
-1, 
0,
0, 
0, 
Thief.MakeWeaponFunc("weapon_emp"),
Thief.MakeDestroyFunc("weapon_emp"), 
nil, 
"models/Weapons/w_bugbait.mdl"))

Thief.AddItem(GetNewItemObject("Grapplig Hook",
"W00t, A grappling Hook!", 
750, 
-1, 
0,
0, 
0, 
Thief.MakeWeaponFunc("grappling_hook"),
Thief.MakeDestroyFunc("grappling_hook"), 
nil, 
"models/props_junk/meathook001a.mdl"))
