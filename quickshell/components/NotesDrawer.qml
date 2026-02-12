import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services as Services
import "../colors" as ColorsModule

Item {
    id: root
    property bool opened: false

    implicitHeight: opened ? 700 : 0
    implicitWidth: opened ? drawerWidth : 0
    property int drawerWidth: 640

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    focus: true

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutCubic
            property: "width"
        }
    }
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutCubic
            property: "height"
        }
    }

    Popout {
        id: popoutBackground
        anchors.fill: parent
        clip: true
        alignment: 5
        radius: 32
        color: ColorsModule.Colors.surface_container_lowest

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(151, 204, 249, 0.02) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Rectangle {
            width: 120
            height: 3
            anchors.top: parent.top
            anchors.topMargin: -1.5
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 1.5
            color: ColorsModule.Colors.primary
            opacity: 0.6
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                radius: 20
                color: ColorsModule.Colors.surface_container
                border.width: 1
                border.color: ColorsModule.Colors.outline_variant
                opacity: 0.8

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.width: 1
                    border.color: Qt.rgba(255, 255, 255, 0.05)
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 16

                    Text {
                        text: "Quick Notes"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        color: ColorsModule.Colors.on_surface
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true }

                    Rectangle {
                        Layout.preferredHeight: 36
                        Layout.preferredWidth: Math.max(36, countText.contentWidth + 24)
                        Layout.alignment: Qt.AlignVCenter
                        radius: 18
                        color: ColorsModule.Colors.primary_container
                        opacity: Services.Notes.getNotesForCategory(
                            Services.Notes.currentCategory).length > 0 ? 1 : 0.4

                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Qt.rgba(151, 204, 249, 0.1) }
                                GradientStop { position: 1.0; color: "transparent" }
                            }
                        }

                        Text {
                            id: countText
                            anchors.centerIn: parent
                            text: Services.Notes.getNotesForCategory(
                                Services.Notes.currentCategory).length
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                            color: ColorsModule.Colors.on_primary_container
                        }
                    }

                    Button {
                        id: addCategoryBtn
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        Layout.alignment: Qt.AlignVCenter
                        flat: true

                        contentItem: Text {
                            text: "+"
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ColorsModule.Colors.on_primary
                        }

                        background: Rectangle {
                            radius: 18
                            color: addCategoryBtn.hovered
                                ? Qt.darker(ColorsModule.Colors.primary_container, 1.2)
                                : ColorsModule.Colors.primary_container

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: "transparent"
                                border.width: 1
                                border.color: Qt.rgba(151, 204, 249, 0.2)
                            }

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        onClicked: categoryDialog.open()

                        ToolTip {
                            text: "Add new category"
                            delay: 300
                            visible: parent.hovered
                            background: Rectangle {
                                radius: 6
                                color: ColorsModule.Colors.surface_container_highest
                                border.width: 1
                                border.color: ColorsModule.Colors.outline_variant
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                radius: 16
                color: ColorsModule.Colors.surface_container
                border.width: 1
                border.color: ColorsModule.Colors.outline_variant
                opacity: 0.6

                ScrollView {
                    anchors.fill: parent
                    anchors.margins: 4
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                    clip: true

                    RowLayout {
                        spacing: 8
                        height: parent.height

                        Repeater {
                            model: Services.Notes.categories

                            delegate: Rectangle {
                                id: categoryTab
                                Layout.preferredHeight: 36
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth:
                                    categoryText.implicitWidth + (modelData === "notes" ? 24 : 40)

                                radius: 18
                                color: Services.Notes.currentCategory === modelData
                                    ? ColorsModule.Colors.primary
                                    : mouseArea.containsMouse
                                        ? ColorsModule.Colors.surface_container_highest
                                        : ColorsModule.Colors.surface_container

                                Rectangle {
                                    anchors.fill: parent
                                    radius: parent.radius
                                    color: "transparent"
                                    border.width: Services.Notes.currentCategory === modelData ? 2 : 0
                                    border.color: ColorsModule.Colors.primary
                                    opacity: 0.5
                                }

                                scale: mouseArea.containsMouse ? 1.05 : 1.0
                                z: mouseArea.containsMouse ? 1 : 0
                                Behavior on scale {
                                    NumberAnimation { duration: 150 }
                                }
                                Behavior on color {
                                    ColorAnimation { duration: 200 }
                                }

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Services.Notes.setCurrentCategory(modelData)
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: modelData === "notes" ? 12 : 8
                                    spacing: 6

                                    Text {
                                        id: categoryText
                                        text: modelData.charAt(0).toUpperCase() + modelData.slice(1)
                                        Layout.alignment: Qt.AlignVCenter
                                        color: Services.Notes.currentCategory === modelData
                                            ? ColorsModule.Colors.on_primary
                                            : ColorsModule.Colors.on_surface
                                        font.pixelSize: 13
                                        font.weight: Font.Medium
                                    }

                                    Button {
                                        visible: modelData !== "notes"
                                        Layout.preferredWidth: 20
                                        Layout.preferredHeight: 20
                                        Layout.alignment: Qt.AlignVCenter
                                        flat: true
                                        opacity: mouseArea.containsMouse ? 1 : 0.6

                                        contentItem: Text {
                                            text: "×"
                                            font.pixelSize: 16
                                            font.weight: Font.Bold
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: Services.Notes.currentCategory === modelData
                                                ? ColorsModule.Colors.on_primary
                                                : ColorsModule.Colors.on_surface
                                        }

                                        background: Rectangle {
                                            radius: 10
                                            color: parent.hovered
                                                ? Qt.rgba(255, 255, 255, 0.2)
                                                : "transparent"
                                        }

                                        onClicked: Services.Notes.removeCategory(modelData)

                                        ToolTip {
                                            text: "Remove category"
                                            delay: 500
                                            visible: parent.hovered
                                            background: Rectangle {
                                                radius: 6
                                                color: ColorsModule.Colors.surface_container_highest
                                                border.width: 1
                                                border.color: ColorsModule.Colors.outline_variant
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 20
                color: ColorsModule.Colors.surface_container
                border.width: 1
                border.color: ColorsModule.Colors.outline_variant

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.width: 1
                    border.color: Qt.rgba(255, 255, 255, 0.05)
                }

                ScrollView {
                    anchors.fill: parent
                    anchors.margins: 1
                    clip: true
                    ScrollBar.vertical.visible: true

                    ColumnLayout {
                        width: parent.width - 20
                        spacing: 12

                        Repeater {
                            model: Services.Notes.getNotesForCategory(
                                Services.Notes.currentCategory)

                            delegate: Rectangle {
                                id: noteCard
                                Layout.fillWidth: true
                                Layout.minimumHeight: 72
                                Layout.preferredHeight:
                                    Math.max(noteText.implicitHeight + 40, 72)

                                radius: 16
                                color: ColorsModule.Colors.surface_container_high

                                Rectangle {
                                    anchors.fill: parent
                                    radius: parent.radius
                                    color: "transparent"
                                    border.width: 1
                                    border.color: noteMouseArea.containsMouse
                                        ? ColorsModule.Colors.primary
                                        : Qt.rgba(255, 255, 255, 0.05)
                                    opacity: noteMouseArea.containsMouse ? 0.3 : 0.1
                                }

                                scale: noteMouseArea.containsMouse ? 1.02 : 1.0
                                z: noteMouseArea.containsMouse ? 1 : 0

                                Behavior on scale {
                                    NumberAnimation { duration: 200 }
                                }

                                MouseArea {
                                    id: noteMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 20
                                    spacing: 16

                                    Rectangle {
                                        id: noteIndicator
                                        Layout.preferredWidth: 6
                                        Layout.preferredHeight: 6
                                        Layout.alignment: Qt.AlignCenter
                                        radius: 6
                                        color: ColorsModule.Colors.primary

                                        SequentialAnimation on scale {
                                            loops: Animation.Infinite
                                            running: true
                                            NumberAnimation { to: 1.3; duration: 1500; easing.type: Easing.InOutQuad }
                                            NumberAnimation { to: 1.0; duration: 1500; easing.type: Easing.InOutQuad }
                                        }
                                    }

                                    ColumnLayout {
                                        spacing: 6
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignVCenter

                                        Text {
                                            id: noteText
                                            text: modelData.text
                                            Layout.fillWidth: true
                                            wrapMode: Text.Wrap
                                            color: ColorsModule.Colors.on_surface
                                            font.pixelSize: 14
                                            lineHeight: 1.5
                                            font.weight: Font.Normal
                                        }
                                    }

                                    Button {
                                        id: copyBtn
                                        Layout.preferredWidth: 32
                                        Layout.preferredHeight: 32
                                        Layout.alignment: Qt.AlignTop | Qt.AlignRight
                                        flat: true
                                        opacity: noteMouseArea.containsMouse ? 1 : 0.5

                                        property bool copied: false

                                        contentItem: Text {
                                            text: copyBtn.copied ? "✓" : "⎘"
                                            font.pixelSize: 16
                                            font.family: "monospace"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: copyBtn.copied
                                                ? ColorsModule.Colors.primary
                                                : ColorsModule.Colors.on_surface
                                        }

                                        background: Rectangle {
                                            radius: 16
                                            color: copyBtn.hovered
                                                ? copyBtn.copied
                                                    ? ColorsModule.Colors.primary_container
                                                    : ColorsModule.Colors.surface_container_highest
                                                : "transparent"
                                            border.width: 1
                                            border.color: copyBtn.hovered
                                                ? copyBtn.copied
                                                    ? ColorsModule.Colors.primary
                                                    : ColorsModule.Colors.outline_variant
                                                : "transparent"
                                        }

                                        onClicked: {
                                            Services.Notes.copy(modelData.text)
                                            copyBtn.copied = true
                                            copyTimer.start()
                                        }

                                        Timer {
                                            id: copyTimer
                                            interval: 1500
                                            onTriggered: copyBtn.copied = false
                                        }

                                        ToolTip {
                                            text: copyBtn.copied ? "Copied!" : "Copy to clipboard"
                                            delay: 300
                                            visible: parent.hovered
                                            background: Rectangle {
                                                radius: 6
                                                color: ColorsModule.Colors.surface_container_highest
                                                border.width: 1
                                                border.color: ColorsModule.Colors.outline_variant
                                            }
                                        }
                                    }

                                    Button {
                                        id: deleteBtn
                                        Layout.preferredWidth: 32
                                        Layout.preferredHeight: 32
                                        Layout.alignment: Qt.AlignTop | Qt.AlignRight
                                        flat: true
                                        opacity: noteMouseArea.containsMouse ? 1 : 0.4

                                        contentItem: Text {
                                            text: "🗑"
                                            font.pixelSize: 16
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            color: ColorsModule.Colors.on_surface
                                        }

                                        background: Rectangle {
                                            radius: 16
                                            color: deleteBtn.hovered
                                                ? ColorsModule.Colors.error_container
                                                : "transparent"
                                            border.width: 1
                                            border.color: deleteBtn.hovered
                                                ? ColorsModule.Colors.error
                                                : "transparent"
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

                                        ToolTip {
                                            text: "Delete note"
                                            delay: 300
                                            visible: parent.hovered
                                            background: Rectangle {
                                                radius: 6
                                                color: ColorsModule.Colors.surface_container_highest
                                                border.width: 1
                                                border.color: ColorsModule.Colors.outline_variant
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                radius: 20
                color: ColorsModule.Colors.surface_container_high
                border.color: inputField.activeFocus
                    ? ColorsModule.Colors.primary
                    : ColorsModule.Colors.outline_variant
                border.width: 2

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.width: 1
                    border.color: Qt.rgba(0, 0, 0, 0.1)
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 8
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    spacing: 8

                    TextField {
                        id: inputField
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        placeholderText: "Type your note here..."
                        font.pixelSize: 14
                        placeholderTextColor: ColorsModule.Colors.on_surface_variant
                        color: ColorsModule.Colors.on_surface
                        background: Rectangle {
                            color: "transparent"
                        }

                        onAccepted: {
                            if (text.trim().length === 0) return
                            Services.Notes.add(text)
                            text = ""
                        }
                    }

                    Button {
                        id: sendButton
                        Layout.preferredWidth: 52
                        Layout.preferredHeight: 52
                        Layout.alignment: Qt.AlignVCenter
                        enabled: inputField.text.trim().length > 0
                        opacity: enabled ? 1 : 0.4

                        contentItem: Text {
                            text: "↑"
                            font.pixelSize: 22
                            font.weight: Font.Bold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ColorsModule.Colors.on_primary
                        }

                        background: Rectangle {
                            radius: 26
                            color: sendButton.hovered && sendButton.enabled
                                ? Qt.darker(ColorsModule.Colors.primary_container, 1.2)
                                : ColorsModule.Colors.primary_container

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: "transparent"
                                border.width: 2
                                border.color: ColorsModule.Colors.primary
                                opacity: 0.3
                            }

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        onClicked: {
                            if (inputField.text.trim().length > 0) {
                                Services.Notes.add(inputField.text)
                                inputField.text = ""
                            }
                        }

                        ToolTip {
                            text: "Add note (Enter)"
                            delay: 300
                            visible: parent.hovered
                            background: Rectangle {
                                radius: 6
                                color: ColorsModule.Colors.surface_container_highest
                                border.width: 1
                                border.color: ColorsModule.Colors.outline_variant
                            }
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: categoryDialog
        title: "Create New Category"
        modal: true

        x: (root.width - width) / 2
        y: (root.height - height) / 2
        width: 400
        height: 220
        parent: root

        background: Rectangle {
            radius: 28
            color: ColorsModule.Colors.surface_container_lowest
            border.color: ColorsModule.Colors.outline_variant
            border.width: 1

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.width: 1
                border.color: Qt.rgba(151, 204, 249, 0.1)
            }
        }

        header: Rectangle {
            height: 64
            radius: 28
            color: ColorsModule.Colors.surface_container_lowest

            Rectangle {
                width: 48
                height: 4
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 2
                color: ColorsModule.Colors.outline_variant
                opacity: 0.3
            }

            Text {
                anchors.centerIn: parent
                text: categoryDialog.title
                font.pixelSize: 20
                font.weight: Font.Bold
                color: ColorsModule.Colors.on_surface
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 24

            TextField {
                id: categoryInput
                Layout.fillWidth: true
                placeholderText: "Enter category name..."
                font.pixelSize: 14
                focus: true
                color: ColorsModule.Colors.on_surface
                placeholderTextColor:ColorsModule.Colors.on_surface

                background: Rectangle {
                    radius: 14
                    color: ColorsModule.Colors.surface_container_high
                    border.color: categoryInput.activeFocus
                        ? ColorsModule.Colors.primary
                        : ColorsModule.Colors.outline_variant
                    border.width: 2
                }

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
                    Layout.preferredHeight: 48

                    background: Rectangle {
                        radius: 14
                        color: parent.hovered
                            ? ColorsModule.Colors.surface_container_high
                            : "transparent"
                        border.width: 1
                        border.color: ColorsModule.Colors.outline_variant
                    }

                    contentItem: Text {
                        text: parent.text
                        color: ColorsModule.Colors.on_surface
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        categoryDialog.close()
                        categoryInput.text = ""
                    }
                }

                Button {
                    text: "Create"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    enabled: categoryInput.text.trim().length > 0

                    background: Rectangle {
                        radius: 14
                        color: parent.hovered && parent.enabled
                            ? Qt.darker(ColorsModule.Colors.primary_container, 1.2)
                            : ColorsModule.Colors.primary_container
                        border.width: 2
                        border.color: ColorsModule.Colors.primary
                        opacity: 0.3
                    }

                    contentItem: Text {
                        text: parent.text
                        color: ColorsModule.Colors.on_primary_container
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
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