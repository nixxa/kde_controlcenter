cmake_minimum_required(VERSION 3.16)

set(PROJECT_VERSION "6.1.80")
set(QT_MIN_VERSION "6.7.0")
set(KF6_MIN_VERSION "6.2.0")

project(controlcenter)

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_MODULE_PATH})

find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS)
find_package(Plasma ${PROJECT_VERSION} REQUIRED)

add_subdirectory(applet)
