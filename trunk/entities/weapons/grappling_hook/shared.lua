
SWEP.Author			= "Levybreak"
SWEP.Contact		= "Facepunch"
SWEP.Purpose		= "Grapple with it."
SWEP.Instructions	= "To climb up the walls of building at specified points."

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.HoldType			= "slam"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HookModel = "models/props_junk/meathook001a.mdl"

SWEP.Force = 1000

function SWEP:Initialize()
	if ( SERVER ) then
       self:SetWeaponHoldType( self.HoldType )
	   self.CurSlack = -2500
	else

	end
end

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	
end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()

end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	
	
		self.Weapon:SetNextPrimaryFire(CurTime() + 1)
		
		if (!SERVER) then return end
		
		
		if not self.RopeKey then
			GAMEMODE:SetPlayerAnimation( self.Owner, PLAYER_ATTACK1 )
	
			local ply = self.Owner
			
			self.Hook = ents.Create("thief_hook")
			self.Hook:SetModel(self.HookModel)
			self.Hook:SetPos(ply:GetShootPos())
			self.Hook:Spawn()
			self.Hook:GetPhysicsObject():ApplyForceCenter(ply:GetAimVector()*self.Force)
			
			self.RopeKey = ents.Create( "keyframe_rope" )
			self.RopeKey:SetKeyValue( "MoveSpeed", "64" )
			self.RopeKey:SetKeyValue( "Slack", "-2500" )
			self.RopeKey:SetKeyValue( "Subdiv", "2" )
			self.RopeKey:SetKeyValue( "Width", "0.5" )
			self.RopeKey:SetKeyValue( "TextureScale", "1" )
			self.RopeKey:SetKeyValue( "Collide", "1" )
			self.RopeKey:SetKeyValue( "RopeMaterial", "cable/rope.vmt" )
			self.RopeKey:SetKeyValue( "targetname", ply:UniqueID().."GrappleRope" )
			self.RopeKey:SetPos( self.Hook:GetPos() )
			self.RopeKey:Spawn()
			self.RopeKey:Activate()
			self.RopeKey:SetParent(self.Hook)
		
			self.RopeMove = ents.Create( "move_rope" )
			self.RopeMove:SetKeyValue( "MoveSpeed", "64" )
			self.RopeMove:SetKeyValue( "Slack", "-2500" )
			self.RopeMove:SetKeyValue( "Subdiv", "2" )
			self.RopeMove:SetKeyValue( "Width", "0.5" )
			self.RopeMove:SetKeyValue( "TextureScale", "1" )
			self.RopeMove:SetKeyValue( "Collide", "1" )
			self.RopeMove:SetKeyValue( "PositionInterpolator", "2" )
			self.RopeMove:SetKeyValue( "NextKey", ply:UniqueID().."GrappleRope" )
			self.RopeMove:SetKeyValue( "RopeMaterial", "cable/rope.vmt" )
			self.RopeMove:SetKeyValue( "targetname", ply:UniqueID().."GrappleMoveRope" )
			self.RopeMove:SetPos( ply:GetShootPos() + Vector( 0, 0, -5 ) )
			self.RopeMove:Spawn()
			self.RopeMove:Activate()
			self.RopeMove:SetParent( ply )
		
		end

end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	
	
	if (!SERVER) then return end
	
	if self.Hook and self.Hook:IsValid() then
		self.Hook:Remove()
	end
	if self.RopeMove and self.RopeMove:IsValid() then
		self.RopeMove:Remove()
	end
	if self.RopeKey and self.RopeKey:IsValid() then
		self.RopeKey:Remove()
	end
	self.CurSlack = -2500
	
end


/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:DrawHUD()

	if (!CLIENT) then return end

end

function SWEP:Think()
	if (SERVER) then
		local ply = self.Owner
		if ply:KeyDown(IN_FORWARD) and self.Hook then
			self.CurSlack = self.CurSlack - 10
			self.RopeKey:SetKeyValue("Slack",self.CurSlack)
			self.RopeMove:SetKeyValue("Slack",self.CurSlack)
		elseif ply:KeyDown(IN_BACK) and self.Hook then
			self.CurSlack = self.CurSlack + 10
			self.RopeKey:SetKeyValue("Slack",self.CurSlack)
			self.RopeMove:SetKeyValue("Slack",self.CurSlack)
		end
	end
	self:NextThink(CurTime()+0.25)
	return true
end
