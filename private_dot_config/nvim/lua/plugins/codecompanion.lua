-- https://codecompanion.olimorris.dev

require("which-key").add({
  {
    { "<leader>a", mode = { "n", "v" }, group = "🤖 Code Companion" },
    { "<leader>aa", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "🤖 Chat" },
    { "<leader>aA", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "🤖 Actions" },
    {
      "<leader>ad",
      function()
        require("codecompanion").prompt("debug")
      end,
      desc = "Debug Code",
      mode = { "v" },
    },
    {
      "<leader>ar",
      function()
        require("codecompanion").prompt("refactor")
      end,
      desc = "Refactor Code",
      mode = { "v" },
    },
    {
      "<leader>as",
      function()
        require("codecompanion").prompt("summarize")
      end,
      desc = "Summarize Code",
      mode = { "v" },
    },
    {
      "<leader>ao",
      function()
        require("codecompanion").prompt("optimize")
      end,
      desc = "Optimize Code",
      mode = { "v" },
    },
  },
})

return {
  {
    "ravitemer/mcphub.nvim",
    cmd = { "MCPHub" },
    event = "BufReadPost",
    build = "bundled_build.lua",
    opts = {
      use_bundled_binary = true,
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "Davidyz/VectorCode",
    -- version = "*", -- optional, depending on whether you're on nightly or release
    -- build = "pipx upgrade vectorcode", -- using mise pipx/uv instead
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 3, { require("mcphub.extensions.lualine") })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    event = "BufReadPost",

    opts = {
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
        vectorcode = {
          opts = {
            add_tool = true,
          },
        },
      },
      prompt_library = {
        ["Optimize"] = {
          strategy = "chat",
          description = "Optimize for performance",
          opts = {
            short_name = "optimize",
            modes = { "v" },
          },
          prompts = {
            {
              role = "user",
              content = "Please optimize the following code for performance.",
            },
          },
        },
        ["Debug"] = {
          strategy = "chat",
          description = "Identify potential bugs",
          opts = {
            short_name = "debug",
            modes = { "v" },
          },
          prompts = {
            {
              role = "user",
              content = "Please identify potential bugs in the following code.",
            },
          },
        },
        ["Summarize"] = {
          strategy = "chat",
          description = "Summarize code",
          opts = {
            short_name = "summarize",
            modes = { "v" },
          },
          prompts = {
            {
              role = "user",
              content = "Please summarize the following code.",
            },
          },
        },
      ["Refactor"] = {
          strategy = "chat",
          description = "Refactor code for clarity, maintainability, and best practices",
          opts = {
            short_name = "refactor",
            modes = { "v" },
          },
          prompts = {
            {
              role = "user",
              content = [[
Please refactor the following code with the following goals:
- Improve readability, maintainability, and modularity.
- Use idiomatic constructs and best practices for the language.
- Remove duplication and unnecessary complexity.
- Use clear, concise naming for variables, functions, and classes.
- Add comments where they clarify non-obvious logic.
- Do not change the code's external behavior.
After refactoring, provide a brief summary of the main changes you made.
]],
            },
          },
        },
      },
    },
    -- config = function(_, opts)
    --   require("codecompanion").setup(opts)
    -- end,
  },
}
