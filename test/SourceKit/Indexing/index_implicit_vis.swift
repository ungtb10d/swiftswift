// RUN: %sourcekitd-test -req=index %S/Inputs/implicit-vis/a.swift -- %S/Inputs/implicit-vis/a.swift %S/Inputs/implicit-vis/b.swift -o implicit_vis.o -Xfrontend -disable-implicit-concurrency-module-import -Xfrontend -disable-implicit-string-processing-module-import | %sed_clean > %t.a.response
// RUN: %sourcekitd-test -req=index %S/Inputs/implicit-vis/b.swift -- %S/Inputs/implicit-vis/a.swift %S/Inputs/implicit-vis/b.swift -o implicit_vis.o -Xfrontend -disable-implicit-concurrency-module-import -Xfrontend -disable-implicit-string-processing-module-import | %sed_clean > %t.b.response
// RUN: %diff -u %S/Inputs/implicit-vis/a.index.response %t.a.response
// RUN: %diff -u %S/Inputs/implicit-vis/b.index.response %t.b.response
