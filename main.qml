import QtQuick 2.1
//import QtQuick.Controls 1.4
import Qt.labs.settings 1.0
import QtQuick.Particles 2.0

Rectangle {
    property var object
    width: 1024
    height: 720

    color: "#21252B"

    Component.onCompleted: {
        runCode();
    }

    function runCode() {
        if(object) {
            object.destroy();
        }
        errorText.text = "";
        try {
            object = Qt.createQmlObject(textInput.text, container, "main_qml");
        } catch (err) {
            errorText.text = "The following errors while parsing the QML:";
            for(var i in err.qmlErrors) {
                var e = err.qmlErrors[i];
                errorText.text += e.lineNumber + ":" + e.columnNumber + ": " + e.message;
            }
        }
    }

    Rectangle {
        id: textAreaRectangle
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: parent.width / 2
        color: "#282C34"

        Text {
            id: title
        }

        TextEdit {
            id: textInput

            anchors {
                left: parent.left
                right: parent.right
                margins: 16
            }

            width: parent.width - 32

            selectByMouse: true
            selectByKeyboard: true
            color: "#ABB2BF"

            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: '
import QtQuick 2.0

Rectangle {
    anchors.fill: parent
    color: "#21252B"

    Rectangle {
        x: 150
        y: 150
        width: 200
        height: width
        radius: width / 2
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#D5D5D5"
            }
            GradientStop {
                position: 1
                color: "#6E6E6E"
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.84
            height: width
            radius: width / 2

            color: "#F2F2F2"
        }

        Text {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: parent.height / 3
            }

            text: "Drag me"
            color: "#8D8D8D"
        }

        Rectangle {
            id: arm1
            property alias angle: rotationTransform.angle
            x: parent.width / 2
            y: parent.height / 2
            width: parent.width * 0.36
            height: width * 0.06
            color: "#3A2A2A"
            radius: width * 0.1
            transform: Rotation {
                id: rotationTransform
                origin: Qt.vector3d(arm1.height / 2, arm1.height / 2, 0.0)
                angle: -90
            }

            Behavior on angle {
                NumberAnimation {
                    duration: 240
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Rectangle {
            id: arm2
            property alias angle: rotationTransform2.angle
            x: parent.width / 2
            y: parent.height / 2
            width: parent.width * 0.24
            height: width * 0.12
            color: "#3A2A2A"
            radius: width * 0.1
            transform: Rotation {
                id: rotationTransform2
                origin: Qt.vector3d(arm1.height / 2, arm1.height / 2, 0.0)
                angle: 40
            }

            Behavior on angle {
                NumberAnimation {
                    duration: 1200
                    easing.type: Easing.InOutBack
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            onPressed: {
                timer1.stop();
                timer2.stop();
            }
            onClicked: {
                arm1.angle = Math.atan2(mouse.y - height / 2, mouse.x - width / 2) / Math.PI * 180;
            }
            onReleased: {
                timer1.start();
                timer2.start();
            }
        }
    }

    Timer {
        id: timer1
        running: true
        repeat: true
        interval: 12000 / 60
        onTriggered: {
            arm1.angle += 360 / 60
        }
    }

    Timer {
        id: timer2
        running: true
        repeat: true
        interval: 12000
        onTriggered: {
            arm2.angle += 360 / 12
        }
    }
}
'
        }

        Rectangle {
            anchors {
                right: parent.right
                top: parent.top
            }
            width: 128
            height: 64
            color: "#AAAAAA"
            Text {
                anchors.centerIn: parent
                text: "Run"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    runCode();
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            onWheel: {
                textInput.y -= wheel.angleDelta.y / 16;
            }
            onPressed: {
                mouse.accepted = false;
            }
            onClicked: {
                mouse.accepted = false;
            }
        }
    }

    Rectangle {
        id: container
        anchors {
            left: textAreaRectangle.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        color: "#21252B"

        Text {
            id: errorText
            anchors.fill: parent
            anchors.margins: 16
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            color: "#ABB2BF"
        }
    }
}
