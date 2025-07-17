local _, RoleLayout = ...

-- Set this to true to enable debug prints
RoleLayout.DEBUG = false

-- Logging helper
function RoleLayout:Log(msg)
    if self.DEBUG and DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[RoleLayout]|r " .. tostring(msg))
    end
end

-- Retrieves the list of layouts, logs available layouts, and changes the active layout to match the specified role if found.

function RoleLayout:ChangeLayoutForRole(role)
    local layouts = C_EditMode.GetLayouts()
    if not layouts or not layouts.layouts then
        self:Log("No layouts found.")
        return
    end
    for i, layout in ipairs(layouts.layouts) do
        self:Log("Available layout: " .. layout.layoutName)
        if layout.layoutName == role then
            self:Log("Changing layout to: " .. layout.layoutName)
            self:Log("Layout ID: " .. i)
            C_EditMode.SetActiveLayout(i)
            return layout
        end
    end
end

-- Retrieves the character's role based on specialization and logs details such as the specialization index, ID, name, and role.

function RoleLayout:GetCharacterRole()
    if GetSpecialization then
        local specIndex = GetSpecialization()
        self:Log("specIndex: " .. tostring(specIndex))
        if specIndex then
            local id, name, description, icon, role = GetSpecializationInfo(specIndex)
            self:Log("Specialization ID: " .. tostring(id) .. ", Name: " .. tostring(name) .. ", Role: " .. tostring(role))
            return role
        end
        return "NONE"
    end
end

-- Enables all action bar toggles and sets the auto-loot behavior to default

function RoleLayout:InitializeCharacterSettings()
    SetActionBarToggles(true,true,true,true,true,true,true,"true")
    SetCVar("autoLootDefault", 1)
end