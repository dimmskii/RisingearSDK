#include <stdio.h>
#include <string.h>
#include "platform.h"

void laun_exec(const char* cmd) {
	char cmd2[32768] = "java -classpath jar/risingear.min.jar:3rdparty/jar/luaj-jse-3.0.2.jar:3rdparty/jar/asm-4.0.jar:3rdparty/jar/kryo-5.6.2.jar:3rdparty/jar/kryonet-2.22.9.jar:3rdparty/jar/objenesis-3.2.jar:3rdparty/jar/reflectasm-1.11.9.jar:3rdparty/jar/jinput.jar:3rdparty/jar/lwjgl_util.jar:3rdparty/jar/lwjgl_util_applet.jar:3rdparty/jar/lwjgl.jar:3rdparty/jar/minlog-1.3.1.jar:3rdparty/jar/jsonbeans-0.9.jar:3rdparty/jar/jogg-0.0.7.jar:3rdparty/jar/jorbis-0.0.15.jar ";
	strcat(cmd2, cmd);
	puts(cmd2);
	system(cmd2);
}

