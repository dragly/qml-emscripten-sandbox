# should be set by Qt, but isn't
#INCLUDEPATH += $$(NACL_SDK_ROOT)/include
SOURCES += main.cpp
RESOURCES += main.qrc
QT += quick
emscripten {
#    QMAKE_LFLAGS -= -Wl,-O1
    QMAKE_LFLAGS += -O3
#    LIBS += -lqtquick2plugin -L/home/svenni/apps/qt-nacl/qt5-nacl-5.6-emscripten2/qtbase/qtbase/qml/QtQuick.2/
}

RESOURCES += naclfonts.qrc


#message($$CONFIG)
#message(lol)
