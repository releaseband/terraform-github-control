# Changelog

## [0.4.1](https://github.com/releaseband/terraform-github-control/compare/v0.4.0...v0.4.1) (2023-12-01)


### Bug Fixes

* **main.tf:** add a condition for check value 'archive' ([8669fc1](https://github.com/releaseband/terraform-github-control/commit/8669fc1aa735c9b1d40399905f84489668ffed29))

## [0.4.0](https://github.com/releaseband/terraform-github-control/compare/v0.3.0...v0.4.0) (2023-10-19)


### Features

* **main.tf:** add members_can_fork_private_repositories attribute to github_repository resource to allow members to fork private repositories ([588710b](https://github.com/releaseband/terraform-github-control/commit/588710b655217ee905cb1c80a459c4c0b7787a54))


### Bug Fixes

* **main.tf:** change default_repository_permission from 'read' to 'none' to enhance security by restricting default access to repositories ([9e0a6ef](https://github.com/releaseband/terraform-github-control/commit/9e0a6efe811df52555b74fbb6869095e993a8f8e))
* **main.tf:** disable members_can_fork_private_repositories to enhance security by preventing unauthorized forks of private repositories ([50b0b2f](https://github.com/releaseband/terraform-github-control/commit/50b0b2f04162141c9c5695cd07e055515d830512))

## [0.3.0](https://github.com/releaseband/terraform-github-control/compare/v0.2.0...v0.3.0) (2023-04-26)


### Features

* add support for creating GitHub Actions secrets ([edd1f9a](https://github.com/releaseband/terraform-github-control/commit/edd1f9a729f825a8de82ff775e839bd9ef2c9a4d))

## [0.2.0](https://github.com/releaseband/terraform-github-control/compare/v0.1.0...v0.2.0) (2023-04-24)


### Features

* **main.tf:** add aws iam user, access key, policy and github secrets for aws access key id and secret access key ([5e2f98e](https://github.com/releaseband/terraform-github-control/commit/5e2f98e60995e6e0da9c5481ca2af8f5ec6667b6))
* **main.tf:** add support for branch protection on versions branch pattern for each repository ([f26e48b](https://github.com/releaseband/terraform-github-control/commit/f26e48b84f91ef27eb67bb4484d427a6a39b4fb7))
* **main.tf:** add support for organization secrets for github actions ([f26e48b](https://github.com/releaseband/terraform-github-control/commit/f26e48b84f91ef27eb67bb4484d427a6a39b4fb7))
* **main.tf:** add support for repository templates ([f26e48b](https://github.com/releaseband/terraform-github-control/commit/f26e48b84f91ef27eb67bb4484d427a6a39b4fb7))
* **README.md:** add AWS IAM access key and secret as GitHub Actions secrets ([5e2f98e](https://github.com/releaseband/terraform-github-control/commit/5e2f98e60995e6e0da9c5481ca2af8f5ec6667b6))
* **variables.tf:** add new optional variables to repositories object and add organization_secrets variable. ([56d4a66](https://github.com/releaseband/terraform-github-control/commit/56d4a667a6cef1873b5b7ca966ff12a8daf789a6))

## [0.1.0](https://github.com/releaseband/terraform-github-control/compare/v0.0.1...v0.1.0) (2023-04-03)


### Features

* **main.tf:** add depends_on to github_branch_default and github_branch_protection_v3 resources ([e23d719](https://github.com/releaseband/terraform-github-control/commit/e23d7199069500270b50e4c3e08373a2f75f5d8a))
* **main.tf:** add resources for GitHub organization settings, teams, team members, team settings, and team repository permissions. ([e23d719](https://github.com/releaseband/terraform-github-control/commit/e23d7199069500270b50e4c3e08373a2f75f5d8a))
* **main.tf:** add security and analysis block to github_repository resource ([e23d719](https://github.com/releaseband/terraform-github-control/commit/e23d7199069500270b50e4c3e08373a2f75f5d8a))
* **README.md:** add input for billing email ([e8a4cf4](https://github.com/releaseband/terraform-github-control/commit/e8a4cf47f1006a205cc405ccf3a6a218cb5d5a46))
* **README.md:** add input for repository homepage URL and teams with access to it ([e8a4cf4](https://github.com/releaseband/terraform-github-control/commit/e8a4cf47f1006a205cc405ccf3a6a218cb5d5a46))
* **README.md:** add input for teams and their members ([e8a4cf4](https://github.com/releaseband/terraform-github-control/commit/e8a4cf47f1006a205cc405ccf3a6a218cb5d5a46))
* **README.md:** update input for repositories to include pages and their branch and path ([e8a4cf4](https://github.com/releaseband/terraform-github-control/commit/e8a4cf47f1006a205cc405ccf3a6a218cb5d5a46))
* **variables.tf:** add billing_email variable ([35a6dd2](https://github.com/releaseband/terraform-github-control/commit/35a6dd206102c88112ab67a643d6200a2ea0e9ee))
* **variables.tf:** add optional teams list to repositories variable ([35a6dd2](https://github.com/releaseband/terraform-github-control/commit/35a6dd206102c88112ab67a643d6200a2ea0e9ee))
* **variables.tf:** add teams variable as a map of objects with optional members list ([35a6dd2](https://github.com/releaseband/terraform-github-control/commit/35a6dd206102c88112ab67a643d6200a2ea0e9ee))

## 0.0.1 (2023-03-30)


### Miscellaneous Chores

* release 0.0.1 ([e2e8a44](https://github.com/releaseband/terraform-github-control/commit/e2e8a4464d491574ada9ba1ba8678f1105e7d801))
