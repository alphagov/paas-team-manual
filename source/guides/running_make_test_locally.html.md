# Running `make test` locally

A number of packages need to be installed in order to run `make test` in `paas-cf` locally.

## Pre-requisites
`paas-cf` needs to be checked out in the correct location in your Go path: `$GOPATH/src/github.com/alphagov/paas-cf`

## Install required packages

* [Homebrew](https://brew.sh/)
* Golang >=1.11.4

  ```sh
  brew install golang
  ```

* Ruby 2.5.1
  * Installed via rbenv

    ```sh
    brew install rbenv
    ```

    then in `~/.bashrc` somewhere, add `eval “$(rbenv init -)”`

  ```sh
  rbenv install 2.5.1
  ```

* Shellcheck
  
  ```sh
  curl -L -o /usr/local/bin/shellcheck https://github.com/alphagov/paas-cf/releases/download/shellcheck_binary_0.4.6/shellcheck_darwin_amd64
  chmod +x /usr/local/bin/shellcheck
  ```

* Terraform (0.11.1)

  ```sh
  wget https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_darwin_amd64.zip
  unzip -o terraform_0.11.1_darwin_amd64.zip -d /usr/local/bin
  rm terraform_0.11.1_darwin_amd64.zip
  ```

* BOSH cli v2 (2.0.48)

  ```sh
  brew install cloudfoundry/tap/bosh-cli
  ```

* Prometheus & Promtool

  ```sh
  brew install prometheus
  ```

* CF CLI

  ```sh
  brew install cloudfoundry/tap/cf-cli`
  ```

* YAML Lint
  
  ```
  brew install yamllint
  ```

* Bundler

  ```sh
  gem install bundler
  ```

  * Gems via bundler

    ```sh
    cd path/to/paas-cf/
    bundle install
    ```

* Ginkgo and gomega (prereq: golang)

  ```sh
  cd path/to/paas-cf/
  go get github.com/onsi/ginkgo/ginkgo
  go get github.com/onsi/gomega/...
  ```

* jq

  ```sh
  brew install jq
  ```

## Install optional packages

* CloudFoundry cf-uaac

  ```sh
  gem install cf-uaac
  ```

* [CloudFoundry UAA CLI](https://github.com/cloudfoundry-incubator/uaa-cli)
