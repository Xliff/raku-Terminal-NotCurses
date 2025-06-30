use v6;

use NativeCall;

our      &notcurses       is export = sub { 'libnotcurses-core.so.3' }
constant notcurses-export is export = './libnotcurses-static.so';

constant NCPALETTESIZE is export = 256;

constant wchar_t is export := uint32;

class ncfadectx is repr<CPointer> is export { }
class ncmenu    is repr<CPointer> is export { }
class ncplane   is repr<CPointer> is export { }
class ncvisual  is repr<CPointer> is export { }
class notcurses is repr<CPointer> is export { }

class timespec is repr<CStruct> is export {
  has int64 $.tv_sec  is rw;
  has int64 $.tv_nsec is rw;
}

constant nccboxmask_e is export := uint32;
our enum ncboxmask_e_enum is export (
  NCBOXMASK_TOP     => 0x0001,
  NCBOXMASK_RIGHT   => 0x0002,
  NCBOXMASK_BOTTOM  => 0x0004,
  NCBOXMASK_LEFT    => 0x0008,
  NCBOXGRAD_TOP     => 0x0010,
  NCBOXGRAD_RIGHT   => 0x0020,
  NCBOXGRAD_BOTTOM  => 0x0040,
  NCBOXGRAD_LEFT    => 0x0080,
  NCBOXCORNER_MASK  => 0x0300,
  NCBOXCORNER_SHIFT => 8
);
