const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};

    const allocator = gpa.allocator();
    // Create a User on the heap
    var user = try allocator.create(User);

    defer allocator.destroy(user);

    user.id = 1;
    user.power = 999;
    levelUp(user);
    std.debug.print("{any}\n", .{user});
}

fn levelUp(user: *User) void {
    user.power += 1;
}
pub const User = struct {
    id: u64,
    power: i32,
};
