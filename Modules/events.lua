local _, RoleLayout = ...
local LibEditModeOverride = LibStub and LibStub("LibEditModeOverride-1.0", true)



-- Role normalization table (only created once)
local roleMap = { DAMAGER = "DPS", HEALER = "HEAL", TANK = "TANK" }



-- Event handling for character data initialization and specialization change detection
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        if RoleLayout and RoleLayout.InitializeCharacterSettings then
            RoleLayout:InitializeCharacterSettings()
        end
    end

    if RoleLayout and RoleLayout.GetCharacterRole then
        local role = RoleLayout:GetCharacterRole()
        local normalizedRole = roleMap[role] or role

        RoleLayout:Log("LibEditModeOverride: " .. tostring(LibEditModeOverride))
        if LibEditModeOverride and LibEditModeOverride.LoadLayouts and LibEditModeOverride.SetActiveLayout then
            if LibEditModeOverride:IsReady() then
                LibEditModeOverride:LoadLayouts()
                if LibEditModeOverride:DoesLayoutExist(normalizedRole) then
                    LibEditModeOverride:SetActiveLayout(normalizedRole)
                    LibEditModeOverride:SaveOnly()
                    RoleLayout:Log("Layout automatically changed to: " .. tostring(normalizedRole))
                else
                    RoleLayout:Log("No layout found with the name: " .. tostring(normalizedRole))
                end
            else
                RoleLayout:Log("Edit Mode is not ready yet. Try opening it manually once per session.")
            end
        else
            RoleLayout:Log("LibEditModeOverride is not available or does not have the required functions.")
        end
    end
end)