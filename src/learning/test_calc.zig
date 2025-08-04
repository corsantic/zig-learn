const calc = @import("calc");
const std = @import("std");

pub fn main() !void {
    const sum_res: u32 = calc.add(3, 2);
    const sub_res: u32 = calc.sub(3, 2);

    std.debug.print("Sum: {d}, Sub: {d}\n", .{sum_res, sub_res});
}
