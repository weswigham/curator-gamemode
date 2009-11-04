ENT.Type = "point"
ENT.Base = "base_point"

function ENT:Initialize() 
	if GAMEMODE.Curator then
		SendUserMessage("RecieveNodeGuardPos",GAMEMODE.Curator,self:GetPos())
	else
		MsgN("Ahhh...what the fuck. On the curator can spawn a guard_node... and there's no Curator. ???")
		self:Remove()
	end
end 

function ENT:OnRemove()
	SendUserMessage("KillGuardNodeAt",GAMEMODE.Curator,self:GetPos())
end 