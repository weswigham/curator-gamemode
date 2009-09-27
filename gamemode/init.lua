
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )


include( 'shared.lua' )



for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/server/*.lua" ) ) do
	include( "modules/server/"..file )
end

for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/shared/*.lua" ) ) do
	include( "modules/shared/" .. file )
	AddCSLuaFile( "modules/shared/"..file )
end	

for _, file in ipairs( file.Find( "../"..GM.Folder.."/gamemode/modules/client/*.lua" ) ) do
	AddCSLuaFile( "modules/client/"..file )
end


function GM:Initialize()
end

local function CurInitPostEntity()
	for k,v in ipairs(ents.FindByClass("info_round_info")) do
		local ent = ents.Create("thief_shop")
		ent:SetPos(v:GetPos())
		ent:Spawn()
	end
end
hook.Add("InitPostEntity","CuratorInitPostEntity",CurInitPostEntity)

local function KeyPressed(ply, code)
	if (not ply:GetNWBool("Curator")) and code == IN_USE then
		local tr = util.QuickTrace(ply:GetShootPos(),ply:GetAimVector()*200,ply)
		if tr.Hit and (not tr.HitSkybox) then
			for k,v in ipairs(ents.FindByClass("trigger_event")) do
				if v:IsPosInBounds(tr.HitPos) then
					if ply:HasItems(v.ReqItems) then
						v:Input("ValidActivate")
					else
						ply:ChatPrint("This event requires "..table.concat(v.ReqItems," and ").." to run.")
					end
				end
			end
		end
	end
end
hook.Add("KeyPress","CuratorKeyPressed",KeyPressed)

function GM:PhysgunPickup(ply, ent)
	return false
end

function GM:PlayerNoClip( ply ) 
	return ply.Curator or false
end

function GM:PlayerDeath(ply,inf,killr)
	ply:SetTeam(TEAM_DEAD)
end

function GM:ArrestPlayer(ply)
	ply:KillSilent()
	ply:Spectate(OBS_MODE_IN_EYE)
	ply:SpectateEntity(self.Curator)
	ply:SetMoveType(MOVETYPE_OBSERVER)
	ply:SetTeam(TEAM_JAILED)
	ply:Lock()
	ply.Arrested = true
	PrintMessage(HUD_PRINTCHAT,ply:Nick().." has been caught and arrested. He is out of the game for 60 seconds!")
end

function GM:UnArrestPlayer(ply)
	ply:UnSpectate()
	ply:SetMoveType(MOVETYPE_WALK)
	ply:SetTeam(TEAM_THIEF)
	ply:UnLock()
	ply.Arrested = false
end

function GM:PlayerSpawn( pl )

	self.BaseClass.PlayerSpawn( self, pl )
	if pl ~= self.Curator then
		pl:SetMoveType(MOVETYPE_WALK)
		pl:SetNoDraw(false)
		pl:SetTeam(TEAM_THIEF)
	else
		pl:SetMoveType(MOVETYPE_NOCLIP)
		local tbl = ents.FindByClass("info_curator_start")
		if tbl[1] then
			self.Curator:SetPos(table.Random(tbl):GetPos())
		end
		pl:SetNoDraw(true)
		pl:SetTeam(TEAM_CURATOR)
	end
	
	pl:SetNWInt("Detection",0)
end


function GM:SetupVote(name,duration,percent,OnPass,OnFail)
	self.ActiveVoting = true
	self.CurrentVote = {}
	self.CurrentVote.Name = name
	self.CurrentVote.Yes = 0
	self.CurrentVote.No = 0
	PrintMessage( HUD_PRINTTALK, "A Vote For "..name.." has commenced! You have "..duration.." seconds to vote. Just say yes or no! "..(percent*100).."% is required to pass it.")
	timer.Simple(duration,function() 
		self.ActiveVoting = nil
		if self.CurrentVote.Yes/#player.GetAll() >= percent then OnPass() else OnFail() end 
		for k,v in pairs(player.GetAll()) do
			v.HasVoted = nil
		end
		self.CurrentVote = nil
	end)
end

function GM:PlayerLoadout( ply )

	ply:RemoveAllAmmo()
	
	if (not ply:GetNWBool("Curator")) and ply ~= self.Curator then
		ply:Give("weapon_crowbar")
	end

	local cl_defaultweapon = ply:GetInfo( "cl_defaultweapon" )

	if ( ply:HasWeapon( cl_defaultweapon )  ) then
		ply:SelectWeapon( cl_defaultweapon ) 
	end
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	return not ply:GetNWBool("Curator")
end

function GM:ShowHelp( ply )
	umsg.Start("OpenHelp",ply)
	umsg.End()
end

local DecayFactor = 1.2

function GM:Payday()
	self.Curator:SetNWInt("money",self.Curator:GetNWInt("money")+(self.Curator:GetNWInt("happ1")*25+self.Curator:GetNWInt("happ2")*50+self.Curator:GetNWInt("happ3")*90)) -- that makes a max of 2500+5000+9000, or 16500. If you're getting this much, your thieves suck, and you pwn.
	for k,v in ipairs(ents.FindByClass("curator_*")) do
		if v.Item then
			if v.Item:GetFamilyHappiness() > 0 then
				v.Item:SetFamilyHappiness(math.Clamp(v.Item:GetFamilyHappiness()/DecayFactor,0.25,100))
			elseif v.Item:GetFamilyHappiness() < 0 then
				v.Item:SetFamilyHappiness(math.Clamp(v.Item:GetFamilyHappiness()/DecayFactor,-100,-0.25))
			end
			if v.Item:GetEnthusistHappiness() > 0 then
				v.Item:SetEnthusistHappiness(math.Clamp(v.Item:GetEnthusistHappiness()/DecayFactor,0.25,100))
			elseif v.Item:GetEnthusistHappiness() < 0 then
				v.Item:SetEnthusistHappiness(math.Clamp(v.Item:GetEnthusistHappiness()/DecayFactor,-100,-0.25))
			end
			if v.Item:GetCollectorHappiness() > 0 then
				v.Item:SetCollectorHappiness(math.Clamp(v.Item:GetCollectorHappiness()/DecayFactor,0.25,100))
			elseif v.Item:GetCollectorHappiness() < 0 then
				v.Item:SetCollectorHappiness(math.Clamp(v.Item:GetCollectorHappiness()/DecayFactor,-100,-0.25))
			end
		end
	end
end

function GM:ShowTeam(ply)

end

function GM:ShowSpare1(ply)

end

function GM:ShowSpare2(ply)

end

local SelectionWeights = {}

function GM:PlayerInitialSpawn( ply )
	self.BaseClass:PlayerInitialSpawn( ply )
	SelectionWeights[ply] = 1
	ply.ItemList = {}

    umsg.Start("SetupCuratorSpawnMenu", ply)
    umsg.End()

end

function GM:PlayerDisconnected( ply )
	SelectionWeights[ply] = nil
end

function GM:TriggerAlarm(sndPos)
	if not self.Alarming then
		self.Alarming = true
		WorldSound("Trainyard.distantsiren",sndPos,165,100)
		SendUserMessage("StartAlarmCountdown")
		timer.Simple(15,function() 
			self.Alarming = false
			for k,v in ipairs(player.GetAll()) do
				if v:GetPos():IsInMuseum() then
					GAMEMODE:ArrestPlayer(v)
					SendUserMessage("YouBeenArrested",v)
					timer.Simple(60,function() GAMEMODE:UnArrestPlayer(v) SendUserMessage("YouveBeenReleased",v) end)
				end
			end
		end)
	end
end

function GM:StealArt(ply,ent,item)
	if #ply:GetItems() < 5 then
		ent:Fade(5)
		ply:Lock()
		SendUserMessage("StealingProgressBar",ply)
		timer.Simple(5,function()
			ply:UnLock()
			ply:GiveStolenItem(item,ent)
		end)
	else
		ply:ChatPrint("Your inventory is full, so you can't pick up that "..item:GetName().."!")
	end
end

function GM:Think()
	if self.Curator and self.Curator:IsValid() then
		self.Curator:SetMoveType(MOVETYPE_NOCLIP)
		self.Curator:SetNoDraw(true)
	elseif #player.GetAll() >= 1 then
		--Wait, what? we have a player and no curator? well that's outright wrong.
		self.Curator = table.WeightedRandom(player.GetAll(),SelectionWeights)
		self.Curator:SetNWBool("Curator",true)
		self.Curator:KillSilent()
		self.Curator:StripWeapons()
		local tbl = ents.FindByClass("info_curator_start")
		if tbl[1] then
			self.Curator:SetPos(table.Random(tbl):GetPos())
		end
		for k,v in ipairs(player.GetAll()) do 
			v:KillSilent()
			v:PrintMessage(HUD_PRINTTALK,"The Curator Has Changed! You will be respawned!")
		end
		self.Curator:SetNWInt("money",10000)
		umsg.Start("SetupCuratorSpawnMenu", self.Curator)
		umsg.End()
		self.Curator:SetTeam(TEAM_CURATOR)
	else
		self.Curator = nil
	end
	for k,v in ipairs(player.GetAll()) do
		v:SetNWBool("Curator",v == self.Curator)
		if v:GetNWInt("Detection") >= 1000 then
			self:TriggerAlarm(v:GetPos())
		end
		if not v:GetPos():IsInMuseum() then
			v:SetNWInt("Detection",math.Clamp(v:GetNWInt("Detection")-2,0,1000))
		end
	end
	if self.Curator then
		local val1,val2,val3 = 0,0,0
		for k,v in ipairs(ents.FindByClass("curator_*")) do
			if v.Item then
				val1 = val1 + v.Item:GetFamilyHappiness()
				val2 = val2 + v.Item:GetEnthusistHappiness()
				val3 = val3 + v.Item:GetCollectorHappiness()
			end
		end
		self.Curator:SetNWInt("happ1", math.Clamp(val1,0,100)) 
		self.Curator:SetNWInt("happ2", math.Clamp(val2,0,100)) 
		self.Curator:SetNWInt("happ3", math.Clamp(val3,0,100))
	end
end 

function GM:ResetMap()
	game.CleanUpMap()
end

function table.WeightedRandom(tbl,weights)
	local selectTbl = {}
	for k,v in pairs(tbl) do
		for i=1,(weights[v] or 1) do
			table.insert(selectTbl,v)
		end
	end
	return table.Random(selectTbl)
end

function GM:RoundBegin()
	self:ResetMap()
	for k,v in ipairs(player.GetAll()) do
		v:SetNWBool("Curator",false)
		self.Curator:SetNWInt("money",0)
	end
	self.Curator = table.WeightedRandom(player.GetAll(),SelectionWeights)
	SelectionWeights[self.Curator] = 1
	self.Curator:SetNWBool("Curator",true)
	self.Curator:SetNWInt("money",10000)
	
	local tbl = ents.FindByClass("info_curator_start")
	if tbl[1] then
		self.Curator:SetPos(table.Random(tbl):GetPos())
	end

	for k,v in ipairs(ents.FindByClass("info_round_info")) do
		local ent = ents.Create("thief_shop")
		ent:SetPos(v:GetPos())
		ent:Spawn()
	end
end

function GM:RoundEnd()
	for k,v in ipairs(player.GetAll()) do
		v:Lock()
		v:ConCommand("OpenEndGameWindow")
		SelectionWeights[v] = SelectionWeights[v] + 1
		v:SetNWBool("Curator",false)
		v:KillSilent()
	end
	timer.Simple(RoundTimer.GraceTime,function()
		for k,v in ipairs(player.GetAll()) do
			v:UnLock()
			v:ConCommand("CloseEndGameWindow")
		end
	end)
end

local function FixStrings(...)
	local tbl = {...}
	for k,v in pairs(tbl) do
		tbl[k] = tonumber(v)
	end
	return unpack(tbl)
end

concommand.Add("curator_spawn_object",function(ply,cmd,args)
    local AType = args[1]
    local name = args[2]
    local ang = Angle(FixStrings(unpack(string.Explode(" ",args[3]))))
    local pos = Vector(FixStrings(unpack(string.Explode(" ",args[4]))))
    local item = _G[AType].GetItems()[name]
    
    if ply == GAMEMODE.Curator and ply:GetNWInt("money") >= item:GetPrice() then
		if item:LimitCheck() < item:GetLimit() then
			if pos:IsInMuseum() then
				ply:SetNWInt("money",ply:GetNWInt("money") - item:GetPrice())
				item:OnSpawn(ply,pos,ang)
			else
				ply:ChatPrint("You can't spawn that "..item:GetName().." outside the museum!")
			end
		else
			ply:ChatPrint("You've hit the limit for "..item:GetName()..". Its limit is "..item:GetLimit()..".")
		end
	else
		ply:ChatPrint("You don't have enough money for that "..item:GetName()..". It costs $"..item:GetPrice()..".")
    end

end)

concommand.Add("UpdateItems",function(ply,com,arg)
	ply:SendItems()
end)

concommand.Add("SellItem", function(ply,cmd,arg)
	ply:SellItem(arg[1])
	ply:SendItems()
end)

concommand.Add("BuyItem", function(ply,cmd,arg)
	ply:BuyItem(arg[1])
	ply:SendItems()
end)


hook.Add("RoundStarted","CuratorRoundStart",function() 
	for k,v in ipairs(ents.FindByClass("info_round_info")) do
		v:Input("RoundStart")
	end
	GAMEMODE:RoundBegin()
end)

hook.Add("GraceTime","CuratorGraceTime", function()
	for k,v in ipairs(ents.FindByClass("info_round_info")) do
		v:Input("RoundEnd")
	end
	GAMEMODE:RoundEnd()
end)

--Redistributable datastream fix.
local META = FindMetaTable("CRecipientFilter")
if META then
	function META:IsValid()
		return true
	end
else
	ErrorNoHalt(os.date().." Failed to fix datastream fuckup: \"CRecipientFilter\"'s metatable invalid.")
end

local Vec = FindMetaTable("Vector")
function Vec:IsInMuseum()
	for k,v in ipairs(ents.FindByClass("trigger_museum")) do
		if v:IsPosInBounds(self) then
			return true
		end
	end
	return false
end

