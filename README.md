DerelictUTF8Proc
================

A dynamic and static binding to the [utf8proc][1] library version 2.1.1 for the D Programming Language.

Please see the sections on [Compiling and Linking][2] and [The Derelict Loader][3] in the Derelict documentation for information on how to build DerelictUTF8Proc and load utf8proc at run time. In the meantime, here's some sample code.

```D
import derelict.utf8proc.utf8proc;

void main() {
    // Load the UTF8Proc library.
    DerelictUTF8Proc.load();

    // Now utf8proc functions can be called.
    ...
}
```

[1]: https://github.com/JuliaStrings/utf8proc
[2]: http://derelictorg.github.io/building/overview/
[3]: http://derelictorg.github.io/loading/loader/
