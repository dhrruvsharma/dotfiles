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
    focus: true

    property int drawerWidth: 600
    implicitWidth: opened ? drawerWidth : 0

    anchors.bottom: parent.bottom
    anchors.left: parent.left

    y: 0

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutCubic
        }
    }

    // Background overlay with shadow effect
    Rectangle {
        anchors.fill: parent
        visible: root.opened
        radius: 24
        color: ColorsModule.Colors.surface_container_high

        layer.enabled: true
        layer.effect: ShaderEffect {
            property real shadowOpacity: 0.15
        }
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

            // Enhanced Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.preferredHeight: 24
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

                // Note count badge
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: countText.contentWidth + 16
                    radius: 14
                    color: ColorsModule.Colors.tertiary_container
                    visible: Services.Notes.getNotesForCategory(Services.Notes.currentCategory).length > 0

                    Text {
                        id: countText
                        anchors.centerIn: parent
                        text: Services.Notes.getNotesForCategory(Services.Notes.currentCategory).length
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: ColorsModule.Colors.on_tertiary_container
                    }
                }

                Button {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    flat: true

                    contentItem: Text {
                        text: "+"
                        font.pixelSize: 22
                        font.weight: Font.Bold
                        anchors.centerIn: parent
                        color: ColorsModule.Colors.on_primary_container
                    }

                    background: Rectangle {
                        radius: 18
                        color: parent.hovered || parent.pressed
                            ? Qt.darker(ColorsModule.Colors.primary_container, 1.1)
                            : ColorsModule.Colors.primary_container

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
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

            // Enhanced Category tabs with improved styling
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
                            Layout.preferredWidth: categoryText.contentWidth + (modelData === "notes" ? 28 : 40)
                            radius: 18

                            color: Services.Notes.currentCategory === modelData
                                ? ColorsModule.Colors.primary_container
                                : ColorsModule.Colors.surface_container_highest

                            border.color: Services.Notes.currentCategory === modelData
                                ? ColorsModule.Colors.primary
                                : "transparent"
                            border.width: 2

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }

                            Behavior on border.color {
                                ColorAnimation { duration: 200 }
                            }

                            // Hover effect
                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: ColorsModule.Colors.on_surface
                                opacity: categoryMouseArea.containsMouse ? 0.08 : 0

                                Behavior on opacity {
                                    NumberAnimation { duration: 150 }
                                }
                            }

                            MouseArea {
                                id: categoryMouseArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: Services.Notes.setCurrentCategory(modelData)
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 14
                                anchors.rightMargin: modelData === "notes" ? 14 : 6
                                spacing: 6

                                Text {
                                    id: categoryText
                                    text: modelData.charAt(0).toUpperCase() + modelData.slice(1)
                                    color: Services.Notes.currentCategory === modelData
                                        ? ColorsModule.Colors.on_primary_container
                                        : ColorsModule.Colors.on_surface
                                    font.pixelSize: 14
                                    font.weight: Services.Notes.currentCategory === modelData
                                        ? Font.DemiBold
                                        : Font.Medium

                                    Behavior on color {
                                        ColorAnimation { duration: 200 }
                                    }
                                }

                                Button {
                                    visible: modelData !== "notes"
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    flat: true

                                    contentItem: Text {
                                        text: "×"
                                        font.pixelSize: 16
                                        font.weight: Font.Bold
                                        anchors.centerIn: parent
                                        color: ColorsModule.Colors.error
                                    }

                                    background: Rectangle {
                                        radius: 12
                                        color: parent.hovered || parent.pressed
                                            ? ColorsModule.Colors.error_container
                                            : "transparent"

                                        Behavior on color {
                                            ColorAnimation { duration: 150 }
                                        }
                                    }

                                    onClicked: Services.Notes.removeCategory(modelData)
                                }
                            }
                        }
                    }
                }
            }

            // Enhanced Notes list with better card design
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ColumnLayout {
                    width: root.drawerWidth - 48
                    spacing: 12

                    // Empty state
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        visible: Services.Notes.getNotesForCategory(Services.Notes.currentCategory).length === 0

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 12

                            Text {
                                text: "📝"
                                font.pixelSize: 48
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: "No notes yet"
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: ColorsModule.Colors.on_surface_variant
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: "Add your first note below"
                                font.pixelSize: 13
                                color: ColorsModule.Colors.on_surface_variant
                                opacity: 0.7
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    Repeater {
                        id: notesRepeater
                        model: Services.Notes.getNotesForCategory(Services.Notes.currentCategory)

                        delegate: Rectangle {
                            width: 500
                            Layout.preferredHeight: Math.max(noteText.contentHeight + 28, 54)
                            Layout.minimumHeight: 54

                            radius: 14
                            color: ColorsModule.Colors.surface_container_highest
                            border.color: ColorsModule.Colors.outline_variant
                            border.width: 1

                            Behavior on border.color {
                                ColorAnimation { duration: 150 }
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 12
                                anchors.topMargin: 14
                                anchors.bottomMargin: 14
                                spacing: 12

                                // Note indicator dot
                                Rectangle {
                                    Layout.preferredWidth: 6
                                    Layout.preferredHeight: 6
                                    Layout.alignment: Qt.AlignTop
                                    Layout.topMargin: 6
                                    radius: 3
                                    color: ColorsModule.Colors.primary
                                }

                                Text {
                                    id: noteText
                                    text: modelData.text
                                    Layout.fillWidth: false
                                    Layout.maximumWidth: 400
                                    color: ColorsModule.Colors.on_surface
                                    font.pixelSize: 14
                                    lineHeight: 1.4
                                    elide: Text.ElideRight
                                    wrapMode: Text.Wrap
                                }


                                Button {
                                    id: deleteButton
                                    Layout.preferredWidth: 32
                                    Layout.preferredHeight: 32
                                    Layout.alignment: Qt.AlignTop
                                    Layout.topMargin: 0

                                    flat: true
                                    hoverEnabled: true

                                    contentItem: Text {
                                        text: "×"
                                        font.pixelSize: 20
                                        font.weight: Font.Bold
                                        anchors.centerIn: parent
                                        color: deleteButton.hovered || deleteButton.pressed
                                            ? ColorsModule.Colors.error
                                            : ColorsModule.Colors.on_surface_variant

                                        Behavior on color {
                                            ColorAnimation { duration: 150 }
                                        }
                                    }

                                    background: Rectangle {
                                        radius: 16
                                        color: deleteButton.hovered || deleteButton.pressed
                                            ? ColorsModule.Colors.error_container
                                            : ColorsModule.Colors.surface_container_low

                                        border.color: deleteButton.hovered || deleteButton.pressed
                                            ? ColorsModule.Colors.error
                                            : "transparent"
                                        border.width: 1

                                        Behavior on color {
                                            ColorAnimation { duration: 150 }
                                        }

                                        Behavior on border.color {
                                            ColorAnimation { duration: 150 }
                                        }
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

            // Enhanced Input field
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                TextField {
                    id: inputField
                    Layout.fillWidth: true
                    placeholderText: "Add note to " + Services.Notes.currentCategory + "..."
                    color: ColorsModule.Colors.on_surface
                    font.pixelSize: 14
                    verticalAlignment: TextInput.AlignVCenter

                    leftPadding: 16
                    rightPadding: 16
                    topPadding: 14
                    bottomPadding: 14

                    background: Rectangle {
                        radius: 14
                        color: ColorsModule.Colors.surface_container_low
                        border.color: inputField.focus
                            ? ColorsModule.Colors.primary
                            : ColorsModule.Colors.outline
                        border.width: inputField.focus ? 2 : 1

                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
                        }

                        Behavior on border.width {
                            NumberAnimation { duration: 150 }
                        }
                    }

                    onAccepted: {
                        if (text.trim().length === 0)
                            return
                        Services.Notes.add(text)
                        text = ""
                    }
                }

                Button {
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                    enabled: inputField.text.trim().length > 0

                    contentItem: Text {
                        text: "↵"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        anchors.centerIn: parent
                        color: parent.enabled
                            ? ColorsModule.Colors.on_primary
                            : ColorsModule.Colors.on_surface_variant
                    }

                    background: Rectangle {
                        radius: 24
                        color: parent.enabled
                            ? (parent.hovered || parent.pressed
                                ? Qt.darker(ColorsModule.Colors.primary, 1.1)
                                : ColorsModule.Colors.primary)
                            : ColorsModule.Colors.surface_container_highest

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
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

    // Enhanced Dialog for adding new category
    Dialog {
        id: categoryDialog
        title: "Add New Category"
        modal: true
        anchors.centerIn: parent
        width: 320

        background: Rectangle {
            radius: 16
            color: ColorsModule.Colors.surface_container_high
            border.color: ColorsModule.Colors.outline_variant
            border.width: 1
        }

        header: Rectangle {
            width: parent.width
            height: 60
            color: "transparent"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                text: "Add New Category"
                font.pixelSize: 18
                font.weight: Font.DemiBold
                color: ColorsModule.Colors.on_surface
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: ColorsModule.Colors.outline_variant
                opacity: 0.5
            }
        }

        ColumnLayout {
            spacing: 16
            anchors.fill: parent

            TextField {
                id: categoryInput
                Layout.fillWidth: true
                placeholderText: "e.g., Work, Personal, Ideas..."
                color: ColorsModule.Colors.on_surface
                font.pixelSize: 14

                leftPadding: 16
                rightPadding: 16
                topPadding: 12
                bottomPadding: 12

                background: Rectangle {
                    radius: 12
                    color: ColorsModule.Colors.surface_container_low
                    border.color: categoryInput.focus
                        ? ColorsModule.Colors.primary
                        : ColorsModule.Colors.outline
                    border.width: categoryInput.focus ? 2 : 1

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }
                }

                onAccepted: {
                    if (text.trim().length > 0) {
                        Services.Notes.addCategory(text.trim())
                        categoryDialog.close()
                        text = ""
                    }
                }
            }

            Item { Layout.preferredHeight: 8 }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Button {
                    text: "Cancel"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 44

                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: ColorsModule.Colors.on_surface
                    }

                    background: Rectangle {
                        radius: 12
                        color: parent.hovered || parent.pressed
                            ? ColorsModule.Colors.surface_container_highest
                            : ColorsModule.Colors.surface_container
                        border.color: ColorsModule.Colors.outline_variant
                        border.width: 1

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    onClicked: {
                        categoryDialog.close()
                        categoryInput.text = ""
                    }
                }

                Button {
                    text: "Add"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 44

                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: ColorsModule.Colors.on_primary
                    }

                    background: Rectangle {
                        radius: 12
                        color: parent.hovered || parent.pressed
                            ? Qt.darker(ColorsModule.Colors.primary, 1.1)
                            : ColorsModule.Colors.primary

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

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
