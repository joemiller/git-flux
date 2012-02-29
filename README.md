git-flux - A git branching model for Infrastructure as code workflows
=======================================================================

Overview
---------

_What?_ git-flux is a set of custom git commands based heavily on 
[git-flow](https://github.com/nvie/gitflow) but tailored to managing the 
workflow of a configuration management system such as Puppet or Chef.

It is intended to be used in conjunction with a setup similar to that described
in [this blog article from puppetlabs](http://puppetlabs.com/blog/git-workflow-and-puppet-environments/)
where multiple, permanent, branches are aligned to different environments. 
For example, you may have a puppet.git repository with 'development', 
'testing', and 'production' branches corresponding to these environments in 
your  infrastructure. This tool helps you safely control the movement of
changes through each environment as testing or sign-off is completed.

_Why not use git-flow?_ Originally we wanted to but as we started discussing
what the workflow would look like we realized it was not a good fit for this
particular problem. For example, consider a scenario with two people making
changes to Puppet modules. Both changes could be completely independent of each
other and the intention is for both to move through the environments (dev ->
test -> prod) at their own pace. Using git-flow, person A would create a
feature branch based on develop, make their changes and push back to the
develop branch.  Person B would then branch from develop and work on his
changes. This branch would contain Person A's changes too. If Person B's change
is ready to move to the test environment first, then he will bring along Person
A's change even though that change is not ready to be promoted to the test
environment (or prod!)

This leads to the first rule of this workflow: we always create feature 
branches from the production branch because any code on the production branch 
is assumed to have passed through all other environments and should not have
any work in progress on it.

Also, this tool tries to keep the types of branches to a minimum. There are
currently only two branch 'types': feature and environment. Feature branches
are short-lived branches that are created for making changes to the codebase.
Environment branches are long-lived branches that correspond to a live
deployment. Feature branches are merged into environment branches.

See the `Typical Workflow` section below for more details.

Installation
------------

TODO

Getting started
---------------

### Preparing a repo (one-time task)

Prepare a repository for git flux by running `git flux init` which will 
create the all important environment branch production. This branch is
used to create all other environment and feature branches. It only needs
to be run once.

If this is an existing git repo, the master branch will be cloned to create
the production branch. If it's a new repo, a branch will be created.

    $ git flux init

    Summary of actions:
        - Created environment branch: 'environment/production'
        - You are now on branch 'environment/production'

    Next steps:
        - Create more environment branches with 'git flux env new <environment_name>
        - Setup a remote repository named 'origin'.
        - Publish your environment branches to remote with 'git flux publish <environment_name>'

### Create other environment branches

Next, create additional environment branches. All environment branches are
based off of the production environment branch.

    $ git flux env new development
    Switched to a new branch 'environment/testing'

    Summary of actions:
    - A new environment branch 'testing' was created, based on 'environment/production'.
    - You are now on branch 'environment/testing'.

### Publish environment branches to remote server

To publish environment branches to remote 'origin' server:

    $ git flux publish development

Update local branches
---------------------

git-flux has a command that is very similar to [git-up](https://github.com/aanand/git-up)
which provides a convenient way to update all local branches with any
changes on the remote server.

Unlike `git-up`, a local tracking branch does not need to exist first. Thus,
`git flux up` is a great way to pull down all remote feature and environment
branches after the first `git clone` from remote.

    $ git flux up

    Updating Feature branches:
      TKT-512_adding_cool_stuff   up to date
      some_new-feature            up to date

    Updating Environment branches:
      production   up to date
    * development  up to date
      testing      up to date

Typical workflow
----------------

After a repo has been prepared by running `git flux init` and your
environment branches have been created and published, the typical workflow
for changes might look like this:

1. Create a feature branch based on the `production` environment branch.
2. Make edits, commit, push.
3. Merge the feature branch into the `development` environment branch.
4. Test the changes, repeat steps 2 and 3 if necessary.
5. Merge the feature branch into the `testing` environment branch.
6. Do moar testing.
7. Merge the feature branch into the `production` environment branch.
8. Done.

### Create a new feature branch. 

    $ git flux feature new TKT-512_adding_cool_stuff
    <edit files, `git commit`, then..>
    $ git flux publish TKT-512_adding_cool_stuff

It is not required to publish feature branches but it can be very
useful for the rest of the team to be able to see your work in
progress, or they can finish merging it into environment branches if 
you get hit by a bus.
 
### Merge a feature branch into an environment branch:

    $ git flux feature merge TKT-512_adding_cool_stuff development

### Publish/push updated environment branch to remote server:

After merging a feature branch into an environment branch, the next step will
be to push your changes to the remote server (if you're ready):

    $ git flux publish development

After testing is completed in the development environment, the feature branch
can be merged to other environment branches. Use the `git flux feature status`
command to see which feature branches are awaiting merging into environment
branches.

Other commands
--------------

### List feature branches waiting to be merged into environment branches

It is possible to get a list of feature branches that have not yet been
merged into environment branches. This feature is still experimental.

    $ git flux feature status
    
    Unmerged feature branches for environment 'development':

    Unmerged feature branches for environment 'production':
      TKT-512_adding_cool_stuff

    Unmerged feature branches for environment 'testing':
      TKT-512_adding_cool_stuff

### List branches

List feature branches by using the `feature` command with no arguments or with
the `list` argument

    $ git flux feature
      TKT-512_adding_cool_stuff
    * some_new-feature

List environment branches by using the `env` command with no arguments
or with the `list` argument:

    $ git flux env
      development
    * production
      testing

### Switch (checkout) to a feature or environment branch

git-flux provides a shortcut for switching to an environment or feature
branch without providing the full prefix. You may need to run `git flux up`
first if the branch exists on the remote server but not locally.

    $ git flux checkout production

Is equivalent to:

    $ git checkout environment/production

Support
-------

Open a new issue on github.

Contributing
------------

Fork the repository.  Then, run:

    git flow init -d
    git flow feature start <new_feature>

Then, do work and commit your changes. Publish your feature to github
and open a pull request to your feature branch.

    git flow feature publish <new_feature>

License
-------

Portions of this code are taken from [git-flow](https://github.com/nvie/gitflow).
`git-flow` is Copyright Vincent Driessen. 
See `gitflux-common` for the git-flow license. 

Copyright 2012 Joe Miller. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 
    1. Redistributions of source code must retain the above copyright notice,
       this list of conditions and the following disclaimer.
 
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY JOE MILLER ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
EVENT SHALL JOE MILLER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
The views and conclusions contained in the software and documentation are
those of the authors and should not be interpreted as representing official
policies, either expressed or implied, of Joe Miller.
