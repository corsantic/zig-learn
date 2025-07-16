const std = @import("std");

pub fn main() void {
    const x = add(5, 6);
    std.debug.print("The sum of 5 and 6 is: {d}\n", .{x});
}
fn add(a: i32, b: i32) i32 {
    return a + b;
}
