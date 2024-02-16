---
title: Finding apps with noisy logging
---

# Finding apps with noisy logging

You can use the `cf top` plugin to get a feel for which applications are
logging more than they should be.

>To install cf plugins on M1 based chips, you need to compile the binary manually and install it

[ECSTeam/cloudfoundry-top-plugin](https://github.com/ECSTeam/cloudfoundry-top-plugin)

Install the plugin with `cf install-plugin -r CF-Community "top"`, then (while
logged in as a global admin) run `cf top`.

You should see something like:

```
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│Events: 4,768 (337/sec)             Warm-up: 40s           04-12-2019 09:08:00                      │
│Target: [admin]api.towers.dev.cloudpipeline.digital                                                   │
│Stack: cflinuxfs3    Cells: 2                                                                       │
│   CPU:   4.2% Used,   800% Max,     Mem:   1GB Used,    -- Max,  17GB Rsrvd                        │
│   Apps:   29 Total, Cntrs:  210     Dsk:   4GB Used,    -- Max,  63GB Rsrvd                        │
└────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌─App List───────────────────────────────────────────────────────────────────────────────────────────┐
│APPLICATION                                        SPACE      ORG        DCR RCR  CPU%↓  CRH        │
│nn-nozzle                                          monitoring admin        2   2   2.55    0        │
│paas-billing-collector                             billing    admin        1   1   1.15    0        │
│simulated-load                                     healthche… admin      180 180   0.23    0        │
│(CATS-1-BRKR-58881b81fd9e42f2)                     CATS-1-SP… CATS-1-OR…   1   1   0.12    0        │
│CATS-2-BRKR-e1563843e6357d85                       CATS-2-SP… CATS-2-OR…   1   1   0.03    0        │
│ACC-6-APP-c304bb41ab6eba37                         ACC-6-SPA… ACC-6-ORG…   1   1   0.02    0        │
│healthcheck                                        healthche… admin        2   2   0.02    0        │
│aiven-broker                                       service-b… admin        2   2   0.02    0        │
│SMOKES-1-APP-3a52f50420f47735                      SMOKE-1-S… SMOKE-1-O…   1   1   0.01    0        │
│CATS-3-BRKR-a7fb013d8e659878                       CATS-3-SP… CATS-3-OR…   1   1   0.01    0        │
└────────────────────────────────────────────────────────────────────────────────────────────────────┘
 d:display  o:order  f:filter  q:quit  h:help  UP/DOWN arrow to highlight row
 ENTER to select highlighted row,  LEFT/RIGHT arrow to scroll columns
```

To order apps by the amount of logging they're doing:

* Press `o` to bring up the order settings
* Press `delete` to delete all the current entries
* Use the arrow keys to choose the `LOG_OUT` column
* Press `space` to order by this column
* Press `enter` to dismiss the dialog

Leave the plugin running for a while to gather a representative data sample.

