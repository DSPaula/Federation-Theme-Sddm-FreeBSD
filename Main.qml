/***************************************************************************
 * Federation Theme (Qt6 migrated version)
 * Original Author: Fernando de Paula
 * Email: fernando.sars@gmail.com
 * Qt6 migration: adapted for SDDM 0.21+ (FreeBSD 14.3)
 ***************************************************************************/

import QtQuick 6.5
/*import QtQuick 2.0  # <-- cambiar ayudo a eliminar la cache de QtQuick 6.5 y volver al QtQuick 6.5 para ser funcional */
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import SddmComponents 2.0
import "."

Rectangle {
    id: container
    width: 640
    height: 480
    color: "black"

    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    // sessionIndex puede inicializarse después si session aún no existe
    property int sessionIndex: 0

    TextConstants { id: textConstants }
    FontLoader { id: loginfont; source: "CompactaBT.ttf" }
    FontLoader { id: titlefont; source: "CompactaBT.ttf" }
    FontLoader { id: loginfontbold; source: "HelveticaUltraComp.ttf" }
    FontLoader { id: titlefontbold; source: "HelveticaUltraComp.ttf" }

    Connections {
        target: sddm
        onLoginSucceeded: {
            if (errorMessage) {
                errorMessage.color = "white"
                errorMessage.text = textConstants.loginSucceeded
            }
        }
        onLoginFailed: {
            if (password) password.text = ""
                if (errorMessage) {
                    errorMessage.color = "#ff9999"
                    errorMessage.text = textConstants.loginFailed
                    // font.bold no siempre existe; usar font.weight si fuera necesario
                }
        }
    }

    Image {
        id: background
        anchors.fill: parent
        source: config ? config.background : ""
        fillMode: Image.Stretch
        onStatusChanged: {
            if (status === Image.Error && source !== (config ? config.defaultBackground : "")) {
                source = (config ? config.defaultBackground : "")
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        // Caja de login
        Rectangle {
            id: promptbox
            anchors.left: parent.left
            anchors.leftMargin: 120
            y: parent.height / 2 - 250
            color: "transparent"
            height: 260
            width: 440

            Text {
                id: errorMessage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 48
                text: textConstants ? textConstants.prompt : ""
                font.pointSize: 10
                color: "white"
                font.family: loginfont.name
            }

            GridLayout {
                id: gridfield
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                columns: 2
                rowSpacing: 8

                Label {
                    text: textConstants ? textConstants.userName : "Usuario"
                    font.pointSize: 12
                    color: "white"
                    font.family: loginfont.name
                }

                TextField {
                    id: name
                    width: 320
                    height: 42
                    text: (typeof userModel !== "undefined" && userModel.lastUser) ? userModel.lastUser : ""
                    font.pointSize: 14
                    font.family: loginfontbold.name
                    color: "#040a0e"
                    background: Image {
                        source: "input.svg"
                        anchors.fill: parent
                    }

                    Keys.onReturnPressed: {
                        if (password) password.forceActiveFocus()
                    }
                }

                Label {
                    text: textConstants ? textConstants.password : "password"
                    font.pointSize: 12
                    color: "white"
                    font.family: loginfont.name
                }

                TextField {
                    id: password
                    width: 320
                    height: 42
                    font.pointSize: 10
                    font.family: loginfontbold.name
                    color: "black"
                    echoMode: TextInput.Password
                    background: Image {
                        source: "input.svg"
                        anchors.fill: parent
                    }

                    Keys.onReturnPressed: {
                        sddm.login(name.text, password.text, sessionIndex)
                    }
                }
            }

            // Botón de login (imagen + MouseArea para hover/press)
            Row {
                anchors.bottom: parent.bottom
                anchors.right: parent.right

                Rectangle {
                    width: 128
                    height: 40
                    color: "transparent"

                    Image {
                        id: btnImg
                        anchors.fill: parent
                        source: "buttonup.svg"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: btnImg.source = "buttonhover.svg"
                        onExited: btnImg.source = "buttonup.svg"
                        onPressed: btnImg.source = "buttondown.svg"
                        onReleased: {
                            btnImg.source = "buttonup.svg"
                            sddm.login(name.text, password.text, sessionIndex)
                        }
                    }

                    Text {
                        text: textConstants ? textConstants.login : "Login"
                        anchors.centerIn: parent
                        font.family: loginfont.name
                        font.pointSize: 10
                        color: "white"
                    }
                }
            } // fin Row (botón)
        } // fin Rectangle promptbox

        // separador vertical / imagen
        Image {
            id: greetbox
            anchors.left: parent.left
            anchors.leftMargin: 620
            y: parent.height / 2 - 250
            width: 8
            height: 320
            source: "divider.svg"
        }

        // panel derecho: título y reloj
        Rectangle {
            id: titlescreen
            anchors.left: parent.left
            anchors.leftMargin: 720
            y: 120
            color: "transparent"
            width: 740
            height: 300

            Text {
                id: greet
                color: "yellow"
                text: textConstants ? textConstants.welcomeText.arg(sddm.hostName) : ("BienVenido a " + (sddm ? sddm.hostName : "host"))
                font.family: titlefontbold.name
                font.pointSize: 60
                font.letterSpacing: 4
                font.bold: true
            }

            Clock2 {
                id: clock
                anchors.topMargin: 90
                anchors.top: parent.top
                anchors.left: parent.left
                color: "orange"
                timeFont.family: titlefont.name
                dateFont.family: titlefont.name
            }
        }
    } // fin Rectangle (contenedor principal transparente)

    // Panel inferior (sesión y botones)
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        width: parent.width
        height: 72
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            spacing: 30

            ColumnLayout {
                Layout.leftMargin: 30

                Label {
                    text: textConstants ? textConstants.session : "Seleccionar sesión"
                    font.family: loginfont.name
                    font.pointSize: 20
                    color: "green"
                }

                // Reemplaza aquí el bloque anterior del ComboBox+Binding
                Item {
                    width: 196
                    height: 24

                    // imagen de fondo (igual estilo que los TextField)
                    Image {
                        anchors.fill: parent
                        source: "input.svg"
                        fillMode: Image.PreserveAspectCrop
                        z: 0
                    }

                    // ComboBox sobre la imagen. NO usar 'background' ni 'indicator' aquí.
                    ComboBox {
                        id: session
                        anchors.fill: parent
                        model: sessionModel
                        font.family: loginfontbold.name
                        font.pixelSize: 15
                        // inicializar índice si existe
                        Component.onCompleted: {
                            if (sessionModel && sessionModel.lastIndex !== undefined)
                                currentIndex = sessionModel.lastIndex
                        }
                    }

                    // flecha a la derecha (superpuesta)
                    Image {
                        source: "comboarrow.svg"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 6
                        width: 16; height: 18
                        z: 2
                    }
                }

                // binding fuera del Item (mantenlo igual)
                Binding {
                    target: container
                    property: "sessionIndex"
                    value: session.currentIndex
                }
            }

            Item { Layout.fillWidth: true }

            ColumnLayout {
                Label {
                    text: textConstants ? textConstants.shutdown : "Apagar"
                    font.family: loginfont.name
                    font.pointSize: 12
                    color: "red"
                    horizontalAlignment: Text.AlignHCenter
                }
                Rectangle {
                    width: 36
                    height: 36
                    color: "transparent"
                    Image {
                        id: shutdownImg
                        anchors.fill: parent
                        source: "shutdown.svg"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onPressed: shutdownImg.source = "shutdownpressed.svg"
                        onReleased: {
                            shutdownImg.source = "shutdown.svg"
                            sddm.powerOff()
                        }
                    }
                }
            }

            ColumnLayout {
                Label {
                    text: textConstants ? textConstants.reboot : "Reiniciar"
                    font.family: loginfont.name
                    font.pointSize: 12
                    color: "red"
                    horizontalAlignment: Text.AlignHCenter
                }
                Rectangle {
                    width: 36
                    height: 36
                    color: "transparent"
                    Image {
                        id: rebootImg
                        anchors.fill: parent
                        source: "reboot.svg"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onPressed: rebootImg.source = "rebootpressed.svg"
                        onReleased: {
                            rebootImg.source = "reboot.svg"
                            sddm.reboot()
                        }
                    }
                }
            }
        }
    } // fin Rectangle panel inferior

    Component.onCompleted: {
        if (typeof name !== "undefined" && name.text === "")
            name.forceActiveFocus()
            else if (typeof password !== "undefined")
                password.forceActiveFocus()

                // inicializar sessionIndex si existe sessionModel
                if (typeof sessionModel !== "undefined" && sessionModel.lastIndex !== undefined)
                    sessionIndex = sessionModel.lastIndex
    }
} // fin Rectangle container
