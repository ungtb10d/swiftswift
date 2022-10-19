// RUN: %empty-directory(%t)
// RUN: %{python} %utils/split_file.py -o %t %s

// RUN: %target-swift-frontend -emit-module %t/Countries.swift -module-name A -emit-module-path %t/Countries.swiftmodule
// RUN: %target-swift-frontend -typecheck -verify -verify-ignore-unknown %t/CountryPicker-without-package-import.swift -I %t
// RUN: %target-swift-frontend -typecheck -package-modules Countries -verify -verify-ignore-unknown %t/CountryPicker-with-package-import.swift -I %t
// RUN: %target-swift-frontend -typecheck -package-modules Countries -verify -verify-ignore-unknown %t/CountryPicker-with-package-import-pass.swift -I %t


// BEGIN Countries.swift

public class Portugal {
   public var region: String = "Europe"
   public init() {}
   @package
   public func city() -> String {
       return "Lisbon"
   }
}

@package
public struct Spain {
    public var cities: Array<String>?
    public init() {}
    public func showCities() { }
}


// BEGIN CountryPicker-without-package-import.swift
import Countries

func showSpain() -> Spain {
  let s = Spain()
  s.showCities() // expected-error{{cannot find 'Spain' in scope}}
  return s
}

func showPortugal() {
  let p = Portugal()
  let eu = p.region
  let lisbon = p.city() // expected-error{{'city' is  inaccessible due to '@package' protection level}}
  print(eu, lisbon)

}

// BEGIN CountryPicker-with-package-import.swift
import Countries // -package-modules Countries is passed

func showSpain() -> Spain { // expected-error{{cannot use struct 'Spain' here; it is a package type imported from 'Countries'}}
    let s = Spain()
    s.showCities()
    return s
}

func showPortugal() {
  let p = Portugal()
  let eu = p.region
  let lisbon = p.city()
  print(eu, lisbon)
}

// BEGIN CountryPicker-with-package-import-pass.swift
import Countries // -package-modules Countries is passed

@package
func showSpain() -> Spain { //'Spain' a package type imported from 'Countries'
    let s = Spain()
    s.showCities()
    return s
}

func showPortugal() {
  let p = Portugal()
  let eu = p.region
  let lisbon = p.city()
  print(eu, lisbon)
}
