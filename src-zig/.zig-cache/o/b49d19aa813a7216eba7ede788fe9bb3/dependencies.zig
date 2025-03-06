pub const packages = struct {
    pub const @"../library" = struct {
        pub const build_root = "/home/soleil/Zdecimal/src-zig/../library";
        pub const build_zig = @import("../library");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "library", "../library" },
};
