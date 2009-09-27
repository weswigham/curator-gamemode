local color_grey = Color(0,0,0,150)

local InvPanel = {}
function InvPanel:PerformLayout()
	if !ValidEntity(self["Slot1"]) then
		if LocalPlayer().MyItems then
			for k,v in ipairs(LocalPlayer().MyItems) do
				local pos = "Slot"..k
				self[pos] = vgui.Create("SpawnIcon")
				self[pos]:SetParent(self)
				self[pos]:SetModel(v:GetModel())
				self[pos]:SetPos(22, k*2 + 64*(k-1))
			end
		end
	end
end

function InvPanel:UpdateItems()
	local Open = Inventory:IsVisible()
	RunConsoleCommand("UpdateItems")
	Inventory:Remove()
	Inventory = nil
	Inventory = vgui.Create("InvPanel")
	Inventory:SetPos(20, ScrH()/2-(133+32))
	Inventory:SetSize(88, (268+64))
	if Open then
		Inventory:Open()
	else
		Inventory:Close()
	end
end

function InvPanel:Open()
	RunConsoleCommand("UpdateItems")
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