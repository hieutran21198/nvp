local plugin_manager = require "plugins"

NVP = {
  plugins = plugin_manager.plugins,
  set_plugs = plugin_manager.set
}

require "settings"
