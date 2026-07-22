-- OPTIONAL: you said you rarely debug via IDE, so this is here for when you
-- need it, not something you have to configure up front. Delete this file
-- if you don't want the extra plugins installed at all.
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",  
      "rcarriga/nvim-dap-ui",
      "mxsdev/nvim-dap-vscode-js",
      {
        "microsoft/vscode-js-debug",
        version = "1.*",
        build = "npm install --legacy-peer-deps && npx gulp dapDebugServer",
      },
    },
    config = function()
      require("dapui").setup()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node" },
      })

      for _, lang in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: continue" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: step into" })
    end,
  },
}
