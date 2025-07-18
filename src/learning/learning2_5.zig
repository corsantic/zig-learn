// memory leak example
//

const std = @import("std");
const Allocator = std.mem.Allocator;

fn allocLower(allocator: Allocator, str: []const u8) ![]const u8 {
    var dest = try allocator.alloc(u8, str.len);

    for (str, 0..) |c, i| {
        dest[i] = switch (c) {
            'A'...'Z' => c + 32,
            else => c,
        };
    }

    return dest;
}

// This is a memory leak. The memory created in allocLower is never freed.
// Not only that, but once isSpecial returns, it can never be freed.
// For this specific code, we should have used std.ascii.eqlIgnoreCase
fn isSpecial(allocator: Allocator, name: []const u8) !bool {
    const lower = try allocLower(allocator, name);
    return std.mem.eql(u8, lower, "admin");
}
