
SWEP.Author			= "Levybreak"
SWEP.Contact		= "Facepunch"
SWEP.Purpose		= "EMP! Pronounced 'EMP' not 'E-EM-PEE'"
SWEP.Instructions	= "Temporarily Disables all electronic devices in 750 unit radius. (7 seconds) Single use only."

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/Weapons/v_bugbait.mdl"
SWEP.WorldModel			= "models/Weapons/w_bugbait.mdl"
SWEP.HoldType			= "slam"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.RangeRadius = 750
SWEP.Duration = 7

local PlySnd = Sound("npc/roller/mine/rmine_shockvehicle2.wav")

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
	if math.random(0,100) >= 75 then
		self.Weapon:SendWeaponAnim(ACT_VM_FIDGET)
	end
end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	
	
		self.Weapon:SetNextPrimaryFire(CurTime() + 1)
		
		if (!SERVER) then return end
		
		--GAMEMODE:SetPlayerAnimation( self.Owner, PLAYER_ATTACK1 )
		
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),self.RangeRadius)) do
			if v.TemporarilyDisable then
				v:TemporarilyDisable(self.Duration)
				local efct = EffectData()
				efct:SetEntity(v)
				efct:SetOrigin(v:GetPos())
				efct:SetStart(self.Owner:GetShootPos())
				efct:SetScale(1)
				efct:SetMagnitude(5)
				util.Effect("TeslaZap",efct)
			end
		end
	
		local efct = EffectData()
		efct:SetOrigin(self.Owner:GetShootPos())
		efct:SetMagnitude(2)
		efct:SetScale(self.RangeRadius)
		util.Effect("emp_blast",efct)

		self:EmitSound(PlySnd)
		
		local ply = self.Owner
		
		local idx = nil
		print(ply.ItemList)
		for k,v in ipairs(ply.ItemList) do
			if v.Item and string.find(v.Item:GetName(),"EMP") then
				if v.Entity then v.Entity:Remove() end
				v.Item:OnRemove(ply)
				idx = k
				break				
			end
		end
		print(ply.ItemList)
		if idx and idx ~= nil then
			table.remove(ply.ItemList,idx)
			ply:SendItems()
		else
			print("Lolwhat? No item?")
			ply:StripWeapon("weapon_emp")
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
