import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services as Services
import "../colors" as ColorsModule
import Qt5Compat.GraphicalEffects
import qs.components

Item {
    id: root
    property bool opened: true

    width: 420
    height: 110

    Behavior on y {
        NumberAnimation {
            duration: 260
            easing.type: Easing.OutCubic
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 180 }
    }

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: ColorsModule.Colors.surface_container_high
        border.color: ColorsModule.Colors.outline_variant
        border.width: 1

        // Subtle shadow effect
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 4
            radius: 12
            samples: 25
            color: "#40000000"
        }

        Item {
            anchors.fill: parent
            anchors.margins: 16
            anchors.topMargin: parent.height - 40
            opacity: 0.3
            clip: true

            Row {
                anchors.fill: parent
                spacing: 2

                Repeater {
                    model: Services.Cava.values

                    Rectangle {
                        width: Math.max(2, parent.width / Services.Cava.barsCount - 2)
                        height: Math.max(2, modelData * parent.height)
                        radius: 2
                        color: ColorsModule.Colors.primary
                        anchors.verticalCenter: parent.verticalCenter

                        Behavior on height {
                            NumberAnimation { duration: 60; easing.type: Easing.OutQuad }
                        }
                    }
                }
            }
        }
        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16

            Rectangle {
                width: 78
                height: 78
                radius: 12
                color: ColorsModule.Colors.surface_container_highest
                clip: true

                Image {
                    anchors.fill: parent
                    source: Services.Media.artUrl
                    fillMode: Image.PreserveAspectCrop
                    smooth: true

                    // Placeholder when no art
                    Rectangle {
                        anchors.fill: parent
                        visible: parent.status !== Image.Ready
                        color: ColorsModule.Colors.surface_container_highest

                        Text {
                            anchors.centerIn: parent
                            text: "🎵"
                            font.pixelSize: 32
                            color: ColorsModule.Colors.on_surface_variant
                        }
                    }
                }
            }

            // Track Info and Progress
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6

                // Track Title
                Text {
                    text: Services.Media.title || "No media playing"
                    color: ColorsModule.Colors.on_surface
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                // Artist
                Text {
                    text: Services.Media.artist || "Unknown artist"
                    color: ColorsModule.Colors.on_surface_variant
                    font.pixelSize: 13
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }

                // Progress Bar
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Slider {
                        id: progressSlider
                        from: 0
                        to: Services.Media.length
                        value: Services.Media.position
                        Layout.fillWidth: true

                        onMoved: Services.Media.setPosition(value)

                        background: Rectangle {
                            x: progressSlider.leftPadding
                            y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 4
                            width: progressSlider.availableWidth
                            height: implicitHeight
                            radius: 2
                            color: ColorsModule.Colors.surface_container_highest

                            Rectangle {
                                width: progressSlider.visualPosition * parent.width
                                height: parent.height
                                color: ColorsModule.Colors.primary
                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: progressSlider.leftPadding + progressSlider.visualPosition * (progressSlider.availableWidth - width)
                            y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                            implicitWidth: 12
                            implicitHeight: 12
                            radius: 6
                            color: progressSlider.pressed ? ColorsModule.Colors.primary_fixed : ColorsModule.Colors.primary
                            border.color: ColorsModule.Colors.primary_container
                            border.width: 1
                        }
                    }

                    // Time labels
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: formatTime(Services.Media.position)
                            color: ColorsModule.Colors.on_surface_variant
                            font.pixelSize: 11
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: formatTime(Services.Media.length)
                            color: ColorsModule.Colors.on_surface_variant
                            font.pixelSize: 11
                        }
                    }
                }
            }

            // Media Controls
            RowLayout {
                spacing: 4
                Layout.rightMargin: 4

                Repeater {
                    model: [
                        { icon: "⏮", action: function() { Services.Media.previous() } },
                        { icon: Services.Media.isPlaying ? "⏸" : "▶", action: function() { Services.Media.playPause() } },
                        { icon: "⏭", action: function() { Services.Media.next() } }
                    ]

                    Button {
                        text: modelData.icon
                        onClicked: modelData.action()

                        implicitWidth: index === 1 ? 44 : 40
                        implicitHeight: index === 1 ? 44 : 40

                        hoverEnabled: true

                        background: Rectangle {
                            radius: parent.width / 2
                            color: index === 1
                                ? (parent.hovered ? ColorsModule.Colors.primary_container : ColorsModule.Colors.primary)
                                : (parent.hovered ? ColorsModule.Colors.surface_container_highest : "transparent")

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: index === 1 ? 18 : 16
                            color: index === 1
                                ? ColorsModule.Colors.on_primary
                                : ColorsModule.Colors.on_surface
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                }
            }
        }
    }

    // Helper function to format time
    function formatTime(seconds) {
        if (!seconds || seconds < 0) return "0:00"
        var mins = Math.floor(seconds / 60)
        var secs = Math.floor(seconds % 60)
        return mins + ":" + (secs < 10 ? "0" : "") + secs
    }
}
