# pugixml
This is [pugixml](https://github.com/zeux/pugixml), packaged for [Zig](https://ziglang.org/). (Intended for C++ projects using Zig as a build tool.)

## Usage
First, update your `build.zig.zon`:
```sh
zig fetch --save git+https://github.com/jessechounard/pugixml
```

Next, in your `build.zig`, you can access the library as a dependency:
```zig
const pugixml_dep = b.dependency("pugixml", .{
    .target = target,
    .optimize = optimize,
    // [optional] build options - see below
});
const pugixml_lib = pugixml_dep.artifact("pugixml");

exe.root_module.linkLibrary(pugixml_lib);
```

Finally, in your C++ file, you can use the library by including `pugixml.hpp`.

## Build Options
pugixml has a few build-time configurable options. See the pugixml documentation for information on these. The options currently exposed here are:
- wchar-mode (PUGIXML_WCHAR_MODE)
- compact (PUGIXML_COMPACT)
- no-xpath (PUGIXML_NO_XPATH)
- no-stl (PUGIXML_NO_STL)
- no-exceptions (PUGIXML_NO_EXCEPTIONS)

These all default to `false` and my guess is that's what most people will want. Please give me a shout if you need any of the other `pugiconfig.hpp` options available here.

An example with options:
```zig
const pugixml_dep = b.dependency("pugixml", .{
    .target = target,
    .optimize = optimize,
    .@"no-xpath" = true,
    .@"no-stl" = false,
});
```

## Todo
- Currently only tested on my Windows box. More validation required.
- Add a CI step on github.

## Help welcome
I'm a zig newbie. If you see anything I could be doing better here, please let me know. I appreciate the input!
