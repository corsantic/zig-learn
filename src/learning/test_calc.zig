
const calc = @import("calc"); 
const std = @import("std");

pub fn main() !void {

    const calc_res: u32= calc.add(3,2); 

    std.debug.print("{d}", .{calc_res});
}
