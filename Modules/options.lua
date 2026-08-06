local _, RoleLayout = ...

RoleLayout.Options = {}

local actionBarLabels = {
    "Action Bar 2",
    "Action Bar 3",
    "Action Bar 4",
    "Action Bar 5",
    "Action Bar 6",
    "Action Bar 7",
    "Action Bar 8"
}

function RoleLayout.Options:InitializeState()
    local db = RoleLayout:GetDB()
    db.actionBars = db.actionBars or {}

    for i = 1, 7 do
        if type(db.actionBars[i]) ~= "boolean" then
            db.actionBars[i] = true
        end
    end

    if type(db.enableExternalDefensives) ~= "boolean" then
        db.enableExternalDefensives = false
    end

    if type(db.enableDamageMeter) ~= "boolean" then
        db.enableDamageMeter = false
    end

    return db
end

function RoleLayout.Options:ApplyActionBarSettings(db)
    SetActionBarToggles(
        db.actionBars[1],
        db.actionBars[2],
        db.actionBars[3],
        db.actionBars[4],
        db.actionBars[5],
        db.actionBars[6],
        db.actionBars[7],
        "true"
    )
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[RoleLayout]|r Action bars updated. Reloading UI to apply the changes.")
    ReloadUI()
end

function RoleLayout.Options:ApplyGameplaySettings(db)
    if RoleLayout and RoleLayout.ApplyGameplayEnhancementsSettings then
        RoleLayout:ApplyGameplayEnhancementsSettings(db.enableExternalDefensives, db.enableDamageMeter)
    end
end

function RoleLayout.Options:SyncWindowControls(owner, db)
    if not owner then
        return
    end

    if owner.frame and owner.frame.checkboxes then
        for i = 1, 7 do
            if owner.frame.checkboxes[i] then
                owner.frame.checkboxes[i]:SetChecked(db.actionBars[i])
            end
        end
    end

    if owner.mainExternalCB then
        owner.mainExternalCB:SetChecked(db.enableExternalDefensives)
    end
    if owner.mainDamageCB then
        owner.mainDamageCB:SetChecked(db.enableDamageMeter)
    end
end

function RoleLayout.Options:SyncPanelControls(owner, db, optionsActionBarCBs, externalCB, damageCB)
    for i = 1, 7 do
        if type(db.actionBars[i]) ~= "boolean" then
            db.actionBars[i] = true
        end
        if optionsActionBarCBs[i] then
            optionsActionBarCBs[i]:SetChecked(db.actionBars[i])
        end
    end

    if externalCB then
        externalCB:SetChecked(db.enableExternalDefensives)
    end
    if damageCB then
        damageCB:SetChecked(db.enableDamageMeter)
    end

    self:SyncWindowControls(owner, db)
end

function RoleLayout.Options:SyncControls(owner, db, optionsActionBarCBs, externalCB, damageCB)
    self:SyncPanelControls(owner, db, optionsActionBarCBs, externalCB, damageCB)
end

function RoleLayout.Options:CreateGameOptionsPanel(owner)
    local panel = CreateFrame("Frame", "RoleLayoutGameOptionsPanel", UIParent)
    panel.name = "RoleLayout"

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("RoleLayout")

    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    subtitle:SetText("Manage your action bars and gameplay enhancements.")

    local db = self:InitializeState()

    local barsTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    barsTitle:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
    barsTitle:SetText("Action Bars")

    local barsHint = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    barsHint:SetPoint("TOPLEFT", barsTitle, "BOTTOMLEFT", 0, -6)
    barsHint:SetText("Enable the bars you want to keep available when you apply the settings.")

    local optionsActionBarCBs = {}
    local externalCB
    local damageCB
    local function syncControls()
        self:SyncControls(owner, db, optionsActionBarCBs, externalCB, damageCB)
    end
    for i = 1, 7 do
        local cb = CreateFrame("CheckButton", "RoleLayoutOptionsActionBarCB" .. i, panel, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", barsHint, "BOTTOMLEFT", 0, -6 - (i - 1) * 22)
        _G[cb:GetName() .. "Text"]:SetText(actionBarLabels[i])
        cb:SetChecked(db.actionBars[i])
        cb:SetScript("OnClick", function(self)
            db.actionBars[i] = self:GetChecked() and true or false
            syncControls()
        end)
        optionsActionBarCBs[i] = cb
    end

    local applyBarsBtn = RoleLayout:CreateButton(panel, "Apply Bars", 120, 24, "TOPLEFT", 16, -270, function()
        self:ApplyActionBarSettings(db)
    end)

    local gameplayTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    gameplayTitle:SetPoint("TOPLEFT", applyBarsBtn, "BOTTOMLEFT", 0, -16)
    gameplayTitle:SetText("Gameplay Enhancements")

    local gameplayHint = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    gameplayHint:SetPoint("TOPLEFT", gameplayTitle, "BOTTOMLEFT", 0, -6)
    gameplayHint:SetText("Adjust optional gameplay features for your current setup.")

    local externalCB = CreateFrame("CheckButton", "RoleLayoutEnableExternalDefensivesCB", panel, "InterfaceOptionsCheckButtonTemplate")
    externalCB:SetPoint("TOPLEFT", gameplayHint, "BOTTOMLEFT", 0, -6)
    _G[externalCB:GetName() .. "Text"]:SetText("Enable External Defensives")
    externalCB:SetScript("OnClick", function(checkboxSelf)
        local checked = checkboxSelf:GetChecked() and true or false
        db.enableExternalDefensives = checked
        RoleLayout.Options:ApplyGameplaySettings(db)
        syncControls()
    end)

    local damageCB = CreateFrame("CheckButton", "RoleLayoutEnableDamageMeterCB", panel, "InterfaceOptionsCheckButtonTemplate")
    damageCB:SetPoint("TOPLEFT", externalCB, "BOTTOMLEFT", 0, -8)
    _G[damageCB:GetName() .. "Text"]:SetText("Enable Damage Meter")
    damageCB:SetScript("OnClick", function(checkboxSelf)
        local checked = checkboxSelf:GetChecked() and true or false
        db.enableDamageMeter = checked
        RoleLayout.Options:ApplyGameplaySettings(db)
        syncControls()
    end)

    owner.optionsExternalCB = externalCB
    owner.optionsDamageCB = damageCB
    owner.optionsActionBarCBs = optionsActionBarCBs

    panel:SetScript("OnShow", function()
        db = self:InitializeState()
        syncControls()
    end)

    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Settings.RegisterAddOnCategory(category)
        owner.optionsCategory = category
    else
        local addCategory = rawget(_G, "InterfaceOptions_AddCategory")
        if type(addCategory) == "function" then
            addCategory(panel)
        end
    end

    return panel
end
