local _, RoleLayout = ...

-- Set this to true to enable debug prints
RoleLayout.DEBUG = false

-- Logging helper
function RoleLayout:Log(msg)
    if self.DEBUG and DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[RoleLayout]|r " .. tostring(msg))
    end
end

-- Retrieve the list of Layouts in the edit mode

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

-- Retrieve the character's role based on specialization

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

-- Initializes action bars and autoloot settings

function RoleLayout:InitializeCharacterSettings()
    SetActionBarToggles(true,true,true,true,true,true,true,"true")
    SetCVar("autoLootDefault", 1)
end