local path = "/Users/dharp/Library/Caches/pypoetry/virtualenvs/basinscout-HIIc3Wgo-py3.11/bin/python"
require("dap-python").setup(path)

local map = vim.keymap.set

map("n", "<leader>dpr", function()
  require("dap-python").test_method()
end, { desc = "Run DAP Python test method" })
