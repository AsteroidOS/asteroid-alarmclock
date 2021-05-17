cmake_minimum_required(VERSION 3.6.0)

project(asteroid-alarmclock
	VERSION 0.0.1
	DESCRIPTION "Default alarm clock app for AsteroidOS")

find_package(ECM REQUIRED NO_MODULE)
find_package(AsteroidApp REQUIRED)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ASTEROID_MODULE_PATH})

include(FindPkgConfig)
include(FeatureSummary)
include(GNUInstallDirs)
include(ECMQMLModules)
include(AsteroidCMakeSettings)
include(AsteroidTranslations)

option(SYSTEMD "Install systemd related files" ON)

find_package(Mapplauncherd_qt5 REQUIRED)

ecm_find_qmlmodule(Nemo.Configuration 1.0)
ecm_find_qmlmodule(Nemo.Alarms 1.0)
ecm_find_qmlmodule(Nemo.Time 1.0)
ecm_find_qmlmodule(Nemo.Ngf 1.0)

add_subdirectory(alarmclock)
add_subdirectory(alarmpresenter)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
