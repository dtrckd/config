-- Async HTTP client for the completion API (curl via vim.system).
local config = require("ai-completion.config")

local M = {}

-- Handle of the in-flight request, so a new trigger can supersede/kill it.
local inflight = nil

-- Cancel any request currently running.
function M.cancel()
    if inflight then
        pcall(function() inflight:kill(15) end)
        inflight = nil
    end
end

-- complete(payload, on_result): POST payload, call on_result(text_or_nil).
-- Silent (nil) on empty choices; WARN on curl/HTTP failure.
function M.complete(payload, on_result)
    M.cancel()

    local body = vim.json.encode(payload)
    local cmd = {
        "curl", "-sS", "-w", "\n%{http_code}",
        "-X", "POST", config.url,
        "-H", "accept: application/json",
        "-H", "content-type: application/json",
        "-H", "Authorization: Bearer " .. (config.token or ""),
        "-d", body,
    }

    inflight = vim.system(cmd, { text = true, timeout = config.timeout_ms }, function(obj)
        inflight = nil
        vim.schedule(function()
            if obj.code ~= 0 then
                vim.notify(
                    "ai-completion: curl failed (" .. tostring(obj.code) .. "): " .. (obj.stderr or ""),
                    vim.log.levels.WARN
                )
                return on_result(nil)
            end

            -- Last line is the HTTP status code; the rest is the JSON body.
            local out = obj.stdout or ""
            local http = out:match("(%d+)%s*$") or "000"
            local json = out:gsub("%s*%d+%s*$", "")

            if tonumber(http) and tonumber(http) >= 300 then
                vim.notify("ai-completion: HTTP " .. http .. ": " .. json, vim.log.levels.WARN)
                return on_result(nil)
            end

            local ok, result = pcall(vim.json.decode, json)
            if not ok or type(result) ~= "table" then
                vim.notify("ai-completion: bad JSON response", vim.log.levels.WARN)
                return on_result(nil)
            end

            local choice = result.choices and result.choices[1]
            local text = choice and choice.text
            if type(text) ~= "string" or text == "" then
                return on_result(nil) -- empty result: silent, no ghost
            end

            on_result(text)
        end)
    end)
end

return M
