local handler = require("__core__/lualib/event_handler")

handler.add_lib(require("__flib__/gui-lite"))

handler.add_lib(require("__EditorExtensions__/scripts/migrations"))

handler.add_lib(require("__EditorExtensions__/scripts/aggregate-chest"))
handler.add_lib(require("__EditorExtensions__/scripts/cheat-mode"))
handler.add_lib(require("__EditorExtensions__/scripts/debug-world"))
handler.add_lib(require("__EditorExtensions__/scripts/editor"))
handler.add_lib(require("__EditorExtensions__/scripts/infinity-accumulator"))
handler.add_lib(require("__EditorExtensions__/scripts/infinity-loader"))
handler.add_lib(require("__EditorExtensions__/scripts/infinity-pipe"))
handler.add_lib(require("__EditorExtensions__/scripts/infinity-wagon"))
handler.add_lib(require("__EditorExtensions__/scripts/inventory-filters"))
handler.add_lib(require("__EditorExtensions__/scripts/inventory-sync"))
handler.add_lib(require("__EditorExtensions__/scripts/linked-belt"))
handler.add_lib(require("__EditorExtensions__/scripts/super-inserter"))
handler.add_lib(require("__EditorExtensions__/scripts/super-pump"))
handler.add_lib(require("__EditorExtensions__/scripts/testing-lab"))

handler.add_lib(require("__EditorExtensions__/scripts/update-notification"))
