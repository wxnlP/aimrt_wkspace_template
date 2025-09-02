include(FetchContent)

FetchContent_Declare(
    aimrt
    GIT_REPOSITORY https://gitee.com/agiros/AimRT.git
    GIT_TAG v1.1.0
)

FetchContent_GetProperties(aimrt)

if(NOT aimrt_POPULATED)
    FetchContent_MakeAvailable(aimrt)
endif()