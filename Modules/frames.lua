local _, RoleLayout = ...

RoleLayout.Window = {}

local actionBarLabels = {
    "Action Bar 2",
    "Action Bar 3",
    "Action Bar 4",
    "Action Bar 5",
    "Action Bar 6",
    "Action Bar 7",
    "Action Bar 8"
}

function RoleLayout.Window:Create()
    if self.frame then return self.frame end 

    local f = CreateFrame("Frame", "RoleLayoutWindow", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(350, 320)
    f:SetPoint("CENTER")
    f.title = f:CreateFontString(nil, "OVERLAY")
    f.title:SetFontObject("GameFontHighlight")
    f.title:SetPoint("LEFT", f.TitleBg, "LEFT", 5, 0)
    f.title:SetText("RoleLayout Options")

    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(f)
    bg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")

    local subtitle = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -28)
    subtitle:SetText("Control your action bars and gameplay enhancements.")

    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    local db = RoleLayout:GetDB()
    f.checkboxes = {}

    local barsTitle = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    barsTitle:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
    barsTitle:SetText("Action Bars")

    for i = 1, 7 do
        local cb = CreateFrame("CheckButton", "RoleLayoutActionBarCB"..i, f, "ChatConfigCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", barsTitle, "BOTTOMLEFT", 0, -8 - (i-1)*22)
        _G[cb:GetName().."Text"]:SetText(actionBarLabels[i])
        cb:SetChecked(db.actionBars[i])
        cb:SetScript("OnClick", function(self)
            db.actionBars[i] = self:GetChecked() and true or false
        end)
        f.checkboxes[i] = cb
    end

    local gameplayTitle = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    gameplayTitle:SetPoint("TOPLEFT", barsTitle, "BOTTOMLEFT", 0, -190)
    gameplayTitle:SetText("Gameplay Enhancements")

    local externalMainCB = CreateFrame("CheckButton", "RoleLayoutWindowExternalDefensivesCB", f, "ChatConfigCheckButtonTemplate")
    externalMainCB:SetPoint("TOPLEFT", gameplayTitle, "BOTTOMLEFT", 0, -8)
    _G[externalMainCB:GetName() .. "Text"]:SetText("Enable External Defensives")
    externalMainCB:SetChecked(db.enableExternalDefensives)
    externalMainCB:SetScript("OnClick", function(self)
        local checked = self:GetChecked() and true or false
        db.enableExternalDefensives = checked
        if RoleLayout and RoleLayout.ApplyGameplayEnhancementsSettings then
            RoleLayout:ApplyGameplayEnhancementsSettings(
                db.enableExternalDefensives,
                db.enableDamageMeter
            )
        end

        if RoleLayout.Window and RoleLayout.Window.optionsExternalCB then
            RoleLayout.Window.optionsExternalCB:SetChecked(checked)
        end
    end)

    local damageMainCB = CreateFrame("CheckButton", "RoleLayoutWindowDamageMeterCB", f, "ChatConfigCheckButtonTemplate")
    damageMainCB:SetPoint("TOPLEFT", externalMainCB, "BOTTOMLEFT", 0, -8)
    _G[damageMainCB:GetName() .. "Text"]:SetText("Enable Damage Meter")
    damageMainCB:SetChecked(db.enableDamageMeter)
    damageMainCB:SetScript("OnClick", function(self)
        local checked = self:GetChecked() and true or false
        db.enableDamageMeter = checked
        if RoleLayout and RoleLayout.ApplyGameplayEnhancementsSettings then
            RoleLayout:ApplyGameplayEnhancementsSettings(
                db.enableExternalDefensives,
                db.enableDamageMeter
            )
        end

        if RoleLayout.Window and RoleLayout.Window.optionsDamageCB then
            RoleLayout.Window.optionsDamageCB:SetChecked(checked)
        end
    end)

    self.mainExternalCB = externalMainCB
    self.mainDamageCB = damageMainCB

    local applyBtn = RoleLayout:CreateButton(f, "Apply Bars", 120, 24, "BOTTOMLEFT", 10, 10, function()
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

        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[RoleLayout]|r Action bars updated.")
        ReloadUI()
    end)

    local reloadBtn = RoleLayout:CreateButton(f, "Reload UI", 120, 24, "BOTTOMRIGHT", -10, 10, function()
        ReloadUI()
    end)
    f:Hide()
    self.frame = f
    return f
end

function RoleLayout.Window:Show()
    local frame = self:Create()

    local db = RoleLayout:GetDB()
    if type(db.enableExternalDefensives) ~= "boolean" then
        db.enableExternalDefensives = false
    end
    if type(db.enableDamageMeter) ~= "boolean" then
        db.enableDamageMeter = false
    end

    if self.mainExternalCB then
        self.mainExternalCB:SetChecked(db.enableExternalDefensives)
    end
    if self.mainDamageCB then
        self.mainDamageCB:SetChecked(db.enableDamageMeter)
    end

    frame:Show()
end

function RoleLayout.Window:Hide()
    if self.frame then self.frame:Hide() end
end

function RoleLayout.Window:CreateGameOptionsPanel()
    if self.optionsPanel then
        return self.optionsPanel
    end

    if RoleLayout.Options and RoleLayout.Options.CreateGameOptionsPanel then
        local panel = RoleLayout.Options:CreateGameOptionsPanel(self)
        self.optionsPanel = panel
        return panel
    end

    return nil
end

function RoleLayout.Window:OpenGameOptionsPanel()
    local panel = self:CreateGameOptionsPanel()
    if not panel then
        return
    end

    if Settings and Settings.OpenToCategory and self.optionsCategory and self.optionsCategory.GetID then
        Settings.OpenToCategory(self.optionsCategory:GetID())
    elseif Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(panel.name)
    else
        local openToCategory = rawget(_G, "InterfaceOptionsFrame_OpenToCategory")
        if type(openToCategory) == "function" then
            openToCategory(panel)
            openToCategory(panel)
        end
    end
end

-- Register a slash command to show the window
SLASH_ROLELAYOUT1 = "/rolelayout"
SlashCmdList.ROLELAYOUT = function()
    RoleLayout.Window:OpenGameOptionsPanel()
end

local optionsInitFrame = CreateFrame("Frame")
optionsInitFrame:RegisterEvent("PLAYER_LOGIN")
optionsInitFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        RoleLayout.Window:CreateGameOptionsPanel()
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)
