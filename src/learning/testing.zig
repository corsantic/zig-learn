const std = @import("std");
const builtin = @import("builtin");
pub fn main() !void {
    std.debug.print("os: {any}\n", .{builtin.os.tag});
}
