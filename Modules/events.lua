local _, RoleLayout = ...
local LibEditModeOverride = LibStub and LibStub("LibEditModeOverride-1.0", true)
if not LibEditModeOverride then
    if RoleLayout and RoleLayout.Log then
        RoleLayout:Log("Error: Failed to load LibEditModeOverride-1.0. Automatic layout switching will not work.")
    end
end

local function applyLayoutForCurrentRole()
    if not RoleLayout or not RoleLayout.GetCharacterRole then
        return
    end

    local role = RoleLayout:GetCharacterRole()
    if not role or role == "NONE" then
        RoleLayout:Log("Invalid role detected: " .. tostring(role) .. ". Skipping layout switching.")
        return
    end

    if RoleLayout and RoleLayout.ApplyRoleLayout then
        RoleLayout:ApplyRoleLayout(role)
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        RoleLayout:Initialize()
        if RoleLayout.Window and RoleLayout.Window.CreateGameOptionsPanel then
            RoleLayout.Window:CreateGameOptionsPanel()
        end
        self:UnregisterEvent("PLAYER_LOGIN")
        return
    end

    if event == "PLAYER_ENTERING_WORLD" then
        RoleLayout:Initialize()
    end

    if event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
        applyLayoutForCurrentRole()
    end
end)