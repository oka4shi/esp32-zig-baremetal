const registers = @import("registers.zig");

const group = enum(comptime_int) {
    GROUP0,
    GROUP1,
};

const timer = enum(u8) {
    TIMER0 = 0,
    TIMER1 = 1,
};

const regs = enum(u8) {
};

pub const Config = struct {
    increase: bool,
    autoreload: bool,
    divider: u16,
};

pub fn config(g: group, t: timer, cfg: Config) void {
    const reg = switch (g) {
        .GROUP0 => registers.get(.TIMERGROUP0),
        .GROUP1 => registers.get(.TIMERGROUP1),
    };

    // TIMGn_TxCONFIG
    reg[0x0 + 0x24 * t] =  (if (cfg.increase) 1 << 30 else 0) |
                          (if (cfg.autoreload) 1 << 29 else 0) |
                          (cfg.divider << 13);
}

pub fn start(g: group, t: timer, init: u64) void {
    const reg = switch (g) {
        .GROUP0 => registers.get(.TIMERGROUP0),
        .GROUP1 => registers.get(.TIMERGROUP1),
    };

    // TIMGn_TxLOADLO
    reg[0x4 + 0x24 * t] = @truncate(init);
    // TIMGn_TxLOADHI
    reg[0x8 + 0x24 * t] = @truncate(init >> 32);

    // TIMGn_TxCONFIG (enable)
    reg[0x0 + 0x24 * t] |= 1 << 31;
}

pub fn stop(g: group, t: timer) void {
    const reg = switch (g) {
        .GROUP0 => registers.get(.TIMERGROUP0),
        .GROUP1 => registers.get(.TIMERGROUP1),
    };

    // TIMGn_TxCONFIG (disable)
    reg[0x0 + 0x24 * t] &= ~(1 << 31);
}

pub fn read(g: group, t: timer) u64 {
    const reg = switch (g) {
        .GROUP0 => registers.get(.TIMERGROUP0),
        .GROUP1 => registers.get(.TIMERGROUP1),
    };

    // TIMGn_TxUPDATE
    reg[0x10 + 0x24 * t] = 1;

    return get_and_join: {
        // TIMGn_TxLO
        const lo = reg[0x4 + 0x24 * t];
        // TIMGn_TxHI
        const hi = reg[0x8 + 0x24 * t];
        break :get_and_join (@as(u64, hi) << 32 | @as(u64, lo));
    };
}
