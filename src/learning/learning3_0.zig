const std = @import("std");

const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}).init;
    const allocator = gpa.allocator();

    var list = try List(u32).init(allocator);

    defer list.deinit();

    for (0..10) |value| {
        try list.add(@intCast(value));
    }
    std.debug.print("{any}\n", .{list.items[0..list.pos]});
}

fn List(comptime T: type) type {
    return struct {
        pos: usize,
        items: []T,
        allocator: Allocator,

        // we can use this instead of List(T)
        const Self = @This();

        fn deinit(self: Self) void {
            self.allocator.free(self.items);
        }

        fn init(allocator: Allocator) !Self {
            return .{
                .pos = 0,
                .allocator = allocator,
                .items = try allocator.alloc(T, 4),
            };
        }

        fn add(self: *Self, value: T) !void {
            const pos = self.pos;
            const len = self.items.len;

            if (pos == len) {
                // we've run out of space
                // create a new slice that's twice as large
                var larger = try self.allocator.alloc(T, len * 2);

                @memcpy(larger[0..len], self.items);

                self.allocator.free(self.items);

                self.items = larger;
            }
            self.items[pos] = value;
            self.pos = pos + 1;
        }
    };
}
