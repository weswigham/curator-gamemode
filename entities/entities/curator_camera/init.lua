
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableMotion(false)
	end

	self:TemporarilyDisable()
end

--MiniTurret.Shoot

local red = Color(255,0,0,255)

function ENT:Think()
	if self.Active == true then
		for k,v in ipairs(player.FindInCone(self:GetPos(),self:GetPos()+(self:GetAngles():Forward()*1000),500)) do
			--if v ~= GAMEMODE.Curator and self:Visible(v) and self:GetPos():Distance(v:GetPos()) <= 2000 then
			if v:IsPlayer() and v ~= GAMEMODE.Curator and self:Visible(v) then
				v:SetNWInt("Detection",math.Clamp(v:GetNWInt("Detection")+25,0,1000))
				debugoverlay.Cross(self:GetPos(),50,1,red)
				debugoverlay.Line(self:GetPos(),v:GetPos(),1,red)
				debugoverlay.Cross(v:GetPos(),50,1,red)
			end
		end
		debugoverlay.Cross(self:GetPos(),50)
		debugoverlay.Line(self:GetPos(),self:GetPos()+(self:GetAngles():Forward()*1000))
		debugoverlay.Cross(self:GetPos()+(self:GetAngles():Forward()*1000),50)
		debugoverlay.Sphere(self:GetPos()+(self:GetAngles():Forward()*1000),500)
	end
	self:NextThink(CurTime() + 0.5)
	return true
end

function ENT:OnRemove()
	if self.Item and self.Item.OnRemove then self.Item:OnRemove() end
end
 
function ENT:ReActivate()
	self.Active = true
	self:EmitSound("HL1/fvox/activated.wav",SNDLVL_VOICE,100)
	print("Activated")
end

function ENT:DeActivate()
	self.Active = false
end 

function ENT:TemporarilyDisable(num)
	self:DeActivate()
	self.timer = timer.Create(self:EntIndex().."Reenable",num or 5,1,function() self:ReActivate() end)
end 