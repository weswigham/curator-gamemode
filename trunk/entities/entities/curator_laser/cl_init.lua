
include('shared.lua')

local bMat = Material( "cable/redlaser" )
local Red = Color( 255, 0, 0, 255 )

function ENT:OnRemove()
	
end 

function ENT:Draw()
	self.Entity:DrawModel()
	if self:GetNWBool("Active") then
		render.SetMaterial(bMat)
		local tr = util.QuickTrace(self:GetPos(),self:GetAngles():Up()*700,table.insert(player.GetAll(),self))
		render.DrawBeam( self:GetPos(), tr.HitPos, 5, 0, 0, Red )
	end
end 