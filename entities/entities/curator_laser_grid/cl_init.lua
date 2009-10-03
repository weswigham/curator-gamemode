
include('shared.lua')

local bMat = Material( "cable/redlaser" )
local Red = Color( 255, 0, 0, 255 )
local aMat = Material( "models/props_combine/com_shield001a")

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
		local DistInc = dist/numtra
		for i=math.floor(numtra/-2)+2,math.floor(numtra/2)+2 do
			local start = self:GetPos()+(self:GetAngles():Up()*i*DistInc)
			tr[i] = util.QuickTraceHull(start,self:GetAngles():Right()*1000,self:OBBMins()/numtra,self:OBBMaxs()/numtra,{self},MASK_SOLID_BRUSHONLY) --convoluted shit here. All for the sake of resolution.
			render.DrawBeam( start, tr[i].HitPos, 5, 0, 0, Red )
			debugoverlay.Line( start, tr[i].HitPos)
			debugoverlay.Cross(start,20)
			--print(i,dist,numtra,self:GetAngles():Up())
		end
		self:SetRenderBoundsWS(self:GetPos(),tr[#tr].HitPos)
		render.SetMaterial(aMat)
		render.DrawQuadEasy( (tr[#tr].StartPos+tr[#tr].HitPos)/2,    --position of the rect
		self:GetAngles():Forward(),      --direction to face in
		tr[1].HitPos:Distance(tr[1].StartPos), dist,              --size of the rect
		Color( 255,255,255,100 )  --color...
                 )
	end
end 