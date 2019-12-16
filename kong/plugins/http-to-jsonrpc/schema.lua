local typedefs = require "kong.db.schema.typedefs"

return {
  name = "http-to-jsonrpc",
  fields = {
    { consumer = typedefs.no_consumer },
    { run_on = typedefs.run_on_first },
    { config = {
        type = "record",
        fields = {
          {
            to_jsonrpc = { type = "boolean", defalt = false }
          },
        },
      },
    },
  },
}
