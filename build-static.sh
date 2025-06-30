gcc -g static.c -fPIC -shared -o libnotcurses-static.so -I../notcurses/src -I/usr/include/notcurses `pkg-config --cflags notcurses-core` -lnotcurses-core

