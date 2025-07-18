const std = @import("std");

pub fn main() void {
    const ken = User{ .id = 1, .power = 999, .manager = null };

    // changed from ken => &ken
    // using a pointer means our manager is no longer tied to the `user`'s memory layout.
    const ryu = User{ .id = 2, .power = 404, .manager = &ken };

    std.debug.print("{any}\n{any}\n", .{ ken, ryu });
}

pub const User = struct {
    id: u64,
    power: i32,
    // changed from ?const User -> ?*const User
    manager: ?*const User,
};
