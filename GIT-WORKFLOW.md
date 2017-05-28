# Documentation :: Git branching model

```
  Created by: Constantine Nicolaou
  Last modified on: May 28, 2017
```

## Description
In order to streamline our software development process, make it easier to work with other developers and to deploy to staging and production environments, we use the following simple git branching model.

## Git branches' naming convention

- `develop:` main day-to-day development branch
- `master:` main staging deployment branch
- `feature-name:` developer specific and personal branch that is originally branched out of develop branch
- `tag-release:` tags are used to label production releases before deployment from master branch

## Workflow

1. Developer checks out a new branch from develop branch, for instance: stripe-implementation
2. Developer starts working on his/her features using the new branch
3. Once work is complete, a git rebase from develop branch is needed to iron out all possible conflicts
4. A merge request is then created on GitLab against develop branch from stripe-implementation
5. After code-review and accepting the merge request, the changes are merged onto master for deployment on a staging server(s)
6. If the code is at a shipping stage, a tag is created from master branch with a version number and message indicating the release number. For example: `git tag tag-name -m 'message associated with the tag'`
