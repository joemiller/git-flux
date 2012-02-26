git-puppet - A git branching model for puppet workflows
=======================================================


Overview
---------

Why? What? How?
TODO. types of branches: feature, environment

Installation
------------

TODO

Usage
-----

### Preparing a repo

git-puppet assumes the following:

1. You have already created a git repo.
2. The repo is stored on a remote server somewhere and that remote is
   named 'origin'.
3. There is a local or remote 'master' branch which will be used to create
   the 'production' environment branch.

Once these conditions are met, you can configure the repo to use git-puppet.
It will ask a couple questions and create an environment branch named
`production` based off of the local `master` branch. All 'feature' and
'environment' branches that are created will be based on this `production`.

    $ git puppet init
    
    Prefix for environment branches? [environment/] 
    Prefix for feature branches? [feature/]

    Creating new branch 'environment/production' based on local 'master' branch.

### Creating environment branches

The next thing you will want to do is create 'environment' branches that will 
be used by each of your environments. These are long-living branches and are 
typicallysetup on your puppet-master to be automatically updated whenever a 
commit is push'd.
(TODO.. link to more info on setting this part up on a puppet-master)

    $ git puppet env new development
    $ git puppet env new testing
    $ git puppet publish development
    $ git puppet publish testing

### Typical workflow

This is the most common task you will perform since it is the mechanism you
will use to make changes to your puppet modules and then push them to your 
various environments.

A typical change workflow might look like this:

1. Create a feature branch based on the `production` environment branch.
2. Make edits, commit, push.
3. Merge the feature branch into the `development` environment branch.
4. Test the changes, repeat steps 2 and 3 if necessary.
5. Merge the feature branch into the `testing` environment branch.
6. Do moar testing.
7. Merge the feature branch into the `production` environment branch.
8. Done.

#### Create a new feature branch. 

    $ git puppet feature new TKT-512_adding_cool_stuff
    <edit files, `git commit`, then..>
    $ git puppet publish TKT-512_adding_cool_stuff

It is not required to publish feature branches but it can be very
useful for the rest of the team to be able to see your work in
progress, or they can finish merging it into environment branches if 
you get hit by a bus.
 
#### Merge a feature branch into an environment branch:

    $ git puppet feature merge TKT-512_adding_cool_stuff development

After merging a feature branch into an environment branch, the next step will
be to push your changes to the remote server (if you're ready):

    $ git puppet publish development

### List feature branches

TODO.. might also include some merge statuses here

### List feature branches waiting to be merged into environment branches

It is possible to get a list of feature branches that have not yet been
merged into environment branches. This feature is still experimental.

    $ git puppet feature status
    
    Unmerged feature branches for environment 'development':

    Unmerged feature branches for environment 'production':
      TKT-512_adding_cool_stuff

    Unmerged feature branches for environment 'testing':
      TKT-512_adding_cool_stuff

In the above example, our feature branch has been merged into the 
development environment but has not yet been merged into
testing or production.

---------------------------


Implementation Priority
=======================
1. git puppet init
2. git puppet feature [list|new|merge|status] delete?
3. git puppet environment [list|new]
4. git puppet publish 
4. git puppet up

Commands
=========

Initialize?
-----------
ex: `git puppet init`

    Environment branch prefix? [environment/]
    Feature branch prefix? [feature/]
    
    
Fetch all remote branches?  IS THIS ONE NEEDED AT ALL?
---------------------------
ex: `git puppet prepare`

Pseudo-code:

    git fetch --all     # ???

Start new environment branch.
-------------------------
ex: `git puppet environment new BRANCH_NAME`

NOTE: probably need some way to create the first branch (production) or .. ?
    
Publish environment branch remote ?
----------------------------
ex:  `git puppet environment publish BRANCH_NAME`


    
Start new feature branch.
-------------------------
ex: `git puppet feature new BRANCH_NAME`

pseudo-code:

    git checkout production ; git pull --rebase (??) ; git checkout -b BRANCH_NAME
    
Publish feature branch remote ?
----------------------------
ex:  `git puppet feature publish BRANCH_NAME`


Merge feature into an environment.
---------------------------------
ex:  `git puppet feature merge [FEATURE_BRANCH] ENV_BRANCH`

pseudo-code:

    git checkout ENV_BRANCH ; git merge FEATURE_BRANCH 
    
Show unmerged feature branches ?
-------------------------------
ex:  `git puppet feature status`

pseudo-code:

    for i in development testing production demo;do git checkout $i && git branch --no-merged|grep OPS;done
