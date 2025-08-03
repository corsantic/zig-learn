const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const path = b.path("src/learning/learning3_3.zig");
    const calc_module = b.addModule("calc", .{
        .root_source_file = b.path("learning/calculation/calc.zig"),
    });

    {
        // setup executable
        const exe = b.addExecutable(.{
            .name = "learning",
            .target = target,
            .optimize = optimize,
            .root_source_file = (path),
        });
        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());

        const run_step = b.step("run", "Start learning!");
        run_step.dependOn(&run_cmd.step);
    }
    {
        // setup our "test" command
        const tests = b.addTest(.{
            .target = target,
            .optimize = optimize,
            .root_source_file = (path),
        });

        tests.root_module.addImport("calc", calc_module);

        const test_cmd = b.addRunArtifact(tests);
        test_cmd.step.dependOn(b.getInstallStep());
        const test_step = b.step("test", "Run the tests");
        test_step.dependOn(&test_cmd.step);
    }
}
