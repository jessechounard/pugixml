const std = @import("std");

pub fn build(b: *std.Build) void {
    const upstream = b.dependency("pugixml", .{});
    const lib = b.addStaticLibrary(.{
        .name = "pugixml",
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    lib.linkLibCpp();
    lib.addIncludePath(upstream.path(""));
    lib.addCSourceFiles(.{
        .root = upstream.path("src"),
        .files = &.{
            "pugixml.cpp",
        },
    });
    lib.installHeadersDirectory(upstream.path("src"), "", .{ .include_extensions = &.{
        ".hpp",
    } });
    b.installArtifact(lib);
}
