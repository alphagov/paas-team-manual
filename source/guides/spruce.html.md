# Spruce

This is a guide to [spruce](https://github.com/geofffranks/spruce), our tool to merge YAML manifests. It contains very simple examples to explain each feature.

For more information, see the spruce readme and [examples](https://github.com/geofffranks/spruce/tree/master/examples).

## Installation

You need to install spruce >= 0.13.0. This version added support for operand expressions.

```
$ go get github.com/geofffranks/spruce/cmd/spruce # Builds spruce, including dependencies and puts it in $GOPATH/bin
```

To upgrade spruce:

```
$ go get -u github.com/geofffranks/spruce/cmd/spruce
```

Note: If you previously built spruce from a branch, following instructions in a
previous version of this guide, you may need to find and remove old
copies of the `spruce` binary that were copied into your $PATH:

```
$ spruce -v     # if version 0.12.0 is reported, you probably built from the branch
$ which spruce  # shows files you may need to remove
```

## Default merge with simple keys

```
$ cat a.yml
a: aaaa
a2: aaaa
$ cat b.yml
a: bbbb
b: bbbb
$ spruce merge a.yml b.yml
a: bbbb
a2: aaaa
b: bbbb
$ spruce merge b.yml a.yml
a: aaaa
a2: aaaa
b: bbbb

```

* Files to merge are listed in-order on the command line. The first file serves as the base to the file structure, and subsequent files are merged on top, adding when keys are new, replacing when keys exist
* A key in the subsequent file overrides the key at the same place. No need for `(( merge ))` for simple values

## Default merge with maps

```
$ cat a.yml
key:
  subkey1: aa1
  subkey2: aa2
  subkey3: aa3
$ cat b.yml
key:
  subkey1: bb1
  subkey2: bb2
  subkey4: bb4
$ spruce merge a.yml b.yml
key:
  subkey1: bb1
  subkey2: bb2
  subkey3: aa3
  subkey4: bb4
```

* Same keys are updated
* Additional keys are added
* Keys not present in other files are kept

## Reference other data

```
$ cat a.yml
key:
  subkey1: aa1
  subkey2: aa2
a: (( grab key.subkey1 ))
$ cat b.yml
key:
  subkey1: bb1
  subkey2: bb2
$ spruce merge a.yml b.yml
a: bb1
key:
  subkey1: bb1
  subkey2: bb2
```

* `grab` allows to merge with the value of another key
* The merge happens first: here `key.subkey1` changes from `aa` to `bb1`. Then the `grab` happens: `a:` takes the new `key.subkey1` value `bb1`

```
$ cat a.yml
key:
  subkey1: aa1
  subkey2: aa2
a: (( grab key.subkey1 key.subkey2 key ))
$ cat b.yml
key:
  subkey1: bb1
  subkey2: bb2
$ spruce merge a.yml b.yml
a:
- bb1
- bb2
- subkey1: bb1
  subkey2: bb2
key:
  subkey1: bb1
  subkey2: bb2
```

* When given several values, `grab` will create an array
* Values can be simple keys or more complex like maps
* Can be separated with commas or spaces

## Pruning

```
$ cat a.yml
key:
  subkey1: aa
  subkey2: aa
a:
- name: a1
  a11: a11
  a12: a12
- name: a2
  a11: a21
  a12: a22
$ cat b.yml
key:
  subkey1: bb
  subkey2: bb
a:
- name: a1
  a11: b11
$ spruce merge --prune a.a1.a11 --prune key.subkey1 a.yml b.yml
a:
- a12: a12
  name: a1
- a11: a21
  a12: a22
  name: a2
key:
  subkey2: bb
```

* Prunes keys based on the path
* To reference a key in an array of maps, use `name:` as identifer
* This can be useful to delete temporary keys, ones that we use only to generate values for other keys but we don't need in the final output

## Arrays
### Default inline replace with simple keys

```
$ cat a.yml
a:
- a1
- a2
- a3
$ cat b.yml
a:
- b1
- b2
$ spruce merge a.yml b.yml
a:
- b1
- b2
- a3

```

* This replaces key by key in the order of the array


### Default inline replace with maps

```
$ cat a.yml
a:
- name123: a1
  a11: a11
  a12: a12
- name123: a2
  a11: a21
  a12: a22
$ cat b.yml
a:
- name123: a1
  a11: b11
$ spruce merge a.yml b.yml
a:
- a11: b11
  a12: a12
  name123: a1
- a11: a21
  a12: a22
  name123: a2
```

* This works for an array of maps. It updates the keys in the maps following the order of the array

### Inline
Same as Simple replacement, using `- (( inline ))` as first element. Maybe more explicit.

### Append

```
$ cat a.yml
a:
- a1
- a2
- a3
$ cat b.yml
a:
- (( append ))
- b1
- b2
- b3
- b4
```

* The merge behaviour is specified in the next file, which is different than spiff
* `(( append ))` must be the first element

### Prepend
Prepend keys. Usage: same with `- (( prepend ))` instead

### Replace
Replaces the whole array. Usage: same with `- (( replace ))` instead

### Merge list of maps

```
$ cat a.yml
a:
- name: a1
  a11: a11
  a12: a12
- name: a2
  a11: a21
  a12: a22
$ cat b.yml
a:
- (( merge ))
- name: a1
  a11: b11
$ spruce merge a.yml b.yml
a:
- a11: b11
  a12: a12
  name: a1
- a11: a21
  a12: a22
  name: a2
```

* This merges a list of maps based on key "name" as identifier
* This allows to override only a set of keys in an array of maps
* To merge based on another key, use `(( merge on <key> ))`

## Static IPs

```
$ cat networks.yml
networks:
- name: net1
  subnets:
  - cloud_properties: random
    static:
    - 192.168.0.2 - 192.168.0.10
$ cat jobs.yml
jobs:
- name: staticIP_z1
  instances: 3
  networks:
  - name: net1
    static_ips: (( static_ips(0, 2, 4) ))
- name: api_z1
  instances: 3
  networks:
  - name: net1
    static_ips: (( static_ips(1, 3, 5) ))
$ cat properties.yml
properties:
  staticIP_servers: (( grab jobs.staticIP_z1.networks.net1.static_ips ))
  api_servers: (( grab jobs.api_z1.networks.net1.static_ips ))
```

* `static_ips()` functions works similarly to `spiff`
* It selects a list of IPs from a particular network in `networks:` map
* It creates as many IPs as jobs instances
* It checks for conflicts
* merge runs first, then `static_ips()`, then finally `grab`. So the order of the manifests in the merge command doesn't matter for this particular case.

## Concatenate strings

```
$ cat a.yml
key:
  subkey1: aa1
  subkey2: aa2
other_key: aaaa
a: (( concat "subkey1=" key.subkey1 " and other_key=" other_key ))
$ cat b.yml
key:
  subkey1: bb1
  subkey2: bb2
$ spruce merge a.yml b.yml
a: subkey1=bb1 and other_key=aaaa
key:
  subkey1: bb1
  subkey2: bb2
other_key: aaaa
```

* We can concatenate a list of strings
* Strings can be quoted string literals, keys from the same file or keys resulting from merge
* Merge happens first, then `concat`
* Can be separated with commas or spaces

## Replace maps
The default in spruce is to merge maps, whereas spiff was replacing. To replace with spruce, we need 2 steps instead of 1:

* delete the map
* add the new map

See https://github.com/geofffranks/spruce#map-replacement

## Inject subtree
YAML has the concept of anchor/alias to inject another subtree from the same file. See: https://en.wikipedia.org/wiki/YAML#Repeated_nodes

In spruce the same can be achieved across different files.

```
$ cat a.yml
green:
  woot: (( inject meta.template ))
  color: green
$ cat b.yml
meta:
  template:
    color: blue
    size: small
$ spruce merge a.yml b.yml
green:
  color: green
  size: small
meta:
  template:
    color: blue
    size: small
```

## Prevent null values
We can add useful error checking to prevent null values due to merge errors. This is probably a good practice to use in any key where we expect a value from a merge.

```
$ cat a.yml
critical_key:
$ spruce merge a.yml
critical_key: null
$ cat a.yml
critical_key: (( param "Merge error! critical_key can't be null."))
$ spruce merge a.yml
1 error(s) detected:
 - $.critical_key: Merge error! critical_key can't be null.
$ echo $?
2
$ cat b.yml
critical_key: critical_value
$ spruce merge a.yml b.yml
critical_key: critical_value
```

## OR operator

Alows to specify alternate values in the first key is null. Compatible with `grab` and `concat`.

```
$ cat a.yml
key1:
    subkey1: a1
    subkey2: a2
# String literal
key2: (( grab absent_key || "default value" ))
# Other key
key3: (( grab absent_key || key1.subkey1 ))
# null (can enter nil, null, Null, and so on)
key4: (( grab absent_key || Null ))
# Boolean
key5: (( grab absent_key || false ))
# Chaining
key6: (( grab absent_key || key1.absent_key || "other default" ))
# Concatenate strings
key7: (( concat "beginning_" absent_key || key1.subkey1 ))
# Grab
key8: (( grab absent_key || key1.subkey1, key1.subkey2 ))
# Multiple keys in concat
key9: (( concat "beginning_", absent_key || key1.subkey1, "_middle_", key1.absent_key || key1.subkey2 ))
$ cat b.yml
key1:
    subkey1: b1
    subkey2: b2
$ spruce merge a.yml b.yml
key1:
  subkey1: b1
  subkey2: b2
key2: default value
key3: b1
key4: null
key5: false
key6: other default
key7: beginning_b1
key8:
- b1
- b2
key9: beginning_b1_middle_b2
```
