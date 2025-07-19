// pseudo code for arena allocator
//

// this is current approach
fn parse(allocator: Allocator, input: []const u8) !Something {
    const state = State{
        .buf = try allocator.alloc(u8, 512),
        .nesting = try allocator.alloc(NestType, 10),
    };
    defer allocator.free(state.buf);
    defer allocator.free(state.nesting);

    return parseInternal(allocator, state, input);
}

// this the arena allocator approach
// we dont need to call free or destroy
// becase arena allocators deinit will release everything
fn parse(allocator: Allocator, input: []const u8) !Something {
    // create an ArenaAllocator from the supplied allocator
    var arena = std.heap.ArenaAllocator.init(allocator);

    // this will free anything created from this arena
    defer arena.deinit();

    // create an std.mem.Allocator from the arena, this will be
    // the allocator we'll use internally
    const aa = arena.allocator();

    const state = State{
        // we're using aa here!
        .buf = try aa.alloc(u8, 512),

        // we're using aa here!
        .nesting = try aa.alloc(NestType, 10),
    };

    // we're passing aa here, so we're guaranteed that
    // any other allocation will be in our arena
    return parseInternal(aa, state, input);
}
