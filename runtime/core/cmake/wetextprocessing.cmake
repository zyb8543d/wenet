   if(NOT ANDROID)
  #set(wetextprocessing_SOURCE_DIR ${LOCAL_WETEXTPROCESSING_PATH})
  #FetchContent_Declare(wetextprocessing
      #GIT_REPOSITORY https://github.com/wenet-e2e/WeTextProcessing.git
    # GIT_TAG        origin/master
    #)
  # 设置本地路径
  #set(LOCAL_WETEXTPROCESSING_PATH "wetextprocessing-src-dir")            
  #FetchContent_Declare(wetextprocessing SOURCE_DIR ${LOCAL_WETEXTPROCESSING_PATH})  # 使用本地文件夹
  FetchContent_MakeAvailable(wetextprocessing)
  include_directories(${wetextprocessing_SOURCE_DIR}/runtime)
  add_subdirectory(${wetextprocessing_SOURCE_DIR}/runtime/utils)
  add_subdirectory(${wetextprocessing_SOURCE_DIR}/runtime/processor)
else()
  include(ExternalProject)
  set(ANDROID_CMAKE_ARGS
    -DBUILD_TESTING=OFF
    -DBUILD_SHARED_LIBS=OFF
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DANDROID_ABI=${ANDROID_ABI}
    -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL}
    -DCMAKE_CXX_FLAGS=-I${openfst_BINARY_DIR}/include
    -DCMAKE_EXE_LINKER_FLAGS=-L${openfst_BINARY_DIR}/${ANDROID_ABI}
  )
  ExternalProject_Add(wetextprocessing
    GIT_REPOSITORY https://github.com/wenet-e2e/WeTextProcessing.git
    GIT_TAG origin/master
    SOURCE_SUBDIR runtime
    CMAKE_ARGS ${ANDROID_CMAKE_ARGS}
    INSTALL_COMMAND ""
  )
  #设置本地路径
  #set(LOCAL_WETEXTPROCESSING_PATH "" CACHE PATH "${SOURCE_DIR}/../../../build/.cxx/cmake/debug/arm64-v8a/wetextprocessing-prefix/src/wetextprocessing")
  #ExternalProject_Add(wetextprocessing
  #        SOURCE_DIR ${LOCAL_WETEXTPROCESSING_PATH}
  #        DOWNLOAD_COMMAND ""
  #        SOURCE_SUBDIR runtime
  #        CMAKE_ARGS ${ANDROID_CMAKE_ARGS}
  #        INSTALL_COMMAND ""
  #)
  ExternalProject_Get_Property(wetextprocessing SOURCE_DIR BINARY_DIR)
  include_directories(${SOURCE_DIR}/runtime)
  link_directories(${BINARY_DIR}/processor ${BINARY_DIR}/utils)
  link_libraries(wetext_utils)
endif()

