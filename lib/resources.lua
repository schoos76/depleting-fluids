-- Resource/fluid data and the pure helpers built on it, shared between
-- settings.lua and data-updates.lua. No Factorio globals: the data stage passes
-- `mods` into eachResource and reads `settings`/`data` itself (see
-- prototypes/finite.lua).
local resources = {}

local SETTING_PREFIX = "depleting-fluids-finite-"

-- Fluid-yielding resources per supporting MOD. Every resource listed here must
-- have an entry in `fluids` below, or makeResourceFinite would build a mining
-- result with no fluid name.
resources.byMod = {
  ["base"] = { "crude-oil" },
  ["space-age"] = { "fluorine-vent", "sulfuric-acid-geyser" },
  ["James-Oil-Processing"] = { "adamo-carbon-natural-gas" },
  ["angelsrefining"] = { "angels-fissure" },
  ["angelspetrochem"] = { "angels-natural-gas" },
  ["bobores"] = { "bob-ground-water", "bob-lithia-water" },
  ["factorioplus"] = { "natural-gas", "aquifer", "geothermal-vent" },
}

-- Resource name -> the fluid its mining yields once the resource is finite.
resources.fluids = {
  ["crude-oil"] = "crude-oil",
  ["fluorine-vent"] = "fluorine",
  ["sulfuric-acid-geyser"] = "sulfuric-acid",
  ["adamo-carbon-natural-gas"] = "adamo-carbon-natural-gas",
  ["angels-fissure"] = "angels-thermal-water",
  ["angels-natural-gas"] = "angels-gas-natural-1",
  ["bob-ground-water"] = "water",
  ["bob-lithia-water"] = "bob-lithia-water",
  ["natural-gas"] = "natural-gas",
  ["aquifer"] = "water",
  ["geothermal-vent"] = "steam",
}

--- Returns the name of the startup setting that toggles finiteness for resourceName.
---@param resourceName string
---@return string
function resources.settingName(resourceName)
  return SETTING_PREFIX .. resourceName
end

--- Calls func(mod, resource) for every resource of every supporting MOD present
--- in installedMods.
---@param installedMods table<string, string>  Factorio's `mods` global, name -> version
---@param func fun(mod: string, resource: string)
function resources.eachResource(installedMods, func)
  for mod, names in pairs(resources.byMod) do
    if installedMods[mod] then
      for _, resource in ipairs(names) do
        func(mod, resource)
      end
    end
  end
end

--- Returns the fluid a resource yields once it is finite.
---@param resourceName string
---@return string|nil  nil when the resource is not mapped in `resources.fluids`
function resources.fluidFor(resourceName)
  return resources.fluids[resourceName]
end

--- Builds the startup bool-setting prototype that toggles finiteness for resourceName.
---@param resourceName string
---@return table  a bool-setting prototype for `data:extend`
function resources.createFiniteResourceSetting(resourceName)
  local name = resources.settingName(resourceName)
  return {
    type = "bool-setting",
    name = name,
    setting_type = "startup",
    default_value = true,
    order = "c",
    localised_name = { "mod-settings-name." .. name },
    localised_description = { "mod-settings-description." .. name },
  }
end

return resources
