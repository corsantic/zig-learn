const std = @import("std");
const Status = @import("models/status_enum.zig").Status;

pub fn main() void {
    var confirmedStatus: Status = Status.pending;

    std.debug.print("first status: {s}\n", .{@tagName(confirmedStatus)});
    std.debug.print("is completed status: {}\n", .{Status.isComplete(confirmedStatus)});

    if (!Status.isComplete(confirmedStatus)) {
        confirmedStatus = Status.confirmed;

        std.debug.print("is completed status: {}\n", .{Status.isComplete(confirmedStatus)});
    }
    std.debug.print("last status: {s}\n", .{@tagName(confirmedStatus)});
}
