Content for the PLTC infoscreen
===============================

All content is in the `content` directory.  The directories
`content-disabled` and `background` are not relevant for basic
execution.

This is the repository for PLTC infoscreen.  It runs the software
<https://github.com/datalogisk-kantineforening/kantinfo>.

Contribute!
-----------

Want to put something on the infoscreen?  It's easy:

  1. Have a GitHub user.
  2. Fork this repository to your own user (there's a green button up and to the right).
  3. Commit and push your changes to your fork.  Supported file types
     are documented at
     <https://github.com/datalogisk-kantineforening/kantinfo>.
  4. Make a pull request to this repository from your fork (there's a
     button on the repository).

Alternatively, if you have commit access to this repository for any reason, feel
free to just commit whatever content you wish. No friction!


Setup
-----

You don't need to know any of the following just to contribute slides.

The infoscreen machine (hereafter called `pltc-pi`) runs on a Raspberry
Pi.  Contact @athas for access information.  On startup, the user
`infoscreen` is logged into a session that runs the script
`.xsessionrc`.  We have put the `.xsessionrc` in this repository; see
the file `xsessionrc` n the `system` directory.

The primary job of `xsessionrc` is to start a `tmux` session that runs
`kantinfo`, and start a simple window manager.

Dependencies
------------

Our `xsessionrc` has these dependencies:

  + `matchbox`: Simple window manager
  + `xdotool`: Mouse pointer hiding.
  + `tmux`: Like `screen`, but BSD.

Other slides may have more dependencies:

  + `toilet`: Text formatting program.
  + `lxterminal` with font size 33; we've attached a `lxterminal.conf` in
    the `system`-directory, which should be symlinked from `~/.config/lxterminal/`.
  + The fonts Gentium og Comfortaa.
