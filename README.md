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
});
const pugixml_lib = pugixml_dep.artifact("pugixml");

exe.root_module.linkLibrary(pugixml_lib);
```

Finally, in your C++ file, you can use the library by including `pugixml.hpp`.

## Todo
- Demonstrate how the configurable build options work.  
- Currently a file named `pugiconfig.generated.hpp` is created in the root folder. I think it would be much better in the `.zig-cache`, but I couldn't seem to get that to work.
- Currently only tested on my Windows box. More validation required.
- Add a CI step on github.

## Help welcome
I'm a zig newbie. If you see anything I could be doing better here, please let me know. I appreciate the input!
