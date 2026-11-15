-- Light sweep animation over the snacks dashboard header
local M = {}

local ns = vim.api.nvim_create_namespace "dashboard_sweep"

local FRAME_MS = 33 -- ~30 fps
local PASS_MS = 2000 -- duration of one sweep
local PAUSE_MS = 3000 -- pause between sweeps
local SLANT = 1 -- columns shifted per row (diagonal band)

-- band from left edge to right edge, brightest at the center
local BAND = { "DashboardSweepEdge", "DashboardSweepGlow", "DashboardSweepCenter", "DashboardSweepGlow", "DashboardSweepEdge" }

local timer

-- header rows are the ones with block characters
local function header_rows(buf)
  local rows = {}
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if line:find("█", 1, true) then
      rows[#rows + 1] = { row = i - 1, line = line, width = vim.fn.strchars(line) }
    end
  end
  return rows
end

local function stop()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

local function start(buf)
  stop()
  timer = vim.uv.new_timer()

  local frames = math.floor(PASS_MS / FRAME_MS)
  local pause_frames = math.floor(PAUSE_MS / FRAME_MS)
  local frame = 0

  timer:start(
    0,
    FRAME_MS,
    vim.schedule_wrap(function()
      if not vim.api.nvim_buf_is_valid(buf) or vim.fn.bufwinid(buf) == -1 then
        stop()
        return
      end

      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
      frame = (frame + 1) % (frames + pause_frames)
      if frame >= frames then
        return
      end

      -- re-read rows every frame: the dashboard re-renders on resize
      local rows = header_rows(buf)
      if #rows == 0 then
        return
      end

      local width = 0
      for _, r in ipairs(rows) do
        width = math.max(width, r.width)
      end

      -- band travels from fully left of the text to fully right of it
      local travel = width + #rows * SLANT + #BAND * 2
      local head = math.floor(frame / frames * travel) - #BAND

      for i, r in ipairs(rows) do
        local start_col = head - (i - 1) * SLANT
        for j, hl in ipairs(BAND) do
          local col = start_col + j - 1
          if col >= 0 and col < r.width then
            local b0 = vim.fn.byteidx(r.line, col)
            local b1 = vim.fn.byteidx(r.line, col + 1)
            vim.api.nvim_buf_set_extmark(buf, ns, r.row, b0, { end_col = b1, hl_group = hl, priority = 5000 }) -- above dashboard's default 4096
          end
        end
      end
    end)
  )
end

M.setup = function()
  local group = vim.api.nvim_create_augroup("DashboardSweep", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "SnacksDashboardOpened",
    callback = function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "snacks_dashboard" then
          start(buf)
          return
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd("User", { group = group, pattern = "SnacksDashboardClosed", callback = stop })
end

return M
