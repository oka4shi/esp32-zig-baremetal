const registers = @import("registers.zig");

pub inline fn socInit() void {
    wdtDisable();
    registers.get(.TIMERGROUP0)[0] |= 1 < 31; //Enable TIMG0
}

inline fn wdtDisable() void {
    registers.get(.RTCCNTL)[41] = 0x50d83aa1;
    wdtFeed();
    registers.get(.RTCCNTL)[35] = 0;      // Disable RTC WDT
    registers.get(.TIMERGROUP0)[18] = 0;  // Disable task WDT
    registers.get(.TIMERGROUP1)[18] = 0;  // Disable task WDT
}

inline fn wdtFeed() void {
    registers.get(.RTCCNTL)[40] |= 1 << 31;
}

inline fn cpuFreq240() void {
  // TRM 3.2.3. We must set SEL_0 = 1, SEL_1 = 2
  // *SEL_0: The vaule of register RTC_CNTL_SOC_CLK_SEL
  // *SEL_1: The vaule of register CPU_CPUPERIOD_SEL
  registers.get(.RTCCNTL)[28] |= 1.0 << 27;  // Register 31.24  SEL0 -> 1
  registers.get(.DPORT)[15] |= 2.0 << 0;     // Register 5.9    SEL1 -> 2
  registers.get(.UART0)[5] = 0x4001e0;       // UART_CLKDIV_REG
}
