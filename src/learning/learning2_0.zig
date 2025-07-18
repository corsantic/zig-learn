const std = @import("std");

pub fn main() void {
    var name = [4]u8{ 'G', 'o', 'k', 'u' };
    const user = OtherUser{
        .id = 1,
        .power = 100,
        // slice it, [4]u8 -> []u8
        .name = name[0..],
    };
    levelUp(user);
    std.debug.print("{s}\n", .{user.name});
}

fn levelUp(user: OtherUser) void {
    user.name[2] = '!';
}

pub const OtherUser = struct {
    id: u64,
    power: i32,
    // []const u8 -> []u8
    name: []u8,
};

// main: user ->    -------------  (id: 1043368d0)
//                  |     1     |
//                  -------------  (power: 1043368d8)
//                  |    100    |
//                  -------------  (name.len: 1043368dc)
//                  |     4     |
//                  -------------  (name.ptr: 1043368e4)
//                  | 1182145c0 |-------------------------
// levelUp: user -> -------------  (id: 1043368ec)       |
//                  |     1     |                        |
//                  -------------  (power: 1043368f4)    |
//                  |    100    |                        |
//                  -------------  (name.len: 1043368f8) |
//                  |     4     |                        |
//                  -------------  (name.ptr: 104336900) |
//                  | 1182145c0 |-------------------------
//                  -------------                        |
//                                                       |
//                  .............  empty space           |
//                  .............  or other data         |
//                                                       |
//                  -------------  (1182145c0)        <---
//                  |    'G'    |
//                  -------------
//                  |    'o'    |
//                  -------------
//                  |    'k'    |
//                  -------------
//                  |    'u'    |
//                  -------------
