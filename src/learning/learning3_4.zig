const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}).init;
    const allocator = gpa.allocator();

    var out = std.ArrayList(u8).init(allocator);
    defer out.deinit();

    try std.json.stringify(.{ .this_is = "an anonymous struct", .above = true, .last_param = "are options" }, .{ .whitespace = .indent_2 }, out.writer());

    std.debug.print("{any}\n", .{out.items});
}
