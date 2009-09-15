
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )


include( 'shared.lua' )
include( 'chatcommands.lua' )



for _, file in ipairs( file.Find( "../" .. GM.Folder .. "/gamemode/modules/server/*.lua" ) ) do
	include( "modules/server/" .. file )
end

for _, file in ipairs( file.Find( "../" .. GM.Folder .. "/gamemode/modules/shared/*.lua" ) ) do
	include( "modules/shared/" .. file )
	AddCSLuaFile( "modules/shared/" .. file )
end	

for _, file in ipairs( file.Find( "../" .. GM.Folder .. "/gamemode/modules/client/*.lua" ) ) do
	AddCSLuaFile( "modules/client/" .. file )
end


function GM:Initialize()

end


function GM:PhysgunPickup(ply, ent)
	return false
end

function GM:PlayerNoClip( ply ) 
	return ply.Curator or false
end


function GM:PlayerSpawn( pl )

	self.BaseClass.PlayerSpawn( self, pl )
	
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

function GM:PlayerLoadout( pl )

	pl:RemoveAllAmmo()

	local cl_defaultweapon = pl:GetInfo( "cl_defaultweapon" )

	if ( pl:HasWeapon( cl_defaultweapon )  ) then
		pl:SelectWeapon( cl_defaultweapon ) 
	end
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	if ( attacker:IsValid() and attacker:IsPlayer() ) then
		return false
	else 
		return true 
	end
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

function GM:PlayerInitialSpawn( ply )
	self.BaseClass:PlayerInitialSpawn( ply )
end

function GM:PlayerDisconnected( ply )

end

function GM:Think()

end 

function GM:RespawnEveryone()
	if player.GetAll() != nil then
		for k,v in pairs(player.GetAll()) do
			v:KillSilent()
		end
	end
end

hook.Add("RoundStarted","CuratorRoundStart",function() 
	for k,v in ipairs(ents.FindByClass("info_round_info")) do
		v:Input("RoundStart")
	end
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


