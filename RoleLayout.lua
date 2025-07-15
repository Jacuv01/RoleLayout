-- Punto de entrada del addon
local addonName, RoleLayout = ...

-- Inicializar la base de datos del addon
if not RoleLayoutDB then
    RoleLayoutDB = {}
    RoleLayoutDB.locked = false
end

print("RoleLayout successfully loaded!")