
ENT.Base = "base_ai" 
ENT.Type = "ai"
 
ENT.PrintName		= "Curator Security Guard"
ENT.Author			= "Levybreak"
ENT.Contact			= "FP" 
ENT.Purpose			= "To server and protect"
ENT.Instructions	= "Spawn, make sure he has nodes visible."
 
ENT.AutomaticFrameAdvance = false
 
 
/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function ENT:OnRemove()
end
 
 
/*---------------------------------------------------------
   Name: PhysicsCollide
   Desc: Called when physics collides. The table contains 
			data on the collision
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )
end
 
 
/*---------------------------------------------------------
   Name: PhysicsUpdate
   Desc: Called to update the physics .. or something.
---------------------------------------------------------*/
function ENT:PhysicsUpdate( physobj )
end
 
/*---------------------------------------------------------
   Name: SetAutomaticFrameAdvance
   Desc: If you're not using animation you should turn this 
	off - it will save lots of bandwidth.
---------------------------------------------------------*/
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
 
	self.AutomaticFrameAdvance = bUsingAnim
 
end
