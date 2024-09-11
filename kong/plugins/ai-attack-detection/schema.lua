local typedefs = require "kong.db.schema.typedefs"


return {
  name = "ai-attack-detection",
  fields = {
    { protocols = typedefs.protocols { default = { "http", "https", "tcp", "tls", "grpc", "grpcs" } }, },
    { config = {
        type = "record",
        fields = {
          { backend_url = { type = "string", required = true }, },
          { backend_path = { type = "string", required = true }, },
        },
      },
    },
  },
}