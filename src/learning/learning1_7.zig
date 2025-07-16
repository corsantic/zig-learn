const std = @import("std");
pub fn main() void {

    // undefined to fill it later
    var pseudo_uuid: [16]u8 = undefined;

    std.crypto.random.bytes(&pseudo_uuid);
    //The above still creates an array of 16 bytes, but leaves the memory uninitialized.
}
