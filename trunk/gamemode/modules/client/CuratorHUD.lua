color_Tgrey = Color(100, 100, 100, 150)

CurrentMenu = nil

CuratorSpawnM = {}
function CuratorSpawnM:PerformLayout()
	if !ValidEntity(MainP) then

		MainP = vgui.Create("CMainPanel")
		MainP:SetSize(532, 136)
		MainP:SetPos(144, 5)
		MainP:SetVisible(false)

					SecurityP = vgui.Create("CItemPanel")
					SecurityP:SetParent(MainP)
					SecurityP:SetSize(MainP:GetWide(), MainP:GetTall())
					SecurityP:SetPos(0, 0)
					SecurityP:SetInfo(Security.GetItems())
					SecurityP:SetVisible(false)

					FamilyP = vgui.Create("CItemPanel")
					FamilyP:SetParent(MainP)
					FamilyP:SetSize(MainP:GetWide(), MainP:GetTall())
					FamilyP:SetPos(0, 0)
					FamilyP:SetInfo(Security.GetItems()) --remember to change to others later
					FamilyP:SetVisible(false)

					FancyP = vgui.Create("CItemPanel")
					FancyP:SetParent(MainP)
					FancyP:SetSize(MainP:GetWide(), MainP:GetTall())
					FancyP:SetPos(0, 0)
					FancyP:SetInfo(Security.GetItems())
					FancyP:SetVisible(false)

					EnthusistP = vgui.Create("CItemPanel")
					EnthusistP:SetParent(MainP)
					EnthusistP:SetSize(MainP:GetWide(), MainP:GetTall())
					EnthusistP:SetPos(0, 0)
					EnthusistP:SetInfo(Security.GetItems())
					EnthusistP:SetVisible(false)

		SecurityB = vgui.Create("CIcon")
		SecurityB:SetParent(self)
		SecurityB:SetSize(64, 64)
		SecurityB:SetPos(2, 2)
		SecurityB:SetInfo("CuratorHUD/lock", SecurityP)

		FamilyB = vgui.Create("CIcon")
		FamilyB:SetParent(self)
		FamilyB:SetSize(64, 64)
		FamilyB:SetPos(68, 2)
		FamilyB:SetInfo("CuratorHUD/family", FamilyP)

		FancyB = vgui.Create("CIcon")
		FancyB:SetParent(self)
		FancyB:SetSize(64, 64)
		FancyB:SetPos(2, 68)
		FancyB:SetInfo("CuratorHUD/fancy", FancyP)

		EnthusistB = vgui.Create("CIcon")
		EnthusistB:SetParent(self)
		EnthusistB:SetSize(64, 64)
		EnthusistB:SetPos(68, 68)
		EnthusistB:SetInfo("CuratorHUD/person", EnthusistP)
	end
end

function CuratorSpawnM:Paint()
	draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), color_Tgrey)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	local Muny = "$"..math.floor(LocalPlayer():GetNWInt("money"))
	draw.SimpleText(Muny, "Default", self:GetWide()/2, self:GetTall() - 10, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
vgui.Register("CuratorSpawnM", CuratorSpawnM, "Panel")

CIcon = {}
function CIcon:SetInfo(T, C)
	self.Texture = T
	self.Child = C
end

function CIcon:OnMousePressed(mc)
	if mc != 107 then return end

	SecurityB.Selected = false
	FamilyB.Selected = false
	FancyB.Selected = false
	EnthusistB.Selected = false

	if CurrentMenu != nil then
		if CurrentMenu == self.Child then
			CurrentMenu:SetVisible(false)
			MainP:SetVisible(false)
			CurrentMenu = nil
		else
			self.Selected = true
			CurrentMenu:SetVisible(false)
			MainP:SetVisible(true)
			CurrentMenu = self.Child
			self.Child:SetVisible(true)
		end
	else
		self.Selected = true
		MainP:SetVisible(true)
		CurrentMenu = self.Child
		self.Child:SetVisible(true)
	end
end

function CIcon:OnCursorEntered()
	self.Over = true
end

function CIcon:OnCursorExited()
	self.Over = false
end

function CIcon:Paint()
	if self.Selected then
		surface.SetDrawColor(255, 255, 255, 40)
		surface.SetTexture(surface.GetTextureID("gui/center_gradient"))
		surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
	end

	if self.Over then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(surface.GetTextureID(self.Texture))
		surface.DrawTexturedRect(-2, -2, self:GetWide() + 4, self:GetTall()+ 4)
	else
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(surface.GetTextureID(self.Texture))
		surface.DrawTexturedRect(6, 6, self:GetWide() - 12, self:GetTall() - 12)
	end
end
vgui.Register("CIcon", CIcon, "Panel")

CMainPanel = {}
function CMainPanel:Paint()
	draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), color_Tgrey)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end
vgui.Register("CMainPanel", CMainPanel, "Panel")

CItemPanel = {}
function CItemPanel:PerformLayout()

end

function CItemPanel:SetInfo(tbl)
	self.Info = tbl

	self.List = vgui.Create("DPanelList")
	self.List:SetParent(self)
	self.List:SetSize(self:GetWide() - 2, self:GetTall() - 2)
	self.List:SetPos(1, 1)
	self.List:SetSpacing(2)
	self.List:SetPadding(2)
	self.List:EnableHorizontal(true)
	self.List:EnableVerticalScrollbar(false)
	self.List.Paint = function() end

	for k, v in pairs(tbl) do
		local Icon = vgui.Create("SpawnIcon")
		Icon:SetModel(v:GetModel())
		Icon.Item = k
		Icon.DoClick = function(Icon)
			LocalPlayer().GhostIsActive = true
			LocalPlayer().GhostModel = Icon.Item:GetModel()
			LocalPlayer().GhostItem = Icon.Item
			print("Yeah")
		end
		Icon.DoRightClick = function(Icon)
			CreateItemInformationWindow(Icon.Item)
		end
		self.List:AddItem(Icon)
	end
end

function CreateItemInformationWindow(item)

end

function CItemPanel:Paint()

end
vgui.Register("CItemPanel", CItemPanel, "Panel")

function PaintOver()

end
hook.Add("PostRenderVGUI", "PaintOverHook", PaintOver)

--[[
function ShowMouse()
	RestoreCursorPosition()
	gui.EnableScreenClicker(true)
end
hook.Add("OnSpawnMenuOpen", "ShowMouse", ShowMouse)

function HideMouse()
	RememberCursorPosition()
	gui.EnableScreenClicker(false)
end
hook.Add("OnSpawnMenuClose", "HideMouse", HideMouse)]]