---
title: How to resolve Kibana indexing errors
---

# How to resolve Kibana indexing errors

Following a recent cf-deployment upgrade, we were unable to query our Logit.io
Kibana interfaces with error messages like `X of Y shards failed` or `Failed to parse mapping`.

Investigation of the Diagnostic logs, found under `View Stack Settings`
on the Logit.io dashboard showed more errors of the form:

```
2021-11-15T18:01:48.236Z WARN logstash.outputs.opensearch Could not index event to Opensearch. {:status=>400, :action=>["index", {:_id=>nil, :_index=>"logstash-2021.11.15", :_type=>"logs", :_routing=>nil}, 2021-11-15T18:01:48.020Z %{host} %{message}], :response=>{"index"=>{"_index"=>"logstash-2021.11.15", "_type"=>"logs", "_id"=>"AX0kwyM1BzIxpry78wO2", "status"=>400, "error"=>{"type"=>"mapper_parsing_exception", "reason"=>"failed to parse [cloud_controller_ng.data.error]", "caused_by"=>{"type"=>"illegal_state_exception", "reason"=>"Can't get text on a START_OBJECT at 1:2169"}}}}}
```

This is resolved by refreshing the logstash-\* field list via the Kibana UI
under:

`Management > Index Patterns > Refresh field list` (Refresh icon on the top
right).
