
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/Barney.mdl" )
 
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
 
	self:SetSolid( SOLID_BBOX ) 
	self:SetMoveType( MOVETYPE_STEP )
 
	self:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_OPEN_DOORS | CAP_ANIMATEDFACE | CAP_TURN_HEAD | CAP_USE_SHOT_REGULATOR )
 
	self:SetMaxYawSpeed( 5000 )
 
	self:SetHealth(4000)
	
	self.AcceptableRadius = 75
	
	self:SetKeyValue("spawnflags","512")
	
	self.RecentNodes = {}
end
 
function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())
	
	if self:Health() <= 0 then
		self:SetSchedule( SCHED_FALL_TO_GROUND )
	end
 end 
 
 
/*---------------------------------------------------------
   Name: SelectSchedule
---------------------------------------------------------*/
function ENT:SelectSchedule()
	--self:StartSchedule( schdChase ) 
end

local shed = SCHED_FORCED_GO
local rndmnde = {}

local function CanTheseTwoSeeEachOther(a,b)
	local tr = util.QuickTrace(a:GetShootPos(),b:GetPos()-a:GetShootPos(),{a,b})
	debugoverlay.Cross(tr.HitPos,30)
	return tr.HitPos:Distance(b:GetPos()) < 70
end

function ENT:Think()
	if not self:IsValid() then return end
	if not self.Destination then
		table.Empty(rndmnde)
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),300)) do
			if v:IsValid() and v:GetClass() == "guard_node" and v ~= self.LastDest and CanTheseTwoSeeEachOther(self,v) then
				table.insert(rndmnde,v)
			end
		end
		if rndmnde and rndmnde[1] then
			for k,v in ipairs(rndmnde) do --hur, hur. old things have less appeal.
				if not self.RecentNodes[v] then
					self.RecentNodes[v] = 7
				else
					self.RecentNodes[v] = self.RecentNodes[v] - 1
				end
				if self.RecentNodes[v] <= 0 then self.RecentNodes[v] = 7 end
			end
			self.Destination = table.WeightedRandom(rndmnde,self.RecentNodes)
			self:SetLastPosition(self.Destination:GetPos())
			self:SetSchedule(shed)
			
		end
	else
		if not self.Destination:IsValid() then self.Destination = nil return end
		
		self:SetLastPosition(self.Destination:GetPos())
		self:SetSchedule(shed)
		
		if self.Destination:GetPos():Distance(self:GetPos()) <= self.AcceptableRadius then
			self.LastDest = self.Destination
			self.Destination = nil
		end
	end
	if self:Health() > 0 then
		local eyes = self:GetAttachment(self:LookupAttachment("eyes"))
		for k,v in ipairs(player.FindInCone(eyes.Pos-(self:GetForward()*20),eyes.Pos+(self:GetAngles():Forward()*2000),2000)) do
			if v:IsPlayer() and v ~= GAMEMODE.Curator and self:Visible(v) then
				v:SetNWInt("Detection",math.Clamp(v:GetNWInt("Detection")+math.random(50,100),0,1000))
			end
		end
	end
end 