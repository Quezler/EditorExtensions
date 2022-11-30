local sounds = require("__base__/prototypes/entity/sounds")

local constants = require("__EditorExtensions__/prototypes/constants")
local util = require("__EditorExtensions__/prototypes/util")

-- set aggregate chest inventory size
local to_check = {
  "ammo",
  "armor",
  "blueprint",
  "blueprint-book",
  "capsule",
  "copy-paste-tool",
  "deconstruction-item",
  "gun",
  "item",
  "item-with-entity-data",
  "item-with-inventory",
  "item-with-label",
  "item-with-tags",
  "module",
  "rail-planner",
  "repair-tool",
  "selection-tool",
  "spidertron-remote",
  "tool",
  "upgrade-item",
}
-- start with four extra slots to account for inserter interactions
local slot_count = 4
for _, category in pairs(to_check) do
  slot_count = slot_count + table_size(data.raw[category])
end
-- apply to aggregate chests
for _, container in pairs(data.raw["infinity-container"]) do
  if string.find(container.name, "aggregate") then
    -- set aggregate chest inventory size to the number of item prototypes
    container.inventory_size = slot_count
  end
end

-- allow all science packs to be placed in the super lab
local packs_build = {}
for _, lab in pairs(data.raw["lab"]) do
  for _, input in pairs(lab.inputs) do
    packs_build[input] = true
  end
end
local packs = {}
for pack in pairs(packs_build) do
  table.insert(packs, pack)
end
data.raw["lab"]["ee-super-lab"].inputs = packs

-- allow equipment to be placed in all existing grid categories
local categories = {}
for _, category in pairs(data.raw["equipment-category"]) do
  table.insert(categories, category.name)
end
data.raw["generator-equipment"]["ee-infinity-fusion-reactor-equipment"].categories = categories
data.raw["roboport-equipment"]["ee-super-personal-roboport-equipment"].categories = categories
data.raw["movement-bonus-equipment"]["ee-super-exoskeleton-equipment"].categories = categories
data.raw["energy-shield-equipment"]["ee-super-energy-shield-equipment"].categories = categories
data.raw["night-vision-equipment"]["ee-super-night-vision-equipment"].categories = categories

-- reset all modules to be able to be used in all recipes
local modules = {
  "ee-super-speed-module",
  "ee-super-effectivity-module",
  "ee-super-productivity-module",
  "ee-super-clean-module",
  "ee-super-slow-module",
  "ee-super-ineffectivity-module",
  "ee-super-dirty-module",
}
for _, name in pairs(modules) do
  data.raw["module"][name].limitation = nil
end

-- allow all character prototypes to craft testing tools
for _, character in pairs(data.raw["character"]) do
  character.crafting_categories = character.crafting_categories or {}
  character.crafting_categories[#character.crafting_categories + 1] = "ee-testing-tool"
end

-- generate linked belts and infinity loaders

local linked_belt_base = table.deepcopy(data.raw["linked-belt"]["linked-belt"])
linked_belt_base.icons = util.extract_icon_info(linked_belt_base)
linked_belt_base.localised_name = { "entity-name.ee-linked-belt" }
linked_belt_base.localised_description = { "entity-description.ee-linked-belt" }
linked_belt_base.placeable_by = { item = "ee-linked-belt", count = 1 }
linked_belt_base.minable = { result = "ee-linked-belt", mining_time = 0.1 }
linked_belt_base.fast_replaceable_group = "transport-belt"
table.insert(linked_belt_base.flags, "not-upgradable")
util.recursive_tint(linked_belt_base, constants.linked_belt_tint)

local function create_linked_belt(base_prototype, suffix)
  local entity = table.deepcopy(linked_belt_base)
  entity.name = "ee-linked-belt" .. suffix

  entity.speed = base_prototype.speed

  -- Account for both variants
  entity.belt_animation_set = base_prototype.belt_animation_set
  entity.belt_horizontal = base_prototype.belt_horizontal
  entity.belt_vertical = base_prototype.belt_vertical
  entity.ending_bottom = base_prototype.ending_bottom
  entity.ending_patch = base_prototype.ending_patch
  entity.ending_side = base_prototype.ending_side
  entity.ending_top = base_prototype.ending_top
  entity.ends_with_stopper = base_prototype.ends_with_stopper
  entity.starting_bottom = base_prototype.starting_bottom
  entity.starting_side = base_prototype.starting_side
  entity.starting_top = base_prototype.starting_top

  data:extend({ entity })
end

local loader_base = {
  type = "loader-1x1",
  localised_name = { "entity-name.ee-infinity-loader" },
  localised_description = { "entity-name.ee-infinity-loader" },
  icons = table.deepcopy(linked_belt_base.icons),
  flags = { "player-creation" },
  minable = { mining_time = 0.1, result = "ee-infinity-loader" },
  placeable_by = { item = "ee-infinity-loader", count = 1 },
  collision_box = { { -0.3, -0.3 }, { 0.3, 0.3 } },
  selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
  animation_speed_coefficient = 32,
  structure = table.deepcopy(linked_belt_base.structure),
  fast_replaceable_group = "transport-belt",
  open_sound = sounds.machine_open,
  close_sound = sounds.machine_close,
  container_distance = 0,
  filter_count = 1,
}
loader_base.structure.direction_in_side_loading = nil
loader_base.structure.direction_out_side_loading = nil
util.recursive_tint(loader_base)

local function create_loader(base_prototype, suffix)
  local entity = table.deepcopy(loader_base)
  entity.name = "ee-infinity-loader" .. suffix
  entity.speed = base_prototype.speed
  -- Preferred
  entity.belt_animation_set = base_prototype.belt_animation_set
  -- Legacy
  entity.belt_horizontal = base_prototype.belt_horizontal
  entity.belt_vertical = base_prototype.belt_vertical
  entity.ending_bottom = base_prototype.ending_bottom
  entity.ending_patch = base_prototype.ending_patch
  entity.ending_side = base_prototype.ending_side
  entity.ending_top = base_prototype.ending_top
  entity.ends_with_stopper = base_prototype.ends_with_stopper
  entity.starting_bottom = base_prototype.starting_bottom
  entity.starting_side = base_prototype.starting_side
  entity.starting_top = base_prototype.starting_top

  data:extend({ entity })
end

local fastest_suffix = ""
local fastest_speed = 0

for name, prototype in pairs(table.deepcopy(data.raw["underground-belt"])) do
  -- determine suffix
  local suffix = name
  for pattern, replacement in pairs(constants.belt_name_patterns) do
    suffix = string.gsub(suffix, pattern, replacement)
  end
  if suffix ~= "" then
    suffix = "-" .. suffix
  end

  create_linked_belt(prototype, suffix)
  create_loader(prototype, suffix)

  if prototype.speed > fastest_speed then
    fastest_speed = prototype.speed
    fastest_suffix = suffix
  end
end

data.raw["item"]["ee-infinity-loader"].place_result = "ee-infinity-loader" .. fastest_suffix
data.raw["item"]["ee-linked-belt"].place_result = "ee-linked-belt" .. fastest_suffix

-- Internal chest for infinity loader
data:extend({
  {
    type = "infinity-container",
    name = "ee-infinity-loader-chest",
    erase_contents_when_mined = true,
    inventory_size = 10, -- Five for output, five for input
    flags = { "hide-alt-info", "player-creation" },
    selectable_in_game = false,
    picture = constants.empty_sheet,
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
  },
})
