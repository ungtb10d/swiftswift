
add_swift_host_library(swiftReflection STATIC
  ${SWIFT_SOURCE_DIR}/stdlib/public/Reflection/MetadataSource.cpp
  ${SWIFT_SOURCE_DIR}/stdlib/public/Reflection/TypeLowering.cpp
  ${SWIFT_SOURCE_DIR}/stdlib/public/Reflection/TypeRef.cpp
  ${SWIFT_SOURCE_DIR}/stdlib/public/Reflection/TypeRefBuilder.cpp)
target_compile_options(swiftReflection PRIVATE -DSWIFT_ENABLE_REFLECTION)
target_link_libraries(swiftReflection PUBLIC
  swiftDemangling)
