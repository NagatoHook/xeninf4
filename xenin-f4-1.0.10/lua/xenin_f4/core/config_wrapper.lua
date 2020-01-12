local CONFIG = {}

function CONFIG:Init()
	F4Menu.Config = {}
	F4Menu.Config.Staff = {}
	F4Menu.Config.Tabs = {}

	self:SetColumnsPerRow(2)
	self:SetCloseMenuAfterJobChange(false)
	self:SetDefaultJobSequence("pose_standing_02")
	self:SetEasySkins(true)
	self:SetDebounceLength(0.2)
	self:SetEmptySearchOnTabSwitch(true)
	self:SetCategoriesStartExpanded(true)
	self:SetMoneyConfig()
	self:SetItemsOrder()
	self:SetTitle("Xenin F4")
	self:SetResolution(1280, 750)
	self:SetLanguage("english")
	self:SetCategoriesBackgroundFullyColored(false)
	self:SetUseOfflineMoney(true)
	self:SetRealtimeModelsEnabled(true)
	self:SetSidebarColors({
		Player = { Color(208, 62, 106), Color(200, 60, 123) },
		PlayerAvatar = { Color(251, 211, 50), Color(69, 198, 103) },
		Commands = { Color(200, 60, 123), Color(176, 55, 180) },
	})
	
	if (CLIENT) then
		if (IsValid(F4Menu.Frame)) then
			F4Menu.Frame:Remove()
		end
	end
end

function CONFIG:SetResolution(width, height)
	if (isfunction(width)) then
		F4Menu.Config.Resolution = width
	else
		F4Menu.Config.Resolution = { width or 1280, height or 750 }
	end
end

function CONFIG:SetRealtimeModelsEnabled(bool)
	F4Menu.Config.RealtimeModels = bool
end

function CONFIG:SetColumnsPerRow(num)
	F4Menu.Config.ColumnsPerRow = num
end

function CONFIG:SetCloseMenuAfterJobChange(bool)
	F4Menu.Config.CloseMenuAfterJobChange = bool
end

function CONFIG:SetDefaultJobSequence(seq)
	F4Menu.Config.DefaultJobSequence = seq
end

function CONFIG:SetEasySkins(bool)
	F4Menu.Config.EasySkins = bool
end

function CONFIG:SetDebounceLength(len)
	F4Menu.Config.DebounceLength = len
end

function CONFIG:SetEmptySearchOnTabSwitch(bool)
	F4Menu.Config.EmptySearchOnTabSwitch = bool
end

function CONFIG:SetCategoriesStartExpanded(bool)
	F4Menu.Config.CategoriesStartExpanded = bool
end

function CONFIG:SetCategoriesBackgroundFullyColored(bool)
	F4Menu.Config.CategoriesBackgroundFullyColored = bool
end

function CONFIG:SetUseOfflineMoney(bool)
	F4Menu.Config.UseOfflineMoney = bool
end

function CONFIG:SetItemsOrder(tbl)
	tbl = tbl or {
		"Entities",
		"Weapons",
		"Shipments",
		"Ammo",
		"Vehicles",
		"Food"
	}

	F4Menu.Config.ItemsOrder = tbl
end

function CONFIG:SetSidebarColors(tbl)
	F4Menu.Config.SidebarColors = tbl
end

function CONFIG:SetMoneyConfig(tbl)
	tbl = tbl or {}
	tbl.CacheInterval = tbl.CacheInterval or 120
	tbl.DaysSinceLastLogin = tbl.DaysSinceLastLogin or 14

	F4Menu.Config.TotalMoney = tbl
end

function CONFIG:AddStaff(id, name, col)
	F4Menu.Config.Staff[id] = col and {
		str = name,
		color = col
	} or name
end

function CONFIG:AddTab(tbl)
	local id = #F4Menu.Config.Tabs + 1
	F4Menu.Config.Tabs[id] = tbl
	F4Menu.Config.Tabs[id].type = "tab"
end

function CONFIG:AddURL(tbl)
	local id = #F4Menu.Config.Tabs + 1
	F4Menu.Config.Tabs[id] = tbl
	F4Menu.Config.Tabs[id].type = "url"
end

function CONFIG:AddWebsite(tbl)
	local id = #F4Menu.Config.Tabs + 1
	F4Menu.Config.Tabs[id] = tbl
	F4Menu.Config.Tabs[id].type = "website"
end

function CONFIG:AddDivider(startCol, endCol)
	F4Menu.Config.Tabs[#F4Menu.Config.Tabs + 1] = {
		type = "divider",
		startColor = startCol,
		endColor = endCol
	}
end

function CONFIG:SetActiveTab(name)
	F4Menu.Config.DefaultTab = name
end

function CONFIG:SetTitle(name)
	F4Menu.Config.Title = name
end

function CONFIG:SetXeninInventory(tbl)
	if (!tbl.enabled) then return end
	tbl.panel = "XeninInventory.XeninInventory"
	
	self:AddTab(tbl)
end

function CONFIG:SetXeninBattlePass(tbl)
	if (!tbl.enabled) then return end
	tbl.panel = "BATTLEPASS_Menu.F4"
	
	self:AddTab(tbl)
end

function CONFIG:SetXeninCoinflips(tbl)
	if (!tbl.enabled) then return end
	tbl.panel = "Coinflip.Frame.F4"
	
	self:AddTab(tbl)
end

function CONFIG:SetLanguage(lang, tbl)
	F4Menu.Language = XeninUI:Language("xenin_f4menu")
	F4Menu.Language:SetURL("https://gitlab.com/sleeppyy/xenin-languages")
	F4Menu.Language:SetFolder("f4menu")
	-- Always down the English one as it'll attempt to use English language as backup
	F4Menu.Language:Download("english", true)
	F4Menu.Language:SetActiveLanguage(lang)
	if (lang != "english" and !tbl) then
		F4Menu.Language:Download(lang, true)
	elseif (tbl) then
		F4Menu.Language:SetLocalLanguage(lang, tbl)
	end
end

function F4Menu:CreateConfig()
	local tbl = table.Copy(CONFIG)
	tbl:Init()

	return tbl
end

function F4Menu:GetPhrase(phrase, replacement)
	return F4Menu.Language:GetPhrase(phrase, replacement)
end

function F4Menu:CreateCommandCategory(name, options)
  options = options or {}
  table.Merge(options, {
    name = name,
    commands = {}
  })
  local id = table.insert(F4Menu.Commands, options)

  local tbl = {}
  tbl.ID = id
  function tbl:AddCommand(tbl)
    local id = self.ID
    if (!id) then return self, Error("The category for " .. name .. " command doesn't seem to exist") end
    local name = tbl.name or "No Name"
    local func = tbl.func or function() end
    local check = tbl.customCheck or function() return true end

    F4Menu:AddCommand(id, tbl)

    return self
  end

  return tbl
end

function F4Menu:AddCommand(cat, tbl)
  self.Commands[cat].commands[#self.Commands[cat].commands + 1] = tbl
end