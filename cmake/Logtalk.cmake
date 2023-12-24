CPMAddPackage(NAME Logtalk GITHUB_REPOSITORY LogtalkDotOrg/logtalk3 VERSION 3.72.0 GIT_TAG lgt3720stable DOWNLOAD_ONLY YES)

if(Logtalk_ADDED AND swiprolog_ADDED)
    #set(ENV{LOGTALKUSER} ${CMAKE_CURRENT_BINARY_DIR}/logtalk)
    set(ENV{LOGTALKHOME} ${Logtalk_SOURCE_DIR})
    set(ENV{LOGTALKUSER} ${Logtalk_SOURCE_DIR})
    set(ENV{PATH} ${CMAKE_CURRENT_BINARY_DIR}/swipl/bin:$ENV{PATH})
    add_custom_target(swilgt
            COMMAND LOGTALKUSER=${Logtalk_SOURCE_DIR} LOGTALKHOME=${Logtalk_SOURCE_DIR} ${SWIPL} -s "${Logtalk_SOURCE_DIR}/integration/logtalk_swi.pl"
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endif()