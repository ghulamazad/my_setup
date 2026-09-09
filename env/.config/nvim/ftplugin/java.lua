local jdtls = require("jdtls")

-- Each project gets its own isolated workspace/index directory, keyed
-- by project folder name — prevents Maven projects' indexes from
-- colliding with each other, and makes `rm -rf` cleanup trivial if
-- an index ever gets corrupted.
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Mason installs jdtls here; we resolve the path dynamically so this
-- config doesn't hardcode a version number that'll go stale on update.
local mason_registry = require("mason-registry")
local jdtls_pkg = mason_registry.get_package("jdtls")
local jdtls_path = jdtls_pkg:get_install_path()

-- jdtls needs a platform-specific launcher config directory
local config_dir = jdtls_path .. "/config_linux" -- Omarchy is Arch-based Linux

local capabilities = vim.lsp.protocol.make_client_capabilities()

local mason_registry = require("mason-registry")

-- Collect the debug + test bundle jars Mason installed, so jdtls can
-- load them into its own runtime — this is what upgrades jdtls from
-- "just an LSP" to "LSP + debugger + test runner" in one process.
local bundles = {}

local java_debug_pkg = mason_registry.get_package("java-debug-adapter")
local java_debug_path = java_debug_pkg:get_install_path()
vim.list_extend(bundles, vim.split(
  vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"),
  "\n"
))

local java_test_pkg = mason_registry.get_package("java-test")
local java_test_path = java_test_pkg:get_install_path()
vim.list_extend(bundles, vim.split(
  vim.fn.glob(java_test_path .. "/extension/server/*.jar"),
  "\n"
))

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", config_dir,
    "-data", workspace_dir,
  },

  -- Maven root detection: jdtls looks for pom.xml (or settings.gradle
  -- as a fallback, though you said Maven-only so pom.xml is primary)
  root_dir = require("jdtls.setup").find_root({ "pom.xml", ".git" }),

  capabilities = capabilities,

  settings = {
    java = {
      -- Spring Boot projects benefit heavily from these two:
      configuration = {
        updateBuildConfiguration = "automatic", -- re-syncs pom.xml on change, no manual reload
      },
      -- Import Maven project structure (multi-module Spring Boot
      -- projects are common — parent pom + child modules)
      import = {
        maven = { enabled = true },
        gradle = { enabled = false }, -- you're Maven-only per your earlier answer
      },
      -- Code generation preferences matching common Spring Boot style
      codeGeneration = {
        toString = { template = "${object.className}{${member.name()}=${member.value}}" },
        useBlocks = true,
      },
      -- Inlay hints, same philosophy as Go/Rust: available, off by default
      inlayHints = {
        parameterNames = { enabled = "literals" },
      },
    },
  },

  -- init_options enables extra jdtls capabilities: extracting variables,
  -- generating constructors/getters/setters via code actions, etc.
  init_options = {
    bundles = bundles,
  }, 

  on_attach = function(client, bufnr)
    -- Run the same universal LSP keymaps from Stage 2 automatically —
    -- LspAttach autocmd already covers this, so nothing extra needed here.

    -- jdtls-specific extras beyond generic LSP:
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
    vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
    vim.keymap.set("v", "<leader>jm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], vim.tbl_extend("force", opts, { desc = "Extract method" }))
  end,
}

jdtls.start_or_attach(config)

-- jdtls needs to register itself as a DAP adapter and discover
-- JUnit/main-class configurations — this only works correctly
-- after the LSP client has actually attached, hence the delay via
-- LspAttach rather than doing it immediately at file-open time.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "jdtls" then
      require("jdtls").setup_dap({ hotcodereplace = "auto" })
      require("jdtls.dap").setup_dap_main_class_configs()

      local opts = { buffer = args.buf, silent = true }
      vim.keymap.set("n", "<leader>dj", require("jdtls").test_class, vim.tbl_extend("force", opts, { desc = "Debug: test class" }))
      vim.keymap.set("n", "<leader>dJ", require("jdtls").test_nearest_method, vim.tbl_extend("force", opts, { desc = "Debug: test nearest method" }))
    end
  end,
})