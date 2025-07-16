const std = @import("std");
pub fn main() !void {
    const save = (try Save.loadLast()) orelse Save.blank();

    std.debug.print("{any}\n", .{save});

    // Error handling
    return doSomething();

    // we can let the zig create error sets for us
    // return error.AccessDenied;
}

const OpenError = error{ AccessDenied, NotFound };

fn doSomething() OpenError!void {
    const b: u8 = 3;

    if (b % 2 != 0) {
        return OpenError.NotFound;
    }
}

// for `anyerror` in zig
pub const Save = struct {
    lives: u8,
    level: u16,

    pub fn loadLast() !?Save {
        //todo
        return null;
    }

    pub fn blank() Save {
        return .{
            .lives = 3,
            .level = 1,
        };
    }
};
