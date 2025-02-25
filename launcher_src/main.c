#include <string.h>
#include <stdio.h>

int main(int argc, char *argv[], char *envp[]) {
	#if defined dedicated
		char cmd[32768] = "-Dfile.encoding=UTF-8 -Djava.library.path=3rdparty/natives/ com.risingear.engine.DesktopLauncher -dedicated";
	#else
		char cmd[32768] = "-Dfile.encoding=UTF-8 -Djava.library.path=3rdparty/natives/ com.risingear.engine.DesktopLauncher";
	#endif
	
	for (int i = 1; i < argc; i++)
	{
		strncat(cmd, " ", 1);
		strncat(cmd, argv[i], strlen(argv[i]));
	}
	#if defined dedicated
		strncat(cmd, " +exec server.cfg", 17);
	#endif
	
	laun_exec(cmd);

	return 0; // Success exit status code
}
