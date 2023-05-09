add_library(asteroid-alarmclock main.cpp resources.qrc)
set_target_properties(asteroid-alarmclock PROPERTIES PREFIX "")

target_link_libraries(asteroid-alarmclock PUBLIC
	AsteroidApp)

install(TARGETS asteroid-alarmclock
	DESTINATION ${CMAKE_INSTALL_LIBDIR})

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/asteroid-alarmclock.in
	${CMAKE_BINARY_DIR}/asteroid-alarmclock
	@ONLY)

install(PROGRAMS ${CMAKE_BINARY_DIR}/asteroid-alarmclock
	DESTINATION ${CMAKE_INSTALL_BINDIR})

build_translations(i18n)
generate_desktop(${CMAKE_CURRENT_SOURCE_DIR} asteroid-alarmclock)
