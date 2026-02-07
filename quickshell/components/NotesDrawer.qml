import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services as Services
import "../colors" as ColorsModule

Item {
    id: root
    property bool opened: false

    implicitHeight: 600
    focus: true

    property int drawerWidth: 380
    implicitWidth: opened ? drawerWidth : 0

    anchors.bottom: parent.bottom
    anchors.left: parent.left

    y: 350

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 260
            easing.type: Easing.OutCubic
        }
    }

    Popout {
        anchors.fill: parent
        clip: true

        alignment: 6
        radius: 22
        color: ColorsModule.Colors.surface_container_high

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14

            Text {
                text: "Notes"
                font.pixelSize: 20
                font.bold: true
                color: ColorsModule.Colors.on_surface
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: ColorsModule.Colors.outline_variant
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ColumnLayout {
                    width: root.drawerWidth - 40
                    spacing: 10

                    Repeater {
                        id: notesRepeater
                        model: Services.Notes.notes

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.max(noteText.contentHeight + 24, 46)
                            Layout.minimumHeight: 46

                            radius: 12
                            color: ColorsModule.Colors.surface_container_highest
                            border.color: ColorsModule.Colors.outline_variant
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 10

                                Text {
                                    id: noteText
                                    text: modelData.text
                                    wrapMode: Text.WordWrap

                                    Layout.fillWidth: true
                                    Layout.maximumWidth: 250
                                    Layout.alignment: Qt.AlignVCenter
                                    Layout.rightMargin: 0

                                    color: ColorsModule.Colors.on_surface
                                    font.pixelSize: 14
                                }

                                Button {
                                    Layout.preferredWidth: 10
                                    Layout.preferredHeight: 34
                                    Layout.alignment: Qt.AlignVCenter
                                    Layout.fillWidth: true

                                    flat: true

                                    contentItem: Text {
                                        text: "×"
                                        font.pixelSize: 18
                                        font.bold: true
                                        anchors.centerIn: parent
                                        color: ColorsModule.Colors.error
                                    }

                                    background: Rectangle {
                                        radius: 8
                                        color: parent.hovered
                                            ? ColorsModule.Colors.error_container
                                            : "transparent"

                                        border.color: parent.hovered
                                            ? ColorsModule.Colors.error
                                            : "transparent"
                                    }

                                    onClicked: Services.Notes.remove(index)
                                }
                            }
                        }

                    }
                }
            }

            TextField {
                id: inputField
                Layout.fillWidth: true
                placeholderText: "Add note..."
                color: ColorsModule.Colors.on_surface

                background: Rectangle {
                    radius: 12
                    color: ColorsModule.Colors.surface_container_low
                    border.color: inputField.focus ? ColorsModule.Colors.primary : ColorsModule.Colors.outline
                }

                onAccepted: {
                    if (text.trim().length === 0)
                        return
                    Services.Notes.add(text)
                    text = ""
                }
            }
        }
    }
}
