const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();

    // ** The next two lines are the important ones **
    var arr = try allocator.alloc(usize, try getRandomCount());

    // defer which executes the given code, or block, on scope exit
    // A relative of defer is errdefer which similarly executes the given code or block on scope exit,
    // but only when an error is returned.
    // also dont free same memory twice!
    defer allocator.free(arr);

    for (0..arr.len) |i| {
        arr[i] = i;
    }
    std.debug.print("{any}\n", .{arr});
}

fn getRandomCount() !u8 {
    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));
    var random = std.Random.DefaultPrng.init(seed);
    return random.random().uintAtMost(u8, 5) + 5;
}
