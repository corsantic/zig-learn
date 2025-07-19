const std = @import("std");

pub fn main() !void {
    // if we change this to lower value we can get a OutOfMemory error
    var buf: [270]u8 = undefined;

    var fa = std.heap.FixedBufferAllocator.init(&buf);

    defer fa.reset();

    const allocator = fa.allocator();

    const json = try std.json.stringifyAlloc(allocator, .{ .this_is = "an anonymous struct", .above = true, .last_param = "are options" }, .{ .whitespace = .indent_2 });

    // We can free this allocation, but since we know that our allocator is
    // a FixedBufferAllocator, we can rely on the above `defer fa.reset()`
    defer allocator.free(json);

    std.debug.print("{s}\n", .{json});

    // buffPrint test
    // bufPrint takes buffer instead of allocator
    const name = "Leto";

    var stdBuf: [100]u8 = undefined;
    const greeting = try std.fmt.bufPrint(&stdBuf, "Hello {s}", .{name});

    std.debug.print("{s}\n", .{greeting});

    // alternative for first example stringifyAlloc
    const out = std.io.getStdOut();

    try std.json.stringify(.{
        .this_is = "an anonymous struct",
        .above = true,
        .last_param = "are options",
    }, .{ .whitespace = .indent_2 }, out.writer());
}
