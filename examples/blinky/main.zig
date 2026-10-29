const gpio = @import("../../esp32/gpio.zig");
const delay = @import("../../esp32/delay.zig");

pub fn main() noreturn {
    const led_pin: gpio.output_pins = .GPIO18;
    gpio.setOutput(led_pin);

    while (true) {
        gpio.write(led_pin, true);
        delay.delayMilliseconds(500);
        gpio.write(led_pin, false);
        delay.delayMilliseconds(500);
    }

}
