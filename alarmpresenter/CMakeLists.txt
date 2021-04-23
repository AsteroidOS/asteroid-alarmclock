add_executable(asteroid-presenter main.cpp resources.qrc)

target_link_libraries(asteroid-presenter PRIVATE
	AsteroidApp
	Mapplauncherd_qt5::Mapplauncherd_qt5)

install(TARGETS asteroid-presenter
	DESTINATION ${CMAKE_INSTALL_BINDIR})

install(FILES com.nokia.voland.service
	DESTINATION ${CMAKE_INSTALL_DATADIR}/dbus-1/services)

if(SYSTEMD)
	install(FILES alarmpresenter.service
		DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/systemd/user)
endif()
