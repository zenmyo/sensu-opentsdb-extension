# sensu-opentsdb-extension
Sensu handler for OpenTSDB

# Usage

put `opentsdb.rb` to `/etc/sensu/extensions/` and configure `/etc/sensu/conf.d/opentsdb.json` like below

```
{
  "opentsdb": {
    "server": "localhost",
    "port": 4242
  }
}
```
