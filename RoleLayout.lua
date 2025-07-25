local addonName, RoleLayout = ...

if not RoleLayoutDB then
    RoleLayoutDB = { locked = false }
end

DEFAULT_CHAT_FRAME:AddMessage("RoleLayout successfully loaded!")