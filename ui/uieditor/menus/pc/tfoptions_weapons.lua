require("ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame")
require("ui.uieditor.widgets.StartMenu.StartMenu_lineGraphics_Options")
require("ui.uieditor.widgets.TabbedWidgets.basicTabList")
require("ui.uieditor.widgets.TabbedWidgets.paintshopTabWidget")
require("ui.uieditor.widgets.PC.StartMenu.GraphicsOptions.StartMenu_Options_PC_Graphics_Game")
require("ui.uieditor.widgets.PC.StartMenu.GraphicsOptions.StartMenu_Options_PC_Graphics_Video")
require("ui.uieditor.widgets.PC.StartMenu.GraphicsOptions.StartMenu_Options_PC_Graphics_Advanced")
require("ui.uieditor.widgets.PC.StartMenu.Dropdown.OptionDropdown")
require("ui.uieditor.widgets.PC.StartMenu.Dropdown.TFOptionDropdown")
require("ui.uieditor.widgets.StartMenu.StartMenu_Options_CheckBoxOption")
require("ui.uieditor.widgets.StartMenu.TFOptions_CheckBoxOption")
require("ui.uieditor.widgets.StartMenu.StartMenu_Options_SliderBar")
require("ui.uieditor.widgets.PC.Utility.VerticalListSpacer")
require("ui.t7.utility.SavingDataUtility")
require("ui.uieditor.widgets.Scrollbars.verticalCounter")





local f0_local2 = function (f29_arg0, f29_arg1)
	Engine.SyncHardwareProfileWithDvars()
	CoD.PCUtil.FreeOptionsDirtyModel(f29_arg1)
	CoD.PCUtil.ShadowOptionIndex = Engine.GetShadowQuality()
	CoD.PCUtil.VolumetricOptionIndex = Engine.GetVolumetricQuality()
	CoD.PCUtil.SaveCurrentGraphicsOptions()
end

local f0_local3 = function (f30_arg0, f30_arg1)
	f30_arg0.categoryFrame:setForceMouseEventDispatch(true)
end

DataSources.TFOptionsWeaponsP1 = DataSourceHelpers.ListSetup("PC.TFOptionsWeaponsP1", function (f26_arg0)
	local f26_local0 = {}
	--table.insert(f26_local0, {models = {label = "Add MW 2019 Weapons to box", description = "Adds all the Modern Warfare 2019 weapons to the mystery box.", profileVarName = "weap_mw2019", widgetType = "tfcheckbox"}, properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties})
	table.insert(f26_local0, {models = {label = "Start With Max Ammo", description = "Choose whether you start the game with max ammo in your pistol.", profileVarName = "max_ammo", widgetType = "tfcheckbox"}, properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties})
	table.insert(f26_local0, {models = {label = "Start With RK5", description = "Changes the starting pistol to the RK5, as if the player has completed the super ee.", profileVarName = "start_rk5", widgetType = "tfcheckbox"}, properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties})
	table.insert(f26_local0, {models = {label = "Start With Bowie Knife", description = "Gives every player the bowie knife.", profileVarName = "start_bowie", widgetType = "tfcheckbox"}, properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties})
	table.insert(f26_local0, {models = {label = "Random Starting Weapon", description = "Gives every player a random starting weapon.", profileVarName = "random_weapon", widgetType = "tfcheckbox"}, properties = CoD.TFPCUtil.OptionsGenericCheckboxProperties})
		return f26_local0
end, true)

DataSources.TFOptionsWeaponsP1.getWidgetTypeForItem = function (f27_arg0, f27_arg1, f27_arg2)
	if f27_arg1 then
		local f27_local0 = Engine.GetModelValue(Engine.GetModel(f27_arg1, "widgetType"))
		if f27_local0 == "dropdown" then
			return CoD.OptionDropdown
		elseif f27_local0 == "checkbox" then
			return CoD.StartMenu_Options_CheckBoxOption
		elseif f27_local0 == "tfcheckbox" then
			return CoD.TFOptions_CheckBoxOption
		elseif f27_local0 == "slider" then
			return CoD.StartMenu_Options_SliderBar
		elseif f27_local0 == "spacer" then
			return CoD.VerticalListSpacer
		end
	end
	return nil
end



DataSources.TFOptionWeaponsCategories = DataSourceHelpers.ListSetup("PC.TFOptionWeaponsCategories", function (f28_arg0)
	local f28_local0 = {}
	table.insert(f28_local0, {models = {tabIcon = CoD.buttonStrings.shoulderl}, properties = {m_mouseDisabled = true}})
	table.insert(f28_local0, {models = {tabName = "WEAPON OPTIONS", tabWidget = "CoD.TFOptions_Weapons_P1"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 4", tabWidget = "CoD.TFOptions_ZCounter"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 5", tabWidget = "CoD.TFOptions_ZCounter"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 6", tabWidget = "CoD.TFOptions_ZCounter"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 7", tabWidget = "CoD.TFOptions_ZCounter"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 8", tabWidget = "CoD.TFOptions_ZCounter"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 9", tabWidget = "CoD.TFOptions_ZCounter"}})
	table.insert(f28_local0, {models = {tabIcon = CoD.buttonStrings.shoulderr}, properties = {m_mouseDisabled = true}})
	return f28_local0
end, true)

LUI.createMenu.TFOptionsWeaponsPage = function (InstanceRef)
	local HudRef = CoD.Menu.NewForUIEditor("TFOptionsWeaponsPage")
	if f0_local2 then
		f0_local2(HudRef, InstanceRef)
	end




	HudRef.soundSet = "ChooseDecal"
	HudRef:setOwner(InstanceRef)
	HudRef:setLeftRight(true, true, 0, 0)
	HudRef:setTopBottom(true, true, 0, 0)
	HudRef:playSound("menu_open", InstanceRef)
	HudRef.buttonModel = Engine.CreateModel(Engine.GetModelForController(InstanceRef), "TFOptionsWeaponsPage.buttonPrompts")
	local f31_local1 = HudRef
	HudRef.anyChildUsesUpdateState = true
	local f31_local2 = LUI.UIImage.new()
	f31_local2:setLeftRight(true, false, 0, 1280)
	f31_local2:setTopBottom(true, false, 0, 720)
	f31_local2:setRGB(0, 0, 0)
	f31_local2:setAlpha(1);
	HudRef:addElement(f31_local2)
	HudRef.Background = f31_local2
	
	local f31_local3 = CoD.GenericMenuFrame.new(f31_local1, InstanceRef)
	f31_local3:setLeftRight(true, true, 0, 0)
	f31_local3:setTopBottom(true, true, 0, 0)
	f31_local3.titleLabel:setText(" ")
	f31_local3.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(" ")
	f31_local3.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.FeatureIcon:setImage(RegisterImage("uie_t7_mp_icon_header_option"))
	HudRef:addElement(f31_local3)
	HudRef.MenuFrame = f31_local3
	
	local f31_local4 = LUI.UIImage.new()
	f31_local4:setLeftRight(true, false, 120, 576)
	f31_local4:setTopBottom(true, false, 22, 76)
	f31_local4:setRGB(0.9, 0.9, 0.9)
	f31_local4:setImage(RegisterImage("tfzoptions_title"))
	HudRef:addElement(f31_local4)
	HudRef.CategoryListLine = f31_local4
	
	local f31_local5 = CoD.StartMenu_lineGraphics_Options.new(f31_local1, InstanceRef)
	f31_local5:setLeftRight(true, false, 1, 69)
	f31_local5:setTopBottom(true, false, -13, 657)
	HudRef:addElement(f31_local5)
	HudRef.StartMenulineGraphicsOptions0 = f31_local5
	
	local f31_local6 = LUI.UIImage.new()
	f31_local6:setLeftRight(true, false, -11, 1293)
	f31_local6:setTopBottom(true, false, 80, 88)
	f31_local6:setRGB(0.9, 0.9, 0.9)
	f31_local6:setImage(RegisterImage("uie_t7_menu_cac_tabline"))
	HudRef:addElement(f31_local6)
	HudRef.CategoryListLine0 = f31_local6
	
	local f31_local7 = CoD.basicTabList.new(f31_local1, InstanceRef)
	f31_local7:setLeftRight(true, false, 64, 1216)
	f31_local7:setTopBottom(true, false, 84, 124)
	f31_local7.grid:setDataSource("TFOptionWeaponsCategories")
	f31_local7.grid:setWidgetType(CoD.paintshopTabWidget)
	f31_local7.grid:setHorizontalCount(11)
	HudRef:addElement(f31_local7)
	HudRef.Tabs = f31_local7
	
	local f31_local8 = LUI.UIFrame.new(f31_local1, InstanceRef, 0, 0, false)
	f31_local8:setLeftRight(true, false, 64, 1216)
	f31_local8:setTopBottom(true, false, 134.22, 657)
	HudRef:addElement(f31_local8)
	HudRef.categoryFrame = f31_local8

	
	f31_local8:linkToElementModel(f31_local7.grid, "tabWidget", true, function (ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			f31_local8:changeFrameWidget(ModelValue)
		end
	end)
	HudRef:registerEventHandler("menu_loaded", function (Sender, Event)
		local f39_local0 = nil
		ShowHeaderIconOnly(f31_local1)
		if not f39_local0 then
			f39_local0 = Sender:dispatchEventToChildren(Event)
		end
		return f39_local0
	end)
	f31_local1:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function (f40_arg0, f40_arg1, f40_arg2, f40_arg3)
		if ShouldOpenGraphicsConfirm(f40_arg1, f40_arg0, f40_arg2) then
			--OpenSystemOverlay(HudRef, f40_arg1, f40_arg2, "ConfirmPCGraphicsChange", nil)
			GoBack(HudRef, f40_arg2)
			return true
		else
			GoBack(HudRef, f40_arg2)
			return true
		end
	end, function (f41_arg0, f41_arg1, f41_arg2)
		CoD.Menu.SetButtonLabel(f41_arg1, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK")
		return true
	end, false)
	f31_local1:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_START, "M", function (f42_arg0, f42_arg1, f42_arg2, f42_arg3)
		if ShouldOpenGraphicsConfirm(f42_arg1, f42_arg0, f42_arg2) then
			--OpenSystemOverlay(HudRef, f42_arg1, f42_arg2, "ConfirmPCGraphicsChange", nil)
			CloseStartMenu(f42_arg1, f42_arg2)
			return true
		else
			CloseStartMenu(f42_arg1, f42_arg2)
			return true
		end
	end, function (f43_arg0, f43_arg1, f43_arg2)
		CoD.Menu.SetButtonLabel(f43_arg1, Enum.LUIButton.LUI_KEY_START, "MENU_DISMISS_MENU")
		return true
	end, false)
	--f31_local1:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, "F", function (f44_arg0, f44_arg1, f44_arg2, f44_arg3)
		--OpenPCApplyGraphicsPopup(HudRef, f44_arg0, f44_arg2)
	--	return true
	--end, function (f45_arg0, f45_arg1, f45_arg2)
	--	CoD.Menu.SetButtonLabel(f45_arg1, Enum.LUIButton.LUI_KEY_XBX_PSSQUARE, "MENU_APPLY")
	--	return true
	--end, false)
	f31_local1:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "R", function (f46_arg0, f46_arg1, f46_arg2, f46_arg3)
		--OpenSystemOverlay(HudRef, f46_arg1, f46_arg2, "ResetPCGraphics", nil)
		CoD.TFPCUtil.ResetToDefault()
		GoBack(HudRef, f46_arg2)
		return true
	end, function (f47_arg0, f47_arg1, f47_arg2)
		CoD.Menu.SetButtonLabel(f47_arg1, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "PLATFORM_RESET_TO_DEFAULT")
		return true
	end, false)
	f31_local1:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil, function (f48_arg0, f48_arg1, f48_arg2, f48_arg3)
		return true
	end, function (f49_arg0, f49_arg1, f49_arg2)
		CoD.Menu.SetButtonLabel(f49_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT")
		return true
	end, false)
	f31_local3:setModel(HudRef.buttonModel, InstanceRef)
	f31_local8.id = "categoryFrame"
	HudRef:processEvent({name = "menu_loaded", controller = InstanceRef})
	HudRef:processEvent({name = "update_state", menu = f31_local1})
	if not HudRef:restoreState() then
		HudRef.categoryFrame:processEvent({name = "gain_focus", controller = InstanceRef})
	end
	LUI.OverrideFunction_CallOriginalSecond(HudRef, "close", function (Sender)
		Sender.MenuFrame:close()
		Sender.StartMenulineGraphicsOptions0:close()
		Sender.Tabs:close()
		Sender.categoryFrame:close()
		Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "TFOptionsWeaponsPage.buttonPrompts"))
	end)
	if f0_local3 then
		f0_local3(HudRef, InstanceRef)
	end
	return HudRef
end

