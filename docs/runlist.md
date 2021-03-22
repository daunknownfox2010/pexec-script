# Script command execution using a "run list"
The way the script does things is using these odd little files I call "run lists", yeah it's pretty unique for a name. The script reads through each line, acting as a list of commands to run.
## Where does it go?
It can go anywhere as long as the file is being pointed to in the configuration file.
## Usable commands
At the start of each line you have a "command", this tells the script what to do on this line. Things don't work without these. Here's a list of valid commands...
Command | Description
------- | -----------
`$EchoMsg?[MESSAGE]` | Simple but nice to have. Echo a simple message.
`$Pause?` | Simple but useless, really only useful for probably testing your run list.
`$CreateFile?[CONTENT]\|[PATH]` | Inserts the contents to a file.
`$AppendFile?[CONTENT]\|[PATH]` | Appends the contents to a file. (no overwrite)
`$CopyFile?[PATH]\|[PATH]` | Copies a file from the first specified path to the second.
`$MakeDir?[PATH]` | Creates a directory.
`$MovePath?[PATH]\|[PATH]` | Moves a file/folder from the first specified path to the second.
`$RemovePath?[PATH]` | Deletes the specified file/folder.
`$SymbolicLink?[PATH]\|[PATH]` | Performs a symbolic link. The first specified path is the target, the second specified path is the link. Requires developer mode.
`$JunctionLink?[PATH]\|[PATH]` | Performs a junction (directory) link. The first specified path is the target, the second specified path is the link.
`$FileAttribute?[-/+]\|[PATH]` | Sets a file attribute on the specified path. Useful for making files read-only, etc.
`$ExtractTAR?[PATH]\|[PATH]` | Extracts the tar file from the first specified path to the second specified path.
`$URLExtractTAR?[URL]\|[PATH]` | Handles the tar file from the specified URL by piping and extracting to the second specified path.
`$Extract7ZA?[PATH]\|[PATH]` | Extracts a file using 7ZA, following convention of `$ExtractTAR?` above. Requires **7za.exe** in _`%PELE_TEMPDIR_EXEC%`_.
`$DecompressZSTD?[PATH]\|[PATH]` | Decompresses a ZSTD compressed file to the specified second path, this creates a new (uncompressed) copy of the file. Requires **zstd.exe** in _`%PELE_TEMPDIR_EXEC%`_.
`$DownloadFile?[URL]\|[PATH]` | Downloads the file to the specified path, creating a file from the downloaded data.
`$ExecuteCmd?[CMD]` | Executes a command. Requires command execution to be allowed from the configuration file.
### Facts about [PATH]
You'll notice that `[PATH]` in run lists works a bit weirdly. Originally you could do anything with file/folder manipulation but I decided to limit its reach for neat & tidy reasons.
How `[PATH]` works is simple... Each instance of `[PATH]` starts with `*>`, the `*` can be changed. This is then followed up with a relative path.
For example, `WDIR>this\is\a\test.txt` will expand this path out to `<PROGRAM WORKING DIRECTORY>\this\is\a\test.txt`. If you need a table to refer to, here:
Prefix | Description
------ | -----------
`~>` | The current script working directory, typically this is _`%PELE_TEMPDIR_EXEC%`_.
`WDIR>` | The current executable working directory, this is the working directory the program wants to launch itself in.
`EDIR>` | This is the executable program directory, this is where the (.exe) file is located usually unless overriden.

Also, yes, you can still directory escape using `..`. Honestly, Batch is annoying enough to deal with as-is to get anything with complexity working so I ain't stopping you with magic statement checks.
### Using environment variables
Yes, due to the script using delayed variable expansion you can actually get away with using the `!VARIABLE!` method here.
## Still confused?
Feel free to have a look at the examples I've placed in this repository.
## Why didn't you just make the script run proper commands on each line?
Good point. I wanted to do something strange and different, that's all. If you REALLY want to execute proper commands, then `$ExecuteCmd?` is your friend here.
