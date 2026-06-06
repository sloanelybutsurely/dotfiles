local M = {}
local H = {}

M.setup = function(config)
  config = H.setup_config(config)

  H.apply_config(config)
end

M.start = function()
  require('jj').start(M.config)
end

H.setup_config = function(config)
  config = vim.tbl_extend('force', vim.deepcopy(H.default_config), config or {})

  return config
end

H.apply_config = function(config)
end

return M
