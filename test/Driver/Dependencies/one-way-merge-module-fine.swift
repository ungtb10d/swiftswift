/// other ==> main

// RUN: %empty-directory(%t)
// RUN: cp -r %S/Inputs/one-way-fine/* %t
// RUN: touch -t 201401240005 %t/*

// RUN: cd %t && %swiftc_driver -driver-use-frontend-path "%{python.unquoted};%S/Inputs/update-dependencies.py;%swift-dependency-tool" -output-file-map %t/output.json -incremental -driver-always-rebuild-dependents ./main.swift ./other.swift -emit-module-path %t/master.swiftmodule -module-name main -j1 -v 2>&1 | %FileCheck -check-prefix=CHECK-FIRST %s

// CHECK-FIRST-NOT: warning
// CHECK-FIRST-DAG: Handled main.swift
// CHECK-FIRST-DAG: Handled other.swift
// CHECK-FIRST-DAG: Produced master.swiftmodule

// swift-driver checks existence of all outputs
// RUN: touch -t 201401240006 %t/{main,other,master}.swift{module,doc,sourceinfo}

// RUN: cd %t && %swiftc_driver -driver-use-frontend-path "%{python.unquoted};%S/Inputs/update-dependencies.py;%swift-dependency-tool" -output-file-map %t/output.json -incremental -driver-always-rebuild-dependents ./main.swift ./other.swift -emit-module-path %t/master.swiftmodule -module-name main -j1 -v 2>&1 | %FileCheck -check-prefix=CHECK-SECOND %s

// CHECK-SECOND-NOT: warning
// CHECK-SECOND-NOT: Handled
// CHECK-SECOND-NOT: Produced master.swiftmodule
