local Mat = Material("effects/emp_ring")

local AVec = Vector(1,1,1)

function EFFECT:Init(efdata)
	self.Length = efdata:GetMagnitude()
	self.End = CurTime()+self.Length
	self.Start = CurTime()
	self.Size = efdata:GetScale()
	self.Pos = efdata:GetOrigin()
	self.Entity:SetPos(self.Pos)
	self.Elapsed = 0
	
	self.RandVecs = {}
	for i=1,7 do
		self.RandVecs[i] = VectorRand()
	end
	
	self.Entity:SetRenderBoundsWS(self.Pos+(AVec*-self.Size),self.Pos+(AVec*self.Size))
end 

function EFFECT:Think()
	return not (CurTime() > self.End)
end 

--[[
 ---Blue Uns---

sprites/strider_blackball
sprites/bluelight
sprites/physring1
sprites/physcannon_bluecore1b
sprites/physcannon_bluecore2b

---Other Uns---

sprites/flare1
sprites/glow01
sprites/orangecore1
sprites/glow
sprites/halo
]]

function EFFECT:Render()
	self.Elapsed = CurTime()-self.Start
	render.SetMaterial(Mat)
	for i=1,7 do
		local TehCol = Color(255,255,255,255*(1-(self.Elapsed/self.Length)))
		render.DrawQuadEasy( self.Pos,
		self.RandVecs[i],
		self.Size*(self.Elapsed/self.Length), self.Size*(self.Elapsed/self.Length),
		TehCol
		)
		
		render.DrawQuadEasy( self.Pos,
		self.RandVecs[i]*-1,
		self.Size*(self.Elapsed/self.Length), self.Size*(self.Elapsed/self.Length),
		TehCol
		)
	end
end 