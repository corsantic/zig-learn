const std = @import("std");
const Allocator = std.mem.Allocator;
const builtin = @import("builtin");

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}).init;

    const allocator = gpa.allocator();

    var userLookup = try Lookup(User).init(allocator);
    // replacing this because it causes memory leaks.
    // We need to free keys ourselves
    // defer lookup.deinit();
    defer userLookup.deinit();
    // stdin is a std.io.Reader
    // the opposite of an std.io.Writer, which we already use
    const stdin = std.io.getStdIn().reader();
    // stdout is a std.io.Writer
    const stdout = std.io.getStdOut().writer();

    try processInput(stdin, stdout, &userLookup);

    try userLookup.printHashMap();
    const has_leto = userLookup.contains("Leto");
    std.debug.print("{any}\n", .{has_leto});
}

fn processInput(stdin: anytype, stdout: anytype, userLookup: *Lookup(User)) !void {
    var i: i32 = 0;
    while (true) : (i += 1) {
        var buf: [30]u8 = undefined;
        try stdout.print("Please enter a name: ", .{});

        if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            var name = line;

            if (builtin.os.tag == .windows) {
                //in windows lines are terminated by \r\n
                //we need to strip out the \r
                name = @constCast(std.mem.trimRight(u8, name, "\r"));
            }
            if (name.len == 0) {
                break;
            }
            // replace the existing lookup.put with these two lines
            const owned_name = try userLookup.dupe(name);
            // name -> owned_name
            try userLookup.put(owned_name, .{ .power = i });
            // try userLookup.lookup.put(owned_name, .{ .power = i });
        }
    }
}

const User = struct {
    power: i32,
};

fn Lookup(comptime T: type) type {
    return struct {
        allocator: Allocator,
        hash_map: std.StringHashMap(T),
        const Self = @This();

        fn init(allocator: Allocator) !Self {
            return .{ .hash_map = std.StringHashMap(T).init(allocator), .allocator = allocator };
        }
        fn deinit(self: *Self) void {
            var it = self.hash_map.iterator();
            while (it.next()) |key| {
                self.allocator.free(key.key_ptr.*);
            }
            self.hash_map.deinit();
        }

        fn dupe(self: *Self, value: []const u8) ![]u8 {
            // we need to dupe the value
            // so that we can free it later
            return try self.allocator.dupe(u8, value);
        }
        fn put(self: *Self, key: []const u8, value: T) !void {
            try self.hash_map.put(key, value);
        }

        fn contains(self: *Self, value: []const u8) !bool {
            return self.hash_map.contains(value);
        }

        fn printHashMap(self: *Self) !void {
            //for debug purposes
            var it = self.hash_map.iterator();
            while (it.next()) |kv| {
                std.debug.print("{s} == {any}\n", .{ kv.key_ptr.*, kv.value_ptr.* });
            }
            //

        }
    };
}

//tests

const testing = std.testing;

test "Lookup: put" {
    var userLookup = try Lookup(User).init(testing.allocator);
    defer userLookup.deinit();

    const test_name = "test";

    const owned_name = try userLookup.dupe(test_name);
    try userLookup.put(owned_name, .{ .power = 1 });

    try testing.expectEqual(@as(User, .{ .power = 1 }), userLookup.hash_map.get(test_name));
}

test "Lookup: dupe" {
    var userLookup = try Lookup(User).init(testing.allocator);
    defer userLookup.deinit();

    const test_name = "test";

    const owned_name = try userLookup.dupe(test_name);

    try testing.expectEqualSlices(u8, "test", owned_name);

    //free duped value
    userLookup.allocator.free(owned_name);
}

test "Lookup: contains" {
    var userLookup = try Lookup(User).init(testing.allocator);
    defer userLookup.deinit();

    const test_name = "test";

    const owned_name = try userLookup.dupe(test_name);
    try userLookup.put(owned_name, .{ .power = 1 });

    try testing.expect(try userLookup.contains("test"));
}

test "main: processInput" {
    // Arrange
    const input = "Chuck\nAlice\nLeto\n\n";
    var reader_stream = std.io.fixedBufferStream(input);
    const reader = reader_stream.reader().any();

    var output_buffer: [128]u8 = undefined;
    var output_stream = std.io.fixedBufferStream(&output_buffer);
    const writer = output_stream.writer().any();

    var userLookup = try Lookup(User).init(testing.allocator);
    defer userLookup.deinit();

    try processInput(reader, writer, &userLookup);

    try testing.expect(userLookup.hash_map.contains("Chuck"));
    try testing.expect(userLookup.hash_map.contains("Alice"));
    try testing.expect(userLookup.hash_map.contains("Leto"));
}

