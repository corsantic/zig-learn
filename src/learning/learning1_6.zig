const std = @import("std");
pub fn main() void {
    // null values
    const home: ?[]const u8 = null;
    const name: ?[]const u8 = "chuck norris";
    const h = home orelse "homefallback";
    const n = name orelse "namefallback";

    std.debug.print("home: {s}\n", .{h});
    std.debug.print("name: {s}\n", .{n});

    if (home) |ho| {
        std.debug.print("{s}\n", .{ho});
    } else {
        std.debug.print("home is null\n", .{});
    }
}
