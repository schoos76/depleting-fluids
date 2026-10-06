local resources = require("lib.resources")

describe("resources.settingName", function()
  it("prefixes the resource name", function()
    assert.are.equal("depleting-fluids-finite-crude-oil", resources.settingName("crude-oil"))
  end)
end)

describe("resources.createFiniteResourceSetting", function()
  local setting = resources.createFiniteResourceSetting("fluorine-vent")

  it("is a startup bool-setting named after the resource", function()
    assert.are.equal("bool-setting", setting.type)
    assert.are.equal("startup", setting.setting_type)
    assert.are.equal("depleting-fluids-finite-fluorine-vent", setting.name)
  end)

  it("defaults to on", function()
    assert.is_true(setting.default_value)
  end)

  it("orders every finiteness setting together", function()
    assert.are.equal("c", setting.order)
  end)

  it("points its localised strings at the setting name", function()
    assert.are.same({ "mod-settings-name.depleting-fluids-finite-fluorine-vent" }, setting.localised_name)
    assert.are.same({ "mod-settings-description.depleting-fluids-finite-fluorine-vent" }, setting.localised_description)
  end)
end)

describe("resources.eachResource", function()
  it("visits every resource of each installed supporting MOD", function()
    local seen = {}
    resources.eachResource({ base = "1.0.0", bobores = "2.0.0" }, function(mod, resource)
      seen[#seen + 1] = mod .. "/" .. resource
    end)
    table.sort(seen)
    assert.are.same({ "base/crude-oil", "bobores/bob-ground-water", "bobores/bob-lithia-water" }, seen)
  end)

  it("skips MODs that are not installed", function()
    local called = false
    resources.eachResource({}, function()
      called = true
    end)
    assert.is_false(called)
  end)
end)

describe("resources.fluidFor", function()
  it("returns the mapped fluid", function()
    assert.are.equal("steam", resources.fluidFor("geothermal-vent"))
  end)

  it("returns nil for an unmapped resource", function()
    assert.is_nil(resources.fluidFor("not-a-resource"))
  end)
end)

describe("the resource maps", function()
  it("give every resource in byMod a fluid", function()
    for mod, names in pairs(resources.byMod) do
      for _, resource in ipairs(names) do
        assert(resources.fluidFor(resource) ~= nil, ("%s -> %s has no entry in resources.fluids"):format(mod, resource))
      end
    end
  end)
end)
