add_library(asteroid-alarmclock main.cpp resources.qrc)
set_target_properties(asteroid-alarmclock PROPERTIES PREFIX "" SUFFIX "")

target_link_libraries(asteroid-alarmclock PUBLIC
	AsteroidApp)

install(TARGETS asteroid-alarmclock
	DESTINATION ${CMAKE_INSTALL_BINDIR})

build_translations(i18n)
generate_desktop(${CMAKE_CURRENT_SOURCE_DIR} asteroid-alarmclock)
