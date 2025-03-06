	///-----------------------
	/// build (library)
	/// zig 0.12.0 dev
	///-----------------------

const std = @import("std");


pub fn build(b: *std.Build) void {


	const decimal_mod = b.addModule("decimal", .{
		.root_source_file = b.path( "./decimal/decimal.zig" ),
	});




	const library_mod = b.addModule("library", .{
		.root_source_file = b.path( "library.zig" ),
		.imports = &.{
		.{ .name = "decimal",	.module = decimal_mod },
		},
	});






	
	_ = library_mod;


}
