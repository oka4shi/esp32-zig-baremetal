const registers = enum (usize) {
    DPORT = 0x3ff00000,
    AES = 0x3ff01000,
    RSA = 0x3ff02000,
    SHA = 0x3ff03000,
    FLASH_MMU_TABLE_PRO = 0x3ff10000,
    FLASH_MMU_TABLE_APP = 0x3ff12000,
    DPORT_END = 0x3ff13FFC,
    UART0 = 0x3ff40000,
    SPI1 = 0x3ff42000,
    SPI0 = 0x3ff43000,
    GPIO = 0x3ff44000,
    GPIO_SD = 0x3ff44f00,
    FE2 = 0x3ff45000,
    FE = 0x3ff46000,
    FRC_TIMER = 0x3ff47000,
    RTCCNTL = 0x3ff48000,
    RTCIO = 0x3ff48400,
    SENS = 0x3ff48800,
    RTC_I2C = 0x3ff48C00,
    IO_MUX = 0x3ff49000,
    HINF = 0x3ff4B000,
    UHCI1 = 0x3ff4C000,
    I2S = 0x3ff4F000,
    UART1 = 0x3ff50000,
    BT = 0x3ff51000,
    I2C_EXT = 0x3ff53000,
    UHCI0 = 0x3ff54000,
    SLCHOST = 0x3ff55000,
    RMT = 0x3ff56000,
    PCNT = 0x3ff57000,
    SLC = 0x3ff58000,
    LEDC = 0x3ff59000,
    EFUSE = 0x3ff5A000,
    SPI_ENCRYPT = 0x3ff5B000,
    NRX = 0x3ff5CC00,
    BB = 0x3ff5D000,
    PWM = 0x3ff5E000,
    TIMERGROUP0 = 0x3ff5F000,
    TIMERGROUP1 = 0x3ff60000,
    RTCMEM0 = 0x3ff61000,
    RTCMEM1 = 0x3ff62000,
    RTCMEM2 = 0x3ff63000,
    SPI2 = 0x3ff64000,
    SPI3 = 0x3ff65000,
    SYSCON = 0x3ff66000,
    APB_CTRL = 0x3ff66000,  // Old name for SYSCON, to be removed
    I2C1_EXT = 0x3ff67000,
    SDMMC = 0x3ff68000,
    EMAC = 0x3ff69000,
    CAN = 0x3ff6B000,
    PWM1 = 0x3ff6C000,
    I2S1 = 0x3ff6D000,
    UART2 = 0x3ff6E000,
    PWM2 = 0x3ff6F000,
    PWM3 = 0x3ff70000,

    GPIO_ENABLE = 0x0018,
};


pub inline fn get(name: registers) [*]volatile u32 {
    return @ptrFromInt(registers[name]);
}

pub inline fn fromInt(addr: usize) *volatile u32 {
    return @ptrFromInt(addr);
}
