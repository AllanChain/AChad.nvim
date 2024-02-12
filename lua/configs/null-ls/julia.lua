-- This null-ls source provides a formatter for JuliaLang.
-- juliafmt is not provided by any packages, and it's just a simple
-- bash script written by me. For more information, see
-- https://allanchain.github.io/blog/post/julia-nvim/

-- already checked null-ls in init.lua
local h = require "null-ls.helpers"
local methods = require "null-ls.methods"

return {
  method = methods.internal.FORMATTING,
  name = "JuliaFormatter",
  meta = {
    url = "https://github.com/domluna/JuliaFormatter.jl",
    description = "An opinionated code formatter for Julia.",
  },
  filetypes = { "julia" },
  generator = h.formatter_factory {
    command = "juliafmt",
    to_temp_file = true,
    from_temp_file = true,
    args = {
      "$FILENAME",
    },
  },
}
