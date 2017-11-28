## Releasing BOSH blobs

This is a guide to upload new BOSH blobs to our common blob store.

Our blobs are stored in the **gds-paas-build-releases-blobs** S3 bucket which belongs to the CI AWS account.

You can read about adding and uploading blobs [here](https://bosh.io/docs/release-blobs.html).

## Requirements

 * You'll need access to the CI AWS account (write access to the blob store S3 bucket)
 * BOSH cli

## Steps

In this example we're going to upload Go 1.9 to the blob store.

You have to run the following commands from a BOSH release.

**1.** First download the blob:

```
curl -L https://redirector.gvt1.com/edgedl/go/go1.9.linux-amd64.tar.gz -O
```

**2.** Add the new blob to the BOSH release

```
bosh add blob [PATH TO]/go1.9.linux-amd64.tar.gz golang/go1.9.linux-amd64.tar.gz
```

**3.** As we are using environment variables for AWS access you have to create the file **config/private.yml** with the following content:

```
blobstore:
  s3:
    access_key_id: ''
    secret_access_key: ''
```

**4.** Check if adding the blob was successful:

```
bosh blobs
```

It should list the added blob as new.

**5.** Upload the new blob to the blobstore

```
bosh upload blobs
```

**6.** The **config/blobs.yml** should be updated now and you can commit the new or updated blob definiton.

```
golang/go1.9.linux-amd64.tar.gz:
  object_id: e414cd61-f037-4d47-a671-c7909b39182c
  sha: 6a00c39435edc1e102f1fb75cc1137fba4c9e4e2
  size: 102601309
```
