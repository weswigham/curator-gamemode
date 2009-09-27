ThiefShop = {}
function ThiefShop:PerformLayout()
	
	if not ValidEntity(self.BG) then self.BG = vgui.Create("DFrame") end
	self.BG:SetTitle("Shop")
	self.BG:SetSize(800,600)
	self.BG:SetPos(ScrW()/2-400,ScrH()/2-300)
	if not self.BG.OldClose then
		self.BG.OldClose = self.BG.Close
		self.BG.Close = function(BG) BG:OldClose() gui.EnableScreenClicker(false) end
	end
	
	if not ValidEntity(self.TopList) then self.TopList = vgui.Create("DPanelList",self.BG) end
	self.TopList:Clear()
	
	self.TopList:SetPos(4,26)
	self.TopList:SetSize(800-8,(600-31)/2-10)
	self.TopList:EnableHorizontal(true)
	
	for k,v in pairs(Thief.GetItems()) do
		print(k)
		local Icon = vgui.Create("SpawnIcon")
		Icon:SetModel(v:GetModel())
		Icon.Item = v
		Icon.DoClick = function(Icon)
			if LocalPlayer():GetNWInt("money") >= Icon.Item:GetPrice() then
				Derma_Query("Are you sure you want to buy this "..Icon.Item:GetName().."?","Confirmation Dialogue","Yes",function() RunConsoleCommand("BuyItem",Icon.Item:GetName()) end,"No",function() end)
			else
				LocalPlayer():PrintMessage(HUD_PRINTCHAT,"You don't have enough money for that "..Icon.Item:GetName())
			end
		end
		Icon.OnMousePressed = function(Icon,enum)
			if enum == 108 then
				CreateThiefItemInformationWindow(Icon.Item)
			elseif enum == 107 then
				Icon:DoClick()
			end
		end
		self.TopList:AddItem(Icon)
	end
	
	self.TopList:InvalidateLayout()
	
	if not ValidEntity(self.BottomList) then self.BottomList = vgui.Create("DPanelList",self.BG) end
	self.BottomList:Clear()
	
	self.BottomList:SetPos(4,((600-31)/2)+20)
	self.BottomList:SetSize(800-8,(600-31)/2-10)
	self.BottomList:EnableHorizontal(true)

	for k,v in pairs(LocalPlayer().MyItems or {}) do
		print(k)
		local Icon = vgui.Create("SpawnIcon")
		Icon:SetModel(v:GetModel())
		Icon.Item = v
		Icon.IIndex = k
		Icon.DoClick = function(Icon)
			Derma_Query("Are you sure you want to sell this "..Icon.Item:GetName().."?","Confirmation Dialogue","Yes",function() RunConsoleCommand("SellItem",Icon.IIndex) end,"No",function() end)
		end
		Icon.OnMousePressed = function(Icon,enum)
			if enum == 108 then
				CreateThiefItemInformationWindow(Icon.Item)
			elseif enum == 107 then
				Icon:DoClick()
			end
		end
		self.BottomList:AddItem(Icon)
	end
	
	
	self.BottomList:InvalidateLayout()
	
	gui.EnableScreenClicker(true)
end

function ThiefShop:Init()
	--[[if not ValidEntity(self.BG) then
	
	RunConsoleCommand("UpdateItems")
	
	self.BG = vgui.Create("DFrame")
	self.BG:SetTitle("Shop")
	self.BG:SetSize(800,600)
	self.BG:SetPos(ScrW()/2-400,ScrH()/2-300)
	self.BG.OldClose = self.BG.Close
	self.BG.Close = function(BG) BG:OldClose() gui.EnableScreenClicker(false) end
	
	self.TopList = vgui.Create("DPanelList",self.BG)
	for k,v in pairs(Thief.GetItems()) do
		print(k)
		local Icon = vgui.Create("SpawnIcon")
		Icon:SetModel(v:GetModel())
		Icon.Item = v
		Icon.DoClick = function(Icon)
			if LocalPlayer():GetNWInt("money") <= Icon.Item:GetPrice() then
				Derma_Query("Are you sure you want to buy this "..Icon.Item:GetName().."?","Confirmation Dialogue","Yes",function() RunConsoleCommand("BuyItem",Icon.Item:GetName()) end,"No",function() end)
			else
				LocalPlayer():PrintMessage(HUD_PRINTCHAT,"You don't have enough money for that "..Icon.Item:GetName())
			end
		end
		Icon.OnMousePressed = function(Icon,enum)
			if enum == 108 then
				CreateThiefItemInformationWindow(Icon.Item)
			elseif enum == 107 then
				Icon:DoClick()
			end
		end
		self.TopList:AddItem(Icon)
	end
	
	self.BottomList = vgui.Create("DPanelList",self.BG)
	for k,v in pairs(LocalPlayer().MyItems or {}) do
		print(k)
		local Icon = vgui.Create("SpawnIcon")
		Icon:SetModel(v:GetModel())
		Icon.Item = v
		Icon.IIndex = k
		Icon.DoClick = function(Icon)
			Derma_Query("Are you sure you want to sell this "..Icon.Item:GetName().."?","Confirmation Dialogue","Yes",function() RunConsoleCommand("SellItem",Icon.IIndex) end,"No",function() end)
		end
		Icon.OnMousePressed = function(Icon,enum)
			if enum == 108 then
				CreateThiefItemInformationWindow(Icon.Item)
			elseif enum == 107 then
				Icon:DoClick()
			end
		end
		self.BottomList:AddItem(Icon)
	end
	
	self.TopList:SetPos(4,26)
	self.TopList:SetSize(800-8,(600-31)/2-10)
	self.TopList:EnableHorizontal(true)
	
	self.BottomList:SetPos(4,(600-31)/2)
	self.BottomList:SetSize(800-8,(600-31)/2-10)
	self.BottomList:EnableHorizontal(true)
	
	end]]
	if self.BG then self.BG:OldClose() end
	gui.EnableScreenClicker(true)
end

function CreateThiefItemInformationWindow(item)

	local BG = vgui.Create("DFrame")
	BG:SetPos((ScrW()/2)-200,(ScrH()/2)-50)
	BG:SetSize(400,100)
	BG:SetTitle(item:GetName())
	
	local SIcon = vgui.Create("SpawnIcon", BG)
	SIcon:SetModel(item:GetModel())
	SIcon:SetPos(6,29)
	SIcon.Item = item
	SIcon.DoClick = function(Icon)

	end
	
	local Cost = vgui.Create("DLabel", BG)
	Cost:SetFont("HudHintTextLarge")
	Cost:SetPos(74,29)
	Cost:SetText("Worth: $"..item:GetPrice().."\n"..item:GetInformation())
	Cost:SizeToContents()
	
end



function ThiefShop:Paint()

end
vgui.Register("ThiefShop", ThiefShop, "Panel")