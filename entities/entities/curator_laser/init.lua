
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

function ENT:Think()
	if self.Active then
		local tr = util.QuickTrace(self:GetPos(),self:GetAngles():Up()*700,{self})
		if tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() and tr.Entity ~= GAMEMODE.Curator then
			tr.Entity:TakeDamage(1,GAMEMODE.Curator,self)
			tr.Entity:SetNWInt("Detection",math.Clamp(tr.Entity:GetNWInt("Detection")+10,0,1000))
		end
	end
	self:NextThink(CurTime() + 0.25)
	return true
end

function ENT:OnRemove()
	if self.Item and self.Item.OnRemove then self.Item:OnRemove() end
end
 
function ENT:ReActivate()
	self.Active = true
	self:EmitSound("HL1/fvox/activated.wav",SNDLVL_VOICE,100)
	self:SetNWBool("Active",true)
end

function ENT:DeActivate()
	self.Active = false
	self:SetNWBool("Active",false)
end 

function ENT:TemporarilyDisable()
	self:DeActivate()
	self.timer = timer.Create(self:EntIndex().."Reenable",5,1,function() self:ReActivate() end)
end 