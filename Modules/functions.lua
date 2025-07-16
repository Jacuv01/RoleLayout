local _, RoleLayout = ...

-- Retrieve the list of Layouts in the edit mode

function RoleLayout:ChangeLayoutForRole(role)
    local layouts = C_EditMode.GetLayouts()
    if not layouts or not layouts.layouts then
        print("No layouts found.")
        return
    end
    for i, layout in ipairs(layouts.layouts) do
        print("Layout disponible:", layout.layoutName)
        if layout.layoutName == role then
            print("Changing layout to: " .. layout.layoutName)
            print("Layout ID:", i)
            C_EditMode.SetActiveLayout(i)
            return layout
        end
    end
end

-- Retrieve the character's role based on specialization

function RoleLayout:GetCharacterRole()
    if GetSpecialization then
        local specIndex = GetSpecialization()
        print("specIndex:", specIndex)
        if specIndex then
            local id, name, description, icon, role = GetSpecializationInfo(specIndex)
            print("Specialization ID:", id, "Name:", name, "Role:", role)
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