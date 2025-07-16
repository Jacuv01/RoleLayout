-- Punto de entrada del addon
local addonName, RoleLayout = ...

-- Inicializar la base de datos del addon
if not RoleLayoutDB then
    RoleLayoutDB = { locked = false }
end

DEFAULT_CHAT_FRAME:AddMessage("RoleLayout successfully loaded!")