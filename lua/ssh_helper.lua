-- Helper module for SSH detection and titlestring prefix
local M = {}

-- Get SSH prefix for titlestring (executed once on load)
function M.get_ssh_prefix()
  local ssh_connection = os.getenv "SSH_CONNECTION" or os.getenv "SSH_CLIENT"
  if ssh_connection then
    local handle = io.popen "hostname"
    if handle then
      local hostname = handle:read("*a"):gsub("%s+$", "")
      handle:close()
      return "[" .. hostname .. "]"
    end
  end
  return ""
end

-- Cache the SSH prefix on module load
M.ssh_prefix = M.get_ssh_prefix()

return M
