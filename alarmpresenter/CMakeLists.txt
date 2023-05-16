add_library(asteroid-alarmpresenter main.cpp resources.qrc)
set_target_properties(asteroid-alarmpresenter PROPERTIES PREFIX "")

target_link_libraries(asteroid-alarmpresenter PRIVATE
	AsteroidApp
	Mapplauncherd_qt5::Mapplauncherd_qt5)

install(TARGETS asteroid-alarmpresenter
	DESTINATION ${CMAKE_INSTALL_LIBDIR})

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/asteroid-alarmpresenter.in
	${CMAKE_BINARY_DIR}/asteroid-alarmpresenter
	@ONLY)

install(PROGRAMS ${CMAKE_BINARY_DIR}/asteroid-alarmpresenter
	DESTINATION ${CMAKE_INSTALL_BINDIR})

install(FILES com.nokia.voland.service
	DESTINATION ${CMAKE_INSTALL_DATADIR}/dbus-1/services)

if(SYSTEMD)
	install(FILES alarmpresenter.service
		DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/systemd/user)
endif()
