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
TARGET = Neliapila

CONFIG += sailfishapp

SOURCES += src/Neliapila.cpp

DEPLOYMENT_PATH = /usr/share/$${TARGET}

py.files = py
py.path = $${DEPLOYMENT_PATH}

INSTALLS += py

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
#CONFIG += sailfishapp_i18n
