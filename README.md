# Forked Repo Notes

The orginal code was not working for us, it would often grab the penultimate version instead of the latest, 
which caused a tag collision when we bumped it and tried to push the tag.  This code is slightly less flexible, 
but we only use v*.*.* pattern tags, so this way always worked for us.  

# Action Get Latest Tag

This is a GitHub Action to get a latest Git tag.

It would be more useful to use this with other GitHub Actions' outputs.

## Inputs

|          NAME          |                                                  DESCRIPTION                                                  |   TYPE   | REQUIRED | DEFAULT  |
|------------------------|---------------------------------------------------------------------------------------------------------------|----------|----------|----------|
| `initial_version`      | The initial version. Works only when `inputs.with_initial_version` == `true`.                                 | `string` | `false`  | `v0.0.0` |
| `with_initial_version` | Whether returns `inputs.initial_version` as `outputs.tag` if no tag exists. `true` and `false` are available. | `bool`   | `false`  | `true`   |


## Outputs

| NAME  |                                            DESCRIPTION                                             |   TYPE   |
|-------|----------------------------------------------------------------------------------------------------|----------|
| `tag` | The latest tag. If no tag exists and `inputs.with_initial_version` == `false`, this value is `''`. | `string` |

## Example

```yaml
name: Push a new tag with Pull Request

on:
  pull_request:
    types: [closed]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: actions-ecosystem/action-release-label@v1
        id: release-label
        if: ${{ github.event.pull_request.merged == true }}

      - uses: actions-ecosystem/action-get-latest-tag@v1
        id: get-latest-tag
        if: ${{ steps.release-label.outputs.level != null }}

      - uses: actions-ecosystem/action-bump-semver@v1
        id: bump-semver
        if: ${{ steps.release-label.outputs.level != null }}
        with:
          current_version: ${{ steps.get-latest-tag.outputs.tag }}
          level: ${{ steps.release-label.outputs.level }}

      - uses: actions-ecosystem/action-push-tag@v1
        if: ${{ steps.release-label.outputs.level != null }}
        with:
          tag: ${{ steps.bump-semver.outputs.new_version }}
          message: '${{ steps.bump-semver.outputs.new_version }}: PR #${{ github.event.pull_request.number }} ${{ github.event.pull_request.title }}'
```

For a further practical example, see [.github/workflows/release.yml](.github/workflows/release.yml).

## License

Copyright 2020 The Actions Ecosystem Authors.

Action Get Latest Tag is released under the [Apache License 2.0](./LICENSE).

<!-- badge links -->

[actions-workflow-lint]: https://github.com/actions-ecosystem/action-get-latest-tag/actions?query=workflow%3ALint
[actions-workflow-lint-badge]: https://img.shields.io/github/workflow/status/actions-ecosystem/action-get-latest-tag/Lint?label=Lint&style=for-the-badge&logo=github

[release]: https://github.com/actions-ecosystem/action-get-latest-tag/releases
[release-badge]: https://img.shields.io/github/v/release/actions-ecosystem/action-get-latest-tag?style=for-the-badge&logo=github

[license]: LICENSE
[license-badge]: https://img.shields.io/github/license/actions-ecosystem/action-add-labels?style=for-the-badge
