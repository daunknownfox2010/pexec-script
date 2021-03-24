# The "pexec.ini" configuration file
In order for the script to do anything, you'll need a configuration file to set a few variables. The script _can_ run without this file, however, it will do nothing before the program launches.
## Where does it go?
The script checks to see if _**pexec.ini**_ exists next to the executable (.exe) program, if it doesn't then it skips the configuration step.
## Configuration variables
Here are the current valid variables you can set...
Variable | Description
-------- | -----------
`@sConfigFileURL` | Specifies a configuration file to download and use. This is a URL pointing to a raw file.
`@sExecutableName` | This doesn't do anything besides allow you to set a pretty name for the current program being launched.
`@pOverrideExecutableDir` | Overrides the script's targeted executable directory (where the program .exe is.)
`@sEnvironmentVars` | Sets specified environment variables before program launch. Example: _`VARIABLE1:Hello\|VARIABLE2:World`_
`@pStartRunListFile` | Specifies the starting "run list" the script will use before launch. This is a path pointing to a file.
`@pEndRunListFile` | Specifies the ending "run list" the script will use after program termination. This is a path pointing to a file.
`@sStartRunListURL` | Specifies the starting "run list" the script will use before launch. This is a URL pointing to a raw file.
`@sEndRunListURL` | Specifies the ending "run list" the script will use after program termination. This is a URL pointing to a raw file.
`@bSuppressLaunch` | The script will not launch the program and instead pause itself. Useful for testing stuff without having the program launch. This is either _`0`_ or _`1`_.
`@bAllowCommandExecution` | This enables `$ExecuteCmd?` in run lists, however, the user will be prompted before its enablement. This is either _`0`_ or _`1`_.
