# DevOpsDream
Is the next evolution from [Mass](https://github.com/ksandom/mass), which is about quickly and easily getting the information you need about your infrastructure, and doing something with it so you can get back to what's important. It

* Brings organisation and understanding to the reality of environments with mixed legacy and current naming conventions.
* Presents the information in a clear and concise manner, *with* the ability to quickly get `--more` information when needed.
* Provides an effective way to share information about what parts of the infrastructure are and what they do.
* Gives you fast access so you can get on with dealing with the task at hand.
* Can export everything it knows (or a selection of it) in many standard formats such as json.

There's a lot in the pipeline. The dream begins *now!*

NOTE There will still be references to mass in the documentation while I complete the migration

## Requirements

* PHP
* Bash

## Install

### If achel is already installed

    achelctl repoInstall https://github.com/ksandom/devOpsDream.git

### Locally, from scratch

    export extraSrc="https://github.com/ksandom/devOpsDream.git"; curl https://raw.githubusercontent.com/ksandom/achel/master/supplimentary/misc/webInstall | bash

See [docs/install.md](mass/tree/master/docs/install.md) for more information.

### Docker, from scratch

Get into the directory where you place bins (like bash scripts) and then run the following command.

    export CONTAINER=kjsandom/devopsdream; curl https://raw.githubusercontent.com/ksandom/achel/master/automation/dockerExternal/dumpBins | bash

This can be used for any Achel based docker container. It pulls the docker container, and then extracts the wrappers for each of the commands provided by that container.

### Docker for careful people (a good habbit)

    curl https://raw.githubusercontent.com/ksandom/achel/master/automation/dockerExternal/dumpBins > dumpBins
    cat dumpBins # sanity check
    export CONTAINER=kjsandom/devopsdream; cat dumpBins | bash

Exactly the same as the "Docker, from scratch" section above, but gives you a chance to sanity check what this code you just downloaded actually does.


## Important updates

* Mass has undergone significant refactoring. You can now install it using the one-liner below. [More info](mass/tree/master/docs/install.md).

As a general rule, when ever you update, you should re-run install.sh to apply any structural changes as the internals are regularly being refactored.

## Contributing

* If there's something you want mass to do that it doesn't currently, take a look at the "creatingA" series in the [documentation](tree/master/docs). It would be lovely if you can contribute is back.
* There are `TODO`'s floating around the documentation that need to be filled in. Filling these in would be very helpful.
* There are `# TODO`'s floating around in the code. There are going to be a few which I'll reserve for me. Typically I only do this if I've planned something else based on how that thing gets done.

The bottom line is, I wrote this tool because it's useful to me. If it's useful to you and you have something to contribute, it would be lovely for you to put it forward.

To submit it, create a pull request to the development branch. Make sure to include in the description
* What you are trying to achieve.
* Any relevant information that can help me test before and after that your code does what you are trying to achieve.

## History

I've written a version of this tool at every company I've worked at since 2007 and it's always been a big hit. In each case it was very specific to the architecture of the given place, so it wasn't very portable.

This time I've developed it entirely in my own time, which means I can take the time to do it right and I can share it and take it with me. Phase 1, which is available now is maturing and ready for public use.

A month or so in to development, it became apparent that this would be a fantastic set of foundations for a concept I came up with in late 2000/early 2001. This is phase 2. It doesn't replace anything, it simply adds a whole lot. Therefore you don't have to worry about any macros you create becomming obsolete because of it. More on this in due time. ;)
 
