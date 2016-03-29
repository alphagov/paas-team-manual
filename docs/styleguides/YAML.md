We produce lots of YAML. This sets out some guidelines for how this should be
formatted.

In general, follow the same formatting style as examples in the [YAML spec]().

[YAML spec]: http://yaml.org/spec/1.2/spec.html

# Indentation

## Lists

Lists should be indented 2 spaces beyond the parent key. eg:

```
foo:
  - one
  - two
  - three
```

It's worth noting that the YAML spec differs from the style that concourse
generated when returning pipelines. We've therefore had to pick one, and have
chosen to stick with the YAML spec. This is also the indentation pattern that
seems to be more commonly implemented by editors.
