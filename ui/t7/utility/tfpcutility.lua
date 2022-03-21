require("lua.Shared.LuaUtils")
require("ui.uieditor.modifyFunctions")
if not CoD.TFPCUtil then
	CoD.TFPCUtil = {}
end
CoD.TFPCUtil.GetModelValues = function (f1_arg0, f1_arg1)
	local f1_local0 = {}
	if type(f1_arg1) == "string" then
		return CoD.SafeGetModelValue(f1_arg0, f1_arg1)
	elseif type(f1_arg1) == "table" then
		for f1_local4, f1_local5 in ipairs(f1_arg1) do
			f1_local0[f1_local5] = CoD.SafeGetModelValue(f1_arg0, f1_local5)
		end
		return f1_local0
	end
	return nil
end

CoD.TFPCUtil.GetElementModelValues = function (f2_arg0, f2_arg1)
	local f2_local0 = f2_arg0:getModel()
	if f2_local0 then
		return CoD.TFPCUtil.GetModelValues(f2_local0, f2_arg1)
	else
		return nil
	end
end

CoD.TFPCUtil.TrimString = function (f3_arg0)
	return string.gsub(f3_arg0, "^%s*(.-)%s*$", "%1")
end

CoD.TFPCUtil.TokenizeString = function (f4_arg0, f4_arg1)
	local f4_local0 = {}
	local f4_local1 = f4_arg0
	local f4_local2 = 0
	local f4_local3 = string.find(f4_arg0, f4_arg1)
	while f4_local3 do
		f4_local1 = CoD.TFPCUtil.TrimString(string.sub(f4_arg0, f4_local2, f4_local3 - 1))
		if f4_local1 ~= "" then
			table.insert(f4_local0, f4_local1)
		end
		f4_local2 = f4_local3 + 1
		f4_local3 = string.find(f4_arg0, f4_arg1, f4_local2)
	end
	f4_local1 = CoD.TFPCUtil.TrimString(string.sub(f4_arg0, f4_local2, string.len(f4_arg0)))
	if f4_local1 ~= "" then
		table.insert(f4_local0, f4_local1)
	end
	return f4_local0
end

CoD.TFPCUtil.SetServerKeywordsFilter = function (f5_arg0)
	Engine.SteamServerBrowser_ClearFilter(Enum.SteamServerFilterType.STEAM_SERVER_BROWSER_FILTERTYPE_KEYWORDS)
	for f5_local3, f5_local4 in ipairs(CoD.TFPCUtil.TokenizeString(f5_arg0, ",")) do
		Engine.SteamServerBrowser_AddFilter(REG1, string.lower(f5_local4))
	end
end

CoD.TFPCUtil.GetFromSaveData = function (varName, InstanceRef)
	if varName ~= "starting_points" then
		local index = CoD.TFOptionIndexes[varName]
		index = (index * 2) + 50
		local multiple = CoD.SavingDataUtility.GetData(InstanceRef, index)
		local remainder = CoD.SavingDataUtility.GetData(InstanceRef, index + 1)
		local result = (255 * multiple) + remainder

		return result
	else 
		local index = CoD.TFOptionIndexes[varName]
		index = (index * 2) + 50
		local multof65025 = CoD.SavingDataUtility.GetData(InstanceRef, index)
		local multof255 = CoD.SavingDataUtility.GetData(InstanceRef, index + 1)
		local remainder = CoD.SavingDataUtility.GetData(InstanceRef, index + 2)
		local result = (65025 * multof65025) + (255 * multof255) + remainder

		return result
	end
end

CoD.TFPCUtil.SetToSaveData = function (varName, value, InstanceRef)

	if varName ~= "starting_points" then
		local index = CoD.TFOptionIndexes[varName]
		index = (index * 2) + 50

		local remainder = value % 255
		local multiple = math.floor(value / 255)
		CoD.SavingDataUtility.SaveData(InstanceRef, index, multiple)
		CoD.SavingDataUtility.SaveData(InstanceRef, index + 1, remainder)
	else
		local index = CoD.TFOptionIndexes[varName]
		index = (index * 2) + 50

		local multof65025 = math.floor(value / 65025)
		local multof255 = math.floor((value % 65025) / 255)
		local remainder = value % 255;
		
		CoD.SavingDataUtility.SaveData(InstanceRef, index, multof65025)
		CoD.SavingDataUtility.SaveData(InstanceRef, index + 1, multof255)
		CoD.SavingDataUtility.SaveData(InstanceRef, index + 2, remainder)
	end
	
	
end

CoD.TFPCUtil.CheckForRecentUpdate = function () 

	local versionNum = 3
	if(CoD.TFPCUtil.GetFromSaveData(320, 0) ~= versionNum) then
		Cod.TFPCUtil.ResetToDefault()
		CoD.TFPCUtil.SetToSaveData(320, versionNum, 0) 
	end
end

CoD.TFPCUtil.ResetToDefault = function()
	CoD.TFPCUtil.SetToSaveData("starting_points", 500, 0)
	CoD.TFPCUtil.SetToSaveData("max_ammo", 0, 0)
	CoD.TFPCUtil.SetToSaveData("higher_health", 100, 0)
	CoD.TFPCUtil.SetToSaveData("no_perk_lim", 0, 0)
	CoD.TFPCUtil.SetToSaveData("more_powerups", 2, 0)
	CoD.TFPCUtil.SetToSaveData("bigger_mule", 0, 0)
	CoD.TFPCUtil.SetToSaveData("extra_cash", 0, 0)
	CoD.TFPCUtil.SetToSaveData("weaker_zombs", 0, 0)
	CoD.TFPCUtil.SetToSaveData("roamer_enabled", 0, 0)
	CoD.TFPCUtil.SetToSaveData("roamer_time", 0, 0)
	CoD.TFPCUtil.SetToSaveData("zcounter_enabled", 0, 0)
	CoD.TFPCUtil.SetToSaveData("starting_round", 1, 0)
	CoD.TFPCUtil.SetToSaveData("perkaholic", 0, 0)
	CoD.TFPCUtil.SetToSaveData("exo_movement", 0, 0)
	CoD.TFPCUtil.SetToSaveData("perk_powerup", 0, 0)
	CoD.TFPCUtil.SetToSaveData("melee_bonus", 0, 0)
	CoD.TFPCUtil.SetToSaveData("headshot_bonus", 0, 0)
	CoD.TFPCUtil.SetToSaveData("zombs_always_sprint", 0, 0)
	CoD.TFPCUtil.SetToSaveData("max_zombies", 24, 0)
	CoD.TFPCUtil.SetToSaveData("no_delay", 0, 0)
	CoD.TFPCUtil.SetToSaveData("start_rk5", 0, 0)
	CoD.TFPCUtil.SetToSaveData("hitmarkers", 0, 0)
	CoD.TFPCUtil.SetToSaveData("zcash_powerup", 0, 0)
	CoD.TFPCUtil.SetToSaveData("no_round_delay", 0, 0)
	CoD.TFPCUtil.SetToSaveData("bo4_max_ammo", 0, 0)
	CoD.TFPCUtil.SetToSaveData("better_nuke", 0, 0)
	CoD.TFPCUtil.SetToSaveData("better_nuke_points", 100, 0)
	CoD.TFPCUtil.SetToSaveData("packapunch_powerup", 0, 0)
	CoD.TFPCUtil.SetToSaveData("spawn_with_quick_res", 0, 0)
	CoD.TFPCUtil.SetToSaveData("bo4_carpenter", 0, 0)
	CoD.TFPCUtil.SetToSaveData("bottomless_clip_powerup", 0, 0)
	CoD.TFPCUtil.SetToSaveData("zblood_powerup", 0, 0)
	CoD.TFPCUtil.SetToSaveData("timed_gameplay", 0, 0)
	CoD.TFPCUtil.SetToSaveData("move_speed", 100, 0)
	CoD.TFPCUtil.SetToSaveData("weap_mw2019", 0, 0)
	CoD.TFPCUtil.SetToSaveData("open_all_doors", 0, 0)
	CoD.TFPCUtil.SetToSaveData("every_box", 0, 0)
	CoD.TFPCUtil.SetToSaveData("random_weapon", 0, 0)
	CoD.TFPCUtil.SetToSaveData("start_bowie", 0, 0)
	CoD.TFPCUtil.SetToSaveData("start_power", 0, 0)
end

CoD.TFPCUtil.CheckBoxOptionChecked = function (itemRef, updateTable)
	local f914_local0 = nil
	if updateTable.menu then
		f914_local0 = updateTable.menu.m_ownerController
	else
		f914_local0 = updateTable.controller
	end
	local itemRefModel = itemRef:getModel()
	if itemRefModel then
		local result = CoD.TFPCUtil.GetOptionInfo(itemRefModel, f914_local0)
		if type(result.currentValue) == "number" then
			return math.abs(result.currentValue - result.highValue) < 0.01
		elseif type(result.currentValue) == "string" then
			return result.currentValue == result.highValue
		end
	end
	return false
end

CoD.TFPCUtil.GetOptionInfo = function (itemRef, f6_arg1)
	if itemRef then
		local result = {}
		
		local varNameModel = Engine.GetModel(itemRef, "profileVarName")
		if varNameModel then
			local varNameString = Engine.GetModelValue(varNameModel)
			local f6_local3 = false
			local f6_local4 = Engine.GetModel(itemRef, "profileType")
			if f6_local4 then
				local f6_local5 = Engine.GetModelValue(f6_local4)
				local f6_local6 = nil
				if f6_local5 == "user" then
					f6_local6 = Engine.ProfileValueAsString(f6_arg1, varNameString)
					
					f6_local3 = true
				elseif f6_local5 == "function" then
					f6_local6 = "errorValueString"
					local f6_local7 = Engine.GetModel(itemRef, "getFunction")
					if f6_local7 then
						local f6_local8 = f6_arg1
						local f6_local9 = Engine.GetModel(itemRef, "optionController")
						if f6_local9 then
							f6_local8 = Engine.GetModelValue(f6_local9)
						end
						result.getValueFunction = Engine.GetModelValue(f6_local7)
						f6_local6 = result.getValueFunction(f6_local8)
					end
				else
					f6_local6 = Engine.GetHardwareProfileValueAsString(varNameString)
					
				end
				result.currentValue = tonumber(f6_local6)
				if not result.currentValue then
					result.currentValue = f6_local6
				end
				result.profileType = f6_local5
			else


				result.currentValue = tonumber(CoD.TFPCUtil.GetFromSaveData(varNameString))
				--result.currentValue = 1
				
				
				
				if not result.currentValue then
					result.currentValue = f6_local5
				end
			end
			result.profileVarName = varNameString
			local f6_local5 = Engine.GetModel(itemRef, "lowValue")
			local f6_local6 = Engine.GetModel(itemRef, "highValue")
			if f6_local5 and f6_local6 then
				result.lowValue = Engine.GetModelValue(f6_local5)
				result.highValue = Engine.GetModelValue(f6_local6)
			elseif f6_local3 then
				result.lowValue = 0
				result.highValue = 1
			else
				local f6_local7, f6_local8 = Dvar["r_sssblurEnable"]:getDomain()
				result.lowValue = 0
				result.highValue = 1
			end
			if Engine.GetModel(itemRef, "useIntegerDisplay") then
				result.useIntegerDisplay = 1
			else
				result.useIntegerDisplay = 0
			end
			if Engine.GetModel(itemRef, "useMultipleOf10Display") then
				result.useMultipleOf10Display = 1
			else
				result.useMultipleOf10Display = 0
			end
			if Engine.GetModel(itemRef, "useMultipleOf100Display") then
				result.useMultipleOf100Display = 1
			else
				result.useMultipleOf100Display = 0
			end

			if Engine.GetModel(itemRef, "isFloat") then
				result.isFloat = 1
				result.currentValue = result.currentValue / 100;
			else
				result.isFloat = 0
			end

			local f6_local8 = Engine.GetModel(itemRef, "widgetType")
			if f6_local8 then
				local f6_local9 = Engine.GetModelValue(f6_local8)
				if f6_local9 == "slider" then
					local f6_local10 = Engine.GetModel(itemRef, "sliderSpeed")
					if f6_local10 then
						result.sliderSpeed = Engine.GetModelValue(f6_local10)
					else
						local f6_local11 = result.highValue - result.lowValue
						if result.useIntegerDisplay == 1 then
							result.sliderSpeed = 10 / f6_local11
						elseif result.useMultipleOf10Display == 1 then
							result.sliderSpeed = 100 / f6_local11
						elseif result.useMultipleOf100Display == 1 then
							result.sliderSpeed = 1000 / f6_local11
						else
							result.sliderSpeed = 0.1 / f6_local11
						end
					end
				end
				result.widgetType = f6_local9
			end
			local f6_local9 = Engine.GetModel(itemRef, "getLabelFn")
			if f6_local9 then
				result.getLabelFn = Engine.GetModelValue(f6_local9)
			end
			local f6_local10 = Engine.GetModel(itemRef, "chatChannel")
			if f6_local10 then
				result.chatChannel = Engine.GetModelValue(f6_local10)
				if 0 < Engine.ChatClient_FilterChannelGet(f6_arg1, result.chatChannel) then
					result.currentValue = 1
				else
					result.currentValue = 0
				end
			end
			return result
		end
	end
	return nil
end

CoD.TFPCUtil.SetOptionValue = function (itemRef, f7_arg1, newValue)
	if itemRef then
		
		local varNameModel = Engine.GetModel(itemRef, "profileVarName")
		if varNameModel then
			local varNameString = Engine.GetModelValue(varNameModel)
			local profileTypeModel = Engine.GetModel(itemRef, "profileType")
			if profileTypeModel then
				local profileType = Engine.GetModelValue(profileTypeModel)
				if profileType == "user" then
					Engine.SetProfileVar(f7_arg1, varNameString, newValue)
				elseif profileType == "function" then
					local f7_local4 = Engine.GetModel(itemRef, "setFunction")
					if f7_local4 then
						local f7_local5 = f7_arg1
						local f7_local6 = Engine.GetModel(itemRef, "optionController")
						if f7_local6 then
							f7_local5 = Engine.GetModelValue(f7_local6)
						end
						local f7_local7 = Engine.GetModelValue(f7_local4)
						f7_local7(f7_local5, newValue)
					end
				else
					Engine.SetHardwareProfileValue(varNameString, newValue)
				end
			else

				CoD.TFPCUtil.SetToSaveData(varNameString, newValue, 0)

				
			end
			CoD.TFPCUtil.DirtyOptions(f7_arg1)
		end
	end
end

CoD.TFPCUtil.GetOptionsDirtyModel = function (f8_arg0, f8_arg1)
	local f8_local0 = Engine.GetModel(Engine.GetModelForController(f8_arg0), "PC.OptionsDirty")
	if not f8_local0 and f8_arg1 then
		f8_local0 = Engine.CreateModel(Engine.GetModelForController(f8_arg0), "PC.OptionsDirty")
	end
	return f8_local0
end

CoD.TFPCUtil.FreeOptionsDirtyModel = function (f9_arg0)
	local f9_local0 = CoD.TFPCUtil.GetOptionsDirtyModel(f9_arg0)
	if f9_local0 then
		Engine.UnsubscribeAndFreeModel(f9_local0)
	end
end

CoD.TFPCUtil.DirtyOptions = function (f10_arg0)
	Engine.SetModelValue(CoD.TFPCUtil.GetOptionsDirtyModel(f10_arg0, true), 1)
end

CoD.TFPCUtil.IsOptionsDirty = function (f11_arg0)
	local f11_local0 = CoD.TFPCUtil.GetOptionsDirtyModel(f11_arg0)
	if f11_local0 then
		return Engine.GetModelValue(f11_local0) ~= 0
	else
		return false
	end
end

CoD.TFPCUtil.RefreshAllOptions = function (f12_arg0, f12_arg1)
	f12_arg0:dispatchEventToRoot({name = "options_refresh", controller = f12_arg1})
end

CoD.TFPCUtil.SimulateButtonPress = function (f13_arg0, f13_arg1)
	local f13_local0 = Engine.GetModel(Engine.GetModelForController(f13_arg0), "ButtonBits." .. f13_arg1)
	if f13_local0 then
		Engine.SetModelValue(f13_local0, Enum.LUIButtonFlags.FLAG_DOWN)
	end
end

CoD.TFPCUtil.SimulateButtonPressUsingElement = function (f14_arg0, f14_arg1)
	local f14_local0 = f14_arg1:getModel()
	if f14_local0 then
		local f14_local1 = Engine.GetModel(f14_local0, "Button")
		if f14_local1 then
			CoD.TFPCUtil.SimulateButtonPress(f14_arg0, Engine.GetModelValue(f14_local1))
		end
	end
end

CoD.TFPCUtil.OptionsCheckboxAction = function (f16_arg0, checkbox)
	local checkboxModel = checkbox:getModel()
	if checkboxModel then
		local result = CoD.TFPCUtil.GetOptionInfo(checkboxModel, f16_arg0)

		if result then
			local newValue = nil
			local isAlreadyOff = false
			if type(result.currentValue) == "number" then
				isAlreadyOff = math.abs(result.currentValue - result.lowValue) < 0.01
			elseif type(result.currentValue) == "string" then
				isAlreadyOff = result.currentValue == result.lowValue
			end
			if isAlreadyOff then
				newValue = result.highValue
			else
				newValue = result.lowValue
			end
			CoD.TFPCUtil.SetOptionValue(checkboxModel, f16_arg0, newValue)
			checkbox:playSound("list_action")
			return newValue
		end
	end
	return false
end

CoD.TFPCUtil.OptionsChatClientChannelFilterCheckboxProperties = function (f17_arg0, f17_arg1)
	local f17_local0 = f17_arg1:getModel()
	if f17_local0 then
		local f17_local1 = CoD.TFPCUtil.GetOptionInfo(f17_local0, f17_arg0)
		if f17_local1 then
			local f17_local2 = nil
			if f17_local1.currentValue == f17_local1.lowValue then
				f17_local2 = f17_local1.highValue
			else
				f17_local2 = f17_local1.lowValue
			end
			Engine.ChatClient_FilterChannelSet(f17_arg0, f17_local1.chatChannel, 0 < f17_local2)
			CoD.TFPCUtil.SetOptionValue(f17_local0, f17_arg0, Engine.ChatClient_FilterChannelGet(f17_arg0, Enum.chatChannel_e.CHAT_CHANNEL_COUNT))
			return f17_local2
		end
	end
	return false
end

CoD.TFPCUtil.OptionsNavNuttonAction = function (var, itemRef, varA, varB) 
	itemRef:playSound("list_action")
	local itemModel = itemRef:getModel()
	if itemModel then
		CoD.TFPCUtil.NavigateToPage(itemModel, varA, varB)
	end

end

CoD.TFPCUtil.NavigateToPage = function (itemRef, varA, varB)
	local pageModel = Engine.GetModel(itemRef, "page")
	if pageModel then
		local newPageString = Engine.GetModelValue(pageModel)

		OpenPopup_NoDependency(varA, newPageString, varB)
	end
end

CoD.TFPCUtil.OptionsNavButtonProperties = {navAction = CoD.TFPCUtil.OptionsNavNuttonAction}

CoD.TFPCUtil.OptionsGenericCheckboxProperties = {checkboxAction = CoD.TFPCUtil.OptionsCheckboxAction}
CoD.TFPCUtil.OptionsChatClientChannelFilterCheckboxProperties = {checkboxAction = CoD.TFPCUtil.OptionsChatClientChannelFilterCheckboxProperties}
CoD.TFPCUtil.OptionsDropdownItemSelected = function (f18_arg0, f18_arg1, f18_arg2)
	local f18_local0 = ""
	local f18_local1 = f18_arg2:getModel()
	if f18_local1 then
		local f18_local2 = Engine.GetModel(f18_local1, "valueDisplay")
		if f18_local2 then
			f18_local0 = Engine.GetModelValue(f18_local2)
		end
		local f18_local3 = nil
		local f18_local4 = Engine.GetModel(f18_local1, "value")
		if f18_local4 then
			f18_local3 = Engine.GetModelValue(f18_local4)
		end
		CoD.TFPCUtil.SetOptionValue(f18_arg1:getModel(), f18_arg0, f18_local3)
		f18_arg1:playSound("list_action")
	end
	return f18_local0
end

CoD.TFPCUtil.OptionsDropdownRefresh = function (f19_arg0, f19_arg1, f19_arg2)
	local f19_local0 = ""
	local f19_local1 = f19_arg1:getModel()
	if f19_local1 then
		local f19_local2 = CoD.TFPCUtil.GetOptionInfo(f19_local1, f19_arg0)
		if f19_local2 then
			local f19_local3 = f19_local2.profileVarName
			local f19_local4, f19_local5 = false
			local f19_local6 = f19_arg2:findItem({value = f19_local2.currentValue}, nil, f19_local4, f19_local5)
			local f19_local7 = false
			if not f19_local6 then
				f19_local6 = f19_arg2:getFirstSelectableItem()
				f19_local7 = true
			end
			if f19_local6 then
				local f19_local8 = f19_local6:getModel()
				if f19_local8 then
					local f19_local9 = Engine.GetModel(f19_local8, "valueDisplay")
					if f19_local9 then
						f19_local0 = Engine.GetModelValue(f19_local9)
					end
					if f19_local7 then
						f19_local4 = Engine.GetModel(f19_local8, "value")
						if f19_local4 then
							CoD.TFPCUtil.SetOptionValue(f19_local1, f19_arg0, Engine.GetModelValue(f19_local4))
						end
					end
				end
			end
		end
	end
	return f19_local0
end

CoD.TFPCUtil.OptionsDropdownCurrentValue = function (f20_arg0, f20_arg1)
	local f20_local0 = f20_arg1:getModel()
	if f20_local0 then
		local f20_local1 = CoD.TFPCUtil.GetOptionInfo(f20_local0, f20_arg0)
		return f20_local1.currentValue
	else

	end
end

CoD.TFPCUtil.OptionsGenericDropdownProperties = {dropDownItemSelected = CoD.TFPCUtil.OptionsDropdownItemSelected, dropDownRefresh = CoD.TFPCUtil.OptionsDropdownRefresh, dropDownCurrentValue = CoD.TFPCUtil.OptionsDropdownCurrentValue}
CoD.TFPCUtil.DependantDropdownProperties = {dropDownItemSelected = function (f21_arg0, f21_arg1, f21_arg2)
	CoD.TFPCUtil.RefreshAllOptions(f21_arg1, f21_arg0)
	return CoD.TFPCUtil.OptionsDropdownItemSelected(f21_arg0, f21_arg1, f21_arg2)
end, dropDownRefresh = CoD.TFPCUtil.OptionsDropdownRefresh, dropDownCurrentValue = CoD.TFPCUtil.OptionsDropdownCurrentValue}
CoD.TFPCUtil.ShadowOptionIndex = 0
CoD.TFPCUtil.ShadowDropdownItemSelected = function (f22_arg0, f22_arg1, f22_arg2)
	local f22_local0 = ""
	local f22_local1 = CoD.TFPCUtil.GetModelValues(f22_arg2:getModel(), {"value", "valueDisplay"})
	if f22_local1 then
		f22_local0 = f22_local1.valueDisplay
		CoD.TFPCUtil.ShadowOptionIndex = f22_local1.value
		CoD.TFPCUtil.DirtyOptions(f22_arg0)
		f22_arg1:playSound("list_action")
	end
	return f22_local0
end

CoD.TFPCUtil.ShadowDropdownRefresh = function (f23_arg0, f23_arg1, f23_arg2)
	local f23_local0 = ""
	local f23_local1, f23_local2 = false
	local f23_local3 = f23_arg2:findItem({value = CoD.TFPCUtil.ShadowOptionIndex}, nil, f23_local1, f23_local2)
	local f23_local4 = false
	if not f23_local3 then
		f23_local3 = f23_arg2:getFirstSelectableItem()
		f23_local4 = true
	end
	if f23_local3 then
		local f23_local5 = CoD.TFPCUtil.GetModelValues(f23_local3:getModel(), {"value", "valueDisplay"})
		f23_local0 = f23_local5.valueDisplay
		if f23_local4 then
			CoD.TFPCUtil.ShadowOptionIndex = f23_local5.value
			CoD.TFPCUtil.DirtyOptions(f23_arg0)
		end
	end
	return f23_local0
end

CoD.TFPCUtil.ShadowDropdownCurrentValue = function (f24_arg0, f24_arg1)
	return CoD.TFPCUtil.ShadowOptionIndex
end

CoD.TFPCUtil.ShadowDropdownProperties = {dropDownItemSelected = CoD.TFPCUtil.ShadowDropdownItemSelected, dropDownRefresh = CoD.TFPCUtil.ShadowDropdownRefresh, dropDownCurrentValue = CoD.TFPCUtil.ShadowDropdownCurrentValue}
CoD.TFPCUtil.VolumetricOptionIndex = 0
CoD.TFPCUtil.VolumetricDropdownItemSelected = function (f25_arg0, f25_arg1, f25_arg2)
	local f25_local0 = ""
	local f25_local1 = CoD.TFPCUtil.GetModelValues(f25_arg2:getModel(), {"value", "valueDisplay"})
	if f25_local1 then
		f25_local0 = f25_local1.valueDisplay
		CoD.TFPCUtil.VolumetricOptionIndex = f25_local1.value
		CoD.TFPCUtil.DirtyOptions(f25_arg0)
		f25_arg1:playSound("list_action")
	end
	return f25_local0
end

CoD.TFPCUtil.VolumetricDropdownRefresh = function (f26_arg0, f26_arg1, f26_arg2)
	local f26_local0 = ""
	local f26_local1, f26_local2 = false
	local f26_local3 = f26_arg2:findItem({value = CoD.TFPCUtil.VolumetricOptionIndex}, nil, f26_local1, f26_local2)
	local f26_local4 = false
	if not f26_local3 then
		f26_local3 = f26_arg2:getFirstSelectableItem()
		f26_local4 = true
	end
	if f26_local3 then
		local f26_local5 = CoD.TFPCUtil.GetModelValues(f26_local3:getModel(), {"value", "valueDisplay"})
		f26_local0 = f26_local5.valueDisplay
		if f26_local4 then
			CoD.TFPCUtil.VolumetricOptionIndex = f26_local5.value
			CoD.TFPCUtil.DirtyOptions(f26_arg0)
		end
	end
	return f26_local0
end

CoD.TFPCUtil.VolumetricDropdownCurrentValue = function (f27_arg0, f27_arg1)
	return CoD.TFPCUtil.VolumetricOptionIndex
end

CoD.TFPCUtil.VolumetricDropdownProperties = {dropDownItemSelected = CoD.TFPCUtil.VolumetricDropdownItemSelected, dropDownRefresh = CoD.TFPCUtil.VolumetricDropdownRefresh, dropDownCurrentValue = CoD.TFPCUtil.VolumetricDropdownCurrentValue}
CoD.TFPCUtil.SaveCurrentGraphicsOptions = function ()
	CoD.TFPCUtil.SavedVolumetricOptionIndex = CoD.TFPCUtil.VolumetricOptionIndex
end

CoD.TFPCUtil.RevertUnsavedGraphicsOptions = function ()
	CoD.TFPCUtil.VolumetricOptionIndex = CoD.TFPCUtil.SavedVolumetricOptionIndex
	Engine.SetVolumetricQuality(CoD.TFPCUtil.VolumetricOptionIndex)
end

CoD.TFPCUtil.OptionsSliderRefresh = function (f30_arg0, f30_arg1)
	local itemRef = f30_arg1:getModel()
	if itemRef then
		local sliderInfo = CoD.TFPCUtil.GetOptionInfo(itemRef, f30_arg0)
		if sliderInfo then
			if sliderInfo.useIntegerDisplay == 1 then
				f30_arg1.m_formatString = "%u"
			end
			if sliderInfo.useMultipleOf10Display == 1 then
				f30_arg1.m_formatString = "%u"
			end
			if sliderInfo.useMultipleOf100Display == 1 then
				f30_arg1.m_formatString = "%u"
			end
			local f30_local2 = (sliderInfo.currentValue - sliderInfo.lowValue) / (sliderInfo.highValue - sliderInfo.lowValue)
			if f30_local2 < 0 then
				f30_local2 = 0
			end
			if 1 < f30_local2 then
				f30_local2 = 1
			end
			f30_arg1.m_fraction = f30_local2
			f30_arg1.m_currentValue = sliderInfo.currentValue
			f30_arg1.m_sliderSpeed = sliderInfo.sliderSpeed
			f30_arg1.m_range = sliderInfo.highValue - sliderInfo.lowValue
		end
	end
end

CoD.TFPCUtil.OptionsSliderUpdated = function (f31_arg0, f31_arg1, f31_arg2)
	local itemRef = f31_arg1:getModel()
	if itemRef then
		local sliderInfo = CoD.TFPCUtil.GetOptionInfo(itemRef, f31_arg0)
		local newValue = string.format(f31_arg1.m_formatString, (sliderInfo.highValue - sliderInfo.lowValue) * f31_arg2 + sliderInfo.lowValue)
		if sliderInfo.useMultipleOf10Display == 1 then
			newValue = string.format("%u0", tonumber(newValue) / 10)
		end
		if sliderInfo.useMultipleOf100Display == 1 then
			newValue = string.format("%u00", tonumber(newValue) / 100)
		end
		if sliderInfo.isFloat == 1 then 
			CoD.TFPCUtil.SetOptionValue(itemRef, f31_arg0, newValue * 100)
		else
			CoD.TFPCUtil.SetOptionValue(itemRef, f31_arg0, newValue)
		end
		f31_arg1.m_currentValue = newValue
		f31_arg1.m_fraction = f31_arg2
		f31_arg1.m_sliderSpeed = sliderInfo.sliderSpeed
		f31_arg1.m_range = sliderInfo.highValue - sliderInfo.lowValue
	end
end

CoD.TFPCUtil.OptionsGenericSliderProperties = {sliderRefresh = CoD.TFPCUtil.OptionsSliderRefresh, sliderUpdated = CoD.TFPCUtil.OptionsSliderUpdated}
CoD.TFPCUtil.Craft_WidgetSelectorFunc = function (f32_arg0, f32_arg1, f32_arg2)
	if f32_arg1 then
		local f32_local0 = Engine.GetModel(f32_arg1, "widgetType")
		if f32_local0 then
			local f32_local1 = Engine.GetModelValue(f32_local0)
			if f32_local1 == "header" then
				return CoD.CraftActionHeader
			elseif f32_local1 == "button" then
				return CoD.CraftActionButton
			elseif f32_local1 == "slider" then
				return CoD.CraftActionSlider
			end
		end
	end
	return nil
end

CoD.TFPCUtil.Craft_GetEmblemEditorEditModeActions = function (f33_arg0)
	local f33_local0 = {}
	table.insert(f33_local0, {models = {actionName = "PLATFORM_MODE", widgetType = "header"}})
	table.insert(f33_local0, {models = {actionName = "MENU_EMBLEM_COLOR_PICKER", image = "t7_pc_ps_menu_color_picker", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE}})
	table.insert(f33_local0, {models = {actionName = "MENU_MATERIAL_PICKER", image = "t7_pc_ps_menu_material_picker", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_UP, m_isDpad = true}})
	table.insert(f33_local0, {models = {actionName = "MENU_CONTROLS", widgetType = "header"}})
	table.insert(f33_local0, {models = {actionName = "PLATFORM_SWITCH_TO_FREE_SCALE", image = "t7_pc_ps_menu_free_scale", widgetType = "button", perControllerStatusModel = "Emblem.EmblemProperties.scaleMode", getStatusTable = function ()
		return {[Enum.CustomizationScaleType.CUSTOMIZATION_SCALE_TYPE_FIXED] = {label = "PLATFORM_SWITCH_TO_FREE_SCALE"}, [Enum.CustomizationScaleType.CUSTOMIZATION_SCALE_TYPE_FREE] = {label = "PLATFORM_SWITCH_TO_FIXED_SCALE"}}
	end}, properties = {m_button = Enum.LUIButton.LUI_KEY_RSTICK_PRESSED}})
	table.insert(f33_local0, {models = {actionName = "PLATFORM_EMBLEM_TOGGLE_FLIP", image = "t7_pc_ps_menu_flip_image", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_BACK}})
	table.insert(f33_local0, {models = {actionName = "PLATFORM_EMBLEM_TOGGLE_OUTLINE", image = "t7_pc_ps_menu_toggle_outline_fill", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_XBX_PSSQUARE}})
	table.insert(f33_local0, {models = {actionName = "PLATFORM_MOVE_LAYER_UP", image = "t7_pc_ps_menu_move_layer_up", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_RIGHT, m_isDpad = true}})
	table.insert(f33_local0, {models = {actionName = "PLATFORM_MOVE_LAYER_DOWN", image = "t7_pc_ps_menu_move_layer_down", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_LEFT, m_isDpad = true}})
	table.insert(f33_local0, {models = {actionName = "MENU_EMBLEM_LAYER_OPACITY", image = "t7_pc_ps_menu_opacity", widgetType = "slider", perControllerValueModel = "Emblem.EmblemSelectedLayerProperties.max_opacity", lowValue = 0, highValue = 100}, properties = {updateAction = function (f41_arg0, f41_arg1, f41_arg2)
		Engine.ExecNow(f33_arg0, "emblemLayerSetOpacity " .. Enum.CustomizationColorNum.CUSTOMIZATION_COLOR_NONE .. " " .. f41_arg2)
	end}})
	table.insert(f33_local0, {models = {actionName = "PLATFORM_EMBLEM_ROTATE_LAYER", image = "t7_pc_ps_menu_rotate", widgetType = "slider", perControllerValueModel = "Emblem.EmblemSelectedLayerProperties.rotation", lowValue = 0, highValue = 360}, properties = {updateAction = function (f42_arg0, f42_arg1, f42_arg2)
		local f42_local0 = CoD.TFPCUtil.GetElementModelValues(f42_arg1, {"lowValue", "highValue"})
		if f42_local0 then
			Engine.ExecNow(f33_arg0, "emblemSetRotation " .. f42_local0.highValue - f42_local0.lowValue * f42_arg2)
		end
	end}})
	return f33_local0
end

CoD.TFPCUtil.Craft_GetEmblemEditorBrowseModeActions = function (f34_arg0, f34_arg1, f34_arg2)
	local f34_local0 = {}
	table.insert(f34_local0, {models = {actionName = "MENU_CONTROLS", widgetType = "header"}})
	table.insert(f34_local0, {models = {actionName = "PLATFORM_INSERT_NEW_LAYER", image = "t7_pc_ps_menu_new_layer", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_DOWN, m_isDpad = true}})
	table.insert(f34_local0, {models = {actionName = "MENU_EMBLEM_CHANGE_DECAL", image = "t7_pc_ps_menu_chang_decal", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE}})
	table.insert(f34_local0, {models = {actionName = "MENU_EMBLEM_CUT_LAYER", image = "t7_pc_ps_menu_cut_layer", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_XBX_PSSQUARE}})
	table.insert(f34_local0, {models = {actionName = "MENU_EMBLEM_LAYER_COPY", image = "t7_pc_ps_menu_copy_layer", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_BACK}})
	table.insert(f34_local0, {models = {actionName = "MENU_EMBLEM_LAYER_PASTE", image = "t7_pc_ps_menu_paste_layer", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_START}})
	if f34_arg1 and f34_arg2 then
		if BrowseModeLinkedLayer(f34_arg1, f34_arg2, f34_arg0) then
			table.insert(f34_local0, {models = {actionName = "MENU_LB_PFILTER_GROUPS", widgetType = "header"}})
			table.insert(f34_local0, {models = {actionName = "MENU_EMBLEM_UNLINK_LAYERS", image = "t7_pc_ps_menu_move_layer_up", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_RTRIG}})
			table.insert(f34_local0, {models = {actionName = "MENU_EMBLEMS_GROUP", image = "t7_pc_ps_menu_color_picker", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_RB}})
		elseif BrowseModeGroupedLayer(f34_arg1, f34_arg2, f34_arg0) then
			table.insert(f34_local0, {models = {actionName = "MENU_LB_PFILTER_GROUPS", widgetType = "header"}})
			table.insert(f34_local0, {models = {actionName = "MENU_EMBLEMS_UNGROUP", image = "t7_pc_ps_menu_color_picker", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_RB}})
		elseif BrowseModeOneLayerLinked(f34_arg1, f34_arg2, f34_arg0) then
			table.insert(f34_local0, {models = {actionName = "MENU_LB_PFILTER_GROUPS", widgetType = "header"}})
			table.insert(f34_local0, {models = {actionName = "MENU_EMBLEM_UNLINK_LAYERS", image = "t7_pc_ps_menu_move_layer_up", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_RTRIG}})
		elseif BrowseMode(f34_arg1, f34_arg2, f34_arg0) then
			table.insert(f34_local0, {models = {actionName = "MENU_LB_PFILTER_GROUPS", widgetType = "header"}})
			table.insert(f34_local0, {models = {actionName = "MENU_EMBLEM_LINK_LAYERS", image = "t7_pc_ps_menu_move_layer_down", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_RTRIG}})
		elseif GroupsDisabledMode(f34_arg1, f34_arg2, f34_arg0) then

		end
	end
	return f34_local0
end

CoD.TFPCUtil.Craft_GetEmblemEditorSolidColorActions = function (f35_arg0)
	local f35_local0 = {}
	table.insert(f35_local0, {models = {actionName = "PLATFORM_MODE", widgetType = "header"}})
	table.insert(f35_local0, {models = {actionName = "PLATFORM_SWITCH_TO_GRADIENT_MODE", image = "t7_pc_ps_menu_gradient", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_XBX_PSSQUARE}})
	table.insert(f35_local0, {models = {actionName = "PLATFORM_SWITCH_TO_COLOR_MIXER", image = "t7_pc_ps_menu_color_mixer", widgetType = "button", perControllerStatusModel = "Emblem.EmblemProperties.colorMode", getStatusTable = function ()
		return {[Enum.CustomizationColorMode.CUSTOMIZATION_COLOR_MODE_MIXER] = {label = "PLATFORM_SWITCH_TO_SOLID_FILL"}, [Enum.CustomizationColorMode.CUSTOMIZATION_COLOR_MODE_SOLID] = {label = "PLATFORM_SWITCH_TO_COLOR_MIXER"}}
	end}, properties = {m_button = Enum.LUIButton.LUI_KEY_BACK}})
	if IsPaintshop(f35_arg0) then
		table.insert(f35_local0, {models = {actionName = "MENU_EMBLEM_TOGGLE_TO_STICKER", image = "t7_pc_ps_menu_toggle_sticker", widgetType = "button", perControllerStatusModel = "Emblem.EmblemSelectedLayerProperties.blend", getStatusTable = function ()
			return {[0] = {label = "MENU_EMBLEM_TOGGLE_TO_BLEND"}, [1] = {label = "MENU_EMBLEM_TOGGLE_TO_STICKER"}}
		end}, properties = {m_button = Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE}})
	end
	table.insert(f35_local0, {models = {actionName = "MENU_CONTROLS", widgetType = "header"}})
	table.insert(f35_local0, {models = {actionName = "MENU_EMBLEM_LAYER_OPACITY", image = "t7_pc_ps_menu_opacity", widgetType = "slider", perControllerValueModel = "Emblem.EmblemSelectedLayerProperties.opacity0", lowValue = 0, highValue = 100}, properties = {updateAction = function (f45_arg0, f45_arg1, f45_arg2)
		EmblemChooseColor_SetOpacity(f45_arg0, f45_arg1, CoD.GetEditorProperties(f35_arg0, "colorNum"), f45_arg2, f35_arg0)
	end}})
	return f35_local0
end

CoD.TFPCUtil.Craft_GetEmblemEditorGradientModeActions = function (f36_arg0)
	local f36_local0 = {}
	table.insert(f36_local0, {models = {actionName = "PLATFORM_MODE", widgetType = "header"}})
	table.insert(f36_local0, {models = {actionName = "PLATFORM_SWITCH_TO_SOLID_MODE", image = "t7_pc_ps_menu_solid_mode", widgetType = "button"}, properties = {m_button = Enum.LUIButton.LUI_KEY_XBX_PSSQUARE}})
	table.insert(f36_local0, {models = {actionName = "PLATFORM_SWITCH_TO_LINEAR_GRADIENT", image = "t7_pc_ps_menu_linear_gradient", widgetType = "button", perControllerStatusModel = "Emblem.EmblemSelectedLayerProperties.gradient_type", getStatusTable = function ()
		return {[Enum.CustomizationGradientType.CUSTOMIZATION_GRADIENT_RADIAL] = {label = "PLATFORM_SWITCH_TO_LINEAR_GRADIENT"}, [Enum.CustomizationGradientType.CUSTOMIZATION_GRADIENT_LINEAR] = {label = "PLATFORM_SWITCH_TO_RADIAL_GRADIENT"}}
	end}, properties = {m_button = Enum.LUIButton.LUI_KEY_RSTICK_PRESSED}})
	if IsPaintshop(f36_arg0) then
		table.insert(f36_local0, {models = {actionName = "MENU_EMBLEM_TOGGLE_TO_STICKER", image = "t7_pc_ps_menu_toggle_sticker", widgetType = "button", perControllerStatusModel = "Emblem.EmblemSelectedLayerProperties.blend", getStatusTable = function ()
			return {[0] = {label = "MENU_EMBLEM_TOGGLE_TO_BLEND"}, [1] = {label = "MENU_EMBLEM_TOGGLE_TO_STICKER"}}
		end}, properties = {m_button = Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE}})
	end
	table.insert(f36_local0, {models = {actionName = "MENU_CONTROLS", widgetType = "header"}})
	table.insert(f36_local0, {models = {actionName = "MENU_EMBLEM_COLOR_1_OPACITY", image = "t7_pc_ps_menu_opacity", widgetType = "slider", perControllerValueModel = "Emblem.EmblemSelectedLayerProperties.opacity0", perControllerStatusModel = "Emblem.EmblemProperties.isColor0NoColor", lowValue = 0, highValue = 100, getStatusTable = function ()
		return {{disabled = true}}
	end}, properties = {updateAction = function (f49_arg0, f49_arg1, f49_arg2)
		EmblemChooseColor_SetOpacity(f49_arg0, f49_arg1, Enum.CustomizationColorNum.CUSTOMIZATION_COLOR_0, f49_arg2, f36_arg0)
	end}})
	table.insert(f36_local0, {models = {actionName = "MENU_EMBLEM_COLOR_2_OPACITY", image = "t7_pc_ps_menu_opacity", widgetType = "slider", perControllerValueModel = "Emblem.EmblemSelectedLayerProperties.opacity1", perControllerStatusModel = "Emblem.EmblemProperties.isColor1NoColor", lowValue = 0, highValue = 100, getStatusTable = function ()
		return {{disabled = true}}
	end}, properties = {updateAction = function (f51_arg0, f51_arg1, f51_arg2)
		EmblemChooseColor_SetOpacity(f51_arg0, f51_arg1, Enum.CustomizationColorNum.CUSTOMIZATION_COLOR_1, f51_arg2, f36_arg0)
	end}})
	table.insert(f36_local0, {models = {actionName = "MENU_EMBLEM_GRADIENT_ROTATION", image = "t7_pc_ps_menu_radial_gradient", widgetType = "slider", perControllerValueModel = "Emblem.EmblemSelectedLayerProperties.gradient_angle", lowValue = 0, highValue = 360}, properties = {updateAction = function (f52_arg0, f52_arg1, f52_arg2)
		local f52_local0 = CoD.TFPCUtil.GetElementModelValues(f52_arg1, {"lowValue", "highValue"})
		EmblemGradient_SetAngle(f52_arg0, f52_arg1, (f52_local0.highValue - f52_local0.lowValue) * f52_arg2, f36_arg0)
	end}})
	return f36_local0
end

CoD.TFPCUtil.Craft_GetEmblemEditorMaterialActions = function ()
	local f37_local0 = {}
	table.insert(f37_local0, {models = {actionName = "PLATFORM_MODE", widgetType = "header"}})
	table.insert(f37_local0, {models = {actionName = "PLATFORM_SWITCH_TO_FREE_SCALE", image = "t7_pc_ps_menu_free_scale", widgetType = "button", perControllerStatusModel = "Emblem.EmblemProperties.materialScaleMode", getStatusTable = function ()
		return {[Enum.CustomizationScaleType.CUSTOMIZATION_SCALE_TYPE_FIXED] = {label = "PLATFORM_SWITCH_TO_FREE_SCALE"}, [Enum.CustomizationScaleType.CUSTOMIZATION_SCALE_TYPE_FREE] = {label = "PLATFORM_SWITCH_TO_FIXED_SCALE"}}
	end}, properties = {m_button = Enum.LUIButton.LUI_KEY_RSTICK_PRESSED}})
	table.insert(f37_local0, {models = {actionName = "MENU_CONTROLS", widgetType = "header"}})
	table.insert(f37_local0, {models = {actionName = "MENU_EMBLEM_ROTATE_MATERIAL", image = "t7_pc_ps_menu_rotate", widgetType = "slider", perControllerValueModel = "Emblem.EmblemSelectedLayerProperties.material_angle", lowValue = 0, highValue = 360}, properties = {updateAction = function (f54_arg0, f54_arg1, f54_arg2)
		Engine.ExecNow(controller, "emblemSetMaterialAngle " .. 359 * f54_arg2)
	end}})
	return f37_local0
end

CoD.TFPCUtil.GamepadsMapped = function (f38_arg0)
	if Engine.GamepadsConnectedIsActive(f38_arg0) == true then
		return true
	elseif 0 < Engine.GamepadsConnectedCount() then
		Engine.Exec(f38_arg0, "gpadMapAny ")
		return true
	else
		return false
	end
end

CoD.TFPCUtil.SetupFakeMouse = function (f39_arg0, f39_arg1, f39_arg2)
	f39_arg0:setHandleMouse(true)
	if f39_arg0.mouseCursor then
		local f39_local0, f39_local1, f39_local2, f39_local3 = f39_arg0.mouseCursor:getLocalRect()
		f39_arg0.mouseCursorWidth = f39_local2 - f39_local0
		f39_arg0.mouseCursorHeight = f39_local3 - f39_local1
		if f39_arg0.mouseCursorWidth and f39_arg0.mouseCursorHeight then
			f39_arg0:registerEventHandler("mousemove", function (Sender, Event)
				local f55_local0, f55_local1, f55_local2 = LUI.UIElement.IsMouseInsideElement(Sender, Event)
				local f55_local3, f55_local4, f55_local5, f55_local6 = Sender:getLocalRect()
				local f55_local7 = f55_local5 - f55_local3
				local f55_local8 = f55_local6 - f55_local4
				local f55_local9, f55_local10, f55_local11, f55_local12 = Sender:getRect()
				local f55_local13 = CoD.ClampColor((f55_local1 - f55_local9) / (f55_local11 - f55_local9) * f55_local7, 0, f55_local7)
				local f55_local14 = CoD.ClampColor((f55_local2 - f55_local10) / (f55_local12 - f55_local10) * f55_local8, 0, f55_local8)
				Sender.mouseCursor:setLeftRight(true, false, f55_local13, f55_local13 + Sender.mouseCursorWidth)
				Sender.mouseCursor:setTopBottom(true, false, f55_local14, f55_local14 + Sender.mouseCursorHeight)
				LUI.UIElement.MouseMoveEvent(Sender, Event)
			end)
		end
	end
	f39_arg0:registerEventHandler("mouseenter", function (Sender, Event)
		HideMouseCursor(f39_arg1)
		Sender:playClip("Over")
	end)
	f39_arg0:registerEventHandler("mouseleave", function (Sender, Event)
		ShowMouseCursor(f39_arg1)
		Sender:playClip("DefaultClip")
	end)
	LUI.OverrideFunction_CallOriginalFirst(f39_arg0, "close", function ()
		ShowMouseCursor(f39_arg1)
	end)
end

