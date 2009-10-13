
SWEP.Author			= "Levybreak"
SWEP.Contact		= "Facepunch"
SWEP.Purpose		= "Grapple with it. To climb up the walls of building at specified points."
SWEP.Instructions	= "Left click to throw out at hook onto a green O area. Right click to remove it. When hooked, hold Shift-forward to move up it. Shift-Back to move down it. Use to hop up once you're near the hook."

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

SWEP.Force = 20000

SWEP.Amt = 120

SWEP.UpForce = 10

function SWEP:Initialize()
	if ( SERVER ) then
       self:SetWeaponHoldType( self.HoldType )
	   self.CurSlack = -3500
	else

	end
end

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	
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
			self.Hook.Fading = true
			
			self.RopeKey = ents.Create( "keyframe_rope" )
			self.RopeKey:SetKeyValue( "MoveSpeed", "64" )
			self.RopeKey:SetKeyValue( "Slack", "-1000" )
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
			self.RopeMove:SetKeyValue( "Slack", "-1000" )
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
			self.RopeMove:SetParent(ply)
		
			self.Hook.MoveRopeName = ply:UniqueID().."GrappleMoveRope"
			self.Hook.RopeName = ply:UniqueID().."GrappleRope"
			self.Hook.Player = self.Owner
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
	self.Hook =  nil
	if self.RopeMove and self.RopeMove:IsValid() then
		self.RopeMove:Remove()
	end
	self.RopeMove = nil
	if self.RopeKey and self.RopeKey:IsValid() then
		self.RopeKey:Remove()
	end
	self.RopeKey = nil
	self.CurSlack = -3500
	
end

function SWEP:Holster()

	if (!SERVER) then return end
	if self.Hook and self.Hook:IsValid() then
		self.Hook:Remove()
	end
	self.Hook =  nil
	if self.RopeMove and self.RopeMove:IsValid() then
		self.RopeMove:Remove()
	end
	self.RopeMove = nil
	if self.RopeKey and self.RopeKey:IsValid() then
		self.RopeKey:Remove()
	end
	self.RopeKey = nil
	self.CurSlack = -3500
	
	return true
end

/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
	return false
end

local Red = Color(255,0,0,200)
local Green = Color(0,240,20,200)

function SWEP:DrawHUD()

	if (!CLIENT) then return end

	local tr = LocalPlayer():GetEyeTrace()
	if tr.HitPos:IsInLadder() then
		draw.SimpleText("O","HUDNumber3",ScrW()/2,ScrH()/2,Green,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("X","HUDNumber3",ScrW()/2,ScrH()/2,Red,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end

local Gravity = Vector(0,0,-9.8) --acceleration due to gravity pl0x?
local UpPowuh = Vector(0,0,375)

function SWEP:Think()
	if (SERVER) and self.Hook and self.Hook.HookedOn then
		local ply = self.Owner
		if ply:KeyDown(IN_FORWARD) and ply:KeyDown(IN_SPEED) and ply:GetShootPos().z < self.Hook:GetPos().z then
			if ply:IsOnGround() then ply:ConCommand("+jump") timer.Simple(0.1,ply.ConCommand,ply,"-jump") end
			local DirNorm = (self.Hook:GetPos()-ply:GetShootPos()):GetNormal()
			local RLength = self.Hook:GetPos():Distance(ply:GetShootPos())
			local Force = ply:GetVelocity()
				Force = DirNorm * self.UpForce
			self.CurSlack = self.CurSlack - self.Amt
			self.RopeKey:SetKeyValue("Slack",tostring(RLength - self.Amt))
			self.RopeMove:SetKeyValue("Slack",tostring(RLength - self.Amt))
			ply:SetVelocity((ply:GetVelocity()*-1))
			ply:SetVelocity(Force)
		elseif ply:KeyDown(IN_BACK) and ply:KeyDown(IN_SPEED) and ply:GetShootPos().z < self.Hook:GetPos().z then 
			if ply:IsOnGround() then ply:ConCommand("+jump") timer.Simple(0.1,ply.ConCommand,ply,"-jump") end
			local DirNorm = (self.Hook:GetPos()-ply:GetShootPos()):GetNormal()
			local RLength = self.Hook:GetPos():Distance(ply:GetShootPos())
			local Force = ply:GetVelocity()
				Force = DirNorm * -self.UpForce
			self.CurSlack = self.CurSlack + self.Amt
			self.RopeKey:SetKeyValue("Slack",tostring(RLength + self.Amt))
			self.RopeMove:SetKeyValue("Slack",tostring(RLength + self.Amt))
			ply:SetVelocity((ply:GetVelocity()*-1))
			ply:SetVelocity(Force+Gravity)
		elseif (not ply:IsOnGround()) and ply:GetShootPos().z - self.Hook:GetPos().z < 4 and ply:GetShootPos().z - self.Hook:GetPos().z > -4 then --we're at the hook, just stop. srsly.
			ply:SetVelocity((ply:GetVelocity()*-1))
		else
			if not ply:IsOnGround() then
				local RLength = self.Hook:GetPos():Distance(ply:GetShootPos())
				local DirNorm = (self.Hook:GetPos()-ply:GetShootPos())
				local Wat = (Gravity:GetNormal()*RLength)
				
				ply:SetVelocity((ply:GetVelocity()*-1))
				ply:SetVelocity(DirNorm+Wat)
			end
		end
		if ply:KeyDown(IN_USE) and ply:GetShootPos().z < self.Hook:GetPos().z then
			ply:SetVelocity((ply:GetVelocity()*-1))
			ply:SetVelocity(UpPowuh)
			self:SecondaryAttack()
		end
	end
	self:NextThink(CurTime())
	return true
end
