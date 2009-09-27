
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

end

function ENT:Think()
	if self.Fading then
		if CurTime() <= self.FadeEndTime then
			local frac = 150*((CurTime()-self.FadeStartTime)/(self.FadeEndTime-self.FadeStartTime))
			self:SetColor(255,255,255,105+frac)
		end
	end
end

function ENT:OnRemove()
	if self.Item and self.Item.OnRemove then self.Item:OnRemove() end
end

function ENT:Use(ply,callr)
	if ply ~= GAMEMODE.Curator then
		GAMEMODE:StealArt(ply,self,self.Item)
	end
end 

function ENT:Fade(dur)
	self.FadeStartTime = CurTime()
	self.FadeEndTime = CurTime() + dur
	self.Fading = true
end 

function ENT:StopFade()
	self.Fading = false
	self.FadeStartTime = nil
	self.FadeEndTime = nil
	self:SetColor(255,255,255,255)
end 