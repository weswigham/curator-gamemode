
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self:SetModel("models/props_c17/FurnitureWashingmachine001a.mdl")
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableMotion(false)
	end

end

function ENT:Think()

end

function ENT:OnRemove()

end

function ENT:Use(ply,callr)
	if ply ~= GAMEMODE.Curator and ply:Alive() then
		SendUserMessage("OpenThiefBuyMenu",ply)
	end
end 
