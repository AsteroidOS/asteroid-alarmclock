add_library(asteroid-alarmpresenter main.cpp)
set_target_properties(asteroid-alarmpresenter PROPERTIES PREFIX "")

asteroid_app_qml_module(asteroid-alarmpresenter
	main.qml
)

target_link_libraries(
	asteroid-alarmpresenter
	PRIVATE
		Asteroid::AsteroidApp6
		Mapplauncherd_qt6::Mapplauncherd_qt6
)

install(
	TARGETS asteroid-alarmpresenter
	DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

configure_file(
	${CMAKE_CURRENT_SOURCE_DIR}/asteroid-alarmpresenter.in
	${CMAKE_BINARY_DIR}/asteroid-alarmpresenter
	@ONLY
)

install(
	PROGRAMS ${CMAKE_BINARY_DIR}/asteroid-alarmpresenter
	DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(
	FILES com.nokia.voland.service
	DESTINATION ${CMAKE_INSTALL_DATADIR}/dbus-1/services
)

if(SYSTEMD)
	install(
		FILES alarmpresenter.service
		DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/systemd/user
	)
endif()
