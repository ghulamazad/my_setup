-- ftplugin/cpp.lua
-- Runs once per C++ buffer, right when the filetype is detected.

-- 1. Auto-fill a new/empty .cpp file with the CP template.
-- getfsize() is -1 if the file doesn't exist yet and 0 if it exists but is
-- empty (neo-tree pre-creates files on disk), so "<= 0" covers both.
local bufname = vim.api.nvim_buf_get_name(0)
local is_new_or_empty = vim.fn.getfsize(bufname) <= 0
local is_empty_buffer = vim.api.nvim_buf_line_count(0) == 1
  and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ""

if is_new_or_empty and is_empty_buffer then
  local template = vim.fn.stdpath("config") .. "/cp-assets/template.cpp"
  if vim.fn.filereadable(template) == 1 then
    vim.cmd("0read " .. template)
    vim.cmd("normal! Gdd")
    local line = vim.fn.search("void solve()")
    if line > 0 then
      vim.fn.cursor(line, 0)
      vim.cmd("normal! j")
    end
  end
end

-- 2. Floating terminal helper shared by run + stress.
local function open_popup(cmd, title, scale)
  local width = math.floor(vim.o.columns * scale)
  local height = math.floor(vim.o.lines * scale)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
    title = title,
    title_pos = "center",
  })
  vim.fn.termopen(cmd, {
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end)
    end,
  })
  -- Guaranteed manual close, independent of the shell's state.
  vim.keymap.set({ "n", "t" }, "<Esc>", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, nowait = true })
  vim.cmd("startinsert")
end

local PAUSE = "; echo; echo '--- press any key to close ---'; read -n 1"

-- 3. Compile + run against input.txt (relative to nvim's working directory).
local function run_cpp(extra_flags, label)
  vim.cmd("write")
  local file = vim.fn.expand("%")
  local out = "/tmp/a.out"
  local cmd = string.format(
    "g++ -std=c++20 -O2 -Wall -DLOCAL %s %s -o %s && %s < input.txt",
    extra_flags, file, out, out
  ) .. PAUSE
  local title = " CP Run" .. (label and (" [" .. label .. "]") or "") .. " "
  local ok, err = pcall(open_popup, cmd, title, 0.8)
  if not ok then
    vim.notify("CP run failed: " .. tostring(err), vim.log.levels.ERROR)
  end
end

-- 4. Stress test: needs sol.cpp, brute.cpp, gen.cpp in this file's folder.
local function run_stress()
  vim.cmd("write")
  local dir = vim.fn.expand("%:p:h")
  local script = vim.fn.stdpath("config") .. "/cp-assets/stress/stress.sh"
  local ok, err = pcall(open_popup, script .. " " .. dir .. " 500" .. PAUSE, " Stress Test ", 0.85)
  if not ok then
    vim.notify("Stress test failed: " .. tostring(err), vim.log.levels.ERROR)
  end
end

vim.keymap.set("n", "<leader>cr", function() run_cpp("", nil) end,
  { buffer = true, desc = "CP: compile + run" })
vim.keymap.set("n", "<leader>cR", function() run_cpp("-fsanitize=address,undefined -g", "ASan/UBSan") end,
  { buffer = true, desc = "CP: compile + run (ASan/UBSan)" })
vim.keymap.set("n", "<leader>cs", run_stress,
  { buffer = true, desc = "CP: stress test vs brute force" })
