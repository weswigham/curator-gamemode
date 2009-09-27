
include('shared.lua')

local bMat = Material( "cable/redlaser" )
local Red = Color( 255, 0, 0, 255 )

function ENT:OnRemove()
	
end 

function ENT:Draw()
	self.Entity:DrawModel()
	if self:GetNWBool("Active") then
		local tr = util.QuickTrace(self:GetPos(),self:GetAngles():Up()*700,table.insert(player.GetAll(),self))
		render.DrawBeam( self:GetPos(), tr.HitPos, 2, 0, 12.5, Red )
	end
end 