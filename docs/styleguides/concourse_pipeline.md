This documents some of the agreed styles we have to writing [Concourse][]
pipelines. Because these are written in YAML, the [YAML styleguide][] also
applies.

[Concourse]: https://concourse.ci
[YAML styleguide]: YAML

## Tasks

### Naming

Tasks should be given names that are verbs. Inputs and outputs should be given
names that are nouns. Inputs and outputs should not be given names that are the
same as a task name.

For example a task that takes a terraform state file and extracts the outputs
should be named as follows:
```yaml
- task: extract-terraform-outputs
  config:
    # ...
    inputs:
      - name: paas-cf
      - name: foo-tfstate
    outputs:
      - name: terraform-outputs
    run:
      # ...
```

### Ordering of sections

Task config section should be ordered as follows:

* `platform`
* `image` or `image_resource`
* `inputs`
* `outputs`
* `params`
* `run`

This makes it easier to follow the flow of a task and see what it operates on.
