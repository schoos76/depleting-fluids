-- Data-stage mutation: turn a resource prototype into a finite one. Kept out of
-- lib/ because it reads `settings` and `data.raw`.
local resources = require("lib.resources")

local finite = {}

--- True when the startup setting for resourceName is enabled.
---@param resourceName string
---@return boolean
function finite.enabled(resourceName)
  return settings.startup[resources.settingName(resourceName)].value
end

--- Rewrites data.raw.resource[resourceName] into a finite resource that mines
--- its mapped fluid.
---
--- No-op when the prototype is absent: its MOD may have disabled the resource
--- through its own settings.
---@param resourceName string
function finite.apply(resourceName)
  local resource = data.raw.resource[resourceName]
  if not resource then
    return
  end

  resource.infinite = false
  resource.minimum = 25000
  resource.normal = 100000
  resource.infinite_depletion_amount = 5
  resource.minable = {
    mining_time = 0.275,
    results = {
      {
        type = "fluid",
        name = resources.fluidFor(resourceName),
        amount_min = 5,
        amount_max = 5,
        independent_probability = 1,
      },
    },
  }
end

return finite
