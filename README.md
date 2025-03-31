# pugixml
This is [pugixml](https://github.com/zeux/pugixml), packaged for [Zig](https://ziglang.org/). (Intended for C or C++ projects using Zig as a build tool.)

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
});
const pugixml_lib = pugixml_dep.artifact("pugixml");

exe.root_module.linkLibrary(pugixml_lib);
```

Finally, in your C++ file, you can use the library by including `pugixml.hpp`.

## Todo
It would be nice to include the configuration options that pugixml exposes. (NO_STD, WCHAR, etc.) Those are normally configured by changing the `pugiconfig.hpp` file before building.