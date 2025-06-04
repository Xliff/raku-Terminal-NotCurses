echo "
#include <time.h>             
#include <ctype.h>            
#include <wchar.h>            
#include <stdio.h>            
#include <stdint.h>           
#include <stdlib.h>           
#include <stdarg.h>           
#include <string.h>           
#include <signal.h>           
#include <limits.h>           
#include <stdbool.h>          
#include <notcurses/notcurses.h>
" > preamble

raku -Iscripts create-exports.raku


