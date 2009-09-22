
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

local function KeyPressed(ply, code)
	if (not ply:GetNWBool("Curator")) and code == IN_USE then
		local tr = util.QuickTrace(ply:GetShootPos(),ply:GetAimVector()*200,ply)
		if tr.Hit and (not tr.HitSkybox) then
			for k,v in ipairs(ents.FindByClass("trigger_event")) do
				if v:IsPosInBounds(tr.HitPos) and ply:HasItems(v.ReqItems) then
					v:Input("ValidActivate")
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


function GM:PlayerSpawn( pl )

	self.BaseClass.PlayerSpawn( self, pl )
	if pl ~= self.Curator then
		pl:SetMoveType(MOVETYPE_WALK)
	else
		pl:SetMoveType(MOVETYPE_NOCLIP)
		local tbl = ents.FindByClass("info_curator_start")
		if tbl[1] then
			self.Curator:SetPos(table.Random(tbl):GetPos())
		end
	end
	pl:SetNoDraw(false)
	
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
		self.Curator:SetNWInt("money",10000)
	else
		self.Curator = nil
	end
	for k,v in ipairs(player.GetAll()) do
		v:SetNWBool("Curator",v == self.Curator)
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


