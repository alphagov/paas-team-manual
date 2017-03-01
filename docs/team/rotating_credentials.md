From time to time, it might be necessary to rotate our platform credentials. We have created helper tasks in the deployer and bootstrap pipelines, credentials tab, to clean passwords that we know are safe to re-set.

## Rotating passwords

Rotating passwords consists of two phases. First, you delete credentials using one of the helper tasks. There's one for CF (in the deployer pipeline), one for BOSH and one for Concourse (in the bootstrap pipeline). These tasks exclude passwords that are difficult or not safe to rotate and clean all other passwords. We do also delete generated ssh keys in these tasks.

Second phase consists of running the main pipeline (on deployer for CF, on bootstrap for BOSH and Concourse) to generate new credentials and apply them. Ensure that there is nothing else triggering this 2nd phase run, as that would mean you would be rotating passwords _and_ trying to apply some changes at the same time, which might not work and you could end up with broken deployment. Pipeline run should complete successfully and all tests should pass. There should be no interruptions to deployed apps.


## Limited functionality during rotation

We have lot of functionality that requires credentials outside of the pipeline. These are mainly our scripts that are orchestrated via Makefile. Most of the tasks (like `bosh-cli` or any ssh tasks) will not work during rotation, as they need credentials (concourse password, ssh keys) that have been deleted and are either not available or not applied yet.

In case you need to run any of these tasks in the middle of the rotation, but before the new credentials have been applied, we suggest that you pause the pipeline first. You can download previous versions of the keys and secret files to recover needed credentials and either use them locally, or re-upload these files as latest version to the bucket. Note that if your pipeline will get into credential applying stage after you unpause, it will apply the latest uploaded credentials. If these are previous version, this means no actual credential rotation will happen and pipeline should finish without needing to apply any changes. If you still want to rotate credentials afterwards, repeat the rotation procedure again.
