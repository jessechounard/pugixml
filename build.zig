const std = @import("std");
const mem = std.mem;

fn append_at(target: []u8, position: usize, source: []const u8) usize {
    std.mem.copyForwards(u8, target[position..], source);
    return position + source.len;
}

pub fn build(b: *std.Build) !void {
    const wchar_mode = b.option(bool, "wchar-mode", "Is PUGIXML_WCHAR_MODE enabled? (default: false)") orelse false;
    const compact = b.option(bool, "compact", "Is PUGIXML_COMPACT enabled? (default: false)") orelse false;
    const no_xpath = b.option(bool, "no-xpath", "Is PUGIXML_NO_XPATH enabled? (default: false)") orelse false;
    const no_stl = b.option(bool, "no-stl", "Is PUGIXML_NO_STL enabled? (default: false)") orelse false;
    const no_exceptions = b.option(bool, "no-exceptions", "Is PUGIXML_NO_EXCEPTIONS enabled? (default: false)") orelse false;

    const upstream = b.dependency("pugixml", .{});

    const lib = b.addLibrary(.{
        .name = "pugixml",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = b.standardTargetOptions(.{}),
            .optimize = b.standardOptimizeOption(.{}),
            .link_libcpp = true,
        }),
    });
    lib.addIncludePath(upstream.path(""));
    lib.addCSourceFiles(.{
        .root = upstream.path("src"),
        .files = &.{
            "pugixml.cpp",
        },
        .flags = &.{
            if (wchar_mode) "-DPUGIXML_WCHAR_MODE" else "",
            if (compact) "-DPUGIXML_COMPACT" else "",
            if (no_xpath) "-DPUGIXML_NO_XPATH" else "",
            if (no_stl) "-DPUGIXML_NO_STL" else "",
            if (no_exceptions) "-DPUGIXML_NO_EXCEPTIONS" else "",
        },
    });

    const max_size = ("// build-time generated file, see pugiconfig.original.hpp for license\n\n" ++
        "#ifndef HEADER_PUGICONFIG_HPP\n" ++
        "#define HEADER_PUGICONFIG_HPP\n\n" ++
        "// #define PUGIXML_WCHAR_MODE\n" ++
        "// #define PUGIXML_COMPACT\n" ++
        "// #define PUGIXML_NO_XPATH\n" ++
        "// #define PUGIXML_NO_STL\n" ++
        "// #define PUGIXML_NO_EXCEPTIONS\n" ++
        "\n#endif// HEADER_PUGICONFIG_HPP\n").len;

    var output_file_buffer = try b.allocator.alloc(u8, max_size);
    defer b.allocator.free(output_file_buffer);

    var position: usize = 0;
    position = append_at(output_file_buffer, position, "// build-time generated file, see pugiconfig.original.hpp for license\n\n");
    position = append_at(output_file_buffer, position, "#ifndef HEADER_PUGICONFIG_HPP\n");
    position = append_at(output_file_buffer, position, "#define HEADER_PUGICONFIG_HPP\n\n");
    if (wchar_mode) {
        position = append_at(output_file_buffer, position, "#define PUGIXML_WCHAR_MODE\n");
    } else {
        position = append_at(output_file_buffer, position, "// #define PUGIXML_WCHAR_MODE\n");
    }
    if (compact) {
        position = append_at(output_file_buffer, position, "#define PUGIXML_COMPACT\n");
    } else {
        position = append_at(output_file_buffer, position, "// #define PUGIXML_COMPACT\n");
    }
    if (no_xpath) {
        position = append_at(output_file_buffer, position, "#define PUGIXML_NO_XPATH\n");
    } else {
        position = append_at(output_file_buffer, position, "// #define PUGIXML_NO_XPATH\n");
    }
    if (no_stl) {
        position = append_at(output_file_buffer, position, "#define PUGIXML_NO_STL\n");
    } else {
        position = append_at(output_file_buffer, position, "// #define PUGIXML_NO_STL\n");
    }
    if (no_exceptions) {
        position = append_at(output_file_buffer, position, "#define PUGIXML_NO_EXCEPTIONS\n");
    } else {
        position = append_at(output_file_buffer, position, "// #define PUGIXML_NO_EXCEPTIONS\n");
    }
    position = append_at(output_file_buffer, position, "\n#endif// HEADER_PUGICONFIG_HPP\n");

    //    const wf = b.addWriteFile("pugiconfig.generated.hpp", output_file_buffer[0..position]);

    const wf = b.addWriteFiles();
    const path = wf.add("pugiconfig.generated.hpp", output_file_buffer[0..position]);

    lib.installHeader(path, "pugiconfig.hpp");
    lib.installHeader(upstream.path("src/pugiconfig.hpp"), "pugiconfig.original.hpp");
    lib.installHeader(upstream.path("src/pugixml.hpp"), "pugixml.hpp");

    b.installArtifact(lib);
}
