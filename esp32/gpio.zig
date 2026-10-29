const registers = @import("registers.zig");

pub const output_pins = enum(u32) {
    GPIO0 = 0,
    GPIO1 = 1,
    GPIO2 = 2,
    GPIO3 = 3,
    GPIO4 = 4,
    GPIO5 = 5,
    GPIO6 = 6,
    GPIO7 = 7,
    GPIO8 = 8,
    GPIO9 = 9,
    GPIO10 = 10,
    GPIO11 = 11,
    GPIO12 = 12,
    GPIO13 = 13,
    GPIO14 = 14,
    GPIO15 = 15,
    GPIO16 = 16,
    GPIO17 = 17,
    GPIO18 = 18,
    GPIO19 = 19,
    GPIO21 = 21,
    GPIO22 = 22,
    GPIO23 = 23,
    GPIO25 = 25,
    GPIO26 = 26,
    GPIO27 = 27,
    GPIO32 = 32,
    GPIO33 = 33,
};

const reg = enum(u8) {
    GPIO_OUT = 0x0004,
    GPIO_OUT_W1TS = 0x008,
    GPIO_OUT_W1TC = 0x000c,
    GPIO_OUT1 = 0x0010,
    GPIO_OUT1_W1TS = 0x0014,
    GPIO_OUT1_W1TC = 0x0018,
    GPIO_ENABLE = 0x0020,
    GPIO_ENABLE_W1TS = 0x0024,
    GPIO_ENABLE_W1TC = 0x0028,
    GPIO_ENABLE1 = 0x002c,
    GPIO_ENABLE1_W1TS = 0x0030,
    GPIO_ENABLE1_W1TC = 0x0034,
    GPIO_STRAP = 0x0038,
    GPIO_IN = 0x003c,
    GPIO_IN1 = 0x0040,
    GPIO_STATUS = 0x0044,
    GPIO_STATUS_W1TS = 0x0048,
    GPIO_STATUS_W1TC = 0x004c,
    GPIO_STATUS1 = 0x0050,
    GPIO_STATUS1_W1TS = 0x0054,
    GPIO_STATUS1_W1TC = 0x0058,
    GPIO_ACPU_INT = 0x0060,
    GPIO_ACPU_NMI_INT = 0x0064,
    GPIO_PCPU_INT = 0x0068,
    GPIO_PCPU_NMI_INT = 0x006c,
    GPIO_ACPU_INT1 = 0x0074,
    GPIO_ACPU_NMI_INT1 = 0x0078,
    GPIO_PCPU_INT1 = 0x007c,
    GPIO_PCPU_NMI_INT1 = 0x0080,
};

pub fn setOutput(pin: output_pins) void {
    registers.get(.GPIO)[0x530 + 0x4 * pin] = 0x100; // set GPIO_FUNCn_OUT_SEL as simple GPIO output

    // Set the pin as output
    if (pin < 32) {
        registers.get(.GPIO)[reg.GPIO_ENABLE] |= 1 << pin;
    } else {
        registers.get(.GPIO)[reg.GPIO_ENABLE1] |= 1 << (pin - 31);
    }
}

pub fn write(pin: output_pins, value: bool) void {
    if (pin < 32) {
        registers.get(.GPIO)[reg.GPIO_OUT] &= ~(1 << pin);
        registers.get(.GPIO)[reg.GPIO_OUT] |= ((if (value) 1 else 0) << pin);
    } else {
        registers.get(.GPIO)[reg.GPIO_OUT1] &= ~(1 << (pin - 31));
        registers.get(.GPIO)[reg.GPIO_OUT1] |= ((if (value) 1 else 0) << (pin - 31));
    }
}
