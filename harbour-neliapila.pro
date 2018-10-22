# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-neliapila

QT += qml quick network

CONFIG += sailfishapp

SOURCES += src/harbour-neliapila.cpp \
    src/neliapilanam.cpp \
    src/harbour-neliapila.cpp \
    src/neliapilanam.cpp

DEPLOYMENT_PATH = /usr/share/$${TARGET}

py.files = py
py.path = $${DEPLOYMENT_PATH}

INSTALLS += py


HEADERS += \
    src/neliapilanam.h

