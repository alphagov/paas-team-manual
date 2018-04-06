# Cloud Foundry debugging

This is a set of useful things that may help you debug CloudFoundry problems.

## Finding which cell an app instance is running on

First, get the GUID of the app you want to investigate:
```
$ cf app APPNAME --guid
c6d1259c-8057-489e-9ac2-beaa896c2bf3
```

Then use `cf curl` and `jq` to extract the information from the stats endpoint:
```
$ cf curl /v2/apps/c6d1259c-8057-489e-9ac2-beaa896c2bf3/stats | jq 'with_entries(.value = .value.stats.host)'
{
  "0": "10.0.33.4",
  "1": "10.0.34.4"
}
```

You can use `bosh vms` to correlate the IPs to BOSH job indexes or VM UUIDs.

## Downloading an app container
If there are problems running an app then ````cf files```` will not function as the container must be running. An alternative is to grab the droplet image directly from CloudFoundry and unpack it locally. This can also be useful when you need to obtain a copy of a deployed app if you don't have the source.

First, get the GUID of the app you want to investigate:
````
$ cf app APPNAME --guid
5ffab66f-0be2-4a65-b9ff-40a902a05b50
````

Then use the ````cf curl```` wrapper to make an API call that retrieves the droplet and unpack it:
````
$ mkdir droplet && cd droplet
$ cf curl /v2/apps/5ffab66f-0be2-4a65-b9ff-40a902a05b50/droplet/download > image.tar.gz
$ tar -zxf image.tar.gz
````

**Note:** Tar will exit complaining about invalid gzip blocks - this is because the droplet has other data (such as a signature) appended to the end of the image. This isn't a problem, all the files for the image will be unpacked anyway.

You should now have everything used to run the app and all the build logs. ````app```` contains everything the user ````cf push````-ed plus any change from the staging phase (for example, compiled binaries):
````
$ ls -lah
total 41M
drwxr-xr-x  5 ubuntu ubuntu 4.0K Dec  9 11:55 .
drwxr-xr-x 23 ubuntu ubuntu 4.0K Dec  8 19:43 ..
drwxr--r-- 10 ubuntu ubuntu 4.0K Dec  8 16:04 app
-rw-rw-r--  1 ubuntu ubuntu  41M Dec  8 13:41 image.tar.gz
drwxr-xr-x  2 ubuntu ubuntu 4.0K Dec  8 13:53 logs
-rw-r--r--  1 ubuntu ubuntu  298 Dec  8 13:27 staging_info.yml
drwxr-xr-x  2 ubuntu ubuntu 4.0K Dec  8 13:27 tmp
````
