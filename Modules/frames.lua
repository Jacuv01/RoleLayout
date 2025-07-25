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

    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    f.checkboxes = {}
    RoleLayoutDB = RoleLayoutDB or {}
    RoleLayoutDB.actionBars = RoleLayoutDB.actionBars or GenerateDefaultActionBars()

function GenerateDefaultActionBars()
    local defaults = {}
    for i = 1, 7 do
        defaults[i] = true
    end
    return defaults
end
    for i = 1, 7 do
        local cb = CreateFrame("CheckButton", "RoleLayoutActionBarCB"..i, f, "ChatConfigCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, -40 - (i-1)*30)
        _G[cb:GetName().."Text"]:SetText(actionBarLabels[i])
        cb:SetChecked(RoleLayoutDB.actionBars[i])
        cb:SetScript("OnClick", function(self)
            RoleLayoutDB.actionBars[i] = self:GetChecked()
        end)
        f.checkboxes[i] = cb
    end

    local applyBtn = RoleLayout:CreateButton(f, "Apply Bars", 120, 24, "BOTTOMLEFT", 10, 10, function()
        SetActionBarToggles(
            RoleLayoutDB.actionBars[1],
            RoleLayoutDB.actionBars[2],
            RoleLayoutDB.actionBars[3],
            RoleLayoutDB.actionBars[4],
            RoleLayoutDB.actionBars[5],
            RoleLayoutDB.actionBars[6],
            RoleLayoutDB.actionBars[7],
            "true"
        )

        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[RoleLayout]|r Action bars updated.")
    end)

    local reloadBtn = RoleLayout:CreateButton(f, "Reload UI", 120, 24, "BOTTOMRIGHT", -10, 10, function()
        ReloadUI()
    end)
    f:Hide()
    self.frame = f
    return f
end

function RoleLayout.Window:Show()
    self:Create():Show()
end

function RoleLayout.Window:Hide()
    if self.frame then self.frame:Hide() end
end

-- Register a slash command to show the window
SLASH_ROLELAYOUT1 = "/rolelayout"
SlashCmdList.ROLELAYOUT = function()
    RoleLayout.Window:Show()
end
