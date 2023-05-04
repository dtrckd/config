vim.g["codegpt_commands"] = {
  ["chat"] = {
    -- Default
    model = "gpt-3.5-turbo",
    max_tokens = 4096,
    temperature = 0.6,
    number_of_choices = 1,
    system_message_template = "",
    user_message_template = "",
    callback_type = "replace_lines",
  },
  ['completion'] = {
    model = "code-davinci-002",
    temperature = 0.3,
  },
  ["code_edit"] = {
    model = "code-davinci-002",
    temperature = 0.3,
  },
  ["explain"] = {
  },
  ["quetion"] = {
  },
  ["debug"] = {
  },
  ["opt"] = {
    model = "code-davinci-002",
    temperature = 0.3,
  },
  ["tests"] = {
    model = "code-davinci-002",
    temperature = 0.3,
  },
  -- Custom command
  ["modernize"] = {
    -- Overrides the system message template
    system_message_template = "You are {{language}} developer.",
    user_message_template =
    "I have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nModernize the above code. Use current best practices. Only return the code snippet and comments. {{language_instructions}}",
    language_instructions = {
      cpp = "Use modern C++ syntax. Use auto where possible. Do not import std. Use trailing return type. Use the c++11, c++14, c++17, and c++20 standards where applicable.",
    },
  }
}
