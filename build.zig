const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(std.Target.Query{
        .cpu_arch = .xtensa,
        .cpu_model = .{ .explicit = &std.Target.xtensa.cpu.esp32 },
        .os_tag = .freestanding,
    });
    const optimize = b.standardOptimizeOption(.{});

    // const mod = b.addModule("foo", .{
    //     .root_source_file = b.path("src/root.zig"),
    //     .target = target,
    // });

    const exe = b.addExecutable(.{
        .name = "esp32-zig-baremetal",
        .root_module = b.createModule(.{
            .root_source_file = b.path("examples/blinky/start.zig"),
            .target = target,
            .optimize = optimize,
            // .imports = &.{
            //     .{ .name = "foo", .module = mod },
            // },
        }),
        .use_llvm = true,
    });

    exe.setLinkerScript(b.path("esp32/link.ld"));

    b.installArtifact(exe);

    const tty = b.option(
        []const u8,
        "tty",
        "Specify the port to which the ESP32 is connected (defaults to /dev/ttyUSB0)",
    ) orelse "/dev/ttyUSB0";

    const bin_path = b.getInstallPath(.{ .custom = exe.installed_path orelse "./bin" }, exe.out_filename);
    std.debug.print("Binary will be installed to: {s}\n", .{bin_path});

    const upload_step = b.step("upload", "Upload the code to an Arduino device using espflash");
    const upload_cmd = b.addSystemCommand(&.{
        "espflash",
        "flash",
        "-c",
        "esp32",
        "-p",
        tty,
        bin_path,
    });
    upload_step.dependOn(&upload_cmd.step);
    upload_cmd.step.dependOn(&exe.step);

    // run_cmd.step.dependOn(b.getInstallStep());

    const monitor_step = b.step("monitor", "Opens a monitor to the serial output");
    const monitor_cmd = b.addSystemCommand(&.{
        "espflash",
        "monitor",
        tty,
    });
    monitor_step.dependOn(&monitor_cmd.step);
}
