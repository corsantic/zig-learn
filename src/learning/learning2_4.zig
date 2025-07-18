const std = @import("std");
const Allocator = std.mem.Allocator;

// This is a example struct about errdefer
// errdefer here used as a guard
// if history initialization fails
// allocator will free the players from memory

pub const Game = struct {
    players: []Player,
    history: []Move,
    allocator: Allocator,

    fn init(allocator: Allocator, player_count: usize) !Game {
        const players = try allocator.alloc(Player, player_count);
        errdefer allocator.free(players);

        // store 10 most recent moves per player
        const history = try allocator.alloc(Move, player_count * 10);

        return .{
            .players = players,
            .history = history,
            .allocator = allocator,
        };
    }

    fn deinit(game: Game) void {
        const allocator = game.allocator;
        allocator.free(game.players);
        allocator.free(game.history);
    }
};

const Player = struct {};

const Move = struct {};
