[![Risingear](https://risingear.com/images/risingear_logo.png "Risingear")](http://risingear.com "Risingear")

# **An SDK for a cross-platform moddable online multiplayer game engine**


### [Project Homepage](http://risingear.com "Project Website")


### Features

- **Traditional Client/Server Online Multiplayer**
  - Host or connect to others' games and enjoy a fully customizible online multiplayer experience. Uses TCP and UDP sockets for reliable and rapid client/server messaging respectively; this is all powered by [KryoNet](https://github.com/EsotericSoftware/kryonet "KryoNet")
- **2D Rigid Body Dynamics**
  - Risingear implements and exposes a physics engine based on [JBox2D](http://www.jbox2d.org/ "JBox2D"). This provides functionality for realistic collisions and movement of objects.
- **Scripting**
  - All game code is written in Lua ([LuaJ](https://github.com/luaj/luaj "LuaJ")). It is moddable with a provided [LDT Eclipse](https://www.eclipse.org/ldt/ "LDT Eclipse") API for client and server functions necessary to build and host a custom game!
- **Runs on all desktop OSes**
  - Risingear runs on desktop Java 11. Play on Windows, Linux or MacOS!
*Android is in the works!*

### Instructions

 - Download the GitHub code as a .zip file
 - Extract the entirety of the .zip file's contents into a new folder
 - Run `launcher.exe` with any applicable startup parameters (cmdproc)
   - Run or see the contents of `dev.bat` in order to understand how startup params work as commands and/or start the game in developer mode with a console, a visible editor button in the main menu, etc.

### To Do
 - Android support with GLES renderer implementation
 - SVG support implemented into GUI and perhaps generally graphics (texture?)
 - Hardcore optimization (I.e. LuaJ compiling, persist Lua table lookup workarounds to avoid serious CPU usage, etc.)
 - Server downloads (as of yet, you must test on client and server end by copying the mod directory files yourself)
 - *Much, much more to be posted!*

### Licensing
##### Currently, this engine is not licensed for commercial use by default. Having said that, you are free to contact and inquire using the [project webpage contact form](https://risingear.com/#contact "project webpage contact form")
