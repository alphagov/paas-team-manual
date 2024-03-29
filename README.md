# Technical Documentation

## Getting started

To preview or build the website, we need to use the terminal.

Install Ruby with Rubygems, perferably with a [Ruby version manager][rvm],
and the [Bundler gem][bundler].

In the application folder type the following to install the required gems:

```
bundle install
```

## Making changes

To make changes edit the source files in the `source` folder.

### Adding pages

All the source files can be found in the
`source` subdirectory.

To add a new page, create a file with a `.html.md` extension in the `/source` directory.

For example, `source/about.html.md` will be accessible on <http://localhost:4567/about.html>.

A new markdown file isn't automatically included in the index. We also need to modify `source/index.html.md.erb` to include the addition.

### Diagrams

Diagrams are generated by
[blockdiag](http://blockdiag.com/en/blockdiag/index.html) from `.diag` source
files in `source/diagrams/`.

To regenerate the diagrams:
- run `make` from the `source/diagrams` directory
- preview the diagram
- commit the changes to the SVG file

If you've added a new diagram, you'll need to edit `source/diagrams/Makefile`.

## Preview

Whilst writing documentation we can run a middleman server to preview how the
published version will look in the browser. After saving a change the preview in
the browser will automatically refresh.

The preview is only available on our own computer. Others won't be able to
access it if they are given the link.

Type the following to start the server:

```
bundle exec middleman server
```

If all goes well something like the following output will be displayed:

```
== The Middleman is loading
== LiveReload accepting connections from ws://192.168.0.8:35729
== View your site at "http://Laptop.local:4567", "http://192.168.0.8:4567"
== Inspect your site configuration at "http://Laptop.local:4567/__middleman", "http://192.168.0.8:4567/__middleman"
```

You should now be able to view a live preview at http://localhost:4567.

## Build and deploy

If you want to publish the website without using a build script you may need to
build the static HTML files.

Type the following to build the HTML:

```
bundle exec middleman build
```

This will create a `build` subfolder in the application folder which contains
the HTML and asset files ready to be published.

[rvm]: https://www.ruby-lang.org/en/documentation/installation/#managers
[bundler]: http://bundler.io/

The team manual is hosted on GitHub Pages which is deployed using GitHub actions. GitHub pages is configured with a custom sub-domain of [team-manual.cloud.service.gov.uk](https://team-manual.cloud.service.gov.uk/).

The deploy process first runs `bundle exec middleman build` which generates a `build` directory consisting of static files for our site. 

Next the [upload-pages-artifact](https://github.com/actions/upload-pages-artifact) action takes the `build` directory and turns it into a [gzip archive](https://en.wikipedia.org/wiki/Gzip) called `github-pages` which the [deploy-pages](https://github.com/actions/deploy-pages) action uses to deploy to GitHub pages.