
SWEP.Author			= "Levybreak"
SWEP.Contact		= "Facepunch"
SWEP.Purpose		= "EMP! Pronounced 'EMP' not 'E-EM-PEE'"
SWEP.Instructions	= "Temporarily Disables all electronic devices in a 30 ft radius. (5 seconds) Single use only."

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

function SWEP:Initialize()
	if ( SERVER ) then
       self:SetWeaponHoldType( self.HoldType )
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
		
		GAMEMODE:SetPlayerAnimation( self.Owner, PLAYER_ATTACK1 )
	
	end
	
	

end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	
	self.Weapon:SetNextSecondaryFire(CurTime() + 2)
	
	if (!SERVER) then return end
	
	
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
