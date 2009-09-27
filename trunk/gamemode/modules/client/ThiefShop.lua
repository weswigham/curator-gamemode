ThiefShop = {}
function ThiefShop:PerformLayout()
	if not ValidEntity(self.BG) then
	
	RunConsoleCommand("UpdateItems")
	
	self.BG = vgui.Create("DFrame")
	self.BG:SetTitle("Shop")
	self.BG:SetSize(800,600)
	self.BG:SetPos(ScrW()/2-400,ScrH()/2-300)
	
	local TopList = vgui.Create("DPanelList")
	for k,v in pairs(Thief.GetItems()) do
		print(k)
		local Icon = vgui.Create("SpawnIcon")
		Icon:SetModel(v:GetModel())
		Icon.Item = v
		Icon.DoClick = function(Icon)

		end
		Icon.OnMousePressed = function(Icon,enum)
			if enum == 108 then
				CreateThiefItemInformationWindow(Icon.Item)
			elseif enum == 107 then
				Icon:DoClick()
			end
		end
		TopList:AddItem(Icon)
	end
	
	local BottomList = vgui.Create("DPanelList")
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
		BottomList:AddItem(Icon)
	end
	
	self.Divider = vgui.Create("DVerticalDivider",self.BG)
	self.Divider:SetPos(4,26)
	self.Divider:SetSize(800-8,600-31)
	self.Divider:SetTopHeight((600/2)-31)
	self.Divider:SetDividerHeight(10)
	self.Divider:SetTop(TopList)
	self.Divider:SetBottom(BottomList)
	
	end
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