if(NOT DEFINED SWIPL)
    CPMAddPackage(NAME swiprolog GITHUB_REPOSITORY SWI-Prolog/swipl-devel VERSION 9.1.20 GIT_TAG V9.1.20
            DOWNLOAD_ONLY YES
            GIT_SUBMODULES packages/http packages/ssl packages/clib packages/sgml packages/zlib packages/readline
                           packages/cpp packages/utf8proc)

    if(swiprolog_ADDED)
        execute_process(COMMAND cmake -S ${swiprolog_SOURCE_DIR} -DMULTI_THREADED=OFF -DSWIPL_STATIC_LIB=ON
                -DSWIPL_PACKAGE_LIST=utf8proc\;http\;clib\;readline\;cpp -DUSE_GMP=OFF -DUSE_SIGNALS=OFF
                -DSWIPL_STATIC_LIB=ON -DBUILD_TESTING=OFF -DINSTALL_TESTS=OFF
                -DINSTALL_DOCUMENTATION=OFF -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/swipl
                -B ${swiprolog_BINARY_DIR}
                RESULT_VARIABLE rc)

        if(NOT rc EQUAL 0)
            message(FATAL_ERROR "Failed configuring swipl")
        endif()

        execute_process(COMMAND cmake --build ${swiprolog_BINARY_DIR} --parallel --target install
                RESULT_VARIABLE rc)
        if(NOT rc EQUAL 0)
            message(FATAL_ERROR "Failed building swipl")
        endif()

        set(SWIPL ${CMAKE_CURRENT_BINARY_DIR}/swipl/bin/swipl)
    else()
        find_program(SWIPL swipl REQUIRED)
    endif()
endif()

execute_process(COMMAND ${SWIPL} --dump-runtime-variables OUTPUT_VARIABLE swipl_runtime_variables)
foreach(line ${swipl_runtime_variables})
    string(STRIP ${line} line)
    if(line STREQUAL "")
        continue()
    endif()
    # Find the positions of '=' and the second '\"'
    string(FIND "${line}" "=" pos_equal)
    string(FIND "${line}" "\"" pos_quote REVERSE)

    # Extract the variable name and value
    math(EXPR length_name "${pos_equal}")
    math(EXPR start_value "${pos_equal} + 2")
    math(EXPR length_value "${pos_quote} - ${start_value}")

    string(SUBSTRING "${line}" 0 ${length_name} name)
    string(SUBSTRING "${line}" ${start_value} ${length_value} value)

    set(${name} "${value}" CACHE INTERNAL "Swipl setting")
endforeach()
