local resources = require("lib.resources")
local finite = require("prototypes.finite")

resources.eachResource(mods, function(_mod, resource)
  if finite.enabled(resource) then
    finite.apply(resource)
  end
end)
