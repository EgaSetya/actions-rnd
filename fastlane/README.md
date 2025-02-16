fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios fetch_provisioning_profile

```sh
[bundle exec] fastlane ios fetch_provisioning_profile
```

Perform the fetch provisioning profile action.

### ios update_provisioning_profile

```sh
[bundle exec] fastlane ios update_provisioning_profile
```

Perform the update provisioning profile action.

### ios register_a_device

```sh
[bundle exec] fastlane ios register_a_device
```

Interactively register a new device and synchronize code signing.

### ios deploy_production

```sh
[bundle exec] fastlane ios deploy_production
```

Distribute the App via Testflight from local machine

### ios deploy_staging

```sh
[bundle exec] fastlane ios deploy_staging
```

Distribute the App via Firebase App Distribution from local machine

### ios deploy_dev

```sh
[bundle exec] fastlane ios deploy_dev
```

Distribute the App with dev scheme via Firebase App Distribution from local machine

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
