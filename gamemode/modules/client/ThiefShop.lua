ThiefShop = {}
function ThiefShop:PerformLayout()
	if not ValidEntity(self.BG) then
	self.BG = vgui.Create("DFrame")
	self.BG:SetTitle("Shop")
	self.BG:SetSize(800,600)
	self.BG:SetPos(ScrW()/2-400,ScrH()/2-300)
	
	local TopList = vgui.Create("DPanelList")
	for k,v in ipairs(Thief.GetItems()) do
		local Icon = vgui.Create("SpawnIcon")
		Icon:SetModel(v:GetModel())
		Icon.Item = v
		Icon.DoClick = function(Icon)

		end
		Icon.OnMousePressed = function(Icon,enum)
			if enum == 108 then
				--right click stuff here
			elseif enum == 107 then
				Icon:DoClick()
			end
		end
		TopList:AddItem(Icon)
	end
	
	local BottomList = vgui.Create("DPanelList")
	for k,v in ipairs(LocalPlayer().MyItems or {}) do
		local Icon = vgui.Create("SpawnIcon")
		Icon:SetModel(v:GetModel())
		Icon.Item = v
		Icon.DoClick = function(Icon)

		end
		Icon.OnMousePressed = function(Icon,enum)
			if enum == 108 then
				--right click stuff here
			elseif enum == 107 then
				Icon:DoClick()
			end
		end
		BottomList:AddItem(Icon)
	end
	
	self.Divider = vgui.Create("DVerticalDivider",self.BG)
	self.Divider:SetPos(4,26)
	self.Divider:SetSize(800-8,600-31)
	self.Divider:SetTopHeight((800-8)/2-10)
	self.Divider:SetDividerHeight(10)
	self.Divider:SetTop(TopList)
	self.Divider:SetBottom(BottomList)
	
	end
end

function ThiefShop:Paint()

end
vgui.Register("ThiefShop", ThiefShop, "Panel")