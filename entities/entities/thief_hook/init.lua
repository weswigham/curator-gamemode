
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableMotion(true)
		phys:Wake()
	end
	
	self.MoveRopeName = ""
	self.RopeName = ""
	self.Player = nil
end

function ENT:Think()

end

function ENT:OnRemove()

end

function ENT:Use(ply,callr)

end 

function ENT:PhysicsCollide(data,pobj)
	if SERVER then
		if data.HitPos:IsInLadder() then
			pobj:EnableMotion(false)
			self.HookedOn = true
			local num = self:GetPos():Distance(self.Player:GetPos())*-1
			for k,v in ipairs(ents.FindByName(self.RopeName)) do
				v:SetKeyValue("Slack",tostring(num))
			end
			for k,v in ipairs(ents.FindByName(self.MoveRopeName)) do
				v:SetKeyValue("Slack",tostring(num))
			end
		end
	end
end 