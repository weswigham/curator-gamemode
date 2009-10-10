
SWEP.Author			= "Levybreak"
SWEP.Contact		= "Facepunch"
SWEP.Purpose		= "Protects you from bullets!"
SWEP.Instructions	= "Hold it up. (Have it out)"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.HoldType			= "ar2"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShieldModel = "models/props_borealis/borealis_door001a.mdl"

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
	if SERVER then
		if (not self.ShieldEnt) and (not self.Off) then
			self.ShieldEnt = ents.Create("prop_physics")
			self.ShieldEnt:SetModel(self.ShieldModel)
			self.ShieldEnt.Fading = true --It's like automatically disabling collisions with players, fweeeeee
			self.ShieldEnt:SetPos(self.Owner:GetShootPos()+(self.Owner:GetAimVector()*50))
			self.ShieldEnt:SetAngles(self.Owner:GetAngles())
			self.ShieldEnt:SetColor(255,255,255,50)
			self.ShieldEnt:Spawn()
			self.ShieldEnt:Activate()
			self.ShieldEnt:GetPhysicsObject():EnableMotion(false)
		elseif self.ShieldEnt and self.Off then
			self.ShieldEnt:Remove()
			self.ShieldEnt = nil
		elseif self.ShieldEnt then
			self.ShieldEnt:SetPos(self.Owner:GetShootPos()+(self.Owner:GetAimVector()*15))
			self.ShieldEnt:SetAngles(self.Owner:GetAngles())
		end
		
	end
end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	
	
		self.Weapon:SetNextPrimaryFire(CurTime() + 1)
		
		if (!SERVER) then return end
		
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
	
	if (!SERVER) then return end
	
	if not self.Off then self.Off = false end
	self.Off = !self.Off
	
end


/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
	return false
end


function SWEP:Holster()

	if (!SERVER) then return end
	if self.ShieldEnt and self.ShieldEnt:IsValid() then
		self.ShieldEnt:Remove()
		self.ShieldEnt = nil
	end
	
	return true
end

function SWEP:DrawHUD()

	if (!CLIENT) then return end

end
