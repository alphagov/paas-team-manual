# Finding the activity for a given user

In case of suspicion of compromised CF details, we can use Kibana to
obtain some information about the API use.

## Finding user GUID

We have our home made script, to find users in the CF DB.

```
./paas-cf/scripts/find-user.sh -e EMAIL [-o ORG]
```

User as an entity, will have metadata enclosed. This metadata will
contain user's GUID.

### Finding deleted user GUID

There may be a need to find a GUID for already deleted user. There is a
way to do that, but it's a little inconvenient...

If you go to Kibana, you can use the `"DELETE \"/v2/users"` phrase in
your search. This will print out the logs that were taken on user
removal. This does not however, give you an indication of who the user
was.

## Kibana: Finding API usage

We can make the investigation easier for ourselves by considering the
following criteria:

- Filter by user by typing `"for user: {GUID}"` in a search box
- *Optionally:* Scope to job: `api` - From the sidebar on the left,
  select `@source.job` and add `api` by pressing little magnifying glass
  with a plus sign.
- `@message` should consist of:
	- Detailed endpoint - You may filter by adding `"/v2/apps/{APP_GUID}"`, `"GET \"/v2/jobs"`
	- IP address - You may filter by adding `"ip: {IP_ADDRESS}"`
	- vcap_request_id - You may filter by adding `"vcap-request-id:
	  {REQUEST_GUID}"`

You can combine many quoted attributes into one, by joining the quotes
with `&&`, like so:

```
"for user: {GUID}" && "ip: {IP_ADDRESS}" && "GET \"/v2/jobs"
```

It probably won't end here, but it should provide a start for an
individual to go further.

## Getting further

Once you found something interesting above, you could use it to refine
your search to get deeper. For instance, one of the logs above, would have:

- `@source.name` - Defining the VM we'd need to access. For example:
  `api/0`
- `@message` consisting of `vcap-request-id`

If you search for `"{VCAP_REQUEST_ID}"` in Kibana, you should get
more actions performed on an API call.

Each of the results will be different, but it could consist of more
data. For example, with a `PUT` request, you could find a
`cloud_controller_ng.body`, `cloud_controller_ng.method` and
`cloud_controller_ng.message`.

Here's a sample JSON of the above:

```
{
    "timestamp": 1492615195.9275572,
    "message": "droplet created: XXXXX-XXXX-XXXX-XXXXX",
    "log_level": "info",
    "source": "cc.package_stage_action",
    "data": {
        "request_guid": "XXXXX-XXXX-XXXX-XXXXX"
    },
    "thread_id": XXXXXXXXXX,
    "fiber_id": XXXXXXXXXX,
    "process_id": XXXX,
    "file": "/var/vcap/packages/cloud_controller_ng/cloud_controller_ng/app/actions/droplet_create.rb",
    "lineno": 52,
    "method": "create_and_stage"
}
```

It would imply that a new app has been created and staged.

