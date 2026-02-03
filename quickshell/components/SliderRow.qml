pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../colors" as ColorsModule

Item {
    id: root

    // Core slider properties
    property real from: 0
    property real to: 100
    property real value: 0
    property real stepSize: 0
    property int snapMode: stepSize > 0 ? Slider.SnapAlways : Slider.NoSnap

    // Signals
    signal moved(real value)

    // Label and display properties
    property string label: ""
    property bool showValue: true
    property string valuePrefix: ""
    property string valueSuffix: ""
    property int valuePrecision: 0

    // Visual customization
    property real trackHeightDiff: 30  // Changed from 15 to 30 to make track thinner
    property real handleGap: 6
    property real trackNearHandleRadius: Appearance.rounding.unsharpen
    property bool useAnim: true
    property int iconSize: Appearance.font.size.large
    property string icon: ""

    // Color customization
    property color accentColor: ColorsModule.Colors.primary
    property color trackColor: ColorsModule.Colors.surface_container_high
    property color labelColor: ColorsModule.Colors.on_surface
    property color valueColor: ColorsModule.Colors.on_surface_variant

    Layout.fillWidth: true
    implicitWidth: 200
    implicitHeight: label !== "" ? 60 : 40

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        // Label and value display row
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: label !== "" ? 20 : 0
            visible: label !== ""

            RowLayout {
                anchors.fill: parent
                spacing: 12

                // Icon (optional)
                Text {
                    visible: root.icon !== ""
                    text: root.icon
                    font.family: "Material Icons"
                    font.pixelSize: root.iconSize
                    color: root.accentColor
                    Layout.alignment: Qt.AlignVCenter

                    Behavior on color {
                        enabled: Config.runtime.appearance.animations.enabled
                        ColorAnimation {
                            duration: Appearance.animation.durations.small
                        }
                    }
                }

                // Label text
                Text {
                    text: root.label
                    font.pixelSize: Appearance.font.size.medium
                    font.weight: Font.Medium
                    color: root.labelColor
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    elide: Text.ElideRight

                    Behavior on color {
                        enabled: Config.runtime.appearance.animations.enabled
                        ColorAnimation {
                            duration: Appearance.animation.durations.small
                        }
                    }
                }

                // Value display
                Text {
                    visible: root.showValue
                    text: {
                        let val = root.valuePrecision > 0
                            ? slider.value.toFixed(root.valuePrecision)
                            : Math.round(slider.value)
                        return root.valuePrefix + val + root.valueSuffix
                    }
                    font.pixelSize: Appearance.font.size.medium
                    font.weight: Font.DemiBold
                    font.family: "JetBrains Mono"
                    color: root.valueColor
                    Layout.alignment: Qt.AlignVCenter

                    Behavior on color {
                        enabled: Config.runtime.appearance.animations.enabled
                        ColorAnimation {
                            duration: Appearance.animation.durations.small
                        }
                    }
                }
            }
        }

        // Slider component
        Slider {
            id: slider

            Layout.fillWidth: true
            Layout.preferredHeight: 40

            from: root.from
            to: root.to
            value: root.value
            stepSize: root.stepSize
            snapMode: root.snapMode

            onMoved: {
                root.moved(value)
            }

            MouseArea {
                anchors.fill: parent
                onPressed: (mouse) => mouse.accepted = false
                cursorShape: slider.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
            }

            background: Item {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: parent.height

                // Background glow effect when pressed
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height - root.trackHeightDiff + 4
                    color: "transparent"
                    border.color: root.accentColor
                    border.width: 2
                    radius: (height / 2) * Config.runtime.appearance.rounding.factor  // Fully rounded
                    opacity: slider.pressed ? 0.2 : 0

                    Behavior on opacity {
                        enabled: Config.runtime.appearance.animations.enabled
                        NumberAnimation {
                            duration: Appearance.animation.durations.fast
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                // Filled segment (left side)
                Rectangle {
                    id: filledTrack
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                    width: root.handleGap + (slider.visualPosition * (slider.width - root.handleGap * 2))
                        - ((slider.pressed ? 1.5 : 3) / 2 + root.handleGap)

                    height: slider.height - root.trackHeightDiff
                    radius: (height / 2) * Config.runtime.appearance.rounding.factor  // Fully rounded on left
                    topRightRadius: root.trackNearHandleRadius
                    bottomRightRadius: root.trackNearHandleRadius

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            position: 0.0
                            color: Qt.lighter(root.accentColor, 1.1)
                        }
                        GradientStop {
                            position: 1.0
                            color: root.accentColor
                        }
                    }

                    // Inner glow effect
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: parent.radius
                        topRightRadius: parent.topRightRadius
                        bottomRightRadius: parent.bottomRightRadius
                        gradient: Gradient {
                            orientation: Gradient.Vertical
                            GradientStop {
                                position: 0.0
                                color: Qt.rgba(1, 1, 1, 0.15)
                            }
                            GradientStop {
                                position: 0.5
                                color: "transparent"
                            }
                        }
                    }

                    Behavior on width {
                        enabled: Config.runtime.appearance.animations.enabled
                        NumberAnimation {
                            duration: !root.useAnim ? 0 : Appearance.animation.durations.small
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.animation.curves.expressiveEffects
                        }
                    }
                }

                // Unfilled segment (right side)
                Rectangle {
                    id: unfilledTrack
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    width: root.handleGap + ((1 - slider.visualPosition) * (slider.width - root.handleGap * 2))
                        - ((slider.pressed ? 1.5 : 3) / 2 + root.handleGap)

                    height: slider.height - root.trackHeightDiff
                    color: root.trackColor
                    radius: (height / 2) * Config.runtime.appearance.rounding.factor  // Fully rounded on right
                    topLeftRadius: root.trackNearHandleRadius
                    bottomLeftRadius: root.trackNearHandleRadius

                    // Subtle inner shadow
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: parent.radius
                        topLeftRadius: parent.topLeftRadius
                        bottomLeftRadius: parent.bottomLeftRadius
                        gradient: Gradient {
                            orientation: Gradient.Vertical
                            GradientStop {
                                position: 0.0
                                color: Qt.rgba(0, 0, 0, 0.1)
                            }
                            GradientStop {
                                position: 0.3
                                color: "transparent"
                            }
                        }
                    }

                    Behavior on width {
                        enabled: Config.runtime.appearance.animations.enabled
                        NumberAnimation {
                            duration: !root.useAnim ? 0 : Appearance.animation.durations.small
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.animation.curves.expressiveEffects
                        }
                    }
                }

                // Track tick marks (optional, shown when stepSize > 0)
                Row {
                    visible: root.stepSize > 0 && root.to > root.from
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: root.handleGap
                    anchors.rightMargin: root.handleGap
                    spacing: {
                        let steps = Math.floor((root.to - root.from) / root.stepSize)
                        if (steps <= 1) return 0
                        return (slider.width - root.handleGap * 2 - 4 * (steps + 1)) / steps
                    }

                    Repeater {
                        model: {
                            if (root.stepSize <= 0 || root.to <= root.from) return 0
                            return Math.floor((root.to - root.from) / root.stepSize) + 1
                        }

                        Rectangle {
                            width: 4
                            height: 4
                            radius: 2
                            color: {
                                let stepValue = root.from + index * root.stepSize
                                return stepValue <= slider.value
                                    ? ColorsModule.Colors.on_primary
                                    : ColorsModule.Colors.outline_variant
                            }
                            opacity: 0.6

                            Behavior on color {
                                enabled: Config.runtime.appearance.animations.enabled
                                ColorAnimation {
                                    duration: Appearance.animation.durations.small
                                }
                            }
                        }
                    }
                }
            }

            handle: Item {
                x: root.handleGap + (slider.visualPosition * (slider.width - root.handleGap * 2)) - width / 2
                anchors.verticalCenter: parent.verticalCenter
                width: slider.pressed ? 24 : 20  // Changed from 7/5 to 20/16 for larger rounded handle
                height: slider.pressed ? 24 : 20  // Changed to make handle circular

                Behavior on width {
                    enabled: Config.runtime.appearance.animations.enabled
                    NumberAnimation {
                        duration: Appearance.animation.durations.fast
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on height {
                    enabled: Config.runtime.appearance.animations.enabled
                    NumberAnimation {
                        duration: Appearance.animation.durations.fast
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on x {
                    enabled: Config.runtime.appearance.animations.enabled
                    NumberAnimation {
                        duration: !root.useAnim ? 0 : Appearance.animation.elementMoveFast.duration
                        easing.type: Appearance.animation.elementMoveFast.type
                        easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                    }
                }

                // Handle shadow/glow
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width + 8
                    height: parent.height + 8
                    radius: width / 2  // Fully circular
                    color: "transparent"
                    border.color: root.accentColor
                    border.width: slider.pressed ? 3 : 0
                    opacity: slider.pressed ? 0.3 : 0

                    Behavior on opacity {
                        enabled: Config.runtime.appearance.animations.enabled
                        NumberAnimation {
                            duration: Appearance.animation.durations.fast
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on border.width {
                        enabled: Config.runtime.appearance.animations.enabled
                        NumberAnimation {
                            duration: Appearance.animation.durations.fast
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                // Main handle - fully rounded/circular
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    radius: width / 2  // Fully circular handle
                    color: root.accentColor

                    // Handle highlight
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width - 4
                        height: parent.height - 4
                        anchors.verticalCenterOffset: 0
                        radius: width / 2  // Circular highlight
                        gradient: Gradient {
                            orientation: Gradient.Vertical
                            GradientStop {
                                position: 0.0
                                color: Qt.rgba(1, 1, 1, 0.3)
                            }
                            GradientStop {
                                position: 1.0
                                color: "transparent"
                            }
                        }
                    }
                }
            }
        }
    }
}
