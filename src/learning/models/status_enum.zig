pub const Status = enum {
    tentative,
    pending,
    confirmed,
    err,

    pub fn isComplete(self: Status) bool {
        return self == .confirmed or self == .err;
    }
};
