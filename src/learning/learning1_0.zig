const std = @import("std");
const user_import = @import("models/user.zig");
const User = user_import.User;
const MAX_POWER = user_import.MAX_POWER;
// This code won't compile if `main` isn't `pub` (public)
pub fn main() void {
    const chuck: User = .{
        .id = 1,
        .power = 100_00,
        .name = "Chuck Norris",
    };
    chuck.diagnose();
    const user = User.init(2, 100_00, "Goku");
    user.diagnose();
    if (user.power > MAX_POWER) {
        std.debug.print("Power exceeds maximum limit of {d}\n", .{MAX_POWER});
        return;
    }
    std.debug.print("{s}'s power is {d}\n", .{ user.name, user.power });
}
