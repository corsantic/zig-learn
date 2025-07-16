const std = @import("std");
const user_import = @import("models/user.zig");
const User = user_import.User;

pub fn main() void {
    var user: User = .{ .id = 1, .power = 100, .name = "Chuck" };
    // added this
    std.debug.print("main: {*}\n", .{&user});
    // if you dont send it with its reference it will create copy of the user
    levelUp(&user);
    std.debug.print("i got leveled up {d}\n", .{user.power});
    // zig method expects point so we dont need call it by reference
    user.levelUp();

    std.debug.print("i got leveled up {d}\n", .{user.power});
    std.debug.print("{*}\n{*}\n{*}\n", .{ &user, &user.id, &user.power });
}
// User -> *User
fn levelUp(user: *User) void {
    user.power += 1;
}
