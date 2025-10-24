import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12
import QtQuick.Extras 1.4
import "."




Rectangle{
    id:leftrect
    width: parent.width * 0.15
    height: parent.height *0.7
    anchors.top: parent.top
    anchors.topMargin: parent.height *0.01
    anchors.left: parent.left
    anchors.leftMargin: parent.width * 0.002
    radius: 5
    color: "transparent"
    border.color: "transparent"
    visible: true

    property alias leftrect: leftrect







    ColumnLayout {
        anchors.fill: parent

        Rectangle{

            id:bordertab
            width: parent.width
            height: parent.height *0.05
            color: "transparent"
            border.color: "white"
            radius: 5

            Rectangle{
                id:tab1
                width: parent.width *0.1
                height: parent.height *0.6
                anchors.left: parent.left
                anchors.leftMargin: parent.width *0.01
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"

                Image {
                    id: btntab1
                    anchors.fill: parent
                    source: "qrc:/img/btnactive.png"
                }

                Text {
                    id: btntab1txt
                    text: qsTr("PTZ")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "White"
                    font.pixelSize: parent.width *0.22
                    font.bold: true
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        btntab1.source = "qrc:/img/btnactive.png"
                        btntab2.source = "qrc:/img/btn.png"
                        btntab3.source = "qrc:/img/btn.png"
                        rectptz.enabled = true
                        rectptz.opacity = 1
                        rectnav.enabled = false
                        rectnav.opacity = 0
                        rectinfo.enabled = false
                        rectinfo.opacity = 0




                    }
                }
            }

            Rectangle{
                id:tab2
                width: parent.width *0.1
                height: parent.height *0.6
                anchors.left: tab1.right
                anchors.leftMargin: parent.width *0.01
                anchors.verticalCenter: parent.verticalCenter

                color: "transparent"

                Image {
                    id: btntab2
                    anchors.fill: parent
                    source: "qrc:/img/btn.png"
                }

                Text {
                    id: btntab2txt
                    text: qsTr("Gimbal")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "White"
                    font.pixelSize: parent.width *0.22
                    font.bold: true
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        btntab1.source = "qrc:/img/btn.png"
                        btntab2.source = "qrc:/img/btnactive.png"
                        btntab3.source = "qrc:/img/btn.png"
                        rectptz.enabled = false
                        rectptz.opacity = 0
                        rectnav.enabled = true
                        rectnav.opacity = 1
                        rectinfo.enabled = false
                        rectinfo.opacity = 0

                    }
                }

            }

            Rectangle{
                id:tab3
                width: parent.width *0.1
                height: parent.height *0.6
                anchors.left: tab2.right
                anchors.leftMargin: parent.width *0.01
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"

                Image {
                    id: btntab3
                    anchors.fill: parent
                    source: "qrc:/img/btn.png"
                }

                Text {
                    id: btntab3txt
                    text: qsTr("Info")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "White"
                    font.pixelSize: parent.width *0.22
                    font.bold: true
                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        btntab1.source = "qrc:/img/btn.png"
                        btntab2.source = "qrc:/img/btn.png"
                        btntab3.source = "qrc:/img/btnactive.png"
                        rectptz.enabled = false
                        rectptz.opacity = 0
                        rectnav.enabled = false
                        rectnav.opacity = 0
                        rectinfo.enabled = true
                        rectinfo.opacity = 1


                    }
                }

            }
        }


        Rectangle{
            id:rectptz
            width: parent.width
            height: parent.height * 0.95
            color: "transparent"
            border.color: "white"
            radius: 5
            anchors.top: bordertab.bottom
            opacity: 1
            enabled: true


            Rectangle{
            id:pantilt
            width: parent.width *0.25
            height: width
            radius: width/2
            color: "transparent"
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.06
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: pantiltimg
                source: "qrc:/img/pantilt.png"
                anchors.fill: parent
            }

            }

            Text {
                id: valuetop
                text: qsTr("+90")
                anchors.top: parent.top
                anchors.topMargin: parent.height *0.02
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                font.pixelSize: parent.width *0.035
            }

            Text {
                id: valuebottom
                text: qsTr("-90")
                anchors.top: parent.top
                anchors.topMargin: parent.height *0.25
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                font.pixelSize: parent.width *0.035

            }

            Text {
                id: valueleft
                text: qsTr("-180")
                anchors.top: parent.top
                anchors.topMargin: parent.height *0.13
                anchors.left: parent.left
                anchors.leftMargin: parent.width *0.27
                color: "white"
                font.pixelSize: parent.width *0.035
            }

            Text {
                id: valueright
                text: qsTr("+180")
                anchors.top: parent.top
                anchors.topMargin: parent.height *0.13
                anchors.right: parent.right
                anchors.rightMargin: parent.width *0.27
                color: "white"
                font.pixelSize: parent.width *0.035
            }

                    Text {
                        id: horizontalspeedtxt
                        text: qsTr("Hrz Speed")
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.02
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        font.pixelSize: parent.width *0.035
                        color: "white"
                    }


                    Slider {
                        id: horizontalSpeedSlider
                        width: 5 // ارتفاع برای اسلایدر عمودی
                        height: parent.height * 0.17 // عرض برای اسلایدر عمودی
                        from: 0
                        to: 100
                        value: 0
                        stepSize: 1
                        anchors.left: parent.left // تغییر به چپ
                        anchors.leftMargin: parent.width * 0.1 // تغییر به margin افقی
                        anchors.top: parent.top
                        anchors.topMargin: parent.height*0.08

                        orientation: Qt.Vertical // تغییر جهت به عمودی

                        background: Rectangle {
                            implicitWidth: 1 // تغییر ارتفاع به عرض
                            radius: 5
                            color: "white"

                            Rectangle {
                                height: horizontalSpeedSlider.visualPosition * parent.height // تغییر به ارتفاع
                                width: parent.width // تغییر به عرض
                                radius: parent.radius
                                color: "gray" // رنگ قسمت پر شده
                            }
                        }

                        handle: Rectangle {
                            width: 10
                            height: 10
                            color: "#b3b3b3"
                            radius: width / 2
                            border.color: "white"
                            border.width: 1
                            y: horizontalSpeedSlider.visualPosition * (horizontalSpeedSlider.height - height) // تغییر به مختصات Y
                            anchors.horizontalCenter: parent.horizontalCenter // تغییر به مرکز افقی
                        }
                    }

                    Rectangle{
                        id:backgroundvaluehorizontalspeedtxt
                        width: parent.width*0.12
                        height: parent.height *0.038
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.14
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.21
                        color: "lightgray"
                        radius: 10
                        Text {
                            id: horizontalspeedvalue
                            text: horizontalSpeedSlider.value
                            color: "black"
                            font.pixelSize: parent.width *0.22
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }




                    Text {
                        id: verticalspeedtxt
                        text: qsTr("Vrt Speed")
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.02
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width *0.05
                        font.pixelSize: parent.width *0.035
                        color: "white"
                    }


                    Slider {
                        id: verticalspeedSlider
                        width: 5 // ارتفاع برای اسلایدر عمودی
                        height: parent.height * 0.17 // عرض برای اسلایدر عمودی
                        from: 0
                        to: 100
                        value: 0
                        stepSize: 1
                        anchors.right: parent.right // تغییر به چپ
                        anchors.rightMargin: parent.width * 0.1 // تغییر به margin افقی
                        anchors.top: parent.top
                        anchors.topMargin: parent.height*0.08

                        orientation: Qt.Vertical // تغییر جهت به عمودی

                        background: Rectangle {
                            implicitWidth: 1 // تغییر ارتفاع به عرض
                            radius: 5
                            color: "white"

                            Rectangle {
                                height: verticalspeedSlider.visualPosition * parent.height // تغییر به ارتفاع
                                width: parent.width // تغییر به عرض
                                radius: parent.radius
                                color: "gray" // رنگ قسمت پر شده
                            }
                        }

                        handle: Rectangle {
                            width: 10
                            height: 10
                            color: "#b3b3b3"
                            radius: width / 2
                            border.color: "white"
                            border.width: 1
                            y: verticalspeedSlider.visualPosition * (verticalspeedSlider.height - height) // تغییر به مختصات Y
                            anchors.horizontalCenter: parent.horizontalCenter // تغییر به مرکز افقی
                        }
                    }

                    Rectangle{
                        id:backgroundvalueverticalspeedSlidertxt
                        width: parent.width*0.12
                        height: parent.height *0.038
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width *0.14
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.21
                        color: "lightgray"
                        radius: 10
                        Text {
                            id: verticalspeedSlidervalue
                            text: verticalspeedSlider.value
                            color: "black"
                            font.pixelSize: parent.width *0.22
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }




















            Rectangle{
                id:titleir
                width: parent.width *0.5
                height: parent.height * 0.06
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: parent.height *0.28

                Image {
                    anchors.fill: parent
                    source: "qrc:/img/title.png"
                }

                Rectangle{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width *0.28
                    height: parent.height *0.65
                    color: "transparent"
                    Image {
                        anchors.fill: parent
                        source: "qrc:/img/icons8-ir-100(3).png"
                    }

                }

            }

            Rectangle{
                id:titlergb
                width: parent.width *0.5
                height: parent.height * 0.06
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: parent.height *0.28

                Image {
                    anchors.fill: parent
                    source: "qrc:/img/title.png"
                }

                Rectangle{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width *0.28
                    height: parent.height *0.65
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        source: "qrc:/img/icons8-rgb-100(2).png"
                    }
                }
            }

            Rectangle{
                id:borderir
                width: parent.width * 0.5
                height: parent.height *0.66
                color: "transparent"
                border.color: "white"
                anchors.left: parent.left
                anchors.top: titleir.bottom
                radius: 3

                Text {
                    id: contrasttxt
                    text: qsTr("Contrast")
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.03
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: parent.width *0.06
                    color: "white"
                }

                Rectangle{
                    id:bordervaluecontrast
                    width: parent.width *0.55
                    height: parent.height *0.08
                    color: "transparent"
                    border.color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: contrasttxt.bottom
                    anchors.topMargin: parent.height *0.01
                    radius: 5


                    Rectangle{
                        id:backgroundvaluecontrasttxt
                        width: parent.width*0.18
                        height: width
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius:3
                        Text {
                            id: contrastvalue
                            text: "25"
                            color: "black"
                            font.pixelSize: parent.width *0.5
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }


                    Rectangle{
                        id:backgroundvaluecontrastdown
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluecontrasttxt.right
                        anchors.leftMargin: parent.width *0.27
                        anchors.verticalCenter: parent.verticalCenter
                        color: "lightgray"
                        radius: 3

                        Image {
                            id: down
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                            rotation: 180
                        }

                    }

                    Rectangle{
                        id:backgroundvaluecontrastup
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluecontrastdown.right
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius: 3

                        Image {
                            id: top
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                        }


                    }

                }


                Text {
                    id: brightnesstxt
                    text: qsTr("Brightness")
                    anchors.top: bordervaluecontrast.bottom
                    anchors.topMargin: parent.height *0.04
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: parent.width *0.06
                    color: "white"
                }

                Rectangle{
                    id:bordervaluebrightness
                    width: parent.width *0.55
                    height: parent.height *0.08
                    color: "transparent"
                    border.color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: brightnesstxt.bottom
                    anchors.topMargin: parent.height *0.01
                    radius: 5


                    Rectangle{
                        id:backgroundvaluebrightnesstxt
                        width: parent.width*0.18
                        height: width
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius:3
                        Text {
                            id: brightnessvalue
                            text: "25"
                            color: "black"
                            font.pixelSize: parent.width *0.5
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }


                    Rectangle{
                        id:backgroundvaluebrightnessdown
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluebrightnesstxt.right
                        anchors.leftMargin: parent.width *0.27
                        anchors.verticalCenter: parent.verticalCenter
                        color: "lightgray"
                        radius: 3

                        Image {
                            id: downbrightness
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                            rotation: 180
                        }

                    }

                    Rectangle{
                        id:backgroundvaluebrightnesstup
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluebrightnessdown.right
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius: 3

                        Image {
                            id: topbrightness
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                        }


                    }
                }



                Text {
                    id: zoomtxt
                    text: qsTr("Zoom")
                    anchors.top: bordervaluebrightness.bottom
                    anchors.topMargin: parent.height *0.06
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: parent.width *0.06
                    color: "white"
                }

                Slider {
                    id: zoomSlider
                    width: parent.width * 0.7
                    height: 6  // ارتفاع کلی کنترل
                    from: 0
                    to: 100
                    value: 0
                    stepSize: 1
                    anchors.top: zoomtxt.bottom
                    anchors.topMargin: parent.height * 0.035
                    anchors.horizontalCenter: parent.horizontalCenter

                    background: Rectangle {
                        implicitHeight: 1
                        radius: 5
                        color: "white"
                        Rectangle {
                            width: zoomSlider.visualPosition * parent.width
                            height: parent.height
                            radius: parent.radius
                            color: "gray" // رنگ قسمت پر شده
                        }

                    }

                    handle: Rectangle {
                        width: 14
                        height: 14
                        color: "#b3b3b3"
                        radius: width / 2
                        border.color: "white"
                        border.width: 1
                        x: zoomSlider.visualPosition * (zoomSlider.width - width)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }


                Rectangle{
                    id:backgroundvaluezoomtxt
                    width: parent.width*0.2
                    height: parent.height *0.046
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width *0.63
                    anchors.top: bordervaluebrightness.bottom
                    anchors.topMargin: parent.height *0.06
                    color: "lightgray"
                    radius: 10
                    Text {
                        id: zoomvalue
                        text: zoomSlider.value
                        color: "black"
                        font.pixelSize: parent.width *0.22
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }


                Text {
                    id: focustxt
                    text: qsTr("Focus")
                    anchors.top: zoomSlider.bottom
                    anchors.topMargin: parent.height *0.06
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: parent.width *0.06
                    color: "white"
                }

                Slider {
                    id: focusSlider
                    width: parent.width * 0.7
                    height: 6  // ارتفاع کلی کنترل
                    from: 0
                    to: 100
                    value: 0
                    stepSize: 1
                    anchors.top: focustxt.bottom
                    anchors.topMargin: parent.height * 0.035
                    anchors.horizontalCenter: parent.horizontalCenter

                    background: Rectangle {
                        implicitHeight: 1
                        radius: 5
                        color: "white"
                        Rectangle {
                            width: focusSlider.visualPosition * parent.width
                            height: parent.height
                            radius: parent.radius
                            color: "gray" // رنگ قسمت پر شده
                        }

                    }


                    handle: Rectangle {
                        width: 14
                        height: 14
                        color: "#b3b3b3"
                        radius: width / 2
                        border.color: "white"
                        border.width: 1
                        x: focusSlider.visualPosition * (focusSlider.width - width)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }


                Rectangle{
                    id:backgroundvaluefocustxt
                    width: parent.width*0.2
                    height: parent.height *0.046
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width *0.63
                    anchors.top: zoomSlider.bottom
                    anchors.topMargin: parent.height *0.06
                    color: "lightgray"
                    radius: 10
                    Text {
                        id: focusvalue
                        text: focusSlider.value
                        color: "black"
                        font.pixelSize: parent.width *0.24
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }

                Text {
                    id: zoomspdir
                    text: qsTr("Zoom SPD")
                    font.pixelSize: parent.width *0.06
                    color: "white"
                    anchors.top: focusSlider.bottom
                    anchors.topMargin: parent.height *0.04
                    anchors.horizontalCenter: parent.horizontalCenter

                }

                Rectangle{
                    id:bordervaluezoomsdp
                    width: parent.width *0.55
                    height: parent.height *0.08
                    color: "transparent"
                    border.color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: zoomspdir.bottom
                    anchors.topMargin: parent.height *0.01
                    radius: 5


                    Rectangle{
                        id:backgroundvaluezoomspdtxt
                        width: parent.width*0.18
                        height: width
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius:3
                        Text {
                            id: zoomspdvalue
                            text: "25"
                            color: "black"
                            font.pixelSize: parent.width *0.5
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }


                    Rectangle{
                        id:backgroundvaluezoomspddown
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluezoomspdtxt.right
                        anchors.leftMargin: parent.width *0.27
                        anchors.verticalCenter: parent.verticalCenter
                        color: "lightgray"
                        radius: 3

                        Image {
                            id: downzoomspd
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                            rotation: 180
                        }

                    }

                    Rectangle{
                        id:backgroundvaluezoomspdup
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluezoomspddown.right
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius: 3

                        Image {
                            id: topzoomspd
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                        }


                    }
                }




                Text {
                    id: focusspdir
                    text: qsTr("Focus SPD")
                    font.pixelSize: parent.width *0.06
                    color: "white"
                    anchors.top: bordervaluezoomsdp.bottom
                    anchors.topMargin: parent.height *0.04
                    anchors.horizontalCenter: parent.horizontalCenter

                }


                Rectangle{
                    id:bordervaluefocusspd
                    width: parent.width *0.55
                    height: parent.height *0.08
                    color: "transparent"
                    border.color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: focusspdir.bottom
                    anchors.topMargin: parent.height *0.01
                    radius: 5


                    Rectangle{
                        id:backgroundvaluefocusspdtxt
                        width: parent.width*0.18
                        height: width
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius:3
                        Text {
                            id: focusspdirvalue
                            text: "25"
                            color: "black"
                            font.pixelSize: parent.width *0.5
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }


                    Rectangle{
                        id:backgroundvaluefocusspdirdown
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluefocusspdtxt.right
                        anchors.leftMargin: parent.width *0.27
                        anchors.verticalCenter: parent.verticalCenter
                        color: "lightgray"
                        radius: 3

                        Image {
                            id: downfocusspdir
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                            rotation: 180
                        }

                    }

                    Rectangle{
                        id:backgroundvaluefocusspdirup
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluefocusspdirdown.right
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius: 3

                        Image {
                            id: topfocusspdir
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                        }


                    }
                }








            }

            Rectangle{
                id:borderrgb
                width: parent.width * 0.5
                height: parent.height *0.66
                color: "transparent"
                border.color: "white"
                anchors.right: parent.right
                anchors.top: titlergb.bottom
                radius: 3

                Text {
                    id: contrasttxtborderrgb
                    text: qsTr("Contrast")
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.03
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: parent.width *0.06
                    color: "white"
                }

                Rectangle{
                    id:bordervaluecontrastborderrgb
                    width: parent.width *0.55
                    height: parent.height *0.08
                    color: "transparent"
                    border.color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: contrasttxtborderrgb.bottom
                    anchors.topMargin: parent.height *0.01
                    radius: 5


                    Rectangle{
                        id:backgroundvaluecontrasttxtborderrgb
                        width: parent.width*0.18
                        height: width
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius:3
                        Text {
                            id: contrastvalueborderrgb
                            text: "25"
                            color: "black"
                            font.pixelSize: parent.width *0.5
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }


                    Rectangle{
                        id:backgroundvaluecontrastdownborderrgb
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluecontrasttxtborderrgb.right
                        anchors.leftMargin: parent.width *0.27
                        anchors.verticalCenter: parent.verticalCenter
                        color: "lightgray"
                        radius: 3

                        Image {
                            id: downborderrgb
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                            rotation: 180
                        }

                    }

                    Rectangle{
                        id:backgroundvaluecontrastupborderrgb
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluecontrastdownborderrgb.right
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius: 3

                        Image {
                            id: topborderrgb
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                        }


                    }

                }


                Text {
                    id: brightnesstxtborderrgb
                    text: qsTr("Brightness")
                    anchors.top: bordervaluecontrastborderrgb.bottom
                    anchors.topMargin: parent.height *0.04
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: parent.width *0.06
                    color: "white"
                }

                Rectangle{
                    id:bordervaluebrightnessborderrgb
                    width: parent.width *0.55
                    height: parent.height *0.08
                    color: "transparent"
                    border.color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: brightnesstxtborderrgb.bottom
                    anchors.topMargin: parent.height *0.01
                    radius: 5


                    Rectangle{
                        id:backgroundvaluebrightnesstxtborderrgb
                        width: parent.width*0.18
                        height: width
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius:3
                        Text {
                            id: brightnessvalueborderrgb
                            text: "25"
                            color: "black"
                            font.pixelSize: parent.width *0.5
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }


                    Rectangle{
                        id:backgroundvaluebrightnessdownborderrgb
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluebrightnesstxtborderrgb.right
                        anchors.leftMargin: parent.width *0.27
                        anchors.verticalCenter: parent.verticalCenter
                        color: "lightgray"
                        radius: 3

                        Image {
                            id: downbrightnessborderrgb
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                            rotation: 180
                        }

                    }

                    Rectangle{
                        id:backgroundvaluebrightnesstupborderrgb
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluebrightnessdownborderrgb.right
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius: 3

                        Image {
                            id: topbrightnessborderrgb
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                        }


                    }
                }



                Text {
                    id: zoomtxtborderrgb
                    text: qsTr("Zoom")
                    anchors.top: bordervaluebrightnessborderrgb.bottom
                    anchors.topMargin: parent.height *0.06
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: parent.width *0.06
                    color: "white"
                }

                Slider {
                    id: zoomSliderborderrgb
                    width: parent.width * 0.7
                    height: 6  // ارتفاع کلی کنترل
                    from: 0
                    to: 100
                    value: 0
                    stepSize: 1
                    anchors.top: zoomtxtborderrgb.bottom
                    anchors.topMargin: parent.height * 0.035
                    anchors.horizontalCenter: parent.horizontalCenter

                    background: Rectangle {
                        implicitHeight: 1
                        radius: 5
                        color: "white"
                        Rectangle {
                            width: zoomSliderborderrgb.visualPosition * parent.width
                            height: parent.height
                            radius: parent.radius
                            color: "gray" // رنگ قسمت پر شده
                        }

                    }

                    handle: Rectangle {
                        width: 14
                        height: 14
                        color: "#b3b3b3"
                        radius: width / 2
                        border.color: "white"
                        border.width: 1
                        x: zoomSliderborderrgb.visualPosition * (zoomSliderborderrgb.width - width)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }


                Rectangle{
                    id:backgroundvaluezoomtxtborderrgb
                    width: parent.width*0.2
                    height: parent.height *0.046
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width *0.63
                    anchors.top: bordervaluebrightnessborderrgb.bottom
                    anchors.topMargin: parent.height *0.06
                    color: "lightgray"
                    radius: 10
                    Text {
                        id: zoomvalueborderrgb
                        text: zoomSliderborderrgb.value
                        color: "black"
                        font.pixelSize: parent.width *0.22
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }


                Text {
                    id: focustxtborderrgb
                    text: qsTr("Focus")
                    anchors.top: zoomSliderborderrgb.bottom
                    anchors.topMargin: parent.height *0.06
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: parent.width *0.06
                    color: "white"
                }

                Slider {
                    id: focusSliderborderrgb
                    width: parent.width * 0.7
                    height: 6  // ارتفاع کلی کنترل
                    from: 0
                    to: 100
                    value: 0
                    stepSize: 1
                    anchors.top: focustxtborderrgb.bottom
                    anchors.topMargin: parent.height * 0.035
                    anchors.horizontalCenter: parent.horizontalCenter

                    background: Rectangle {
                        implicitHeight: 1
                        radius: 5
                        color: "white"
                        Rectangle {
                            width: focusSliderborderrgb.visualPosition * parent.width
                            height: parent.height
                            radius: parent.radius
                            color: "gray" // رنگ قسمت پر شده
                        }

                    }


                    handle: Rectangle {
                        width: 14
                        height: 14
                        color: "#b3b3b3"
                        radius: width / 2
                        border.color: "white"
                        border.width: 1
                        x: focusSliderborderrgb.visualPosition * (focusSliderborderrgb.width - width)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }


                Rectangle{
                    id:backgroundvaluefocustxtborderrgb
                    width: parent.width*0.2
                    height: parent.height *0.046
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width *0.63
                    anchors.top: zoomSliderborderrgb.bottom
                    anchors.topMargin: parent.height *0.06
                    color: "lightgray"
                    radius: 10
                    Text {
                        id: focusvalueborderrgb
                        text: focusSliderborderrgb.value
                        color: "black"
                        font.pixelSize: parent.width *0.24
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }

                Text {
                    id: zoomspdirborderrgb
                    text: qsTr("Zoom SPD")
                    font.pixelSize: parent.width *0.06
                    color: "white"
                    anchors.top: focusSliderborderrgb.bottom
                    anchors.topMargin: parent.height *0.04
                    anchors.horizontalCenter: parent.horizontalCenter

                }

                Rectangle{
                    id:bordervaluezoomsdpborderrgb
                    width: parent.width *0.55
                    height: parent.height *0.08
                    color: "transparent"
                    border.color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: zoomspdirborderrgb.bottom
                    anchors.topMargin: parent.height *0.01
                    radius: 5


                    Rectangle{
                        id:backgroundvaluezoomspdtxtborderrgb
                        width: parent.width*0.18
                        height: width
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius:3
                        Text {
                            id: zoomspdvalueborderrgb
                            text: "25"
                            color: "black"
                            font.pixelSize: parent.width *0.5
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }


                    Rectangle{
                        id:backgroundvaluezoomspddownborderrgb
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluezoomspdtxtborderrgb.right
                        anchors.leftMargin: parent.width *0.27
                        anchors.verticalCenter: parent.verticalCenter
                        color: "lightgray"
                        radius: 3

                        Image {
                            id: downzoomspdborderrgb
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                            rotation: 180
                        }

                    }

                    Rectangle{
                        id:backgroundvaluezoomspdupborderrgb
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluezoomspddownborderrgb.right
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius: 3

                        Image {
                            id: topzoomspdborderrgb
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                        }


                    }
                }




                Text {
                    id: focusspdirborderrgb
                    text: qsTr("Focus SPD")
                    font.pixelSize: parent.width *0.06
                    color: "white"
                    anchors.top: bordervaluezoomsdpborderrgb.bottom
                    anchors.topMargin: parent.height *0.04
                    anchors.horizontalCenter: parent.horizontalCenter

                }


                Rectangle{
                    id:bordervaluefocusspdborderrgb
                    width: parent.width *0.55
                    height: parent.height *0.08
                    color: "transparent"
                    border.color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: focusspdirborderrgb.bottom
                    anchors.topMargin: parent.height *0.01
                    radius: 5


                    Rectangle{
                        id:backgroundvaluefocusspdtxtborderrgb
                        width: parent.width*0.18
                        height: width
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius:3
                        Text {
                            id: focusspdirvalueborderrgb
                            text: "25"
                            color: "black"
                            font.pixelSize: parent.width *0.5
                            anchors.centerIn: parent
                            font.bold: true
                        }
                    }


                    Rectangle{
                        id:backgroundvaluefocusspdirdownborderrgb
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluefocusspdtxtborderrgb.right
                        anchors.leftMargin: parent.width *0.27
                        anchors.verticalCenter: parent.verticalCenter
                        color: "lightgray"
                        radius: 3

                        Image {
                            id: downfocusspdirborderrgb
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                            rotation: 180
                        }

                    }

                    Rectangle{
                        id:backgroundvaluefocusspdirupborderrgb
                        width: parent.width*0.16
                        height: width
                        anchors.left: backgroundvaluefocusspdirdownborderrgb.right
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        color: "lightgray"
                        radius: 3

                        Image {
                            id: topfocusspdirborderrgb
                            source: "qrc:/img/icons8-triangle-100.png"
                            anchors.centerIn: parent
                            width: parent.width *0.6
                            height: parent.height *0.5
                        }


                    }
                }

            }

        }


        Rectangle{
            id:rectnav
            width: parent.width
            height: parent.height * 0.95
            color: "transparent"
            border.color: "white"
            radius: 5
            anchors.top: bordertab.bottom
            opacity: 0
            enabled: false

            Rectangle{
                id:columnmenu
                width: parent.width *0.12
                height: parent.height
                radius: 3
                color: "transparent"
                border.color: "white"
                anchors.left: parent.left

                Rectangle{
                    id:borderplan
                    width: parent.width
                    height: parent.height
                    color: "transparent"
                    border.color: "white"
                    anchors.top: parent.rotation

                    Rectangle{
                        id:patrol
                        width: parent.width * 0.8
                        height: width
                        color: "transparent"
                        border.color: "transparent"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.03

                        Image {
                            id: patrolimg
                            anchors.fill: parent
                            source: "qrc:/img/valueactive.png"
                        }

                        Text {
                            id: patroltxt
                            text: qsTr("Patrol")
                            anchors.centerIn: parent
                            color: "white"
                            font.pixelSize: parent.width * 0.25
                            font.bold: true
                        }

                        MouseArea{
                            anchors.fill: parent


                            onPressed: {
                                patrol.opacity = 0.5
                                rectpatrol.visible = true
                                rectpatrol2.visible = false
                                patrolimg.source = "qrc:/img/valueactive.png"
                                patrol2img.source = "qrc:/img/value.png"

                            }
                            onReleased: {
                                patrol.opacity = 1.0
                            }



                        }



                    }

                    Rectangle{
                        id:patrol2
                        width: parent.width * 0.8
                        height: width
                        color: "transparent"
                        border.color: "transparent"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: patrol.bottom
                        anchors.topMargin: parent.height *0.03

                        Image {
                            id: patrol2img
                            anchors.fill: parent
                            source: "qrc:/img/value.png"
                        }

                        Text {
                            id: patrol2txt
                            text: qsTr("Preset")
                            anchors.centerIn: parent
                            color: "white"
                            font.pixelSize: parent.width * 0.25
                            font.bold: true
                        }

                        MouseArea{
                            anchors.fill: parent


                            onPressed: {
                                patrol2.opacity = 0.5
                                rectpatrol2.visible = true
                                rectpatrol.visible = false
                                patrolimg.source = "qrc:/img/value.png"
                                patrol2img.source = "qrc:/img/valueactive.png"
                            }
                            onReleased: {
                                patrol2.opacity = 1.0
                            }



                        }


                    }

                }


            }


            Rectangle{
            id:rectpatrol
            width: rectnav.width * 0.88
            height: rectnav.height
            anchors.right: parent.right
            color: "transparent"
            visible: true

            Rectangle{
                id:returnplan1
                width: parent.width * 0.05
                height: parent.height *0.03
                color: "transparent"
                anchors.left: lblpolygontxt.right
                anchors.leftMargin: parent.width *0.03
                anchors.top: parent.top
                anchors.topMargin: parent.height *0.035
                Image {
                    id: returnplan1img
                    anchors.fill: parent
                    source: "qrc:/img/icons8-reset-100.png"
                }

            }



            Text {
                id: lblpolygontxt
                text: qsTr("Plan1")
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.035
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.15
                color: "White"
                font.pixelSize: parent.width *0.04
                font.bold: true
            }

            Rectangle{
            id:plan1
            width: parent.width * 0.8
            height: parent.height *0.4
            color: "transparent"
            border.color: "white"
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.08
            anchors.horizontalCenter: parent.horizontalCenter


            Text {
                id: lblpreset1txt
                text: qsTr("Preset1")
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.05
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.1
                color: "White"
                font.pixelSize: parent.width *0.04
                font.bold: true
            }


            Rectangle{
                id:preset1
                width: parent.width * 0.9
                height: parent.height *0.22
                color: "transparent"
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.13
                anchors.horizontalCenter: parent.horizontalCenter
                Image {
                    id: rectpolygonimg
                    anchors.fill: parent
                    source: "qrc:/img/polygan.png"
                }




            Rectangle{
                id:txtfieldpan1
                width: parent.width * 0.22
                height: parent.height *0.5
                anchors.left: parent.left
                anchors.leftMargin: parent.width *0.05
                anchors.verticalCenter: parent.verticalCenter

                radius: 3
                color: "transparent"
                border.color: "white"

                TextField {
                    anchors.fill: parent
                    font.pixelSize: parent.width *0.25
                    placeholderText: "Pan"
                }
            }

            Rectangle{
                id:txtfieldtilt1
                width: parent.width * 0.22
                height: parent.height *0.5
                anchors.left: txtfieldpan1.right
                anchors.leftMargin: parent.width *0.08
                anchors.verticalCenter: parent.verticalCenter

                radius: 3
                color: "transparent"
                border.color: "white"

                TextField {
                    anchors.fill: parent
                    font.pixelSize: parent.width *0.25
                    placeholderText: "Tilt"
                }
            }

            Rectangle{
                id:btnsaveplan1
                color: "transparent"
                width: parent.width * 0.2
                height: parent.height * 0.45
                anchors.verticalCenter: parent.verticalCenter

                anchors.left: txtfieldtilt1.right
                anchors.leftMargin: parent.width *0.1
                radius: 5

                Image {
                    id: btnsaveplan1img
                    anchors.fill: parent
                    source: "qrc:/img/btn.png"
                }
                Text {
                    id:btnsaveplan1txt
                    text: qsTr("Save")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "White"
                    font.pixelSize: parent.width *0.2
                    font.bold: true

                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        btnsaveplan1.opacity = 0.5
                    }
                    onReleased: {
                        btnsaveplan1.opacity = 1.0
                    }
                }
            }

            }

            Text {
                id: lblpreset2txt
                text: qsTr("Preset2")
                anchors.top: preset1.bottom
                anchors.topMargin: parent.height * 0.08
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.1
                color: "White"
                font.pixelSize: parent.width *0.04
                font.bold: true
            }

            Rectangle{
                id:preset2
                width: parent.width * 0.9
                height: parent.height *0.22
                color: "transparent"
                anchors.top: preset1.bottom
                anchors.topMargin: parent.height * 0.15
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    id: rectpreset2img
                    anchors.fill: parent
                    source: "qrc:/img/polygan.png"
                }

            Rectangle{
                id:txtfieldpreset2
                width: parent.width * 0.22
                height: parent.height *0.5
                anchors.left: parent.left
                anchors.leftMargin: parent.width *0.05
                anchors.verticalCenter: parent.verticalCenter

                radius: 3
                color: "transparent"
                border.color: "white"

                TextField {
                    anchors.fill: parent
                    font.pixelSize: parent.width *0.25
                    placeholderText: "Pan"
                }
            }

            Rectangle{
                id:txtfieldtilt1preset2
                width: parent.width * 0.22
                height: parent.height *0.5
                anchors.left: txtfieldpreset2.right
                anchors.leftMargin: parent.width *0.08
                anchors.verticalCenter: parent.verticalCenter

                radius: 3
                color: "transparent"
                border.color: "white"

                TextField {
                    anchors.fill: parent
                    font.pixelSize: parent.width *0.25
                    placeholderText: "Tilt"
                }
            }

            Rectangle{
                id:btnsavepreset2
                color: "transparent"
                width: parent.width * 0.2
                height: parent.height * 0.45
                anchors.verticalCenter: parent.verticalCenter

                anchors.left: txtfieldtilt1preset2.right
                anchors.leftMargin: parent.width *0.1
                radius: 5

                Image {
                    id: btnsavepreset2img
                    anchors.fill: parent
                    source: "qrc:/img/btn.png"
                }
                Text {
                    id:btnsavepreset2txt
                    text: qsTr("Save")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "White"
                    font.pixelSize: parent.width *0.2
                    font.bold: true

                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        btnsavepreset2.opacity = 0.5
                    }
                    onReleased: {
                        btnsavepreset2.opacity = 1.0
                    }
                }
            }

            }




            Rectangle{
                id:txtfieldplan1spd
                width: parent.width * 0.2
                height: parent.height *0.11
                anchors.left: parent.left
                anchors.leftMargin: parent.width *0.08
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height *0.05

                radius: 3
                color: "transparent"
                border.color: "white"

                TextField {
                    anchors.fill: parent
                    font.pixelSize: parent.width *0.2
                    placeholderText: "Spd"
                }
            }

            Rectangle{
                id:txtfieldplan1sec
                width: parent.width * 0.2
                height: parent.height *0.11
                anchors.left: txtfieldplan1spd.right
                anchors.leftMargin: parent.width *0.07
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height *0.05
                radius: 3
                color: "transparent"
                border.color: "white"

                TextField {
                    anchors.fill: parent
                    font.pixelSize: parent.width *0.2
                    placeholderText: "Sec"
                }
            }

            Rectangle{
                id:btnstartplan1
                color: "transparent"
                width: parent.width * 0.18
                height: parent.height * 0.11
                anchors.left: txtfieldplan1sec.right
                anchors.leftMargin: parent.width *0.03
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height *0.05
                radius: 5

                Image {
                    id: btnstartplan1img
                    anchors.fill: parent
                    source: "qrc:/img/btn.png"
                }
                Text {
                    id:btnstartplan1txt
                    text: qsTr("Start")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "White"
                    font.pixelSize: parent.width *0.2
                    font.bold: true

                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        btnstartplan1.opacity = 0.5
                    }
                    onReleased: {
                        btnstartplan1.opacity = 1.0
                    }
                }
            }

            Rectangle{
                id:btnpauseplan1
                color: "transparent"
                width: parent.width * 0.18
                height: parent.height * 0.11
                anchors.left: btnstartplan1.right
                anchors.leftMargin: parent.width *0.03
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height *0.05
                radius: 5

                Image {
                    id: btnpauseplan1img
                    anchors.fill: parent
                    source: "qrc:/img/btn.png"
                }
                Text {
                    id:btnpauseplan1txt
                    text: qsTr("Pause")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "White"
                    font.pixelSize: parent.width *0.2
                    font.bold: true

                }

                MouseArea{
                    anchors.fill: parent
                    onPressed: {
                        btnpauseplan1.opacity = 0.5
                    }
                    onReleased: {
                        btnpauseplan1.opacity = 1.0
                    }
                }
            }

            }


            Rectangle{
                id:returnplan2
                width: parent.width * 0.05
                height: parent.height *0.03
                color: "transparent"
                anchors.left: lblpolygontxtplan2.right
                anchors.leftMargin: parent.width *0.03
                anchors.top: plan1.bottom
                anchors.topMargin: parent.height *0.02
                Image {
                    id: returnplan2img
                    anchors.fill: parent
                    source: "qrc:/img/icons8-reset-100.png"
                }

            }


            Text {
                id: lblpolygontxtplan2
                text: qsTr("Plan2")
                anchors.top: plan1.bottom
                anchors.topMargin: parent.height * 0.02
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.15
                color: "White"
                font.pixelSize: parent.width *0.04
                font.bold: true
            }
            Rectangle {
                id:plan2
                width: parent.width * 0.8
                height: parent.height *0.4
                color: "transparent"
                border.color: "white"
                anchors.top: plan1.bottom
                anchors.topMargin: parent.height * 0.06
                anchors.horizontalCenter: parent.horizontalCenter


                Text {
                    id: lblpresettxtplan2
                    text: qsTr("Preset1")
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.05
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.1
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }


                Rectangle{
                    id:preset1plan2
                    width: parent.width * 0.9
                    height: parent.height *0.22
                    color: "transparent"
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.13
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image {
                        id: rectpolygonimgplan2
                        anchors.fill: parent
                        source: "qrc:/img/polygan.png"
                    }




                    Rectangle{
                        id:txtfieldpan1plan2
                        width: parent.width * 0.22
                        height: parent.height *0.5
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Pan"
                        }
                    }

                    Rectangle{
                        id:txtfieldtilt1plan2
                        width: parent.width * 0.22
                        height: parent.height *0.5
                        anchors.left: txtfieldpan1plan2.right
                        anchors.leftMargin: parent.width *0.08
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Tilt"
                        }
                    }

                    Rectangle{
                        id:btnsaveplan1plan2
                        color: "transparent"
                        width: parent.width * 0.2
                        height: parent.height * 0.45
                        anchors.verticalCenter: parent.verticalCenter

                        anchors.left: txtfieldtilt1plan2.right
                        anchors.leftMargin: parent.width *0.1
                        radius: 5

                        Image {
                            id: btnsaveplan1imgplan2
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }
                        Text {
                            id:btnsaveplan1txtplan2
                            text: qsTr("Save")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.2
                            font.bold: true

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                btnsaveplan1plan2.opacity = 0.5
                            }
                            onReleased: {
                                btnsaveplan1plan2.opacity = 1.0
                            }
                        }
                    }

                }

                Text {
                    id: lblpreset2txtplan2
                    text: qsTr("Preset2")
                    anchors.top: preset1plan2.bottom
                    anchors.topMargin: parent.height * 0.08
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.1
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }

                Rectangle{
                    id:preset2plan2
                    width: parent.width * 0.9
                    height: parent.height *0.22
                    color: "transparent"
                    anchors.top: preset1plan2.bottom
                    anchors.topMargin: parent.height * 0.15
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        id: rectpreset2imgplan2
                        anchors.fill: parent
                        source: "qrc:/img/polygan.png"
                    }

                    Rectangle{
                        id:txtfieldpreset2plan2
                        width: parent.width * 0.22
                        height: parent.height *0.5
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Pan"
                        }
                    }

                    Rectangle{
                        id:txtfieldtilt1preset2plan2
                        width: parent.width * 0.22
                        height: parent.height *0.5
                        anchors.left: txtfieldpreset2plan2.right
                        anchors.leftMargin: parent.width *0.08
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Tilt"
                        }
                    }

                    Rectangle{
                        id:btnsavepreset2plan2
                        color: "transparent"
                        width: parent.width * 0.2
                        height: parent.height * 0.45
                        anchors.verticalCenter: parent.verticalCenter

                        anchors.left: txtfieldtilt1preset2plan2.right
                        anchors.leftMargin: parent.width *0.1
                        radius: 5

                        Image {
                            id: btnsavepreset2imgplan2
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }
                        Text {
                            id:btnsavepreset2txtplan2
                            text: qsTr("Save")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.2
                            font.bold: true

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                btnsavepreset2plan2.opacity = 0.5
                            }
                            onReleased: {
                                btnsavepreset2plan2.opacity = 1.0
                            }
                        }
                    }

                }




                Rectangle{
                    id:txtfieldplan1spdplan2
                    width: parent.width * 0.2
                    height: parent.height *0.11
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width *0.08
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.05

                    radius: 3
                    color: "transparent"
                    border.color: "white"

                    TextField {
                        anchors.fill: parent
                        font.pixelSize: parent.width *0.2
                        placeholderText: "Spd"
                    }
                }

                Rectangle{
                    id:txtfieldplan1secplan2
                    width: parent.width * 0.2
                    height: parent.height *0.11
                    anchors.left: txtfieldplan1spdplan2.right
                    anchors.leftMargin: parent.width *0.07
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.05
                    radius: 3
                    color: "transparent"
                    border.color: "white"

                    TextField {
                        anchors.fill: parent
                        font.pixelSize: parent.width *0.2
                        placeholderText: "Sec"
                    }
                }

                Rectangle{
                    id:btnstartplan1plan2
                    color: "transparent"
                    width: parent.width * 0.18
                    height: parent.height * 0.11
                    anchors.left: txtfieldplan1secplan2.right
                    anchors.leftMargin: parent.width *0.03
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.05
                    radius: 5

                    Image {
                        id: btnstartplan1imgplan2
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }
                    Text {
                        id:btnstartplan1txtplan2
                        text: qsTr("Start")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.2
                        font.bold: true

                    }

                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            btnstartplan1plan2.opacity = 0.5
                        }
                        onReleased: {
                            btnstartplan1plan2.opacity = 1.0
                        }
                    }
                }

                Rectangle{
                    id:btnpauseplan1plan2
                    color: "transparent"
                    width: parent.width * 0.18
                    height: parent.height * 0.11
                    anchors.left: btnstartplan1plan2.right
                    anchors.leftMargin: parent.width *0.03
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.05
                    radius: 5

                    Image {
                        id: btnpauseplan1imgplan2
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }
                    Text {
                        id:btnpauseplan1txtplan2
                        text: qsTr("Pause")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.2
                        font.bold: true

                    }

                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            btnpauseplan1plan2.opacity = 0.5
                        }
                        onReleased: {
                            btnpauseplan1plan2.opacity = 1.0
                        }
                    }
                }

            }













            Rectangle{
                id:add
                width: parent.width * 0.08
                height: parent.height *0.05
                color: "transparent"
                anchors.right: parent.right
                anchors.rightMargin: parent.width *0.03
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height *0.005

                Image {
                    id: addimg
                    anchors.fill: parent
                    source: "qrc:/img/icons8-add-100.png"
                }

            }

            }


            Rectangle{
                id:rectpatrol2
                width: rectnav.width * 0.88
                height: rectnav.height
                anchors.right: parent.right
                color: "transparent"
                visible: false

                Text {
                    id: lblpresert1
                    text: qsTr("Preset1")
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.05
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.15
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }



                Text {
                    id: lblpresert2
                    text: qsTr("Preset2")
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.05
                    anchors.left: lblpresert1.right
                    anchors.leftMargin: parent.width * 0.12
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }

                Text {
                    id: lblpresert3
                    text: qsTr("Preset3")
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.05
                    anchors.left: lblpresert2.right
                    anchors.leftMargin: parent.width * 0.12
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }

                Rectangle{
                    id:borderpreset1patrol2
                    width: parent.width * 0.8
                    height: parent.height *0.3
                    color: "transparent"
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.08
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        id: borderpreset1patrol2img
                        anchors.fill: parent
                        source: "qrc:/img/borderpreset.png"
                    }

                    Rectangle{
                        id:txtfieldpan1patrol2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Pan"
                        }
                    }

                    Rectangle{
                        id:txtfieldtil1patrol2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.top: txtfieldpan1patrol2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Tilt"
                        }
                    }

                    Rectangle{
                        id:txtfieldsec1patrol2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.top: txtfieldtil1patrol2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Sec"
                        }
                    }


                    Rectangle{
                        id:btnset1
                        color: "transparent"
                        width: parent.width * 0.2
                        height: parent.height * 0.13
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.top: txtfieldsec1patrol2.bottom
                        anchors.topMargin: parent.height *0.03
                        radius: 5

                        Image {
                            id: btnbtnset1img
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }
                        Text {
                            id:btnbtnset1txt
                            text: qsTr("Set")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.2
                            font.bold: true

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                btnset1.opacity = 0.5
                            }
                            onReleased: {
                                btnset1.opacity = 1.0
                            }
                        }
                    }




                    Rectangle{
                        id:txtfieldpan2patrol2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldpan1patrol2.right
                        anchors.leftMargin: parent.width *0.15
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Pan"
                        }
                    }

                    Rectangle{
                        id:txtfieldtil2patrol2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldtil1patrol2.right
                        anchors.leftMargin: parent.width *0.15
                        anchors.top: txtfieldpan2patrol2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Tilt"
                        }
                    }

                    Rectangle{
                        id:txtfieldsec2patrol2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldsec1patrol2.right
                        anchors.leftMargin: parent.width *0.15
                        anchors.top: txtfieldtil2patrol2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Sec"
                        }
                    }


                    Rectangle{
                        id:btnset2
                        color: "transparent"
                        width: parent.width * 0.2
                        height: parent.height * 0.13
                        anchors.left: btnset1.right
                        anchors.leftMargin: parent.width *0.15
                        anchors.top: txtfieldsec2patrol2.bottom
                        anchors.topMargin: parent.height *0.03
                        radius: 5

                        Image {
                            id: btnbtnset2img
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }
                        Text {
                            id:btnbtnset2txt
                            text: qsTr("Set")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.2
                            font.bold: true

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                btnset2.opacity = 0.5
                            }
                            onReleased: {
                                btnset2.opacity = 1.0
                            }
                        }
                    }




                    Rectangle{
                        id:txtfieldpan3patrol2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldpan2patrol2.right
                        anchors.leftMargin: parent.width *0.14
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Pan"
                        }
                    }

                    Rectangle{
                        id:txtfieldtil3patrol2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldtil2patrol2.right
                        anchors.leftMargin: parent.width *0.14
                        anchors.top: txtfieldpan3patrol2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Tilt"
                        }
                    }

                    Rectangle{
                        id:txtfieldsec3patrol2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldsec2patrol2.right
                        anchors.leftMargin: parent.width *0.14
                        anchors.top: txtfieldtil3patrol2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Sec"
                        }
                    }


                    Rectangle{
                        id:btnset3
                        color: "transparent"
                        width: parent.width * 0.2
                        height: parent.height * 0.13
                        anchors.left: btnset2.right
                        anchors.leftMargin: parent.width *0.14
                        anchors.top: txtfieldsec3patrol2.bottom
                        anchors.topMargin: parent.height *0.03
                        radius: 5

                        Image {
                            id: btnbtnset3img
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }
                        Text {
                            id:btnbtnset3txt
                            text: qsTr("Set")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.2
                            font.bold: true

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                btnset3.opacity = 0.5
                            }
                            onReleased: {
                                btnset3.opacity = 1.0
                            }
                        }
                    }




                    Rectangle{
                        id:btnstartpreset1
                        color: "transparent"
                        width: parent.width * 0.2
                        height: parent.height * 0.13
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.03
                        radius: 5

                        Image {
                            id: btnstartpreset1img
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }
                        Text {
                            id:btnstartpreset1txt
                            text: qsTr("Start")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.2
                            font.bold: true

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                btnstartpreset1.opacity = 0.5
                            }
                            onReleased: {
                                btnstartpreset1.opacity = 1.0
                            }
                        }
                    }


                    Rectangle{
                        id:returnpreset1
                        width: parent.width * 0.09
                        height: parent.height *0.11
                        color: "transparent"
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width *0.03
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.03

                        Image {
                            id: returnpatrol2img
                            anchors.fill: parent
                            source: "qrc:/img/icons8-reset-100.png"
                        }

                    }

                }



                Text {
                    id: lblpresert1plan2
                    text: qsTr("Preset4")
                    anchors.top: borderpreset1patrol2.bottom
                    anchors.topMargin: parent.height * 0.15
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.15
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }



                Text {
                    id: lblpresert2plan2
                    text: qsTr("Preset5")
                    anchors.top: borderpreset1patrol2.bottom
                    anchors.topMargin: parent.height * 0.15
                    anchors.left: lblpresert1plan2.right
                    anchors.leftMargin: parent.width * 0.12
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }

                Text {
                    id: lblpresert3plan2
                    text: qsTr("Preset6")
                    anchors.top: borderpreset1patrol2.bottom
                    anchors.topMargin: parent.height * 0.15
                    anchors.left: lblpresert2plan2.right
                    anchors.leftMargin: parent.width * 0.12
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }

                Rectangle  {
                    id:borderpreset1patrol2plan2
                    width: parent.width * 0.8
                    height: parent.height *0.3
                    color: "transparent"
                    anchors.top: borderpreset1patrol2.bottom
                    anchors.topMargin: parent.height * 0.18
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        id: borderpreset1patrol2imgplan2
                        anchors.fill: parent
                        source: "qrc:/img/borderpreset.png"
                    }

                    Rectangle{
                        id:txtfieldpan1patrol2plan2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Pan"
                        }
                    }

                    Rectangle{
                        id:txtfieldtil1patrol2plan2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.top: txtfieldpan1patrol2plan2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Tilt"
                        }
                    }

                    Rectangle{
                        id:txtfieldsec1patrol2plan2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.top: txtfieldtil1patrol2plan2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Sec"
                        }
                    }


                    Rectangle{
                        id:btnset1plan2
                        color: "transparent"
                        width: parent.width * 0.2
                        height: parent.height * 0.13
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.top: txtfieldsec1patrol2plan2.bottom
                        anchors.topMargin: parent.height *0.03
                        radius: 5

                        Image {
                            id: btnbtnset1imgplan2
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }
                        Text {
                            id:btnbtnset1txtplan2
                            text: qsTr("Set")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.2
                            font.bold: true

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                btnset1plan2.opacity = 0.5
                            }
                            onReleased: {
                                btnset1plan2.opacity = 1.0
                            }
                        }
                    }




                    Rectangle{
                        id:txtfieldpan2patrol2plan2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldpan1patrol2plan2.right
                        anchors.leftMargin: parent.width *0.15
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.05
                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Pan"
                        }
                    }

                    Rectangle{
                        id:txtfieldtil2patrol2plan2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldtil1patrol2plan2.right
                        anchors.leftMargin: parent.width *0.15
                        anchors.top: txtfieldpan2patrol2plan2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Tilt"
                        }
                    }

                    Rectangle{
                        id:txtfieldsec2patrol2plan2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldsec1patrol2plan2.right
                        anchors.leftMargin: parent.width *0.15
                        anchors.top: txtfieldtil2patrol2plan2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Sec"
                        }
                    }


                    Rectangle{
                        id:btnset2plan2
                        color: "transparent"
                        width: parent.width * 0.2
                        height: parent.height * 0.13
                        anchors.left: btnset1plan2.right
                        anchors.leftMargin: parent.width *0.15
                        anchors.top: txtfieldsec2patrol2plan2.bottom
                        anchors.topMargin: parent.height *0.03
                        radius: 5

                        Image {
                            id: btnbtnset2imgplan2
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }
                        Text {
                            id:btnbtnset2txtplan2
                            text: qsTr("Set")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.2
                            font.bold: true

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                btnset2plan2.opacity = 0.5
                            }
                            onReleased: {
                                btnset2plan2.opacity = 1.0
                            }
                        }
                    }




                    Rectangle{
                        id:txtfieldpan3patrol2plan2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldpan2patrol2plan2.right
                        anchors.leftMargin: parent.width *0.14
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Pan"
                        }
                    }

                    Rectangle{
                        id:txtfieldtil3patrol2plan2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldtil2patrol2plan2.right
                        anchors.leftMargin: parent.width *0.14
                        anchors.top: txtfieldpan3patrol2plan2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Tilt"
                        }
                    }

                    Rectangle{
                        id:txtfieldsec3patrol2plan2
                        width: parent.width * 0.2
                        height: parent.height *0.15
                        anchors.left: txtfieldsec2patrol2plan2.right
                        anchors.leftMargin: parent.width *0.14
                        anchors.top: txtfieldtil3patrol2plan2.bottom
                        anchors.topMargin: parent.height *0.05

                        radius: 3
                        color: "transparent"
                        border.color: "white"

                        TextField {
                            anchors.fill: parent
                            font.pixelSize: parent.width *0.25
                            placeholderText: "Sec"
                        }
                    }


                    Rectangle{
                        id:btnset3plan2
                        color: "transparent"
                        width: parent.width * 0.2
                        height: parent.height * 0.13
                        anchors.left: btnset2plan2.right
                        anchors.leftMargin: parent.width *0.14
                        anchors.top: txtfieldsec3patrol2plan2.bottom
                        anchors.topMargin: parent.height *0.03
                        radius: 5

                        Image {
                            id: btnbtnset3imgplan2
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }
                        Text {
                            id:btnbtnset3txtplan2
                            text: qsTr("Set")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.2
                            font.bold: true

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                btnset3plan2.opacity = 0.5
                            }
                            onReleased: {
                                btnset3plan2.opacity = 1.0
                            }
                        }
                    }




                    Rectangle{
                        id:btnstartpreset1plan2
                        color: "transparent"
                        width: parent.width * 0.2
                        height: parent.height * 0.13
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.03
                        radius: 5

                        Image {
                            id: btnstartpreset1imgplan2
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }
                        Text {
                            id:btnstartpreset1txtplan2
                            text: qsTr("Start")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.2
                            font.bold: true

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                btnstartpreset1plan2.opacity = 0.5
                            }
                            onReleased: {
                                btnstartpreset1plan2.opacity = 1.0
                            }
                        }
                    }


                    Rectangle{
                        id:returnpreset1plan2
                        width: parent.width * 0.09
                        height: parent.height *0.11
                        color: "transparent"
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width *0.03
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.03

                        Image {
                            id: returnpatrol2imgplan2
                            anchors.fill: parent
                            source: "qrc:/img/icons8-reset-100.png"
                        }
                    }
                }

                Rectangle{
                    id:addpatrol2
                    width: parent.width * 0.08
                    height: parent.height *0.05
                    color: "transparent"
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width *0.03
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.005

                    Image {
                        id: addpatrol2img
                        anchors.fill: parent
                        source: "qrc:/img/icons8-add-100.png"
                    }
                }





            }


            Rectangle{
            id:rectpreset
            width: rectnav.width * 0.88
            height: rectnav.height
            anchors.right: parent.right
            color: "yellow"
            visible: false


            }

            Rectangle{
            id:rectsweep
            width: rectnav.width * 0.88
            height: rectnav.height
            anchors.right: parent.right
            color: "purple"
            visible: false

            Rectangle{
                id:handpositionborder
                width: parent.width * 0.43
                height: parent.height *0.55
                color: "transparent"
                border.color: "white"
                anchors.top: parent.top
                anchors.topMargin: parent.height *0.17
                anchors.left: parent.left
                anchors.leftMargin:parent.width *0.03

//                            Image {
//                                id: handpositionborderimg
//                                anchors.fill: parent
//                                source: "qrc:/img/border2.png"
//                            }


                Text {
                    id: fromlbl
                    text: qsTr("From")
                    color: "white"
                    font.pixelSize: parent.width *0.12
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width *0.05
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.05
                }


                Rectangle{
                    id:txtfieldfromlbl
                    width: parent.width * 0.35
                    height: parent.height *0.2
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width *0.05
                    anchors.top: fromlbl.bottom
                    anchors.topMargin: parent.height *0.05
                    radius: 3
                    color: "transparent"
                    border.color: "white"

                    TextField {
                        anchors.fill: parent
                        font.pixelSize: parent.width *0.15
                        placeholderText: "Pan"
                    }
                }


                Rectangle{
                    id:txtfieldfromlbltilt
                    width: parent.width * 0.35
                    height: parent.height *0.2
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width *0.05
                    anchors.top: fromlbl.bottom
                    anchors.topMargin: parent.height *0.34
                    radius: 3
                    color: "transparent"
                    border.color: "white"

                    TextField {
                        anchors.fill: parent
                        font.pixelSize: parent.width *0.15
                        placeholderText: "Tilt"
                    }
                }


                Rectangle{
                    id:txtfieldtolbltilt
                    width: parent.width * 0.35
                    height: parent.height *0.2
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width *0.05
                    anchors.top: fromlbl.bottom
                    anchors.topMargin: parent.height *0.34
                    radius: 3
                    color: "transparent"
                    border.color: "white"

                    TextField {
                        anchors.fill: parent
                        font.pixelSize: parent.width *0.15
                        placeholderText: "Tilt"
                    }
                }


                Text {
                    id: tolbl
                    text: qsTr("To")
                    color: "white"
                    font.pixelSize: parent.width *0.12
                    anchors.left: fromlbl.right
                    anchors.leftMargin: parent.width *0.3
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.05
                }



                Rectangle{
                    id:txtfieldtolbl
                    width: parent.width * 0.35
                    height: parent.height *0.2
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width *0.05
                    anchors.top: fromlbl.bottom
                    anchors.topMargin: parent.height *0.05
                    radius: 3
                    color: "transparent"
                    border.color: "white"

                    TextField {
                        anchors.fill: parent
                        font.pixelSize: parent.width *0.15
                        placeholderText: "Pan"
                    }
                }



                Rectangle{
                    id:btnsendhand
                    color: "transparent"
                    width: parent.width * 0.4
                    height: parent.height * 0.15
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.042
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 5


                    Image {
                        id: btnsendhandimg
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }
                    Text {
                        id:btnsendhandtxt
                        text: qsTr("Send")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true

                    }


                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            btnsendhand.opacity = 0.5
                            gimbalhandimg.source = "qrc:/img/gimbalhand-active.png"
                            isactivesweep = true
                        }
                        onReleased: {
                            btnsendhand.opacity = 1.0
                        }

                    }


                }

            }





            }


        }

        Rectangle{
            id:rectinfo
            width: parent.width
            height: parent.height * 0.95
            color: "transparent"
            border.color: "white"
            radius: 5
            anchors.top: bordertab.bottom
            opacity: 0
            enabled: false


            ListModel {
                id: tableModel
                Component.onCompleted: {
                    for (var i = 0; i < 20; i++) {
                        append({"checked": false, "time":"12:00", "objectID":"Obj"+i, "type":"Type"+i, "state":"State"+i})
                    }
                }
            }

            Column {
                anchors.fill: parent
                spacing: 0

                // هدر با border
                Row {
                     width: parent.width
                    id: header
                    height: 40
                    spacing: 0
                    Rectangle { width: parent.width *0.1; height: parent.height; color: "#2f3438"; border.color: "white"; Text { text: ""; anchors.centerIn: parent; color: "white" } }
                    Rectangle { width: parent.width * 0.224; height: parent.height; color: "#2f3438"; border.color: "white"; Text { text: "Time"; anchors.centerIn: parent; color: "white" } }
                    Rectangle { width: parent.width * 0.224; height: parent.height; color: "#2f3438"; border.color: "white"; Text { text: "Object ID"; anchors.centerIn: parent; color: "white" } }
                    Rectangle { width: parent.width * 0.224; height: parent.height; color: "#2f3438"; border.color: "white"; Text { text: "Type"; anchors.centerIn: parent; color: "white" } }
                    Rectangle { width: parent.width * 0.224; height: parent.height; color: "#2f3438"; border.color: "white"; Text { text: "State"; anchors.centerIn: parent; color: "white" } }
                }

                // جدول با پس‌زمینه و border
                Flickable {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: header.bottom
                    anchors.bottom: parent.bottom
                    contentWidth: parent.width
                    contentHeight: tableModel.count * 40
                    clip: true

                    Rectangle {
                        width: parent.width
                        height: contentHeight
                        color: "#e0e0e0"   // پس‌زمینه جدول

                        Column {
                            width: parent.width
                            spacing: 0

                            Repeater {
                                model: tableModel
                                Row {
                                    width: parent.width
                                    spacing: 0
                                    height: 40

                                    // ستون CheckBox با border
                                    Rectangle {
                                        width: parent.width *0.1
                                        height: parent.height
                                        color: "white"
                                        border.color: "gray"
                                        CheckBox {
                                            anchors.centerIn: parent
                                            checked: tableModel.get(index).checked
                                            onCheckedChanged: tableModel.setProperty(index, "checked", checked)


                                            indicator: Rectangle {
                                                implicitWidth:16;
                                                implicitHeight:16;
                                                radius:3;
                                                anchors.centerIn: parent
                                                border.color:"gray";
                                                               color: checked ? "#4a90e2" : "gray"
                                                               Rectangle { anchors.centerIn: parent;
                                                                   width:8;
                                                                   height:8;
                                                                   radius:2;
                                                                   color: checked ? "white" : "transparent" }
                                                           }


                                        }
                                    }

                                    // ستون Time
                                    Rectangle { width: parent.width * 0.224; height: parent.height; color: "white"; border.color: "gray"; Text { text: tableModel.get(index).time; anchors.centerIn: parent } }
                                    // ستون Object ID
                                    Rectangle { width: parent.width * 0.224; height: parent.height; color: "white"; border.color: "gray"; Text { text: tableModel.get(index).objectID; anchors.centerIn: parent } }
                                    // ستون Type
                                    Rectangle { width: parent.width * 0.224; height: parent.height;  color: "white"; border.color: "gray"; Text { text: tableModel.get(index).type; anchors.centerIn: parent } }
                                    // ستون State
                                    Rectangle { width:parent.width * 0.224; height: parent.height;  color: "white"; border.color: "gray"; Text { text: tableModel.get(index).state; anchors.centerIn: parent } }
                                }
                            }
                        }
                    }
                }
            }







        }









    }
}
