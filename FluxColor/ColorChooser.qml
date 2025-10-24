/*
 * Copyright (C) 2020-2021 Frank Mertens.
 *
 * Distribution and use is allowed under the terms of the zlib license
 * (see LICENSE-zlib).
 *
 */

import QtQuick 2.6
import QtQuick.Controls 2.6



Rectangle{
    id:root
    width: 100
    height: 300
    color: "transparent"

    signal colorChanged(color newColor)
    readonly property color selectedColor: hueWheel.color
    property color currentColor: hueWheel.color

    Column {
        id: column
        height: 80
        width: 120
        x: 220
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.3
        Item {
            width: column.width
            height: width
            HueWheel {
                id: hueWheel
                anchors.fill: parent
                onColorChanged: {
                    root.currentColor = color
                    root.colorChanged(color)
                    console.log("HueWheel color changed:", color)
                }

            }
        }
        Column {
            leftPadding: 10
            rightPadding: 10
            bottomPadding: 10
            spacing: 5
            Row {
                spacing: parent.spacing
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("S")
                    color: "white"

                }
                Slider {
                    id: satSlider
                    width: 80
                    from: 0
                    to: 1
                    value: 1

                    onMoved: hueWheel.colorSaturation = value

                    handle: Rectangle {
                        width: 10
                        height: 10
                        color: "#b3b3b3"
                        radius: width / 2
                        border.color: "white"
                        border.width: 1
                        x: satSlider.visualPosition * (satSlider.width - width)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

            }
            Row {
                spacing: parent.spacing
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("V")
                    color: "white"
                }
                Slider {
                    id: valSlider
                    width: 80
                    from: 0
                    to: 1
                    value: 1
                    onMoved:
                        hueWheel.colorValue = valSlider.value

                    handle: Rectangle {
                        width: 10
                        height: 10
                        color: "#b3b3b3"
                        radius: width / 2
                        border.color: "white"
                        border.width: 1
                        x: valSlider.visualPosition * (valSlider.width - width)
                        anchors.verticalCenter: parent.verticalCenter
                    }



                }
            }
        }
        TextField {
            id: rgbField
            width: parent.width *0.52
            x: 32
            text: hueWheel.color
            font.capitalization: Font.AllUppercase
            font.family: "mono"
            color: "white"  // رنگ متن سفید

            background: Rectangle {
                color: "gray"  // بک‌گراند مشکی
                radius: 4
            }

            font.pixelSize: 10
            onFocusChanged: if (focus) selectAll()
            Connections {
                target: hueWheel
                function onColorChanged() {
                    rgbField.text = hueWheel.color
                }
            }
            Connections {
                property color newColor
                function onEditingFinished() {
                    newColor = rgbField.text
                    let invalid = newColor.hsvValue === 0 && rgbField.text.toLowerCase() != "black" && rgbField.text.toUpperCase() != "#000" && rgbField.text.toUpperCase() != "#000000"
                    if (!invalid) {
                        satSlider.value = newColor.hsvSaturation
                        valSlider.value = newColor.hsvValue
                        satSlider.moved()
                        valSlider.moved()
                        hueWheel.setValue(newColor.hsvHue * 360)
                        rgbField.text = newColor
                        rgbField.focus = false
                    }
                    else {
                        rgbField.selectAll()
                    }
                }
            }
        }
        Item { width: 1; height: 16 }
    }
}
