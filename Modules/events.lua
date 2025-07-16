local _, RoleLayout = ...
local LibEditModeOverride = LibStub and LibStub("LibEditModeOverride-1.0", true)

-- Set this to true to enable debug prints
local DEBUG = false

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
        local roleMap = { DAMAGER = "DPS", HEALER = "HEAL", TANK = "TANK" }
        local normalizedRole = roleMap[role] or role

        if DEBUG then print("LibEditModeOverride:", LibEditModeOverride) end
        if LibEditModeOverride and LibEditModeOverride.LoadLayouts and LibEditModeOverride.SetActiveLayout then
            if LibEditModeOverride:IsReady() then
                LibEditModeOverride:LoadLayouts()
                if LibEditModeOverride:DoesLayoutExist(normalizedRole) then
                    LibEditModeOverride:SetActiveLayout(normalizedRole)
                    LibEditModeOverride:SaveOnly()
                    if DEBUG then print("Layout automatically changed to: " .. tostring(normalizedRole)) end
                else
                    if DEBUG then print("No layout found with the name: " .. tostring(normalizedRole)) end
                end
            else
                if DEBUG then print("Edit Mode is not ready yet. Try opening it manually once per session.") end
            end
        else
            if DEBUG then print("LibEditModeOverride is not available or does not have the required functions.") end
        end
    end
end)

