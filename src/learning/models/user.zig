const std = @import("std");
pub const MAX_POWER: u64 = 100_100;

pub const User = struct {
    power: u64,
    name: []const u8,

    pub const SUPER_POWER: u64 = 9000;

    pub fn init(power: u64, name: []const u8) User {
        return User{ .name = name, .power = power };
    }

    pub fn diagnose(user: User) void {
        if (user.power >= SUPER_POWER) {
            std.debug.print("{s}'s power is above: {d}!\n", .{ user.name, SUPER_POWER });
        }
    }
};
