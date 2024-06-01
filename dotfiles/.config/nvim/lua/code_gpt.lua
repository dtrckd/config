require("codegpt.config")

-- Override the default chat completions url, this is useful to override when testing custom commands
vim.g["codegpt_openai_api_key"] = os.getenv("MISTRAL_API_KEY")
vim.g["codegpt_chat_completions_url"] = "https://api.mistral.ai/v1/chat/completions"

vim.g["codegpt_global_commands_defaults"] = {
    model = "codestral-latest",
    max_tokens = 4096,
    temperature = 0.4,
    -- extra_parms = { -- optional list of extra parameters to send to the API
    --     presence_penalty = 1,
    --     frequency_penalty= 1
    -- }
}
