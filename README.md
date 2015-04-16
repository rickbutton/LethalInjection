# Lethal-Injection

Welcome! This github repository hosts the code for Lethal-Injection, one of the most popular L4D2 Co-Op servers ever.

This project was created in order to preserve, projected, and maintain the code written by the original owner of the LI server, [Machine](http://steamcommunity.com/profiles/76561198001936748/).
After 5 years of running LI, he has given the code to the community.

## Current host

The plugin/server is currently hosted on Microsoft Azure, connect to it using the developer console:

    connect lethal.cloudapp.net

### Developing

This repository contains all plugins needed by the server, as well as the main `LI` plugin `lethal.sp`. It is currently a monolith of a file, sitting at over 20,000 lines of code.

The files in the repository are not copied into the game server folder, but are symlinked, for easy deployment (see links.txt).

**The current objective is to fully move LI over to a new server with no bugs (that didn't already exist). If you have experience with SourcePawn, let me know.**
