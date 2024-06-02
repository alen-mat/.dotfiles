-- Don't do comment stuffs when I use o/O
vim.opt_local.formatoptions:remove "o"

vim.keymap.set("n", "<F5>", function()
  if require("dap").session() then
    require("dap").continue()
--  else
  end
end)

vim.keymap.set('n',"<leader><F5>", ":!zellij run -f -- cargo run <CR>", { desc ='Cargo test'})

vim.keymap.set('n','<F5>',  ":!zellij run -f -- cargo test<CR>", { desc = 'Cargo test' })
