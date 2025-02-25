#include <windows.h>
#include <stdio.h>
#include "platform.h"

void laun_exec(const char* cmd) {
	// start java-win-x86_64/jdk-14.0.2-jre/bin/java.exe
	// start java-win-x86_64/jdk-14.0.2-jre/bin/javaw.exe
	#if defined dedicated
		char cmd2[32768] = "start java-win-x86_64/jdk-11.0.26+4-jre/bin/java.exe -classpath jar/risingear.min.jar;3rdparty/jar/luaj-jse-3.0.2.jar;3rdparty/jar/asm-4.0.jar;3rdparty/jar/kryo-3.0.3.jar;3rdparty/jar/kryonet-2.21.jar;3rdparty/jar/objenesis-1.2.jar;3rdparty/jar/reflectasm-1.07.jar;3rdparty/jar/jinput.jar;3rdparty/jar/lwjgl_util.jar;3rdparty/jar/lwjgl_util_applet.jar;3rdparty/jar/lwjgl.jar;3rdparty/jar/minlog-none-1.2.jar;3rdparty/jar/jsonbeans-0.5.jar;3rdparty/jar/jogg-0.0.7.jar;3rdparty/jar/jorbis-0.0.15.jar;3rdparty/jar/ibxm.jar ";
	#else
		char cmd2[32768] = "start java-win-x86_64/jdk-11.0.26+4-jre/bin/javaw.exe -classpath jar/risingear.min.jar;3rdparty/jar/luaj-jse-3.0.2.jar;3rdparty/jar/asm-4.0.jar;3rdparty/jar/kryo-3.0.3.jar;3rdparty/jar/kryonet-2.21.jar;3rdparty/jar/objenesis-1.2.jar;3rdparty/jar/reflectasm-1.07.jar;3rdparty/jar/jinput.jar;3rdparty/jar/lwjgl_util.jar;3rdparty/jar/lwjgl_util_applet.jar;3rdparty/jar/lwjgl.jar;3rdparty/jar/minlog-none-1.2.jar;3rdparty/jar/jsonbeans-0.5.jar;3rdparty/jar/jogg-0.0.7.jar;3rdparty/jar/jorbis-0.0.15.jar;3rdparty/jar/ibxm.jar ";
	#endif
	strcat(cmd2, cmd);
	puts(cmd2);
	system(cmd2);
}
