# Launching Steam games with PELE
This process is simple and utilises a feature Steam has had for ages. While the `%command%` feature in Steam game launch options is primarily used for Linux users, it's available on the Windows client too.
Due to how the Windows environment works though... It's not as flexible and thus this script sorta gets around that.
## How to make the script do its magic
It's so simple that you could probably do this in your sleep. Open up the game's properties window where you set the game's launch parameters then put `"<PATH TO LAUNCHER SCRIPT>\pele-launcher.cmd" %command%` at the beginning.
To give you an example, let's use a game that's currently using a launch parameter of `-insecure`... Currently it'd just be `-insecure` in the launch parameters. This should turn into `"<PATH TO LAUNCHER SCRIPT>\pele-launcher.cmd" %command% -insecure`.
