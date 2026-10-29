const main = @import("main.zig");
const init = @import("../../esp32/init.zig");

extern var _sbss: u8;
extern var _ebss: u8;
extern var _end: u8;
extern var _eram: u8;

var s_heap_start = &_end;
var s_brk = &_end;
var s_heap_end = &_eram;

pub export fn _start () noreturn {
    var p = &_sbss;
    while (@intFromPtr(p) < @intFromPtr(_ebss)) : (p += 1) {
        p.* = 0;
    }

    init.socInit();

    main.main();

    while (true) {}
    
}
