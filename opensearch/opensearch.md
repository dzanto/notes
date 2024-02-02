# Opensearch полезные комады

```js
GET _cat/allocation?v
GET _cat/nodes?v
GET _nodes/stats
GET _cat/indices?v
GET _nodes/_all?pretty=true
GET _cat/shards?v
GET _cat/indices?v&health=yellow
GET _cluster/allocation/explain
GET _cluster/health

GET _cat/nodes?v&h=name,version,node.role,master

GET /_nodes/cluster_manager:true/process,transport

GET _plugins/_ism/explain/app-dev-2023_02_22?show_policy=true

GET audit-app-dev/_search
{
   "query": {
       "match": {
          "app_name": "my-app"
       }
   }
}

GET app-stage-2023_02_14/_seq_no/538225
GET app-stage-2023_02_14/_mget
GET app-dev-2023_02_17

GET app-load-2023_02_09/_settings
GET /audit-app-dev/_doc/4e45d338-d9c7-4138-9aae-fe126aa0031b

GET /audit-app-dev/_doc/2e915a96-28b0-4dba-8e34-eba67de056e8

PUT _cluster/settings
{
 "persistent": {
    "cluster.routing.allocation.enable": "all"
  }
}

PUT _cluster/settings
{
  "persistent": {
    "cluster.routing.allocation.enable": "primaries"
  }
}

GET _cluster/settings

PUT _cluster/settings
{
  "transient" :{
      "cluster.routing.allocation.exclude._ip" : null
  }
}

POST /_cluster/voting_config_exclusions?node_names=elastic3
DELETE _cluster/voting_config_exclusions

DELETE /_cluster/voting_config_exclusions?wait_for_removal=false

GET /_cluster/settings

GET _template

PUT _cluster/settings
{
  "persistent" :{
     "cluster.routing.allocation.same_shard.host" : "false"
   }
}

PUT _cluster/settings
{
  "transient" :{
     "cluster.routing.allocation.node_concurrent_recoveries" : "5"
   }
}

GET _plugins/_security/api/nodesdn
GET _plugins/_security/api/securityconfig

GET /_cluster/state?filter_path=metadata.cluster_coordination.last_committed_config

GET _plugins/_security/api/nodesdn
GET _plugins/_security/api/ssl/certs
DELETE _plugins/_security/api/cache
GET _opendistro/_security/api/securityconfig
GET _plugins/_security/api/internalusers
```
