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

DataSources.OptionPCGraphicsPlayerNameIndicator = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsPlayerNameIndicator", function (f1_arg0)
	local f1_local0 = {}
	table.insert(f1_local0, {models = {value = 0, valueDisplay = "PLATFORM_INDICATOR_FULL_NAME"}})
	table.insert(f1_local0, {models = {value = 1, valueDisplay = "PLATFORM_INDICATOR_ABBREVIATED"}})
	table.insert(f1_local0, {models = {value = 2, valueDisplay = "PLATFORM_INDICATOR_ICON_ONLY"}})
	return f1_local0
end, true)
DataSources.OptionPCGraphicsSplitscreen = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsSplitscreen", function (f2_arg0)
	local f2_local0 = {}
	table.insert(f2_local0, {models = {value = 0, valueDisplay = "PLATFORM_HORIZONTAL"}})
	table.insert(f2_local0, {models = {value = 1, valueDisplay = "PLATFORM_VERTICAL"}})
	return f2_local0
end, true)
DataSources.OptionPCGraphicsColorblindMode = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsColorblindMode", function (f3_arg0)
	local f3_local0 = {}
	table.insert(f3_local0, {models = {value = Enum.ColorVisionDeficiencies.CVD_OFF, valueDisplay = "MENU_OFF"}})
	table.insert(f3_local0, {models = {value = Enum.ColorVisionDeficiencies.CVD_DEUTERANOMALY, valueDisplay = "MENU_COLORBLIND_DEUTERANOPIA"}})
	table.insert(f3_local0, {models = {value = Enum.ColorVisionDeficiencies.CVD_PROTANOMALY, valueDisplay = "MENU_COLORBLIND_PROTANOPIA"}})
	table.insert(f3_local0, {models = {value = Enum.ColorVisionDeficiencies.CVD_TRITANOMALY, valueDisplay = "MENU_COLORBLIND_TRITANOPIA"}})
	return f3_local0
end, true)
DataSources.OptionGraphicsGame = DataSourceHelpers.ListSetup("PC.OptionGraphicsGame", function (f4_arg0)
	local f4_local0 = {}
	table.insert(f4_local0, {models = {label = "PLATFORM_TEAM_INDICATOR", description = "PLATFORM_TEAM_INDICATOR_DESC", profileVarName = "team_indicator", profileType = "user", datasource = "OptionPCGraphicsPlayerNameIndicator", widgetType = "dropdown", minimapAlpha = 0}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	table.insert(f4_local0, {models = {label = "PLATFORM_SPLITSCREEN_ORIENTATION", description = "PLATFORM_SPLITSCREEN_ORIENTATION_DESC", profileVarName = "splitscreen_horizontal", datasource = "OptionPCGraphicsSplitscreen", widgetType = "dropdown", minimapAlpha = 0}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	if IsLuaCodeVersionAtLeast(17) then
		table.insert(f4_local0, {models = {label = "MENU_COLORBLIND_MODE", description = "MENU_COLORBLIND_MODE_DESC", profileVarName = "colorblindMode", profileType = "user", datasource = "OptionPCGraphicsColorblindMode", widgetType = "dropdown", minimapAlpha = 1}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	end
	return f4_local0
end, true)
DataSources.OptionGraphicsGame.getWidgetTypeForItem = function (f5_arg0, f5_arg1, f5_arg2)
	if f5_arg1 then
		local f5_local0 = Engine.GetModelValue(Engine.GetModel(f5_arg1, "widgetType"))
		if f5_local0 == "dropdown" then
			return CoD.OptionDropdown
		elseif f5_local0 == "checkbox" then
			return CoD.StartMenu_Options_CheckBoxOption
		elseif f5_local0 == "slider" then
			return CoD.StartMenu_Options_SliderBar
		elseif f5_local0 == "spacer" then
			return CoD.VerticalListSpacer
		end
	end
	return nil
end

DataSources.OptionPCGraphicsDisplayMode = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsDisplayMode", function (f6_arg0)
	local f6_local0 = {}
	table.insert(f6_local0, {models = {value = 0, valueDisplay = "PLATFORM_WINDOWED"}})
	table.insert(f6_local0, {models = {value = 1, valueDisplay = "PLATFORM_FULLSCREEN"}})
	table.insert(f6_local0, {models = {value = 2, valueDisplay = "PLATFORM_WINDOWED_FULLSCREEN"}})
	return f6_local0
end, true)
DataSources.OptionPCGraphicsMonitor = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsMonitor", function (f7_arg0)
	local f7_local0 = {}
	local f7_local1 = Dvar.r_monitorCount
	for f7_local2 = 1, f7_local1:get(), 1 do
		table.insert(f7_local0, {models = {value = f7_local2, valueDisplay = f7_local2}})
	end
	return f7_local0
end, true)
DataSources.OptionPCGraphicsScreenResolution = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsScreenResolution", function (f8_arg0)
	local f8_local0 = {}
	local f8_local1 = nil
	local f8_local2 = Dvar.r_fullscreen
	if f8_local2:get() == 0 then
		f8_local1 = Engine.GetAllResolutions()
	else
		f8_local2 = tonumber(Engine.GetHardwareProfileValueAsString("r_monitor"))
		local f8_local3 = Dvar.r_monitorCount
		if f8_local3:get() < f8_local2 then
			f8_local2 = 0
		end
		if f8_local2 == 0 then
			f8_local2 = Dvar.r_monitor:get()
		end
		if f8_local2 == 0 then
			f8_local2 = 1
		end
		f8_local1 = Engine.GetAvailableResolutions(f8_local2)
	end
	f8_local2 = Dvar.r_mode:get()
	if f8_local2 then
		table.insert(f8_local1, f8_local2)
	end
	table.sort(f8_local1, function (f32_arg0, f32_arg1)
		local f32_local0, f32_local1 = string.match(f32_arg0, "([%d]+)x([%d]+)")
		local f32_local2, f32_local3 = string.match(f32_arg1, "([%d]+)x([%d]+)")
		if f32_local0 == f32_local2 then
			return tonumber(f32_local3) < tonumber(f32_local1)
		else
			return tonumber(f32_local2) < tonumber(f32_local0)
		end
	end)
	local f8_local4 = {}
	for f8_local8, f8_local9 in ipairs(f8_local1) do
		if not f8_local4[f8_local9] then
			table.insert(f8_local0, {models = {value = f8_local9, valueDisplay = f8_local9}})
			f8_local4[f8_local9] = true
		end
	end
	return f8_local0
end, true)
DataSources.OptionPCGraphicsSceneResolution = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsSceneResolution", function (f9_arg0)
	local f9_local0 = {}
	local f9_local1, f9_local2 = string.match(Engine.GetHardwareProfileValueAsString("r_mode"), "([%d]+)x([%d]+)")
	local f9_local3 = {}
	for f9_local4 = 50, Engine.GetMaxSceneResolutionMultiplier(f9_local1, f9_local2), 10 do
		local f9_local5 = f9_local4 * f9_local1 / 100
		local f9_local6 = f9_local4 * f9_local2 / 100
		if f9_local4 ~= 100 then
			f9_local5 = math.floor(f9_local5 / 8) * 8
			f9_local6 = math.floor(f9_local6 / 8) * 8
		end
		table.insert(f9_local0, {models = {value = f9_local4, valueDisplay = string.format("%d%% - %dx%d", f9_local4, f9_local5, f9_local6)}})
	end
	return f9_local0
end, true)
DataSources.OptionPCGraphicsRefreshRate = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsRefreshRate", function (f10_arg0)
	local f10_local0 = {}
	local f10_local1, f10_local2 = string.match(Engine.GetHardwareProfileValueAsString("r_mode"), "([%d]+)x([%d]+)")
	local f10_local3 = tonumber(Engine.GetHardwareProfileValueAsString("r_monitor"))
	local f10_local4 = Dvar.r_monitorCount
	if f10_local4:get() < f10_local3 then
		f10_local3 = 0
	end
	if f10_local3 == 0 then
		f10_local3 = Dvar.r_monitor:get()
	end
	if f10_local3 == 0 then
		f10_local3 = 1
	end
	for f10_local8, f10_local9 in ipairs(Engine.GetAvailableRefreshRates(f10_local1, f10_local2, f10_local3)) do
		table.insert(f10_local0, {models = {value = tonumber(f10_local9), valueDisplay = f10_local9 .. "hz"}})
	end
	return f10_local0
end, true)
DataSources.OptionPCGraphicsDisplayGamma = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsDisplayGamma", function (f11_arg0)
	local f11_local0 = {}
	local f11_local1 = Dvar.r_videoMode:getDomainEnumStrings()
	local f11_local2 = {"PLATFORM_DISPLAY_GAMMA_COMPUTER", "PLATFORM_DISPLAY_GAMMA_HDTV"}
	for f11_local3 = 1, 2, 1 do
		table.insert(f11_local0, {models = {value = f11_local1[f11_local3], valueDisplay = f11_local2[f11_local3]}})
	end
	return f11_local0
end, true)
DataSources.OptionPCGraphicsMotionBlur = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsMotionBlur", function (f12_arg0)
	local f12_local0 = {}
	table.insert(f12_local0, {models = {value = "Off", valueDisplay = "PLATFORM_MOTION_BLUR_OFF"}})
	table.insert(f12_local0, {models = {value = "Auto", valueDisplay = "PLATFORM_MOTION_BLUR_AUTO"}})
	table.insert(f12_local0, {models = {value = "On", valueDisplay = "PLATFORM_MOTION_BLUR_ON"}})
	return f12_local0
end, true)
DataSources.OptionGraphicsVideo = DataSourceHelpers.ListSetup("PC.OptionGraphicsVideo", function (f13_arg0)
	local f13_local0 = {}
	table.insert(f13_local0, {models = {label = "PLATFORM_DISPLAY_MODE", description = "PLATFORM_DISPLAY_MODE_DESC", profileVarName = "r_fullscreen", datasource = "OptionPCGraphicsDisplayMode", widgetType = "dropdown"}, properties = CoD.PCUtil.DependantDropdownProperties})
	table.insert(f13_local0, {models = {label = "PLATFORM_MONITOR", description = "PLATFORM_MONITOR_DESC", profileVarName = "r_monitor", datasource = "OptionPCGraphicsMonitor", widgetType = "dropdown", disabledFunction = function ()
		return Engine.GetHardwareProfileValueAsString("r_fullscreen") == "0"
	end}, properties = CoD.PCUtil.DependantDropdownProperties})
	table.insert(f13_local0, {models = {label = "PLATFORM_SCREEN_RESOLUTION", description = "PLATFORM_SCREEN_RESOLUTION_DESC", profileVarName = "r_mode", datasource = "OptionPCGraphicsScreenResolution", widgetType = "dropdown", disabledFunction = function ()
		return Engine.GetHardwareProfileValueAsString("r_fullscreen") == "2"
	end}, properties = CoD.PCUtil.DependantDropdownProperties})
	table.insert(f13_local0, {models = {label = "PLATFORM_REFRESH_RATE", description = "PLATFORM_REFRESH_RATE_DESC", profileVarName = "r_refreshRate", datasource = "OptionPCGraphicsRefreshRate", widgetType = "dropdown", disabledFunction = function ()
		return Engine.GetHardwareProfileValueAsString("r_fullscreen") ~= "1"
	end}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	table.insert(f13_local0, {models = {label = "PLATFORM_SCENE_RESOLUTION_RATIO", description = "PLATFORM_SCENE_RESOLUTION_RATIO_DESC", profileVarName = "r_sceneResolutionMultiplier", datasource = "OptionPCGraphicsSceneResolution", widgetType = "dropdown"}, properties = CoD.PCUtil.DependantDropdownProperties})
	table.insert(f13_local0, {models = {label = "PLATFORM_DISPLAY_GAMMA", description = "PLATFORM_DISPLAY_GAMMA_DESC", profileVarName = "r_videoMode", datasource = "OptionPCGraphicsDisplayGamma", widgetType = "dropdown"}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	table.insert(f13_local0, {models = {label = "PLATFORM_BRIGHTNESS", description = "PLATFORM_BRIGHTNESS_DESC", profileVarName = "r_sceneBrightness", profileType = "user", lowValue = -1, highValue = 1, widgetType = "slider"}, properties = CoD.PCUtil.OptionsGenericSliderProperties})
	table.insert(f13_local0, {models = {label = "PLATFORM_FOV", description = "PLATFORM_FOV_DESC", profileVarName = "cg_fov_default", lowValue = 65, highValue = 120, useIntegerDisplay = 1, widgetType = "slider"}, properties = CoD.PCUtil.OptionsGenericSliderProperties})
	table.insert(f13_local0, {models = {widgetType = "spacer", height = 32}})
	table.insert(f13_local0, {models = {label = "PLATFORM_MAX_FPS", description = "PLATFORM_MAX_FPS_DESC", profileVarName = "com_maxfps", lowValue = 24, highValue = 240, useIntegerDisplay = 1, widgetType = "slider"}, properties = CoD.PCUtil.OptionsGenericSliderProperties})
	table.insert(f13_local0, {models = {label = "PLATFORM_SYNC_EVERY_FRAME", description = "PLATFORM_VSYNC_DESC", profileVarName = "r_vsync", widgetType = "checkbox"}, properties = CoD.PCUtil.OptionsGenericCheckboxProperties})
	table.insert(f13_local0, {models = {label = "PLATFORM_DRAW_FPS", description = "PLATFORM_DRAW_FPS_DESC", profileVarName = "com_drawFPS_PC", widgetType = "checkbox"}, properties = CoD.PCUtil.OptionsGenericCheckboxProperties})
	return f13_local0
end, true)
DataSources.OptionGraphicsVideo.getWidgetTypeForItem = function (f14_arg0, f14_arg1, f14_arg2)
	if f14_arg1 then
		local f14_local0 = Engine.GetModelValue(Engine.GetModel(f14_arg1, "widgetType"))
		if f14_local0 == "dropdown" then
			return CoD.OptionDropdown
		elseif f14_local0 == "checkbox" then
			return CoD.StartMenu_Options_CheckBoxOption
		elseif f14_local0 == "slider" then
			return CoD.StartMenu_Options_SliderBar
		elseif f14_local0 == "spacer" then
			return CoD.VerticalListSpacer
		end
	end
	return nil
end

DataSources.OptionPCGraphicsTextureQuality = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsTextureQuality", function (f15_arg0)
	local f15_local0 = {}
	local f15_local1 = Engine.GetMaxTextureQuality()
	table.insert(f15_local0, {models = {value = 3, valueDisplay = "PLATFORM_LOW"}})
	if f15_local1 <= 2 then
		table.insert(f15_local0, {models = {value = 2, valueDisplay = "PLATFORM_MEDIUM"}})
	end
	if f15_local1 <= 1 then
		table.insert(f15_local0, {models = {value = 1, valueDisplay = "PLATFORM_HIGH"}})
	end
	if f15_local1 <= 0 then
		table.insert(f15_local0, {models = {value = 0, valueDisplay = "PLATFORM_EXTRA"}})
	end
	return f15_local0
end, true)
DataSources.OptionPCGraphicsTextureFiltering = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsTextureFiltering", function (f16_arg0)
	local f16_local0 = {}
	table.insert(f16_local0, {models = {value = 0, valueDisplay = "PLATFORM_LOW"}})
	table.insert(f16_local0, {models = {value = 1, valueDisplay = "PLATFORM_MEDIUM"}})
	table.insert(f16_local0, {models = {value = 2, valueDisplay = "PLATFORM_HIGH"}})
	return f16_local0
end, true)
DataSources.OptionPCGraphicsMeshQuality = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsMeshQuality", function (f17_arg0)
	local f17_local0 = {}
	table.insert(f17_local0, {models = {value = 2, valueDisplay = "PLATFORM_LOW"}})
	table.insert(f17_local0, {models = {value = 1, valueDisplay = "PLATFORM_MEDIUM"}})
	table.insert(f17_local0, {models = {value = 0, valueDisplay = "PLATFORM_HIGH"}})
	return f17_local0
end, true)
DataSources.OptionPCGraphicsShadowQuality = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsShadowQuality", function (f18_arg0)
	local f18_local0 = {}
	local f18_local1 = Engine.GetMaxShadowQuality()
	table.insert(f18_local0, {models = {value = 3, valueDisplay = "PLATFORM_LOW"}})
	if f18_local1 <= 2 then
		table.insert(f18_local0, {models = {value = 2, valueDisplay = "PLATFORM_MEDIUM"}})
	end
	if f18_local1 <= 1 then
		table.insert(f18_local0, {models = {value = 1, valueDisplay = "PLATFORM_HIGH"}})
	end
	if f18_local1 <= 0 then
		table.insert(f18_local0, {models = {value = 0, valueDisplay = "PLATFORM_EXTRA"}})
	end
	return f18_local0
end, true)
DataSources.OptionPCGraphicsVolumetricQuality = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsVolumetricQuality", function (f19_arg0)
	local f19_local0 = {}
	table.insert(f19_local0, {models = {value = 0, valueDisplay = "PLATFORM_NONE"}})
	table.insert(f19_local0, {models = {value = 1, valueDisplay = "PLATFORM_MEDIUM"}})
	table.insert(f19_local0, {models = {value = 2, valueDisplay = "PLATFORM_HIGH"}})
	return f19_local0
end, true)

DataSources.OptionPCGraphicsOIT = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsOIT", function (f21_arg0)
	local f21_local0 = {}
	local f21_local1 = Engine.GetMaxOITQuality()
	table.insert(f21_local0, {models = {value = 0, valueDisplay = "PLATFORM_NONE"}})
	if f21_local1 <= 1 then
		table.insert(f21_local0, {models = {value = 8, valueDisplay = "PLATFORM_MEDIUM"}})
	end
	if f21_local1 <= 0 then
		table.insert(f21_local0, {models = {value = 16, valueDisplay = "PLATFORM_HIGH"}})
	end
	return f21_local0
end, true)
local f0_local0 = function (f22_arg0, f22_arg1, f22_arg2)
	local f22_local0 = ""
	local f22_local1 = f22_arg2:getModel()
	if f22_local1 then
		local f22_local2 = Engine.GetModel(f22_local1, "valueDisplay")
		if f22_local2 then
			f22_local0 = Engine.GetModelValue(f22_local2)
		end
		local f22_local3 = nil
		local f22_local4 = Engine.GetModel(f22_local1, "value")
		if f22_local4 then
			f22_local3 = Engine.GetModelValue(f22_local4)
		end
		if f22_local3 == 0 then
			f22_local3 = 8
			Engine.SetHardwareProfileValue("r_oit", 0)
			Engine.SetVolumetricQuality(0)
			CoD.PCUtil.VolumetricOptionIndex = 0
		else
			Engine.SetHardwareProfileValue("r_oit", 1)
		end
		CoD.PCUtil.SetOptionValue(f22_arg1:getModel(), f22_arg0, f22_local3)
		CoD.PCUtil.RefreshAllOptions(f22_arg1, f22_arg0)
	end
	return f22_local0
end

local f0_local1 = function (f23_arg0, f23_arg1, f23_arg2)
	local f23_local0 = CoD.PCUtil.OptionsDropdownRefresh(f23_arg0, f23_arg1, f23_arg2)
	if f23_local0 == "PLATFORM_MEDIUM" and not (Engine.GetHardwareProfileValueAsString("r_oit") == "1") then
		f23_local0 = "PLATFORM_NONE"
	end
	return f23_local0
end

DataSources.OptionPCGraphicsMaxFPS = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsMaxFPS", function (f24_arg0)
	local f24_local0 = {}
	table.insert(f24_local0, {models = {value = 0, valueDisplay = "PLATFORM_UNLIMITED"}})
	table.insert(f24_local0, {models = {value = 30, valueDisplay = "30"}})
	table.insert(f24_local0, {models = {value = 60, valueDisplay = "60"}})
	table.insert(f24_local0, {models = {value = 90, valueDisplay = "90"}})
	table.insert(f24_local0, {models = {value = 120, valueDisplay = "120"}})
	return f24_local0
end, true)
DataSources.OptionPCGraphicsAmbientOcclusion = DataSourceHelpers.ListSetup("PC.OptionPCGraphicsAmbientOcclusion", function (f25_arg0)
	local f25_local0 = {}
	table.insert(f25_local0, {models = {value = "Disabled", valueDisplay = "MENU_DISABLED"}})
	if Engine.GetGPUCount() == 1 then
		table.insert(f25_local0, {models = {value = "GTAO Low Quality", valueDisplay = "PLATFORM_LOW"}})
		table.insert(f25_local0, {models = {value = "GTAO Medium Quality", valueDisplay = "PLATFORM_MEDIUM"}})
		table.insert(f25_local0, {models = {value = "GTAO High Quality", valueDisplay = "PLATFORM_HIGH"}})
		table.insert(f25_local0, {models = {value = "GTAO Ultra Quality", valueDisplay = "PLATFORM_EXTRA"}})
	else
		table.insert(f25_local0, {models = {value = "GTAO Ultra Quality", valueDisplay = "MENU_ENABLED"}})
	end
	return f25_local0
end, true)

DataSources.OptionGraphicsAdvanced = DataSourceHelpers.ListSetup("PC.OptionGraphicsAdvanced", function (f26_arg0)
	local f26_local0 = {}
	table.insert(f26_local0, {models = {label = "PLATFORM_TEXTURE_QUALITY", description = "PLATFORM_TEXTURE_QUALITY_DESC", profileVarName = "r_picmip", datasource = "OptionPCGraphicsTextureQuality", widgetType = "dropdown"}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	table.insert(f26_local0, {models = {label = "PLATFORM_TEXTURE_FILTERING", description = "PLATFORM_TEXTURE_FILTERING_DESC", profileVarName = "r_texFilterQuality", datasource = "OptionPCGraphicsTextureFiltering", widgetType = "dropdown"}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	table.insert(f26_local0, {models = {label = "PLATFORM_MESH_QUALITY", description = "PLATFORM_MESH_QUALITY_DESC", profileVarName = "r_modelLodLimit", datasource = "OptionPCGraphicsMeshQuality", widgetType = "dropdown"}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	table.insert(f26_local0, {models = {widgetType = "spacer", height = 32}})
	table.insert(f26_local0, {models = {label = "PLATFORM_SHADOW_MAP_QUALITY", description = "PLATFORM_SHADOW_MAP_QUALITY_DESC", datasource = "OptionPCGraphicsShadowQuality", widgetType = "dropdown"}, properties = CoD.PCUtil.ShadowDropdownProperties})
	table.insert(f26_local0, {models = {label = "PLATFORM_DYNAMIC_SHADOWS", description = "PLATFORM_DYNAMIC_SHADOWS_DESC", profileVarName = "r_lightingSunShadowDisableDynamicDraw", lowValue = 1, highValue = 0, widgetType = "checkbox"}, properties = {checkboxAction = function (f36_arg0, f36_arg1)
		Engine.SetHardwareProfileValue("r_deferredForceShadowNeverUpdate", CoD.PCUtil.OptionsCheckboxAction(f36_arg0, f36_arg1))
	end}})
	table.insert(f26_local0, {models = {label = "PLATFORM_SUBSURFACE_SCATTERING", description = "PLATFORM_SUBSURFACE_SCATTERING_DESC", profileVarName = "r_sssblurEnable", widgetType = "checkbox"}, properties = CoD.PCUtil.OptionsGenericCheckboxProperties})
	table.insert(f26_local0, {models = {label = "PLATFORM_ORDER_INDEPENDENT_TRANSPARENCY", description = "PLATFORM_ORDER_INDEPENDENT_TRANSPARENCY_DESC", profileVarName = "r_OIT_MaxEntries", datasource = "OptionPCGraphicsOIT", widgetType = "dropdown"}, properties = {dropDownItemSelected = f0_local0, dropDownRefresh = f0_local1, dropDownCurrentValue = CoD.PCUtil.OptionsDropdownCurrentValue}})
	table.insert(f26_local0, {models = {label = "PLATFORM_VOLUMETRIC_LIGHTING", description = "PLATFORM_VOLUMETRIC_LIGHTING_DESC", datasource = "OptionPCGraphicsVolumetricQuality", widgetType = "dropdown", disabledFunction = function ()
		return Engine.GetHardwareProfileValueAsString("r_oit") == "0"
	end}, properties = CoD.PCUtil.VolumetricDropdownProperties})
	table.insert(f26_local0, {models = {widgetType = "spacer", height = 32}})
	table.insert(f26_local0, {models = {label = "PLATFORM_ANTIALIASING", description = "PLATFORM_ANTIALIASING_DESC", profileVarName = "r_aaTechnique", datasource = "OptionPCGraphicsAntiAliasing", widgetType = "dropdown"}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	table.insert(f26_local0, {models = {label = "PLATFORM_AMBIENT_OCCLUSION", description = "PLATFORM_AMBIENT_OCCLUSION_DESC", profileVarName = "r_ssaoTechnique", datasource = "OptionPCGraphicsAmbientOcclusion", widgetType = "dropdown"}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	table.insert(f26_local0, {models = {label = "PLATFORM_MOTION_BLUR", description = "PLATFORM_MOTION_BLUR_DESC", profileVarName = "r_motionBlurMode", datasource = "OptionPCGraphicsMotionBlur", widgetType = "dropdown"}, properties = CoD.PCUtil.OptionsGenericDropdownProperties})
	return f26_local0
end, true)
DataSources.OptionGraphicsAdvanced.getWidgetTypeForItem = function (f27_arg0, f27_arg1, f27_arg2)
	if f27_arg1 then
		local f27_local0 = Engine.GetModelValue(Engine.GetModel(f27_arg1, "widgetType"))
		if f27_local0 == "dropdown" then
			return CoD.OptionDropdown
		elseif f27_local0 == "checkbox" then
			return CoD.StartMenu_Options_CheckBoxOption
		elseif f27_local0 == "slider" then
			return CoD.StartMenu_Options_SliderBar
		elseif f27_local0 == "spacer" then
			return CoD.VerticalListSpacer
		end
	end
	return nil
end

DataSources.OptionGraphicsCategories = DataSourceHelpers.ListSetup("PC.OptionGraphicsCategories", function (f28_arg0)
	local f28_local0 = {}
	table.insert(f28_local0, {models = {tabIcon = CoD.buttonStrings.shoulderl}, properties = {m_mouseDisabled = true}})
	table.insert(f28_local0, {models = {tabName = "PLATFORM_VIDEO_CAPS", tabWidget = "CoD.StartMenu_Options_PC_Graphics_Video"}})
	table.insert(f28_local0, {models = {tabName = "PLATFORM_ADVANCED_CAPS", tabWidget = "CoD.StartMenu_Options_PC_Graphics_Advanced"}})
	table.insert(f28_local0, {models = {tabName = "MENU_GAME_CAPS", tabWidget = "CoD.StartMenu_Options_PC_Graphics_Game"}})
	table.insert(f28_local0, {models = {tabIcon = CoD.buttonStrings.shoulderr}, properties = {m_mouseDisabled = true}})
	return f28_local0
end, true)
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












DataSources.TFOptionsPlayerHealth = DataSourceHelpers.ListSetup("PC.TFOptionsPlayerHealth", function (f15_arg0)
	local f15_local0 = {}
	table.insert(f15_local0, {models = {value = 35, valueDisplay = "1 Hit (35%)"}})
	table.insert(f15_local0, {models = {value = 75, valueDisplay = "2 Hits (75%)"}})
	table.insert(f15_local0, {models = {value = 100, valueDisplay = "3 Hits (100%)"}})
	table.insert(f15_local0, {models = {value = 150, valueDisplay = "4 Hits (150%)"}})
	table.insert(f15_local0, {models = {value = 200, valueDisplay = "5 Hits (200%)"}})
	return f15_local0
end, true)

DataSources.TFOptionsStartingPoints = DataSourceHelpers.ListSetup("PC.TFOptionsStartingPoints", function (f15_arg0)
	local f15_local0 = {}
	table.insert(f15_local0, {models = {value = 0, valueDisplay = "0"}})
	table.insert(f15_local0, {models = {value = 250, valueDisplay = "250"}})
	table.insert(f15_local0, {models = {value = 500, valueDisplay = "500"}})
	table.insert(f15_local0, {models = {value = 750, valueDisplay = "750"}})
	table.insert(f15_local0, {models = {value = 1000, valueDisplay = "1000"}})
	table.insert(f15_local0, {models = {value = 1500, valueDisplay = "1500"}})
	table.insert(f15_local0, {models = {value = 2000, valueDisplay = "2000"}})
	table.insert(f15_local0, {models = {value = 2500, valueDisplay = "2500"}})
	table.insert(f15_local0, {models = {value = 3000, valueDisplay = "3000"}})
	table.insert(f15_local0, {models = {value = 4000, valueDisplay = "4000"}})
	table.insert(f15_local0, {models = {value = 5000, valueDisplay = "5000"}})
	table.insert(f15_local0, {models = {value = 7500, valueDisplay = "7500"}})
	table.insert(f15_local0, {models = {value = 10000, valueDisplay = "10000"}})
	table.insert(f15_local0, {models = {value = 15000, valueDisplay = "15000"}})
	table.insert(f15_local0, {models = {value = 20000, valueDisplay = "20000"}})
	table.insert(f15_local0, {models = {value = 30000, valueDisplay = "30000"}})
	table.insert(f15_local0, {models = {value = 50000, valueDisplay = "50000"}})
	table.insert(f15_local0, {models = {value = 100000, valueDisplay = "100000"}})
	table.insert(f15_local0, {models = {value = 500000, valueDisplay = "500000"}})
	table.insert(f15_local0, {models = {value = 1000000, valueDisplay = "1000000"}})
	return f15_local0
end, true)

DataSources.TFOptionsPowerups = DataSourceHelpers.ListSetup("PC.TFOptionsPowerups", function (f15_arg0)
	local f15_local0 = {}
	table.insert(f15_local0, {models = {value = 0, valueDisplay = "None"}})
	table.insert(f15_local0, {models = {value = 1, valueDisplay = "Less"}})
	table.insert(f15_local0, {models = {value = 2, valueDisplay = "Default"}})
	table.insert(f15_local0, {models = {value = 3, valueDisplay = "More"}})
	table.insert(f15_local0, {models = {value = 4, valueDisplay = "Insane"}})
	table.insert(f15_local0, {models = {value = 5, valueDisplay = "STOOPID"}})
	return f15_local0
end, true)

DataSources.TFOptionsExtraPoints = DataSourceHelpers.ListSetup("PC.TFOptionsExtraPoints", function (f15_arg0)
	local f15_local0 = {}
	table.insert(f15_local0, {models = {value = 0, valueDisplay = "0"}})
	table.insert(f15_local0, {models = {value = 10, valueDisplay = "+10"}})
	table.insert(f15_local0, {models = {value = 20, valueDisplay = "+20"}})
	table.insert(f15_local0, {models = {value = 30, valueDisplay = "+30"}})
	table.insert(f15_local0, {models = {value = 40, valueDisplay = "+40"}})
	table.insert(f15_local0, {models = {value = 50, valueDisplay = "+50"}})
	table.insert(f15_local0, {models = {value = 60, valueDisplay = "+60"}})
	table.insert(f15_local0, {models = {value = 70, valueDisplay = "+70"}})
	table.insert(f15_local0, {models = {value = 80, valueDisplay = "+80"}})
	table.insert(f15_local0, {models = {value = 90, valueDisplay = "+90"}})
	table.insert(f15_local0, {models = {value = 100, valueDisplay = "+100"}})
	return f15_local0
end, true)

DataSources.TFOptionsRoamerTime = DataSourceHelpers.ListSetup("PC.TFOptionsRoamerTime", function (f15_arg0)
	local f15_local0 = {}
	table.insert(f15_local0, {models = {value = 0, valueDisplay = "Infinite"}})
	table.insert(f15_local0, {models = {value = 30, valueDisplay = "30 Seconds"}})
	table.insert(f15_local0, {models = {value = 60, valueDisplay = "1 Minute"}})
	table.insert(f15_local0, {models = {value = 120, valueDisplay = "2 Minutes"}})
	table.insert(f15_local0, {models = {value = 300, valueDisplay = "5 Minutes"}})
	return f15_local0
end, true)

DataSources.TFOptionsBetterNukePoints = DataSourceHelpers.ListSetup("PC.TFOptionsBetterNukePoints", function (f15_arg0)
	local f15_local0 = {}
	table.insert(f15_local0, {models = {value = 0, valueDisplay = "0"}})
	table.insert(f15_local0, {models = {value = 10, valueDisplay = "10"}})
	table.insert(f15_local0, {models = {value = 20, valueDisplay = "20"}})
	table.insert(f15_local0, {models = {value = 30, valueDisplay = "30"}})
	table.insert(f15_local0, {models = {value = 40, valueDisplay = "40"}})
	table.insert(f15_local0, {models = {value = 50, valueDisplay = "50"}})
	table.insert(f15_local0, {models = {value = 60, valueDisplay = "60"}})
	table.insert(f15_local0, {models = {value = 70, valueDisplay = "70"}})
	table.insert(f15_local0, {models = {value = 80, valueDisplay = "80"}})
	table.insert(f15_local0, {models = {value = 90, valueDisplay = "90"}})
	table.insert(f15_local0, {models = {value = 100, valueDisplay = "100"}})
	table.insert(f15_local0, {models = {value = 110, valueDisplay = "110"}})
	table.insert(f15_local0, {models = {value = 120, valueDisplay = "120"}})
	table.insert(f15_local0, {models = {value = 130, valueDisplay = "130"}})
	table.insert(f15_local0, {models = {value = 140, valueDisplay = "140"}})
	table.insert(f15_local0, {models = {value = 150, valueDisplay = "150"}})
	table.insert(f15_local0, {models = {value = 160, valueDisplay = "160"}})
	table.insert(f15_local0, {models = {value = 170, valueDisplay = "170"}})
	table.insert(f15_local0, {models = {value = 180, valueDisplay = "180"}})
	table.insert(f15_local0, {models = {value = 190, valueDisplay = "190"}})
	table.insert(f15_local0, {models = {value = 200, valueDisplay = "200"}})
	return f15_local0
end, true)

DataSources.TFOptionsP1 = DataSourceHelpers.ListSetup("PC.TFOptionsP1", function (f26_arg0)
	local f26_local0 = {}
	table.insert(f26_local0, {models = {label = "Player Options", description = "Open the player options menu.", page = "TFOptionsPlayerPage", widgetType = "navbutton"}, properties = CoD.TFPCUtil.OptionsNavButtonProperties})
	table.insert(f26_local0, {models = {label = "Game Options", description = "Open the game options menu.", page = "TFOptionsGamePage", widgetType = "navbutton"}, properties = CoD.TFPCUtil.OptionsNavButtonProperties})
	table.insert(f26_local0, {models = {label = "Weapon Options", description = "Open the weapon options menu.", page = "TFOptionsWeaponsPage", widgetType = "navbutton"}, properties = CoD.TFPCUtil.OptionsNavButtonProperties})
	table.insert(f26_local0, {models = {label = "Powerup Options", description = "Open the powerup options menu.", page = "TFOptionsPowerupsPage", widgetType = "navbutton"}, properties = CoD.TFPCUtil.OptionsNavButtonProperties})
	table.insert(f26_local0, {models = {label = "Zombie Options", description = "Open the zombie options menu.", page = "TFOptionsZombiesPage", widgetType = "navbutton"}, properties = CoD.TFPCUtil.OptionsNavButtonProperties})
	table.insert(f26_local0, {models = {label = "Perk Options", description = "Open the perk options menu.", page = "TFOptionsPerksPage", widgetType = "navbutton"}, properties = CoD.TFPCUtil.OptionsNavButtonProperties})
	table.insert(f26_local0, {models = {label = "Roamer Options", description = "Open the roamer options menu.", page = "TFOptionsRoamerPage", widgetType = "navbutton"}, properties = CoD.TFPCUtil.OptionsNavButtonProperties})
	table.insert(f26_local0, {models = {label = "Open Server Settings", description = "Open the server settings menu.", page = "ServerSettings", widgetType = "navbutton"}, properties = CoD.TFPCUtil.OptionsNavButtonProperties})
	return f26_local0
end, true)

DataSources.TFOptionsP1.getWidgetTypeForItem = function (f27_arg0, f27_arg1, f27_arg2)
	if f27_arg1 then
		local f27_local0 = Engine.GetModelValue(Engine.GetModel(f27_arg1, "widgetType"))
		if f27_local0 == "dropdown" then
			return CoD.OptionDropdown --CoD.TFOptions_Dropdown --
		elseif f27_local0 == "checkbox" then
			return CoD.StartMenu_Options_CheckBoxOption
		elseif f27_local0 == "tfcheckbox" then
			return CoD.TFOptions_CheckBoxOption
		elseif f27_local0 == "slider" then
			return CoD.StartMenu_Options_SliderBar
		elseif f27_local0 == "spacer" then
			return CoD.VerticalListSpacer
		elseif f27_local0 == "navbutton" then
			return CoD.TFOptions_NavButton
		end
	end
	return nil
end

DataSources.TFOptionsP2 = DataSourceHelpers.ListSetup("PC.TFOptionsP2", function (f26_arg0)
	local f26_local0 = {}
	return f26_local0
end, true)

DataSources.TFOptionsP2.getWidgetTypeForItem = function (f27_arg0, f27_arg1, f27_arg2)
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
		elseif f27_local0 == "navbutton" then
			return CoD.TFOptions_NavButton
		end
	end
	return nil
end

DataSources.TFOptionsP3 = DataSourceHelpers.ListSetup("PC.TFOptionsP3", function (f26_arg0)
	local f26_local0 = {}
	return f26_local0
end, true)

DataSources.TFOptionsP3.getWidgetTypeForItem = function (f27_arg0, f27_arg1, f27_arg2)
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
		elseif f27_local0 == "navbutton" then
			return CoD.TFOptions_NavButton
		end
	end
	return nil
end

DataSources.TFOptionCategories = DataSourceHelpers.ListSetup("PC.TFOptionCategories", function (f28_arg0)
	local f28_local0 = {}
	table.insert(f28_local0, {models = {tabIcon = CoD.buttonStrings.shoulderl}, properties = {m_mouseDisabled = true}})
	table.insert(f28_local0, {models = {tabName = "PAGE 1", tabWidget = "CoD.TFOptions_P1"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 2", tabWidget = "CoD.TFOptions_P2"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 3", tabWidget = "CoD.TFOptions_P3"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 4", tabWidget = "CoD.TFOptions_ZCounter"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 5", tabWidget = "CoD.TFOptions_ZCounter"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 6", tabWidget = "CoD.TFOptions_ZCounter"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 7", tabWidget = "CoD.TFOptions_ZCounter"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 8", tabWidget = "CoD.TFOptions_ZCounter"}})
	--table.insert(f28_local0, {models = {tabName = "PAGE 9", tabWidget = "CoD.TFOptions_ZCounter"}})
	table.insert(f28_local0, {models = {tabIcon = CoD.buttonStrings.shoulderr}, properties = {m_mouseDisabled = true}})
	return f28_local0
end, true)
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

LUI.createMenu.TFOptions = function (InstanceRef)
	local HudRef = CoD.Menu.NewForUIEditor("TFOptions")
	if f0_local2 then
		f0_local2(HudRef, InstanceRef)
	end

	
	
	

	CoD.TFOptionIndexes = {}
	CoD.TFOptionIndexes["temp"] = 0
    CoD.TFOptionIndexes["max_ammo"] = 1
    CoD.TFOptionIndexes["higher_health"] = 2
    CoD.TFOptionIndexes["no_perk_lim"] = 3  
    CoD.TFOptionIndexes["more_powerups"] = 4 
    CoD.TFOptionIndexes["bigger_mule"] = 5
    CoD.TFOptionIndexes["extra_cash"] = 6
    CoD.TFOptionIndexes["weaker_zombs"] = 7 
	CoD.TFOptionIndexes["roamer_enabled"] = 8  
    CoD.TFOptionIndexes["roamer_time"] = 9  
	CoD.TFOptionIndexes["zcounter_enabled"] = 10
	CoD.TFOptionIndexes["starting_round"] = 11  
	CoD.TFOptionIndexes["perkaholic"] = 12  
	CoD.TFOptionIndexes["exo_movement"] = 13  
	CoD.TFOptionIndexes["perk_powerup"] = 14  
	CoD.TFOptionIndexes["melee_bonus"] = 15
	CoD.TFOptionIndexes["headshot_bonus"] = 16
	CoD.TFOptionIndexes["zombs_always_sprint"] = 17
	CoD.TFOptionIndexes["max_zombies"] = 18
	CoD.TFOptionIndexes["no_delay"] = 19
	CoD.TFOptionIndexes["start_rk5"] = 20
	CoD.TFOptionIndexes["hitmarkers"] = 21
	CoD.TFOptionIndexes["zcash_powerup"] = 22
	CoD.TFOptionIndexes["starting_points"] = 300 -- unique case, needs to save to 3 values for values higher than 65k
	CoD.TFOptionIndexes["no_round_delay"] = 24
	CoD.TFOptionIndexes["bo4_max_ammo"] = 25
	CoD.TFOptionIndexes["better_nuke"] = 26
	CoD.TFOptionIndexes["better_nuke_points"] = 27
	CoD.TFOptionIndexes["packapunch_powerup"] = 28
	CoD.TFOptionIndexes["spawn_with_quick_res"] = 29
	CoD.TFOptionIndexes["bo4_carpenter"] = 30
	CoD.TFOptionIndexes["bottomless_clip_powerup"] = 31
	CoD.TFOptionIndexes["zblood_powerup"] = 32
	CoD.TFOptionIndexes["timed_gameplay"] = 33
	CoD.TFOptionIndexes["move_speed"] = 34
	CoD.TFOptionIndexes["weap_mw2019"] = 35
	CoD.TFOptionIndexes["open_all_doors"] = 36
	CoD.TFOptionIndexes["every_box"] = 37
	CoD.TFOptionIndexes["random_weapon"] = 38
	CoD.TFOptionIndexes["start_bowie"] = 39
	CoD.TFOptionIndexes["start_power"] = 40



	HudRef.soundSet = "ChooseDecal"
	HudRef:setOwner(InstanceRef)
	HudRef:setLeftRight(true, true, 0, 0)
	HudRef:setTopBottom(true, true, 0, 0)
	HudRef:playSound("menu_open", InstanceRef)
	HudRef.buttonModel = Engine.CreateModel(Engine.GetModelForController(InstanceRef), "TFOptions.buttonPrompts")
	local f31_local1 = HudRef
	HudRef.anyChildUsesUpdateState = true
	local f31_local2 = LUI.UIImage.new()
	f31_local2:setLeftRight(true, false, 0, 1280)
	f31_local2:setTopBottom(true, false, 0, 720)
	f31_local2:setRGB(0, 0, 0)
	f31_local2:setAlpha(0.7);
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
	f31_local7.grid:setDataSource("TFOptionCategories")
	f31_local7.grid:setWidgetType(CoD.paintshopTabWidget)
	f31_local7.grid:setHorizontalCount(11)
	HudRef:addElement(f31_local7)
	HudRef.Tabs = f31_local7
	
	local f31_local8 = LUI.UIFrame.new(f31_local1, InstanceRef, 0, 0, false)
	f31_local8:setLeftRight(true, false, 64, 1216)
	f31_local8:setTopBottom(true, false, 134.22, 657)
	HudRef:addElement(f31_local8)
	HudRef.categoryFrame = f31_local8

--[[ 	CoD.TFOptionDebugText = CoD.TextWithBg.new(HudRef, InstanceRef)
    CoD.TFOptionDebugText:setLeftRight(true, true, 240, -240)
    CoD.TFOptionDebugText:setTopBottom(true, false, 20, 50)
    CoD.TFOptionDebugText.Text:setText("HUD Inject")
    CoD.TFOptionDebugText.Bg:setRGB(0.098, 0.098, 0.098)
    CoD.TFOptionDebugText.Bg:setAlpha(0.8)
	HudRef:addElement(CoD.TFOptionDebugText) ]]
	
	
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
		Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "TFOptions.buttonPrompts"))
	end)
	if f0_local3 then
		f0_local3(HudRef, InstanceRef)
	end
	return HudRef
end

