-- bootstrap lazy.nvim, LazyVim and your plugins

local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. package.path

-- 2. LazyVim の本体設定
require("config.lazy")

-- 3. カスタマイズ設定
require("config.keymaps")
