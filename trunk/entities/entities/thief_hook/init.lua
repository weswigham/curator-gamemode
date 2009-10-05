
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
			print("Latched On!")
		end
	end
end 