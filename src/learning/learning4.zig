const std = @import("std");
pub fn main() void {
    const haystack = [_]u32{ 1, 2, 3, 4, 5, 6 };
    const needle: u32 = 5;

    const needleIndex: ?usize = indexOf(&haystack, needle);

    if (needleIndex != null) {
        std.debug.print("needleIndex: {any}\n", .{needleIndex});
    } else {
        std.debug.print("this needle cannot be found in the haystack: {any}\n", .{needle});
    }

    // while loop example
    const src = "hello\\brother\\";
    var i: usize = 0;
    var escape_count: usize = 0;

    //                  this part
    while (i < src.len) : (i += 1) {
        if (src[i] == '\\') {
            // +1 here, and +1 above == +2
            i += 1;
            escape_count += 1;
        }
    }

    std.debug.print("escape count: {any}\n", .{escape_count});
}

fn indexOf(haystack: []const u32, needle: u32) ?usize {
    for (haystack, 0..) |value, i| {
        if (value == needle)
            return i;
    }

    return null;
}
