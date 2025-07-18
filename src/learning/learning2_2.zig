const std = @import("std");

pub fn main() void {
    const user1 = User.init(1, 10);
    const user2 = User.init(2, 20);

    std.debug.print("User {d} has power of {d}\n", .{ user1.id, user1.power });
    std.debug.print("User {d} has power of {d}\n", .{ user2.id, user2.power });
}

pub const User = struct {
    id: u64,
    power: i32,
    // The key problem with this code is that User.init returns the address of the local user, &user.
    // This is called a dangling pointer, a pointer that references invalid memory.
    // It's the source of many segfaults
    fn init(id: u64, power: i32) *User {
        var user = User{
            .id = id,
            .power = power,
        };
        return &user;
    }

    // our return type changed, since init can now fail
    // *User -> !*User
    fn initWithCreate(allocator: std.mem.Allocator, id: u64, power: i32) !*User {
        const user = try allocator.create(User);
        // user.* is how we derefence a pointer
        // create returns !*T is this example !*User
        // & takes a T and gives us *T. .* is the opposite, applied to a value of type *T it gives us T
        user.* = .{
            .id = id,
            .power = power,
        };
        return user;
    }
};
