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
          --{ allow = { type = "array", elements = typedefs.ip_or_cidr, }, },
          --{ deny = { type = "array", elements = typedefs.ip_or_cidr, }, },
          { status = { type = "number", required = false } },
          { message = { type = "string", required = false } },
        },
      },
    },
  },
  --entity_checks = {
  --  { at_least_one_of = { "config.allow", "config.deny" }, },
  --},
}