# Effective remote pairing

Remote pairing can be more difficult than pairing in person, so we use tools to support us in it. However, those tools are subject to some pitfalls and easy-to-make mistakes. The rest of this document details the pairing tools we use, and how to avoid the most common problems.

## The tools
The tools we use for remote pairing are ..

### [Floobits](https://floobits.com)
Floobits is a tool which synchronises the contents of a workspace between 2 or more connected users. It has a number of IDE integrations available, and can even share shell sessions through [flootty](https://floobits.com/help/flootty) (although we've found that to be a bit unreliable).

### An IDE
Pick a [supported IDE](https://floobits.com/help/plugins), configure it however you want, and install the Floobits plugin. It shouldn't matter if two people are using different IDEs, since only the source code is synchronised.

The Floobits website only lists integration for JetBrains IntelliJ, but the plugin is available for every JetBrains IDE.

### Slack voice and video
We typically don't use the video for anything but screen sharing, but the voice communications are essential.

## Setup
Getting a smooth setup is important for remote pairing, so we don't get distracted by problems in the tools, or otherwise [caused by the tools]. This is the setup we've been using, and has been effective for us.

### 1. Pick a host

The other person will be the guest.

The host should get a clean slate in git, create a new branch to work on. They then open the project in their IDE, and connect to their own workspace. When prompted, the host will overwrite the workspace's files with their own. This makes the workspace look the same as the on the host's machine.

### 2. Configure `.flooignore`
If it doesn't already exist, create the `.flooignore` file in the root of the project. Add to it the `.git` directory, any git submodule directories, and any third-party package directories like `node_modules`. We've found that, in a Go project, when the `vendor` directory is included in version control, that it should not be ignored by Floobits.

It's also worth adding any folders maintained by the IDE (such as `.idea`), so that settings and state don't bleed between participants using the same IDE.

**Note:** We ignore the `.git` directory so that any git actions taken by either party don't affect the other.

### 3. The guest connects

The guest uses their IDE to connect to the host's workspace. They should open the workspace at the same path as they have their version-controlled copy of the project locally. When prompted, the guest overwrites their local files with those from the remote workspace.

**Important:** Opening the workspace on top of a local project gives the guest the full support of their IDE. This is particularly important in Go projects, where the path matters.

### 4. Run the tests
Both parties should run the tests locally, to verify that they have all the files and working versions thereof.

### 5. Do the work
All parties work together however they see fit

### 6. The host makes git commits
The host should be the one to make changes in git, because the `.git` directory should have been ignored in `.flooignore`.

## Tasks, considerations, and tips
### Switching branches
If the pair need to switch branches, the guest should disconnect from the workspace, and the host should switch branch then go through the setup steps again.

### Terminal sessions
We have found that [flootty](https://floobits.com/help/flootty) isn't the best experience, and doesn't really add much value. If the pair need to see a terminal session together, we suggest screen sharing on Slack.

### Use follow and summon in Floobits
Floobits has a built-in mechanism for one of the pair to show something in code to the other, called summon. When used, the other person's IDE immediately opens the right file at the right line.

The opposite function also exists: follow. This allows one person to follow along as the other navigates through files and makes changes.

These two features make it very easy to replicate the "look at this" and navigator/driver type behaviour of pairing in person.
