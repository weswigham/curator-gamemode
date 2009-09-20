LocalPlayer().MyItems = {{Model = "models/weapons/w_crowbar.mdl"}, {Model = "models/weapons/w_crowbar.mdl"}, {Model = "models/weapons/w_crowbar.mdl"}, {Model = "models/weapons/w_crowbar.mdl"}, {Model = "models/weapons/w_crowbar.mdl"}}
local color_grey = Color(30, 30, 30, 200)

local InvPanel = {}
function InvPanel:PerformLayout()
	if !ValidEntity(self["Slot1"]) then
		for k,v in ipairs(LocalPlayer().MyItems) do
			local pos = "Slot"..k
			self[pos] = vgui.Create("SpawnIcon")
			self[pos]:SetParent(self)
			self[pos]:SetModel(v.Model)
			self[pos]:SetPos(2, k*2 + 64*(k-1))
		end
	end
end

function InvPanel:UpdateItems()
	local Open = Inventory:IsVisible()
	Inventory:Remove()
	Inventory = nil
	Inventory = vgui.Create("InvPanel")
	Inventory:SetPos(0, ScrH()/2-(133+32))
	Inventory:SetSize(68, (268+64))
	if Open then
		Inventory:Open()
	else
		Inventory:Close()
	end
end

function InvPanel:Open()
	self:SetVisible(true)
	RestoreCursorPosition()
	gui.EnableScreenClicker(true)
end

function InvPanel:Close()
	self:SetVisible(false)
	RememberCursorPosition()
	gui.EnableScreenClicker(false)
end

function InvPanel:Paint()
	draw.RoundedBox(4, -4, 0, self:GetWide() + 4, self:GetTall(), color_grey)
end
vgui.Register("InvPanel", InvPanel, "Panel")