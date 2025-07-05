use v6;

use NativeCall;

our      &notcurses       is export = sub { 'libnotcurses-core.so.3' }
constant notcurses-export is export = './libnotcurses-static.so';

constant NCPALETTESIZE is export = 256;

constant wchar_t is export := uint32;

class ncfadectx  is repr<CPointer> is export { }
class ncmenu     is repr<CPointer> is export { }
class ncplane    is repr<CPointer> is export { }
class ncprogbar  is repr<CPointer> is export { }
class ncreader   is repr<CPointer> is export { }
class ncvisual   is repr<CPointer> is export { }
class notcurses  is repr<CPointer> is export { }

class timespec is repr<CStruct> is export {
  has int64 $.tv_sec  is rw;
  has int64 $.tv_nsec is rw;
}

constant NCPROGBAR_OPTION_RETROGRADE is export = 1;
