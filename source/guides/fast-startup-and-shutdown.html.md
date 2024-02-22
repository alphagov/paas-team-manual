---
title: Fast Startup and Shutdown Script and Concourse Pipelines
---

# Fast Startup and Shutdown Script and Concourse Pipelines

The idea of this set of processes is to save on unnecessary AWS infrastructure expendature in dev environments, and to provide an automated way to implement a scheduled shutdown of each environment, and to provide a manual mechanism to start dev environments back up, or shut them down before the configured schedule. The [script](https://github.com/alphagov/paas-cf/blob/main/concourse/scripts/fast-startup-and-shutdown-cf-env.sh) that is utimately run, toggles the BOSH resurrector in order to prevent it from interfering with the state changes, and powers up/down the relevant EC2 and RDS instances for the environment. The script does not affect the BOSH or Concourse instances to maintain the ability to quickly startup and shutdown each env. The cost saving is based around the fact that the majority of the cost is incurred by instances being online. Even a powered-down environment does incur some cost due to the block storage being maintained, and the BOSH and Concourse instances that are not affected.

Each dev environment has a fast-startup-cf-env and fast-shutdown-cf-env deployed into concourse by default, enabled or disabled by setting the environment variable ENABLE_FAST_STARTUP_AND_SHUTDOWN_CF_ENV to either true or false. These pipelines configure the shutdown process to run each day at 19:00, and allow for both the startup and shutdown processes to be run manually.

## fast-startup-and-shutdown-cf-env group
![fast-startup-and-shutdown-cf-env group](/screenshots/fast-start-and-shutdown-1.png)

## fast-startup-cf-env
![fast-startup-cf-env](/screenshots/fast-start-and-shutdown-2.png)

## kick-off startup pipeline
![kick-off startup pipeline](/screenshots/fast-start-and-shutdown-3.png)

## fast-startup-cf-env is triggered
![fast-startup-cf-env is triggered](/screenshots/fast-start-and-shutdown-4.png)

## script run starts
![script run starts](/screenshots/fast-start-and-shutdown-5.png)

## script run completes
![script run completes](/screenshots/fast-start-and-shutdown-6.png)
