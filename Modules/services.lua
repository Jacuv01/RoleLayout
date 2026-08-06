local _, RoleLayout = ...

local function getEditModeOverride()
    return LibStub and LibStub("LibEditModeOverride-1.0", true)
end

local roleMap = {
    DAMAGER = "DPS",
    HEALER = "HEAL",
    TANK = "TANK"
}

local function normalizeRole(role)
    if not role then
        return nil
    end
    return roleMap[role] or role
end

function RoleLayout:GetCharacterRole()
    if GetSpecialization then
        local specIndex = GetSpecialization()
        if specIndex then
            local id, name, description, icon, role = GetSpecializationInfo(specIndex)
            self:Log("Specialization ID: " .. tostring(id) .. ", Name: " .. tostring(name) .. ", Role: " .. tostring(role))
            return role
        end
    end
    return "NONE"
end

function RoleLayout:NormalizeRole(role)
    return normalizeRole(role)
end

function RoleLayout:ChangeLayoutForRole(role)
    local normalizedRole = self:NormalizeRole(role)
    if not normalizedRole then
        return nil
    end

    local lib = getEditModeOverride()
    if not lib then
        self:Log("LibEditModeOverride is not available.")
        return nil
    end

    if not lib:IsReady() then
        self:Log("Edit Mode is not ready yet. Retrying once.")
        if C_Timer and C_Timer.After then
            C_Timer.After(1, function()
                self:ApplyRoleLayout(role)
            end)
        end
        return nil
    end

    if not lib:AreLayoutsLoaded() then
        lib:LoadLayouts()
    end

    if not lib:DoesLayoutExist(normalizedRole) then
        self:Log("No layout found with the name: " .. normalizedRole)
        return nil
    end

    lib:SetActiveLayout(normalizedRole)
    lib:SaveOnly()
    self:Log("Layout automatically changed to: " .. normalizedRole)
    return true
end

function RoleLayout:ApplyRoleLayout(role)
    local normalizedRole = self:NormalizeRole(role)
    if not normalizedRole then
        return false
    end

    local layout = self:ChangeLayoutForRole(normalizedRole)
    return layout ~= nil
end
