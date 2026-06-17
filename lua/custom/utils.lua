local M = {}

M.run_build = function(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
        local stderr = result.stderr or ''
        local stdout = result.stdout or ''
        local output = stderr ~= '' and stderr or stdout
        if output == '' then output = 'No output from build command.' end
        vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
end

-- Git helpers

-- cache result of `git rev-parse`
local is_inside_work_tree = {}

M.is_git_repo = function()
    local cwd = vim.fn.getcwd()
    if is_inside_work_tree[cwd] == nil then
        vim.fn.system('git rev-parse --is-inside-work-tree')
        is_inside_work_tree[cwd] = vim.v.shell_error == 0
    end
    return is_inside_work_tree[cwd]
end

M.has_unstaged_changes = function()
    return vim.fn.system('git status -z -- .') ~= ''
end

return M
