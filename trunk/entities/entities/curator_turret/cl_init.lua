include('shared.lua')

local bMat = Material( "cable/redlaser" )
local Red = Color( 255, 0, 0, 255 )

ENT.AutomaticFrameAdvance = true 

function ENT:OnRemove()
	
end 

function ENT:Draw()
	self.Entity:DrawModel()
	if self:GetNWBool("Active") then
		render.SetMaterial(bMat)
		
		local atm = self:LookupAttachment("eyes")
		local tbl = self:GetAttachment(atm)
		local tr = util.QuickTrace(tbl.Pos,tbl.Ang:Forward()*1000,self,MASK_SOLID_BRUSHONLY)
		self:SetRenderBoundsWS(tbl.Pos,tr.HitPos)
		render.DrawBeam( tbl.Pos, tr.HitPos, 5, 0, 0, Red )
		debugoverlay.Line( tbl.Pos, tr.HitPos)
	end
end 

function ENT:Think() 
	if self:GetNWBool("Active") then
		if self:GetNWInt("FiringAt") > 0 then
			local atm = self:LookupAttachment("eyes")
			local tbl = self:GetAttachment(atm)
			local ply = player.GetByID(self:GetNWInt("FiringAt"))
			self.Entity:SetPoseParameter( "aim_yaw", ((ply:GetShootPos()-tbl.Pos):Angle()).y )
			self.Entity:SetPoseParameter( "aim_pitch", ((ply:GetShootPos()-tbl.Pos):Angle()).p )
			local fire = self:LookupSequence("fire")
			self:SetSequence(fire)
		else
			local idle = self:LookupSequence("idle")
			self:ResetSequence(idle)
			self.Entity:SetPoseParameter( "aim_yaw", math.sin( CurTime() ) * 60 )
			self.Entity:SetPoseParameter( "aim_pitch", 0 )
		end
	end
	self:NextThink(CurTime())
	return true
end 