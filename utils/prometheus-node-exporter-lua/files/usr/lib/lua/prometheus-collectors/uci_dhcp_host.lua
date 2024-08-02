local uci = require("uci")

local function scrape()
  local curs = uci.cursor()
  local metric_uci_host = metric("uci_dhcp_host", "gauge")

  curs:foreach("dhcp", "host", function(s)
    if s[".type"] == "host" then
      local mac = s["mac"]
      if type(mac) == "table" then
        mac = string.upper(mac[1])  -- Take the first element if it's a table
      end
      if type(mac) == "string" then
        mac = string.upper(mac)
      end
      local labels = {name = s["name"], mac = mac, dns = s["dns"], ip = s["ip"]}
      metric_uci_host(labels, 1)
    end
  end)
end
