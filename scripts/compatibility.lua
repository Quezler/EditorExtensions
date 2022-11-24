local compatibility = {}

local constants = require("__EditorExtensions__/scripts/constants")
local infinity_loader = require("__EditorExtensions__/scripts/entity/infinity-loader")

function compatibility.add_cursor_enhancements_overrides()
  if
    remote.interfaces["CursorEnhancements"]
    and remote.call("CursorEnhancements", "version") == constants.cursor_enhancements_interface_version
  then
    remote.call("CursorEnhancements", "add_overrides", constants.cursor_enhancements_overrides)
  end
end

function compatibility.check_for_space_exploration()
  return script.active_mods["space-exploration"] and true or false
end

function compatibility.in_se_satellite_view(player)
  return compatibility.check_for_space_exploration() and player.controller_type == defines.controllers.god
end

--- @param player LuaPlayer
function compatibility.in_qis_window(player)
  local opened = player.opened
  if opened and player.opened_gui_type == defines.gui_type.custom and string.find(opened.name, "^qis") then
    return true
  end
  return false
end

function compatibility.register_picker_dollies()
  if remote.interfaces["PickerDollies"] then
    script.on_event(remote.call("PickerDollies", "dolly_moved_entity_id"), infinity_loader.picker_dollies_move)
  end
end

return compatibility
