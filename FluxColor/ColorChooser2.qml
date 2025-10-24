import QtQuick 2.6
import QtQuick.Controls 2.6

Rectangle {
    width: 100
    height: 300
    color: "transparent"

    Column {
        readonly property color color: hueWheel2.color

        id: column2
        height: 80
        width: 120
        x: 500
        y: -120

        Item {
            width: column2.width
            height: width
            HueWheel {
                id: hueWheel2
                anchors.fill: parent
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
                    id: satSlider2
                    width: 80
                    from: 0
                    to: 1
                    value: 1

                    onMoved: hueWheel2.colorSaturation = value

                    handle: Rectangle {
                        width: 10
                        height: 10
                        color: "#b3b3b3"
                        radius: width / 2
                        border.color: "white"
                        border.width: 1
                        x: satSlider2.visualPosition * (satSlider2.width - width)
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
                    id: valSlider2
                    width: 80
                    from: 0
                    to: 1
                    value: 1

                    onMoved: hueWheel2.colorValue = value

                    handle: Rectangle {
                        width: 10
                        height: 10
                        color: "#b3b3b3"
                        radius: width / 2
                        border.color: "white"
                        border.width: 1
                        x: valSlider2.visualPosition * (valSlider2.width - width)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        TextField {
            id: rgbField2
            width: parent.width * 0.52
            x: 32
            text: hueWheel2.color
            font.capitalization: Font.AllUppercase
            font.family: "mono"
            color: "white"

            background: Rectangle {
                color: "gray"
                radius: 4
            }
            font.pixelSize: 10


            onFocusChanged: if (focus) selectAll()

            Connections {
                target: hueWheel2
                function onColorChanged() {
                    rgbField2.text = hueWheel2.color
                }
            }

            Connections {
                property color newColor2
                function onEditingFinished() {
                    newColor2 = rgbField2.text
                    let invalid = newColor2.hsvValue === 0 &&
                                  rgbField2.text.toLowerCase() !== "black" &&
                                  rgbField2.text.toUpperCase() !== "#000" &&
                                  rgbField2.text.toUpperCase() !== "#000000"

                    if (!invalid) {
                        satSlider2.value = newColor2.hsvSaturation
                        valSlider2.value = newColor2.hsvValue
                        satSlider2.moved()
                        valSlider2.moved()
                        hueWheel2.setValue(newColor2.hsvHue * 360)
                        rgbField2.text = newColor2
                        rgbField2.focus = false
                    } else {
                        rgbField2.selectAll()
                    }
                }
            }
        }

        Item { width: 1; height: 16 }
    }
}
