local jj = {}

jj.start = function(config)
  vim.print("Hello, " .. config.name)
end

return jj
