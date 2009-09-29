
include('shared.lua')

local bMat = Material( "cable/redlaser" )
local Red = Color( 255, 0, 0, 255 )

function ENT:OnRemove()
	
end 

function ENT:Draw()
	self.Entity:DrawModel()
	if self:GetNWBool("Active") then
		render.SetMaterial(bMat)
		--local tr = util.QuickTrace(self:GetPos(),self:GetAngles():Up()*700,self,MASK_SOLID_BRUSHONLY)
		--self:SetRenderBoundsWS(self:GetPos(),tr.HitPos)
		--render.DrawBeam( self:GetPos(), tr.HitPos, 5, 0, 0, Red )
		--debugoverlay.Line( self:GetPos(), tr.HitPos)
		local tr = {}
		local numtra = 6
		local dist = self:BoundingRadius()*2
		for i=math.floor(numtra/-2),math.floor(numtra/2),1 do
			tr[i] = util.QuickTraceHull(self:GetPos()+(self:GetAngles():Up()*i*(dist/numtra)),self:GetAngles():Right()*1000,self:OBBMins()/numtra,self:OBBMaxs()/numtra,{self},MASK_SOLID_BRUSHONLY) --convoluted shit here. All for the sake of resolution.
			render.DrawBeam( self:GetPos(), tr[i].HitPos, 5, 0, 0, Red )
			debugoverlay.Line( self:GetPos(), tr[i].HitPos)
		end
	end
end 