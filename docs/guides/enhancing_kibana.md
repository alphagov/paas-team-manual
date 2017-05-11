# Enhancing Kibana

We may find the need, to parse some more logs into Kibana for later use at convinient times.

## How it works

The logstash config file is being generated:

1. The [logsearch-4cf packaging](https://github.com/alphagov/paas-logsearch-for-cloudfoundry/blob/master/packages/logsearch-for-cloudfoundry-filters/packaging) runs [the build script](https://github.com/alphagov/paas-logsearch-for-cloudfoundry/blob/master/src/logsearch-config/bin/build) which executes `rake build`.
1. The [logsearch-4cf rake build](https://github.com/alphagov/paas-logsearch-for-cloudfoundry/blob/master/src/logsearch-config/Rakefile) renders the [main template file](https://github.com/alphagov/paas-logsearch-for-cloudfoundry/blob/master/src/logsearch-config/src/logstash-filters/default.conf.erb) and creates `logstash-filters-default.conf`. It follows the [`parsing-rules` order](https://github.com/cloudfoundry-community/logsearch-for-cloudfoundry/blob/develop/docs/logs-parsing.md#parsing-rules) to acomplish it's task.
1. Logsearch functionality `logstash_parser.filters`, takes a list of files that must be present on disk. These contain logstash filters.
1. Standard logsearch-4cf `logstash-filters-default.conf` [is added to logstash_parser.filters](https://github.com/cloudfoundry-community/logsearch-for-cloudfoundry/blob/develop/docs/customization.md#parsing-rules).
1. We add the path of our own `custom-filters` file to `logstash_parser.filters`.
1. With help of [our PR](https://github.com/alphagov/paas-logsearch-for-cloudfoundry/pull/1) we can add content to the `custom-filters` file by filling in property`logstash_parser.custom_filters`
1. The [`logsearch parser_ctl`](https://github.com/logsearch/logsearch-boshrelease/blob/develop/jobs/parser/templates/bin/parser_ctl) gathers all the files, including the ones from `logstash_parser.filters` to create `/var/vcap/jobs/parser/config/logstash.conf` which then is used by Logstash on each run.

## Running Logstash

1. Download `logstash@5.0.0` - you will need Java 8.
1. Install the translate plugin: `logstash-plugin install logstash-filter-translate`
1. Copy `/var/vcap/jobs/parser/config/logstash.conf` locally or use the [minimal config logsearch_logstash.conf](https://gist.github.com/saliceti/1f290c5ac98633e364ab56c549ab7b76)
1. Edit the config file and point to the log input file
1. Run logstash: `logstash -f ../../logstash/logsearch_logstash.conf`
1. You may find [Grok debugger](http://grokdebug.herokuapp.com/) useful
	- [Grok filter plugin documentation](https://www.elastic.co/guide/en/logstash/current/plugins-filters-grok.html)
	- [Regex syntax](https://github.com/kkos/oniguruma/blob/master/doc/RE)
	- [List of patterns](https://github.com/logstash-plugins/logstash-patterns-core/tree/master/patterns)

### Patience

Working with the above, may be a very unappealing process... If you combine it with [](https://www.elastic.co/guide/en/logstash/current/reloading-config.html) you can save a lot of time

1. To restart reading from the beginning of file: `rm data/plugins/inputs/file/.sincedb_*` and restart logstash
1. To start reading the log file from beginning everytime you restart logstash:

	```
	file {
		path => "/Users/colin/Documents/Boulot/gds/logstash/nginx_access.log"
		start_position => "beginning"
		sincedb_path => "/dev/null"
	}
	```

1. If you combine it with https://www.elastic.co/guide/en/logstash/current/reloading-config.html you can save a lot of time

## Working example

Now, let's say we've got a log like:

```
May 11 13:24:09 57n27d4b-60p0-42ly-a00a-f913j7b8841f custom_nginx_access: 10.0.1.217 - - [11/May/2017:13:24:09 +0000] "GET /healthz HTTP/1.1" 200 3 "-" "ELB-HealthChecker/1.0"
```

By adding few extra lines to our logstash configuration file, we can specify, what these actually are:

```
if [@source][component] == "custom_nginx_access" {
  grok {
    match => {
      "@message" =>
      '%{IPORHOST:[nginx][clientip]} - - \[%{HTTPDATE:[nginx][timestamp]}\] "%{WORD:[nginx][verb]} %{URIPATHPARAM:[nginx][request]} HTTP/%{NUMBER:[nginx][httpversion]}" %{NUMBER:[nginx][response]} (?:%{NUMBER:[nginx][bytes]}|-) (?:"(?:%{URI:[nginx][referrer]}|-)"|%{QS:[nginx][referrer]}) %{QS:[nginx][agent]}'
    }
  }
}
```

After a restart and successful entry in Kibana, it will look like that:

| Key | Value |
|---|---|
| nginx.agent | "ELB-HealthChecker/1.0" |
| nginx.bytes | 566 |
| nginx.clientip | 10.0.16.6 |
| nginx.httpversion | 1.1 |
| nginx.request | /info |
| nginx.response | 200 |
| nginx.response_time | 0.029 |
| nginx.timestamp | 11/May/2017:14:59:04 +0000 |
| nginx.vcap_request_id | 9ed66476-764d-486e-b52c-05280929f726 |
| nginx.verb | GET |
| nginx.x_forwarded_for | 10.0.0.116 |
