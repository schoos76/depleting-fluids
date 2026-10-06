local resources = require("lib.resources")

resources.eachResource(mods, function(_mod, resource)
  data:extend({
    resources.createFiniteResourceSetting(resource),
  })
end)
