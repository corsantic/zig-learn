const std = @import("std");
pub fn main() void {
    const ts = Timestamp{ .unix = 1693278411 };
    std.debug.print("{d}\n", .{ts.seconds()});

    const dt = Timestamp{ .datetime = Timestamp.DateTime{ .year = 2025, .month = 5, .day = 1, .hour = 11, .minute = 58, .second = 1 } };

    std.debug.print("{d}\n", .{dt.seconds()});
}
const TimestampType = enum {
    unix,
    datetime,
};
// tagged union
const Timestamp = union(TimestampType) {
    unix: i32,
    datetime: DateTime,

    const DateTime = struct {
        year: u16,
        month: u8,
        day: u8,
        hour: u8,
        minute: u8,
        second: u8,
    };

    fn seconds(self: Timestamp) u16 {
        switch (self) {
            .datetime => |dt| return dt.second,
            .unix => |ts| {
                const seconds_since_midnight: i32 = @rem(ts, 86400);
                return @intCast(@rem(seconds_since_midnight, 60));
            },
        }
    }
};
