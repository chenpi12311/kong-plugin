local typedefs = require "kong.db.schema.typedefs"

return {
  name = "http-to-jsonrpc",
  fields = {
    { run_on = typedefs.run_on_first },
    { config = {
        type = "record",
        fields = {
          { to_jsonrpc = { type = "boolean", default = false }, },
        },
      },
    },
  },

}
