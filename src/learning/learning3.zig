const std = @import("std");

pub fn main() void {
    const a = [_]u32{ 1, 2, 3, 4, 5 };
    // because `end` is declared var, it isn't compiled-time known
    var end: usize = 4;

    // but because it's a `var` we need to mutate it, else the compiler
    // will insist we make it `const`.
    end += 1;
    const b = a[1..end];

    std.debug.print("{any}\n", .{@TypeOf(b)});

    rewrite();
}

// if we want to rewrite b we need set a to `var`
// A slice's type is always derived from what it is slicing.
fn rewrite() void {
    var a = [_]u32{ 1, 2, 3, 4, 5 };
    var end: usize = 4;

    end += 1;
    var b = a[1..end];

    printArr(b);
    std.debug.print("rewrite type: {any}\n", .{@TypeOf(b)});
    b[3] = 9;
    // this will give error when b is const
    b = b[2..];

    printArr(b);
}

fn printArr(arr: []u32) void {
    for (arr) |value| {
        std.debug.print("item: {d}\n", .{value});
    }
}
