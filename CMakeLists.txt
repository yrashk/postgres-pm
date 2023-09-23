cmake_minimum_required(VERSION 3.22)
project(pgpm)


include(cmake/CPM.cmake)
include(cmake/SWIprolog.cmake)
include(cmake/Logtalk.cmake)

# FIXME: the capability to compile everything statically is currently problematic:
# as long as we don't need foreign libraries, we're fine, # but the moment we do,
# these static builds don't work.
#find_library(LIBSWIPL_STATIC NAMES swipl_static PATHS "${PLLIBDIR}")
find_library(LIBSWIPL NAMES swipl PATHS "${PLLIBDIR}")

if(LIBSWIPL_STATIC)
    set(STATIC TRUE)
    set(libswipl swipl_static)
else()
    set(libswipl swipl)
endif()

# If we'll ever need it
add_library(swicpp2 STATIC ${swiprolog_SOURCE_DIR}/packages/cpp/SWI-cpp2.cpp)
target_compile_features(swicpp2 PRIVATE cxx_std_17)
target_include_directories(swicpp2 PUBLIC ${swiprolog_SOURCE_DIR}/packages/cpp)
target_include_directories(swicpp2 PRIVATE "${PLBASE}/include")

add_executable(pgpm main.c ${CMAKE_CURRENT_BINARY_DIR}/app/application)
target_compile_features(pgpm PRIVATE cxx_std_17)
target_compile_definitions(pgpm PRIVATE __SWI_PROLOG __SWI_EMBEDDED_)
target_include_directories(pgpm PRIVATE "${PLBASE}/include")
target_link_libraries(pgpm PRIVATE ${libswipl} swicpp2)
target_link_directories(pgpm PRIVATE "${PLLIBDIR}")

set_target_properties(pgpm PROPERTIES BUILD_WITH_INSTALL_RPATH TRUE)
if(APPLE)
    set_target_properties(pgpm PROPERTIES INSTALL_RPATH "@loader_path")
else()
    set_target_properties(pgpm PROPERTIES INSTALL_RPATH "$ORIGIN")
endif()

if(STATIC)
    if(APPLE)
        find_library(CoreFoundation NAMES CoreFoundation)
        target_link_libraries(pgpm PRIVATE ${CoreFoundation})
        set_target_properties(pgpm PROPERTIES ENABLE_EXPORTS ON)
    endif()

    find_library(libncurses NAMES ncurses REQUIRED)
    find_library(libz NAMES z REQUIRED)
    find_library(libm NAMES m REQUIRED)

    target_link_libraries(pgpm PRIVATE ${libncurses} ${libz} ${libm})
endif()

set(pgpm_SOURCES
        loader.lgt pgpm/config.lgt pgpm/metadata.lgt pgpm/inherit_hook.lgt pgpm/build.lgt pgpm/env.lgt pgpm/extended_relations.lgt
        pgpm/postgres.lgt
        pgpm/fs.lgt pgpm/git.lgt pgpm/git_explicit_revision_package.lgt
        pgpm/git_remote.lgt pgpm/path.lgt pgpm/git_rev.lgt pgpm/git_tagged_revision_package.lgt
        pgpm/inferences.lgt pgpm/loader.lgt pgpm/make_builder.lgt pgpm/origin.lgt
        pgpm/package.lgt pgpm/pgpm.lgt pgpm/requirement.lgt pgpm/version.lgt pgpm/tagged.lgt
        pgpm/requirements/c_compiler.lgt pgpm/requirements/pkgconfig.lgt
        pgpm/requirements/loader.lgt pgpm/requirements/make.lgt pgpm/requirements/when.lgt)

add_custom_command(
        DEPENDS ${pgpm_SOURCES} settings-build.lgt
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/app/application
        COMMAND LOGTALKUSER=${Logtalk_SOURCE_DIR} LOGTALKHOME=${Logtalk_SOURCE_DIR} PATH=${Logtalk_SOURCE_DIR}/integration:$ENV{PATH}
                ${Logtalk_SOURCE_DIR}/scripts/embedding/swipl/swipl_logtalk_qlf.sh
                -f save
                -d ${CMAKE_CURRENT_BINARY_DIR}/app
                -s ${CMAKE_CURRENT_SOURCE_DIR}/settings-build.lgt
                -l ${CMAKE_CURRENT_SOURCE_DIR}/loader.lgt
                -c -x
        # Trigger a rebuild for pgpm. Not pretty but does the job
        COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_SOURCE_DIR}/main.c)


add_custom_command(TARGET pgpm POST_BUILD
        COMMAND cat $<TARGET_FILE:pgpm> ${CMAKE_CURRENT_BINARY_DIR}/app/application > ${CMAKE_CURRENT_BINARY_DIR}/pgpm1
        COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/pgpm1 $<TARGET_FILE:pgpm>
        COMMAND chmod +x $<TARGET_FILE:pgpm>)

if(NOT STATIC)
    if(IS_SYMLINK ${LIBSWIPL})
        file(READ_SYMLINK ${LIBSWIPL} LIBSWIPL_)
        get_filename_component(LIBSWIPL_ ${LIBSWIPL_} NAME)
    else()
        get_filename_component(LIBSWIPL_ ${LIBSWIPL} NAME)
    endif()
    add_custom_target(copy-${LIBSWIPL_} BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/${LIBSWIPL_}
            COMMAND ${CMAKE_COMMAND} -E copy ${LIBSWIPL} ${CMAKE_CURRENT_BINARY_DIR}/${LIBSWIPL_}
           DEPENDS ${LIBSWIPL})
    add_dependencies(pgpm copy-${LIBSWIPL_})
endif()

enable_testing()
add_test(NAME pgpm_test COMMAND ${Logtalk_SOURCE_DIR}/scripts/logtalk_tester.sh -p swi -l 1
              WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})