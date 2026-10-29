const timer = @import("timer.zig");

pub fn delayMicroseconds(us: u32) void {
    timer.configTimer(.GROUP0, .TIMER0, .{
        .increase = true,
        .autoreload = false,
        .divider = 80, // 1 MHz (80 MHz / 80)
    });
    timer.startTimer(.GROUP0, .TIMER0, 0);

    while (timer.readTimer(.GROUP0, .TIMER0) < us) {
        asm volatile ("nop");
    }

    timer.stopTimer(.GROUP0, .TIMER0);
}

pub fn delayMilliseconds(ms: u32) void {
    delayMicroseconds(ms * 1000);
}
