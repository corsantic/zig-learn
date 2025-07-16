const std = @import("std");
pub const MAX_POWER: u64 = 100_100;

pub const User = struct {
    id: u64,
    power: u64,
    name: []const u8,

    pub const SUPER_POWER: u64 = 9000;

    pub fn init(id: u64, power: u64, name: []const u8) User {
        // instead of return User{...}
        return .{ .id = id, .name = name, .power = power };
    }
    pub fn levelUp(user: *User) void {
        user.power += 1;
    }
    pub fn diagnose(user: User) void {
        if (user.power >= SUPER_POWER) {
            std.debug.print("{s}'s power is above: {d}!\n", .{ user.name, SUPER_POWER });
        }
    }
};
