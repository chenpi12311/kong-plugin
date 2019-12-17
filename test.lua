local helpers = require "spec.helpers"

for _, strategy in helpers.each_strategy() do 
  describe("http-to-json", function()

    local bp = helpers.get_db_utils(strategy)

    setup(function ()
      local service = bp.services:insert {
        name = "test-service",
        host = "loan-backend-fine.iwosai.com"
      }

      bp.routes:insert({
        hosts = { "test.com" },
        service = { id = service.id }
      })

      assert(helpers.start_kong({ plugins = "bundled, http-to-jsonrpc" }))

      admin_client = helpers.admin_client()
    end)

    teardown(function ()
      if admin_client then
        admin_client:close()
      end

      helpers.stop_kong()
    end)

    before_each(function()
      proxy_client = helpers.proxy_client()
    end)

    after_each(function ()
      if proxy_client then
        proxy_client:close()
      end
    end)

    describe("thing", function ()
      it("should do thing", function ()
        local res = proxy_client:post("/rpc/lakala/addWhitelist", {
          ["Host"] = "test.com"
        })
      end)
    end)

  end)
end
