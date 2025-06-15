use v6;

use NativeCall;

our      &notcurses       is export = sub { 'libnotcurses-core.so.3' }
constant notcurses-export is export = './libnotcurses-static.so';

constant NCPALETTESIZE is export = 256;

constant wchar_t is export := uint64;

class notcurses is repr<CPointer> is export { }
class ncplane   is repr<CPointer> is export { }
class ncfadectx is repr<CPointer> is export { }
class ncvisual  is repr<CPointer> is export { }

class timespec is repr<CStruct> is export {
  # cw: Signed my ass!
  has uint64 $.tv_sec  is rw;
  has uint64 $.tv_nsec is rw;
}
