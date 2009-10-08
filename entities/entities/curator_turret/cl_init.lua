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
			local possibleAng = (ply:GetShootPos()-tbl.Pos):Angle()+self:GetAngles()
			
			debugoverlay.Line(tbl.Pos,tbl.Pos+(possibleAng:Forward()*20))
			debugoverlay.Cross(tbl.Pos+(possibleAng:Forward()*20),10)
			
			self.Entity:SetPoseParameter( "aim_yaw", math.wrap(possibleAng.y,-60,60) )
			self.Entity:SetPoseParameter( "aim_pitch", math.wrap(possibleAng.p,-15,15) )
			local fire = self:LookupSequence("fire")
			self:SetSequence(fire)
		else
			local idle = self:LookupSequence("idle")
			self:ResetSequence(idle)
			
			local degr = math.Rad2Deg(math.atan2(500,950))
			
			self.Entity:SetPoseParameter( "aim_yaw", math.sin( CurTime() ) * degr )
			self.Entity:SetPoseParameter( "aim_pitch", 0 )
		end
	end
	self:NextThink(CurTime())
	return true
end 

function math.wrap(number,mins,maxs)
	if number > maxs or number < mins then
		if number > maxs then
			return math.wrap(mins+(number-maxs),mins,maxs)
		elseif number < mins then
			return math.wrap(maxs+(number-mins),mins,maxs)
		end
	else
		return number
	end
end 

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	if LocalPlayer():GetNWBool("Curator") then
		RunConsoleCommand("CuratorUpdateEnt",self:EntIndex())
	end
end 