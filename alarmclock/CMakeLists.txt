add_library(asteroid-alarmclock main.cpp)
set_target_properties(asteroid-alarmclock PROPERTIES PREFIX "")

asteroid_app_qml_module(asteroid-alarmclock
	main.qml
	DayButton.qml
	TimePickerDialog.qml
	DaysSelectorDialog.qml
	AlarmListItem.qml
)

target_link_libraries(
	asteroid-alarmclock
	PUBLIC
		Asteroid::AsteroidApp6
)

install(
	TARGETS asteroid-alarmclock
	DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

configure_file(
	${CMAKE_CURRENT_SOURCE_DIR}/asteroid-alarmclock.in
	${CMAKE_BINARY_DIR}/asteroid-alarmclock
	@ONLY
)

install(
	PROGRAMS ${CMAKE_BINARY_DIR}/asteroid-alarmclock
	DESTINATION ${CMAKE_INSTALL_BINDIR}
)

build_translations(i18n)
generate_desktop(${CMAKE_CURRENT_SOURCE_DIR} asteroid-alarmclock)
