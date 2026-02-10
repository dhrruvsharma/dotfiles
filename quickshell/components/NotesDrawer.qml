import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services as Services
import "../colors" as ColorsModule

Item {
    id: root
    property bool opened: false

    implicitHeight: opened ? 600 : 0
    implicitWidth: opened ? drawerWidth : 0
    property int drawerWidth: 600

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    focus: true

    Behavior on implicitWidth {
        NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
    }
    Behavior on implicitHeight {
        NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
    }

    Rectangle {
        anchors.fill: parent
        visible: root.opened
        radius: 24
        color: ColorsModule.Colors.surface_container_high
    }

    Popout {
        anchors.fill: parent
        clip: true
        alignment: 5
        radius: 24
        color: ColorsModule.Colors.surface_container_high

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            /* HEADER */
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.preferredHeight: 24
                    Layout.alignment: Qt.AlignVCenter
                    radius: 2
                    color: ColorsModule.Colors.primary
                }

                Text {
                    text: "Notes"
                    font.pixelSize: 24
                    font.weight: Font.DemiBold
                    color: ColorsModule.Colors.on_surface
                    Layout.alignment: Qt.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: countText.contentWidth + 16
                    Layout.alignment: Qt.AlignVCenter
                    radius: 14
                    color: ColorsModule.Colors.tertiary_container
                    visible: Services.Notes.getNotesForCategory(
                        Services.Notes.currentCategory).length > 0

                    Text {
                        id: countText
                        anchors.centerIn: parent
                        text: Services.Notes.getNotesForCategory(
                            Services.Notes.currentCategory).length
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: ColorsModule.Colors.on_tertiary_container
                    }
                }

                Button {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    Layout.alignment: Qt.AlignVCenter
                    flat: true

                    contentItem: Text {
                        text: "+"
                        font.pixelSize: 22
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                    }

                    background: Rectangle {
                        radius: 18
                        color: parent.hovered || parent.pressed
                            ? Qt.darker(ColorsModule.Colors.primary_container, 1.1)
                            : ColorsModule.Colors.primary_container
                    }

                    onClicked: categoryDialog.open()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: ColorsModule.Colors.outline_variant
                opacity: 0.5
            }

            /* CATEGORY TABS */
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                clip: true

                RowLayout {
                    spacing: 10

                    Repeater {
                        model: Services.Notes.categories

                        delegate: Rectangle {
                            Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth:
                                categoryText.implicitWidth +
                                (modelData === "notes" ? 28 : 40)

                            radius: 18
                            color: Services.Notes.currentCategory === modelData
                                ? ColorsModule.Colors.primary_container
                                : ColorsModule.Colors.surface_container_highest

                            border.color: Services.Notes.currentCategory === modelData
                                ? ColorsModule.Colors.primary
                                : "transparent"
                            border.width: 2

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Services.Notes.setCurrentCategory(modelData)
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 14
                                anchors.rightMargin: 8
                                spacing: 6

                                Text {
                                    id: categoryText
                                    text: modelData.charAt(0).toUpperCase()
                                        + modelData.slice(1)
                                    Layout.alignment: Qt.AlignVCenter
                                    color: Services.Notes.currentCategory === modelData
                                        ? ColorsModule.Colors.on_primary_container
                                        : ColorsModule.Colors.on_surface
                                    font.pixelSize: 14
                                }

                                Button {
                                    visible: modelData !== "notes"
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    Layout.alignment: Qt.AlignVCenter
                                    flat: true

                                    contentItem: Text {
                                        text: "×"
                                        font.pixelSize: 16
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.fill: parent
                                    }

                                    onClicked:
                                        Services.Notes.removeCategory(modelData)
                                }
                            }
                        }
                    }
                }
            }

            /* NOTES LIST */
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ColumnLayout {
                    width: parent.width
                    spacing: 12

                    Repeater {
                        model: Services.Notes.getNotesForCategory(
                            Services.Notes.currentCategory)

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.minimumHeight: 54
                            Layout.preferredHeight:
                                Math.max(noteText.implicitHeight + 28, 54)

                            radius: 14
                            color: ColorsModule.Colors.surface_container_highest
                            border.color: ColorsModule.Colors.outline_variant

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 12

                                Rectangle {
                                    Layout.preferredWidth: 6
                                    Layout.preferredHeight: 6
                                    Layout.alignment: Qt.AlignTop
                                    radius: 3
                                    color: ColorsModule.Colors.primary
                                }

                                Text {
                                    id: noteText
                                    text: modelData.text
                                    Layout.fillWidth: true
                                    wrapMode: Text.Wrap
                                    color: ColorsModule.Colors.on_surface
                                    font.pixelSize: 14
                                }

                                Button {
                                    Layout.preferredWidth: 32
                                    Layout.preferredHeight: 32
                                    Layout.alignment: Qt.AlignTop
                                    flat: true

                                    contentItem: Text {
                                        text: "×"
                                        font.pixelSize: 18
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.fill: parent
                                    }

                                    onClicked: {
                                        var allNotes = Services.Notes.notes
                                        for (var i = 0; i < allNotes.length; i++) {
                                            if (allNotes[i].id === modelData.id) {
                                                Services.Notes.remove(i)
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            /* INPUT ROW */
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                TextField {
                    id: inputField
                    Layout.fillWidth: true
                    placeholderText:
                        "Add note to " + Services.Notes.currentCategory + "..."
                    font.pixelSize: 14

                    onAccepted: {
                        if (text.trim().length === 0) return
                        Services.Notes.add(text)
                        text = ""
                    }
                }

                Button {
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                    Layout.alignment: Qt.AlignVCenter
                    enabled: inputField.text.trim().length > 0

                    contentItem: Text {
                        text: "↵"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                    }

                    onClicked: {
                        if (inputField.text.trim().length > 0) {
                            Services.Notes.add(inputField.text)
                            inputField.text = ""
                        }
                    }
                }
            }
        }
    }

    /* CATEGORY DIALOG (unchanged except alignment fixes) */
    Dialog {
        id: categoryDialog
        title: "Add New Category"
        modal: true
        anchors.centerIn: parent
        width: 320

        ColumnLayout {
            anchors.fill: parent
            spacing: 16

            TextField {
                id: categoryInput
                Layout.fillWidth: true
                placeholderText: "e.g., Work, Personal, Ideas..."

                onAccepted: {
                    if (text.trim().length > 0) {
                        Services.Notes.addCategory(text.trim())
                        categoryDialog.close()
                        text = ""
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Button {
                    text: "Cancel"
                    Layout.fillWidth: true
                    onClicked: {
                        categoryDialog.close()
                        categoryInput.text = ""
                    }
                }

                Button {
                    text: "Add"
                    Layout.fillWidth: true
                    onClicked: {
                        if (categoryInput.text.trim().length > 0) {
                            Services.Notes.addCategory(categoryInput.text.trim())
                            categoryDialog.close()
                            categoryInput.text = ""
                        }
                    }
                }
            }
        }
    }
}
