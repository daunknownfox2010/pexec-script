# Reference for script environment variables
In case you want them, here:
Variable | Description
-------- | -----------
`%PELE_EXECUTABLE_LWDIR%` | The "long version" of the program working directory.
`%PELE_EXECUTABLE_WDIR%` | The "short version" of the program working directory.
`%PELE_EXECUTABLE_DIR%` | The executable program directory, this is where the (.exe) file should be located.
`%PELE_TEMPDIR_ROOT%` | The script creates a temporary directory in `%TEMP%` to work with. This points to that directory.
`%PELE_TEMPDIR_EXEC%` | Directory in `%PELE_TEMPDIR_ROOT%` where the script executes commands to ensure command outputs land here instead of elsewhere.
`%PELE_CONFIG_FILE%` | Points to the current active configuration file.
`%PELE_RUNLIST_STARTFILE%`/`%PELE_RUNLIST_ENDFILE%` | Points to run lists, the starting list being executed before a program launches and the ending list executed after program termination.
`%PELE_EXECUTABLE_NAME%` | A "pretty name" for the script to use. Users would likely prefer seeing a pretty name instead of "program.exe" being displayed, right?
## Some reference for Steam environment variables
There's actually a number of them but the ones you are likely to use are `%SteamAppUser%` and `%SteamAppId%`.
