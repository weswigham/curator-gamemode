
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self:SetModel("models/props_c17/FurnitureWashingmachine001a.mdl")
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

end

function ENT:Think()

end

function ENT:OnRemove()

end

function ENT:Use(ply,callr)
	if ply ~= GAMEMODE.Curator then
		SendUserMessage("OpenThiefBuyMenu",ply)
	end
end 