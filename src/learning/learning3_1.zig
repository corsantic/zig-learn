const std = @import("std");

// dangling pointers
pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();

    // User -> *const User
    var lookup = std.StringHashMap(*const User).init(allocator);
    defer lookup.deinit();

    const goku = User{ .power = 9001 };

    // goku -> &goku
    try lookup.put("Goku", &goku);

    // returns an optional, .? would panic if "Goku"
    // wasn't in our hashmap
    // getPtr -> get
    const entry = lookup.get("Goku").?;

    std.debug.print("Goku's power is: {d}\n", .{entry.power});

    // returns true/false depending on if the item was removed
    _ = lookup.remove("Goku");

    std.debug.print("Goku's power is: {d}\n", .{entry.power});
}

const User = struct {
    power: i32,
};
