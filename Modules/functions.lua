local _, RoleLayout = ...

RoleLayout.DEBUG = false

-- Logging helper
function RoleLayout:Log(msg)
    if self.DEBUG and DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[RoleLayout]|r " .. tostring(msg))
    end
end

function RoleLayout:GetGameplayEnhancementsSettings()
    local external = false
    if GetCVarBool then
        external = GetCVarBool("externalDefensivesEnabled")
        if not external then
            external = GetCVarBool("enableExternalDefensives")
        end
    end
    local damage = GetCVarBool and GetCVarBool("damageMeterEnabled") or false
    return external and true or false, damage and true or false
end

function RoleLayout:ApplyGameplayEnhancementsSettings(externalEnabled, damageMeterEnabled)
    local externalValue = externalEnabled and "1" or "0"
    local damageValue = damageMeterEnabled and "1" or "0"

    if SetCVar then
        SetCVar("externalDefensivesEnabled", externalValue)
        SetCVar("enableExternalDefensives", externalValue)
        SetCVar("damageMeterEnabled", damageValue)
    end
end

function RoleLayout:InitializeCharacterSettings()
    local db = self:GetDB()
    db.actionBars = db.actionBars or {}

    if type(db.enableExternalDefensives) ~= "boolean" then
        db.enableExternalDefensives = false
    end

    if type(db.enableDamageMeter) ~= "boolean" then
        db.enableDamageMeter = false
    end

    for i = 1, 7 do
        if type(db.actionBars[i]) ~= "boolean" then
            db.actionBars[i] = true
        end
    end

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

    self:ApplyGameplayEnhancementsSettings(
        db.enableExternalDefensives,
        db.enableDamageMeter
    )

    SetCVar("autoLootDefault", 1)
end

function RoleLayout:CreateButton(parent, text, width, height, point, x, y, onClick)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetSize(width, height)
    btn:SetPoint(point, x, y)
    btn:SetText(text)
    if onClick then
        btn:SetScript("OnClick", onClick)
    end
    return btn
end