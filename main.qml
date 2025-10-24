import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.1
import "FluxColor"
//import FluxColor 1.0 as Flux
import "qrc:/FluxColor" as Flux
import QtMultimedia 5.12
import "."



ApplicationWindow {
    id:targettracking
    width: 1200
    height: 800
    visible: true
    title: qsTr("Target Tracking")
//    visibility: "FullScreen" // حالت تمام صفحه


    property bool isFullScreen: false // وضعیت تمام‌صفحه




//    FontLoader{
//        id:custom
//        source: "qrc:/font/W tahoma .ttf"
//    }
    property bool showColorWheel: false

    property string videoPath: ""
    property var currentBoxes: []
    property string lastVideoPath: ""
    property bool alarmPlaying: false
    property int objectsInRect: 0 // تعداد اشیاء در مستطیل
    property bool isactivesweep: false


    Rectangle{
        id:mainbackground
        visible: true
        anchors.fill: parent
        color: "black"



        Rectangle {
            id: screenpic
            width: isFullScreen ? parent.width : parent.width * 0.75
            height: isFullScreen ? parent.height : parent.height * 0.98
            anchors.top: parent.top
            anchors.topMargin: isFullScreen ? 0 : parent.height * 0.01
            anchors.right: parent.right
            anchors.rightMargin: isFullScreen ? 0 : parent.width * 0.002
            radius: 5
            color: "transparent"
            border.color: "white"
            visible: true
            clip: true


            Rectangle {
                id: videoArea
                anchors.fill: parent
                color: "black"

                property int curIndex: 0 // 0 => imageA visible, 1 => imageB visible

                Image {
                    id: imageA
                    anchors.fill: parent
                    visible: videoArea.curIndex === 0
                    asynchronous: true
                    cache: false
                    fillMode: Image.PreserveAspectFit

                    onStatusChanged: {
                        if (status === Image.Ready) {
                            videoArea.curIndex = 0
                        }
                    }
                }

                Image {
                    id: imageB
                    anchors.fill: parent
                    visible: videoArea.curIndex === 1
                    asynchronous: true
                    cache: false
                    fillMode: Image.PreserveAspectFit

                    onStatusChanged: {
                        if (status === Image.Ready) {
                            videoArea.curIndex = 1
                        }
                    }
                }

                Connections {
                    target: pythonBridge
                    onFrameReady: {
                        var next = (videoArea.curIndex === 0) ? 1 : 0

                        if (next === 0) {
                            imageA.source = framePath    // framePath از سیگنال C++ می‌آید
                        } else {
                            imageB.source = framePath
                        }
                    }
                }
            }

            Row {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                anchors.margins: 20

                Button {
                    text: "Start"
                    onClicked: pythonBridge.startDetection()
                }

                Button {
                    text: "Stop"
                    onClicked: pythonBridge.stopDetection()
                }
            }



















            function startVideoDetection(videoPath) {
                lastVideoPath = videoPath
                pythonBridge.startDetection(videoPath)
            }


            function drawBoxes() {
                // حذف باکس‌های قبلی
                for (var i = boxesContainer.children.length - 1; i >= 0; i--) {
                    var child = boxesContainer.children[i]
                    if (child.objectName === "dynamicBox")
                        child.destroy()
                }

                // اگر تصویر هنوز لود نشده باشد خروج
                if (processedImage.sourceSize.width === 0 || processedImage.sourceSize.height === 0) {
                    console.log("Image not loaded yet")
                    return
                }

                objectsInRect = 0 // ریست شمارنده
                var imgRatio = processedImage.paintedWidth / processedImage.sourceSize.width
                var yOffset = (processedImage.height - processedImage.paintedHeight) / 2
                var xOffset = (processedImage.width - processedImage.paintedWidth) / 2

                for (var i = 0; i < currentBoxes.length; i++) {
                    var box = currentBoxes[i]

                    // تبدیل مختصات به سیستم نمایشی
                    var displayX = box.x * imgRatio + xOffset
                    var displayY = box.y * imgRatio + yOffset
                    var displayWidth = box.width * imgRatio
                    var displayHeight = box.height * imgRatio

                    // ایجاد باکس گرافیکی
                    var component = Qt.createComponent("BoundingBox.qml")
                    if (component.status === Component.Ready) {
                        component.createObject(boxesContainer, {
                                                   objectName: "dynamicBox",
                                                   x: displayX,
                                                   y: displayY,
                                                   width: displayWidth,
                                                   height: displayHeight,
                                                   confidence: box.confidence,
                                                   label: box.label // نمایش لیبل اگر وجود دارد
                                               })
                    }

                    // بررسی برخورد با drawRect
                    if (drawRect.visible && drawRect.width > 0 && drawRect.height > 0) {
                        var boxRight = displayX + displayWidth
                        var boxBottom = displayY + displayHeight
                        var rectRight = drawRect.x + drawRect.width
                        var rectBottom = drawRect.y + drawRect.height

                        var intersects = !(displayX > rectRight ||
                                           boxRight < drawRect.x ||
                                           displayY > rectBottom ||
                                           boxBottom < drawRect.y)

                        if (intersects) {
                            console.log("✅ Object Detected inside rectangle!")
                            objectsInRect++ // افزایش تعداد اشیاء در مستطیل
                        }
                    }
                }

                // مدیریت پخش صدا
                if (objectsInRect > 0) {
                    console.log("Objects detected in rectangle:", objectsInRect)
                    if (!alarmPlaying && alarmSound.status === Audio.Loaded) {
                        console.log("🔊 Playing alarm")
                        alarmSound.play()
                        alarmPlaying = true
                    }
                } else {
                    console.log("No objects in rectangle")
                    if (alarmPlaying) {
                        console.log("⛔ Stopping alarm")
                        alarmSound.stop()
                        alarmPlaying = false
                    }
                }
            }


            Rectangle{
                id: screenpanaroma
                width: screenpic.width
                height: screenpic.height
                color: "transparent"
                border.color: "gray"
                border.width: 1
                visible: false

                Rectangle{
                    id:frame1
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.007
                    radius: 5

                    Rectangle {
                        id: fullscreenframe1
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe1img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe1.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe1.opacity=1.0
                            }
                        }
                    }
                }

                Rectangle{
                    id:frame2
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: frame1.bottom
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.007
                    radius: 5

                    Rectangle {
                        id: fullscreenframe2
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe2img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe2.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe2.opacity=1.0
                            }
                        }
                    }


                }

                Rectangle{
                    id:frame3
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: frame2.bottom
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.007
                    radius: 5

                    Rectangle {
                        id: fullscreenframe3
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe3img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe3.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe3.opacity=1.0
                            }
                        }
                    }



                }




                Rectangle{
                    id:frame4
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: frame1.right
                    anchors.leftMargin: parent.width * 0.005
                    radius: 5

                    Rectangle {
                        id: fullscreenframe4
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe4img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe4.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe4.opacity=1.0
                            }
                        }
                    }

                }

                Rectangle{
                    id:frame5
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: frame4.bottom
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: frame2.right
                    anchors.leftMargin: parent.width * 0.005
                    radius: 5

                    Rectangle {
                        id: fullscreenframe5
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe5img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe5.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe5.opacity=1.0
                            }
                        }
                    }


                }

                Rectangle{
                    id:frame6
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: frame5.bottom
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: frame3.right
                    anchors.leftMargin: parent.width * 0.005
                    radius: 5

                    Rectangle {
                        id: fullscreenframe6
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe6img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe6.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe6.opacity=1.0
                            }
                        }
                    }

                }



                Rectangle{
                    id:frame7
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: frame4.right
                    anchors.leftMargin: parent.width * 0.005
                    radius: 5

                    Rectangle {
                        id: fullscreenframe7
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe7img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe7.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe7.opacity=1.0
                            }
                        }
                    }

                }

                Rectangle{
                    id:frame8
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: frame7.bottom
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: frame5.right
                    anchors.leftMargin: parent.width * 0.005
                    radius: 5

                    Rectangle {
                        id: fullscreenframe8
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe8img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe8.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe8.opacity=1.0
                            }
                        }
                    }


                }

                Rectangle{
                    id:frame9
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: frame8.bottom
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: frame6.right
                    anchors.leftMargin: parent.width * 0.005
                    radius: 5

                    Rectangle {
                        id: fullscreenframe9
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe9img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe9.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe9.opacity=1.0
                            }
                        }
                    }

                }


                Rectangle{
                    id:frame10
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: frame3.bottom
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.007
                    radius: 5

                    Rectangle {
                        id: fullscreenframe10
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe10img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe10.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe10.opacity=1.0
                            }
                        }
                    }

                }

                Rectangle{
                    id:frame11
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: frame6.bottom
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: frame10.right
                    anchors.leftMargin: parent.width * 0.005
                    radius: 5

                    Rectangle {
                        id: fullscreenframe11
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe11img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe11.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe11.opacity=1.0
                            }
                        }
                    }


                }

                Rectangle{
                    id:frame12
                    width: parent.width  *0.325
                    height: parent.height *.242
                    color: "transparent"
                    border.color: "white"
                    anchors.top: frame9.bottom
                    anchors.topMargin: parent.height * 0.005
                    anchors.left: frame11.right
                    anchors.leftMargin: parent.width * 0.005
                    radius: 5

                    Rectangle {
                        id: fullscreenframe12
                        width: parent.width * 0.05
                        height: width
                        color: "transparent"
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.005
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width * 0.005
                        opacity: 1.0

                        Image {
                            id: fullscreenframe12img
                            source: "qrc:/img/icons8-fullscreen-100.png"
                            anchors.fill: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                fullscreenframe12.opacity=0.5
                            }

                            onReleased: {
                                fullscreenframe12.opacity=1.0
                            }
                        }
                    }

                }

            }

            Rectangle {
                id: screenRectangle
                width: screenpic.width
                height: screenpic.height
                color: "transparent"
                border.color: "white"
                border.width: 1
                property bool isDrawingEnabled: pencil.isActivepencil
                property bool isPolygonDrawingEnabled: false

                Canvas {
                       id: polygonCanvas
                       anchors.fill: parent
                       visible: screenRectangle.isPolygonDrawingEnabled
                       z: 11

                       property var points: []

                       onPaint: {
                           var ctx = getContext("2d");
                           ctx.clearRect(0, 0, width, height);

                           if (points.length > 0) {
                               ctx.strokeStyle = Qt.rgba(colorChooser.currentColor.r,
                                                        colorChooser.currentColor.g,
                                                        colorChooser.currentColor.b, 1.0);
                               ctx.lineWidth = 2;
                               ctx.beginPath();

                               ctx.moveTo(points[0].x, points[0].y);
                               for (var i = 1; i < points.length; i++) {
                                   ctx.lineTo(points[i].x, points[i].y);
                               }

                               // اگر بیش از دو نقطه داریم، به نقطه اول وصل می‌کنیم تا چندضلعی بسته شود
                               if (points.length > 2) {
                                   ctx.lineTo(points[0].x, points[0].y);
                               }

                               ctx.stroke();
                           }
                       }
                   }

                   // MouseArea برای رسم چندضلعی
                   MouseArea {
                       id: polygonMouseArea
                       anchors.fill: parent
                       hoverEnabled: true
                       enabled: screenRectangle.isPolygonDrawingEnabled

                       onClicked: {
                           if (screenRectangle.isPolygonDrawingEnabled) {
                               // اضافه کردن نقطه جدید به چندضلعی
                               polygonCanvas.points.push({x: mouse.x, y: mouse.y});
                               polygonCanvas.requestPaint();
                           }
                       }

                       onDoubleClicked: {
                           if (screenRectangle.isPolygonDrawingEnabled && polygonCanvas.points.length > 0) {
                               // تمام کردن رسم چندضلعی و پاک کردن نقاط
                               polygonCanvas.points = [];
                               polygonCanvas.requestPaint();
                           }
                       }
                   }


                   onIsPolygonDrawingEnabledChanged: {
                       if (!isPolygonDrawingEnabled) {
                           // غیرفعال کردن حالت رسم چندضلعی
                           polygonCanvas.points = [];
                           polygonCanvas.requestPaint();
                       }
                   }

                onIsDrawingEnabledChanged: {
                    if (!isDrawingEnabled) {
                        drawRect.visible = false;
                        drawRect.width = 0;
                        drawRect.height = 0;
                    }
                }

                Rectangle {
                    id: fullscreenback
                    width: parent.width * 0.015
                    height: width
                    color: "transparent"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.005
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width * 0.005
                    opacity: 1.0
                    visible: isFullScreen

                    Image {
                        id: fullscreenbackimg
                        source: "qrc:/img/icons8-fullscreen-100.png"
                        anchors.fill: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            fullscreenback.opacity=0.5
                        }

                        onReleased: {
                            fullscreenback.opacity=1.0
                            previewComponent.visible = true
                            rectmenu.visible = true
                            isFullScreen = false
                            fullscreenback.visible = false
                        }
                    }
                }



                Item {
                    anchors.fill: parent
                    Image {
                        id: processedImage
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        cache: false
                    }
                    Item {
                        anchors.fill: parent

                        Item {
                            id: boxesContainer
                            anchors.fill: parent
                        }
                        Rectangle {
                            id: drawRect
                            color: "transparent"
                            border.color: Qt.rgba(colorChooser.currentColor.r,
                                                  colorChooser.currentColor.g,
                                                  colorChooser.currentColor.b, 1.0)
                            border.width: 2
                            visible: false
                            z: 10
                        }

                        MouseArea {
                            id: drawingMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: screenRectangle.isDrawingEnabled // فعال/غیرفعال بر اساس وضعیت ابزار

                            property bool isDrawing: false
                            property real startX: 0
                            property real startY: 0

                            onPressed: {
                                if (!screenRectangle.isDrawingEnabled) return;

                                isDrawing = true;
                                startX = mouse.x
                                startY = mouse.y
                                drawRect.visible = true
                                drawRect.x = startX
                                drawRect.y = startY
                                drawRect.width = 0
                                drawRect.height = 0
                            }

                            onPositionChanged: {
                                if (!isDrawing) return;

                                if (mouse.buttons === Qt.LeftButton) {
                                    drawRect.width = Math.abs(mouse.x - startX)
                                    drawRect.height = Math.abs(mouse.y - startY)
                                    drawRect.x = Math.min(mouse.x, startX)
                                    drawRect.y = Math.min(mouse.y, startY)

                                    // به‌روزرسانی موقعیت شمارنده
                                    if (objectsCounter) {
                                        objectsCounter.x = drawRect.x
                                        objectsCounter.y = drawRect.y - 30
                                    }
                                }
                            }

                            onReleased: {
                                if (!isDrawing) return;

                                isDrawing = false;

                                console.log("Drawn rectangle:",
                                            drawRect.x, drawRect.y,
                                            drawRect.width, drawRect.height)

                                // به‌روزرسانی موقعیت شمارنده
                                if (objectsCounter) {
                                    objectsCounter.x = drawRect.x
                                    objectsCounter.y = drawRect.y - 30
                                }

                                // پس از رسم مستطیل، باکس‌ها را دوباره ترسیم می‌کنیم
                                if (screenpic && screenpic.drawBoxes) {
                                    screenpic.drawBoxes();
                                }

                                // فقط مستطیل را پنهان می‌کنیم اما مقادیر را ریست نمی‌کنیم
                                // تا برای استفاده بعدی حفظ شوند
                            }

                            // هنگامی که ماوس از ناحیه خارج شد
                            onExited: {
                                if (isDrawing) {
                                    // اگر در حال رسم بودیم و خارج شدیم، رسم را لغو می‌کنیم
                                    isDrawing = false;
                                    drawRect.visible = false;
                                }
                            }
                        }
                    }
                }

                MediaPlayer {
                    id: mediaPlayer
                    autoPlay: true
                    onError: console.error("MediaPlayer error:", errorString)
                    loops: MediaPlayer.Infinite
                    onStopped: {
                        if (mediaPlayer.status == MediaPlayer.EndOfMedia) {
                            mediaPlayer.play();
                        }
                    }
                }

            }









            // نمایشگر تعداد اشیاء در مستطیل
            Rectangle {
                id: objectsCounter
                color: "#80000000" // سیاه نیمه شفاف
                border.color: "black"
                border.width: 1
                radius: 5
                width: objectsCounterText.implicitWidth + 20
                height: objectsCounterText.implicitHeight + 10
                visible: drawRect.visible
                z: 11

                Text {
                    id: objectsCounterText
                    anchors.centerIn: parent
                    text: "ObjNumber  " + objectsInRect
                    color: "white"
                    font.bold: true
                    font.pixelSize: 16
                }
            }

            FileDialog {
                id: fileDialog
                title: "Select Video File"
                folder: shortcuts.home
                nameFilters: ["Video files (*.mp4 *.avi *.mov)"]
                onAccepted: {
                    videoPath = fileDialog.fileUrl.toString().replace("file:///", "")
                    mediaPlayer.source = fileDialog.fileUrl
                    pythonBridge.startDetection(videoPath)
                    alarmSound.stop() // توقف هر گونه صدای قبلی
                    alarmPlaying = false
                    objectsInRect = 0 // ریست شمارنده
                }
            }

            Connections {
                target: pythonBridge

                onFrameReady: {
                    processedImage.source = "file:///" + imagePath
                }

                onBoxesReady: {
                    currentBoxes = boxes
                    screenpic.drawBoxes() // استفاده از id برای فراخوانی تابع
                }
            }



            Component.onCompleted: {
                console.log("Application loaded")
                console.log("مقدار appDir:", appDir)

            }

            //            Audio {
            //                id: alarmSound
            ////                source: "file:///C:/Users/Mobina/Desktop/newgui/beep-1.wav"

            //                source: Qt.resolvedUrl("file:///" + appDir + "/videos/beep-1.wav")

            //                volume: 1.0

            //                onStatusChanged: {
            //                    console.log("Audio status:", status)
            //                    if (status === Audio.Error) {
            //                        console.error("Audio Error:", errorString)
            //                    } else if (status === Audio.EndOfMedia) {
            //                        console.log("Audio finished, restarting")
            //                        // فقط اگر هنوز اشیاء در مستطیل هستند صدا را دوباره پخش کن
            //                        if (objectsInRect > 0) {
            //                            alarmSound.play()
            //                        }
            //                    }
            //                }

            //                onPlaying: {
            //                    console.log("Audio started playing")
            //                }

            //                onStopped: {
            //                    console.log("Audio stopped")
            //                }
            //            }



            // بخش انتخاب فایل
            FileDialog {
                id: fileDialogsound
                title: "Select Audio File"
                folder: shortcuts.home
                nameFilters: ["Audio Files (*.mp3 *.wav *.ogg)", "All Files (*)"]

                onAccepted: {
                    var fileUrl = fileDialogsound.fileUrl;
                    settings.setValue("customSoundPath", fileUrl);

                    alarmSound.stop();
                    alarmSound.source = Qt.resolvedUrl(fileUrl);
                }
            }

            Audio {
                id: alarmSound
                volume: 1.0


                onStatusChanged: {

                    console.log("Audio status:", status)
                    if (status === Audio.Error) {
                        console.error("Audio Error:", errorString)
                    } else if (status === Audio.EndOfMedia) {
                        console.log("Audio finished, restarting")
                        // فقط اگر هنوز اشیاء در مستطیل هستند صدا را دوباره پخش کن
                        if (objectsInRect > 0) {
                            alarmSound.play()
                        }
                    }

                }


                Component.onCompleted: {
                    var savedPath = settings.value("customSoundPath", "");
                    if (savedPath !== "") {
                        source = Qt.resolvedUrl(savedPath); // اصلاح این خط
                    } else {
                        source = Qt.resolvedUrl("file:///" + appDir + "/videos/beep-1.wav");
                    }
                }




            }

            Settings {
                id: settings
                category: "AudioSettings"
            }



        }

        Rectangle {
            id: rectmenu
            width: parent.width * 0.24
            height: parent.height * 0.3
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.01
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.002
            radius: 5
            color: "transparent"
            border.color: "white"
            visible: true

            Rectangle{
                id:rectmenuleft
                color: "transparent"
                anchors.left: parent.left
                anchors.leftMargin: parent.width *0.02
                width: parent.width * 0.7
                height: parent.height * 1.0
                radius: 5



                Rectangle{
                    id:btnSetting
                    color: "transparent"
                    width: parent.width * 0.27
                    height: parent.height * 0.15
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.02
                    radius: 5
                    Image {
                        id: btnSettingimg
                        anchors.fill: parent
                        source: "qrc:/img/btnactive.png"
                    }
                    Text {
                        id: btnSettingtxt
                        text: qsTr("Setting")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true

                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {

                            btnSettingimg.source="qrc:/img/btnactive.png"
                            btnGimbalimg.source="qrc:/img/btn.png"
                            btnAlarmimg.source="qrc:/img/btn.png"
                            btnVideoimg.source="qrc:/img/btn.png"
                            btnNetworkimg.source="qrc:/img/btn.png"
                            rectsetting.visible = true
                            rectgimbal.visible = false
                            rectalarm.visible = false
                            rectvideo.visible = false
                            rectnetwork.visible = false


                        }
                    }

                }

                Rectangle{
                    id:btnGimbal
                    color: "transparent"
                    width: parent.width * 0.27
                    height: parent.height * 0.15
                    anchors.top: btnSetting.bottom
                    anchors.topMargin: parent.height *0.042
                    radius: 5

                    Image {
                        id: btnGimbalimg
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }
                    Text {
                        id: btnGimbaltxt
                        text: qsTr("Tools")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true

                    }

                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            btnSettingimg.source="qrc:/img/btn.png"
                            btnGimbalimg.source="qrc:/img/btnactive.png"
                            btnAlarmimg.source="qrc:/img/btn.png"
                            btnVideoimg.source="qrc:/img/btn.png"
                            btnNetworkimg.source="qrc:/img/btn.png"

                            rectsetting.visible = false
                            rectgimbal.visible = true
                            rectalarm.visible = false
                            rectvideo.visible = false
                            rectnetwork.visible = false

                        }
                    }

                }
                Rectangle{
                    id:btnAlarm
                    color: "transparent"
                    width: parent.width * 0.27
                    height: parent.height * 0.15
                    anchors.top: btnGimbal.bottom
                    anchors.topMargin: parent.height *0.042
                    radius: 5
                    Image {
                        id: btnAlarmimg
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }
                    Text {
                        id: btnAlarmtxt
                        text: qsTr("Alarm")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true

                    }

                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            btnSettingimg.source="qrc:/img/btn.png"
                            btnGimbalimg.source="qrc:/img/btn.png"
                            btnAlarmimg.source="qrc:/img/btnactive.png"
                            btnVideoimg.source="qrc:/img/btn.png"
                            btnNetworkimg.source="qrc:/img/btn.png"

                            rectsetting.visible = false
                            rectgimbal.visible = false
                            rectalarm.visible = true
                            rectvideo.visible = false
                            rectnetwork.visible = false

                        }
                    }

                }
                Rectangle{
                    id:btnVideo
                    color: "transparent"
                    width: parent.width * 0.27
                    height: parent.height * 0.15
                    anchors.top: btnAlarm.bottom
                    anchors.topMargin: parent.height *0.042
                    radius: 5
                    Image {
                        id: btnVideoimg
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }

                    Text {
                        id: btnVideotxt
                        text: qsTr("Video")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true

                    }

                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            btnSettingimg.source="qrc:/img/btn.png"
                            btnGimbalimg.source="qrc:/img/btn.png"
                            btnAlarmimg.source="qrc:/img/btn.png"
                            btnVideoimg.source="qrc:/img/btnactive.png"
                            btnNetworkimg.source="qrc:/img/btn.png"

                            rectsetting.visible = false
                            rectgimbal.visible = false
                            rectalarm.visible = false
                            rectvideo.visible = true
                            rectnetwork.visible = false

                        }
                    }

                }
                Rectangle{
                    id:btnNetwork
                    color: "transparent"
                    width: parent.width * 0.27
                    height: parent.height * 0.15
                    anchors.top: btnVideo.bottom
                    anchors.topMargin: parent.height *0.042
                    radius: 5
                    Image {
                        id: btnNetworkimg
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }

                    Text {
                        id: btnNetworktxt
                        text: qsTr("Network")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            btnSettingimg.source="qrc:/img/btn.png"
                            btnGimbalimg.source="qrc:/img/btn.png"
                            btnAlarmimg.source="qrc:/img/btn.png"
                            btnVideoimg.source="qrc:/img/btn.png"
                            btnNetworkimg.source="qrc:/img/btnactive.png"

                            rectsetting.visible = false
                            rectgimbal.visible = false
                            rectalarm.visible = false
                            rectvideo.visible = false
                            rectnetwork.visible = true

                        }
                    }
                }
            }



            Rectangle{
                id:rectmenuright
                width: parent.width * 0.73
                height: parent.height * 0.96
                radius: 5
                color: "transparent"
                border.color: "grey"
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.02
                anchors.top: parent.top
                anchors.topMargin: parent.height *0.02


                Rectangle{
                id:rectsetting
                width: rectmenu.width * 0.73
                height: rectmenu.height * 0.96
                radius: 5
                color: "transparent"
                border.color: "grey"
                anchors.right: parent.right
                anchors.top: parent.top
                visible: true

                Rectangle{
                    id:btndrawing
                    color: "transparent"
                    width: parent.width * 0.2
                    height: parent.height * 0.1
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.03
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.03
                    radius: 5

                    Image {
                        id: btndrawingimg
                        anchors.fill: parent
                        source: "qrc:/img/btnactive.png"
                    }
                    Text {
                        id: btndrawingtxt
                        text: qsTr("Drawing")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true
                    }

                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            btndrawingimg.source = "qrc:/img/btnactive.png"
                            btnlogsimg.source = "qrc:/img/btn.png"
                            btndetectionimg.source = "qrc:/img/btn.png"
                            rectdrawing.visible = true
                            rectlogs.visible = false
                            rectdetect.visible = false

                        }
                    }

                }

                Rectangle{
                    id:btnlogs
                    color: "transparent"
                    width: parent.width * 0.2
                    height: parent.height * 0.1
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.03
                    anchors.left: btndrawing.right
                    anchors.leftMargin: parent.width * 0.03
                    radius: 5

                    Image {
                        id: btnlogsimg
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }
                    Text {
                        id: btnlogstxt
                        text: qsTr("Logs")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true
                    }

                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            btndrawingimg.source = "qrc:/img/btn.png"
                            btnlogsimg.source = "qrc:/img/btnactive.png"
                            btndetectionimg.source = "qrc:/img/btn.png"
                            rectdrawing.visible = false
                            rectlogs.visible = true
                            rectdetect.visible = false

                        }
                    }

                }


                Rectangle{
                    id:btndetection
                    color: "transparent"
                    width: parent.width * 0.2
                    height: parent.height * 0.1
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.03
                    anchors.left: btnlogs.right
                    anchors.leftMargin: parent.width * 0.03
                    radius: 5

                    Image {
                        id: btndetectionimg
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }
                    Text {
                        id: btndetectiontxt
                        text: qsTr("Detect")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true
                    }

                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            btndrawingimg.source = "qrc:/img/btn.png"
                            btnlogsimg.source = "qrc:/img/btn.png"
                            btndetectionimg.source = "qrc:/img/btnactive.png"
                            rectdrawing.visible = false
                            rectlogs.visible = false
                            rectdetect.visible = true

                        }
                    }

                }

                Rectangle{
                id:rectdetect
                width: rectmenu.width * 0.73
                height: rectmenu.height * 0.96
                radius: 5
                color: "transparent"
                border.color: "grey"
                anchors.right: parent.right
                anchors.top: parent.top
                visible: false




                Rectangle{
                    id:detect
                    width: parent.width * 0.9
                    height: parent.height *0.6
                    color: "transparent"
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.23
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        id: detectimg
                        anchors.fill: parent
                        source: "qrc:/img/border2.png"
                    }

                    Rectangle{
                        id:rectpolygondetect1
                        color: "transparent"
                        width: parent.width * 0.8
                        height: parent.height * 0.32
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.1
                        anchors.horizontalCenter: parent.horizontalCenter
                        radius: 5

                        Image {
                            id: rectpolygondetect1img
                            anchors.fill: parent
                            source: "qrc:/img/polygan.png"
                        }


                        Rectangle{
                            id:person
                            width: parent.width * 0.14
                            height: parent.height * 0.4
                            color: "transparent"  // رنگ مستطیل را شفاف می‌کنیم چون فقط تصویر مهم است
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.16
                            border.color: "transparent"
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width * 0.08

                            property bool isActiveperson: false

                            Image {
                                id: personimg
                                anchors.fill: parent
                                source: person.isActiveperson ? "qrc:/img/icons8-person-100(1).png"
                                                              : "qrc:/img/icons8-person-100.png"
                            }


                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    person.isActiveperson = !person.isActiveperson;

                                }

                                onPressed: {
                                    person.opacity = 0.5
                                }
                                onReleased: {
                                    person.opacity= 1.0
                                }

                            }

                        }


                        Rectangle{
                            id:truck
                            width: parent.width * 0.12
                            height: parent.height * 0.5
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.1
                            color: "transparent"
                            border.color: "transparent"
                            anchors.left: person.right
                            anchors.leftMargin: parent.width * 0.12


                            property bool isActivetruckcanvas: false


                            Image {
                                id: truckimg
                                anchors.fill: parent
                                // تغییر تصویر بر اساس isActivepencil
                                source: truck.isActivetruckcanvas ? "qrc:/img/icons8-truck-100 (1).png"
                                                                  : "qrc:/img/icons8-truck-100.png"
                            }


                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    truck.isActivetruckcanvas = !truck.isActivetruckcanvas;

                                }

                                onPressed: {
                                    truck.opacity = 0.5
                                }
                                onReleased: {
                                    truck.opacity= 1.0
                                }


                            }

                        }

                        Rectangle{
                            id:motor
                            width: parent.width * 0.09
                            height: parent.height * 0.47
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.07
                            color: "transparent"
                            border.color: "transparent"
                            anchors.left: truck.right
                            anchors.leftMargin: parent.width * 0.12

                            property bool isActivemotor: false


                            Image {
                                id: motorimg
                                anchors.fill: parent
                                source: motor.isActivemotor ? "qrc:/img/icons8-motorbike-100.png"
                                                            : "qrc:/img/icons8-motorbike-100 (1).png"
                            }

                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    motor.opacity = 0.5
                                }
                                onReleased: {
                                    motor.opacity = 1.0
                                    motor.isActivemotor = !motor.isActivemotor
                                }
                            }
                        }


                        Rectangle{
                            id:animal
                            width: parent.width * 0.09
                            height: parent.height * 0.46
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.15
                            color: "transparent"
                            border.color: "transparent"
                            anchors.left: motor.right
                            anchors.leftMargin: parent.width * 0.12

                            property bool isActiveanimal: false


                            Image {
                                id: animalimg
                                anchors.fill: parent
                                source: animal.isActiveanimal ? "qrc:/img/icons8-dog-100(1).png"
                                                                          : "qrc:/img/icons8-dog-100.png"
                            }

                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    animal.opacity = 0.5
                                }
                                onReleased: {
                                    animal.opacity = 1.0
                                    animal.isActiveanimal = !animal.isActiveanimal
                                }
                            }
                        }
                    }




                    Rectangle {
                        id:rectpolygondetect2
                        color: "transparent"
                        width: parent.width * 0.8
                        height: parent.height * 0.32
                        anchors.top: rectpolygondetect1.bottom
                        anchors.topMargin: parent.height *0.1
                        anchors.horizontalCenter: parent.horizontalCenter
                        radius: 5

                        Image {
                            id: rectpolygondetect2img
                            anchors.fill: parent
                            source: "qrc:/img/polygan.png"
                        }


                        Rectangle{
                            id:car
                            width: parent.width * 0.14
                            height: parent.height * 0.4
                            color: "transparent"  // رنگ مستطیل را شفاف می‌کنیم چون فقط تصویر مهم است
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.16
                            border.color: "transparent"
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width * 0.08

                            property bool isActivecar: false

                            Image {
                                id: carimg
                                anchors.fill: parent

                                source: car.isActivecar ? "qrc:/img/icons8-car-100.png"
                                                              : "qrc:/img/icons8-car-100 (1).png"
                            }


                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    car.isActivecar = !car.isActivecar;

                                }

                                onPressed: {
                                    car.opacity = 0.5
                                }
                                onReleased: {
                                    car.opacity= 1.0
                                }

                            }

                        }

                    }

                }



                Rectangle{
                    id:btnsenddetect
                    color: "transparent"
                    width: parent.width * 0.25
                    height: parent.height * 0.08
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.042
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 5


                    Image {
                        id: btnsenddetectimg
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }
                    Text {
                        id:btnsenddetecttxt
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
                            btnsenddetect.opacity = 0.5
                        }
                        onReleased: {
                            btnsenddetect.opacity = 1.0
                        }
                    }

                }

                }






                Rectangle{
                id:rectdrawing
                width: rectmenu.width * 0.73
                height: rectmenu.height * 0.96
                radius: 5
                color: "transparent"
                border.color: "grey"
                anchors.right: parent.right
                anchors.top: parent.top
                visible: true

                Text {
                    id: lblpolygontxt
                    text: qsTr("Polygon")
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.215
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.13
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }


                Rectangle{
                    id:rectpolygon
                    color: "transparent"
                    width: parent.width * 0.8
                    height: parent.height * 0.22
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.24
                   anchors.horizontalCenter: parent.horizontalCenter
                    radius: 5

                    Image {
                        id: rectpolygonimg
                        anchors.fill: parent
                        source: "qrc:/img/polygan.png"
                    }


                    Rectangle{
                    id:pencil
                    width: parent.width * 0.14
                    height: parent.height * 0.4
                    color: "transparent"  // رنگ مستطیل را شفاف می‌کنیم چون فقط تصویر مهم است
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.16
                    border.color: "transparent"
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.08

                    property bool isActivepencil: false

                    Image {
                            id: pencilimg
                            anchors.fill: parent
                            // تغییر تصویر بر اساس isActivepencil
                            source: pencil.isActivepencil ? "qrc:/img/rectangleactive.png"
                                                          : "qrc:/img/rectangle.png"
                        }


                    MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pencil.isActivepencil = !pencil.isActivepencil;

                    }

                    onPressed: {
                    pencil.opacity = 0.5
                    }
                    onReleased: {
                    pencil.opacity= 1.0
                    }

                    }

                    }


                    Rectangle{
                    id:lamp
                    width: parent.width * 0.14
                    height: parent.height * 0.6
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.055
                    color: "transparent"
                    border.color: "transparent"
                    anchors.left: pencil.right
                    anchors.leftMargin: parent.width * 0.12


                    property bool isActivepencilcanvas: false


                    Image {
                            id: lampimg
                            anchors.fill: parent
                            // تغییر تصویر بر اساس isActivepencil
                            source: lamp.isActivepencilcanvas ? "qrc:/img/icons8-pencil-100 (1).png"
                                                          : "qrc:/img/icons8-pencil-100.png"
                        }


                    MouseArea {
                           anchors.fill: parent
                           onClicked: {
                               lamp.isActivepencilcanvas = !lamp.isActivepencilcanvas
                               screenRectangle.isPolygonDrawingEnabled = lamp.isActivepencilcanvas


                               if (!lamp.isActivepencilcanvas) {
                                          // وقتی غیر فعال شد، همه‌چیز پاک بشه
                                          polygonCanvas.points = []
                                          polygonCanvas.requestPaint()
                                      }

                               if (lamp.isActivepencilcanvas) {
                                              screenRectangle.isDrawingEnabled = false;
                                              pencil.isActivepencil = false;
                                          }


                           }
                       }

                    }

                    Rectangle{
                        id:colorpolygan
                        width: parent.width * 0.08
                        height: parent.height * 0.45
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.15
                        color: "transparent"
                        border.color: "transparent"
                        anchors.left: lamp.right
                        anchors.leftMargin: parent.width * 0.12

                        property bool isActivecolorpolygan: false


                        Image {
                            id: colorpolyganimg
                            anchors.fill: parent
                            source: colorpolygan.isActivecolorpolygan ? "qrc:/img/icons8-brush-100.png"
                                                                      : "qrc:/img/icons8-brush-stroke-100.png"
                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                colorpolygan.opacity = 0.5
                            }
                            onReleased: {
                                colorpolygan.opacity = 1.0
                                colorpolygan.isActivecolorpolygan = !colorpolygan.isActivecolorpolygan
                            }

                        }

                        Flux.ColorChooser {
                            id: colorChooser
                            anchors.centerIn: parent
                            visible: colorpolygan.isActivecolorpolygan
                        }

                        Component.onCompleted: {
                            console.log("COLOR:", colorChooser.color)
                        }


                    }


//




                    Rectangle{
                    id:numobjinpolygan
                    width: parent.width * 0.12
                    height: width
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.12
                    color: "transparent"
                    border.color: "transparent"
                    anchors.left: colorpolygan.right
                    anchors.leftMargin: parent.width * 0.12

                    Image {
                        id: numobjinpolyganimg
                        anchors.fill: parent
                        source: "qrc:/img/value.png"
                    }

                    }



                }

                Text {
                    id: lblboundingboxtxt
                    text: qsTr("Bounding Box")
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.55
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.13
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }

                Rectangle{
                    id:rectboundingbox
                    color: "transparent"
                    width: parent.width * 0.8
                    height: parent.height * 0.22
                    anchors.top: rectpolygon.bottom
                    anchors.topMargin: parent.height *0.1
                   anchors.horizontalCenter: parent.horizontalCenter
                    radius: 5

                    Image {
                        id: rectboundingboximg
                        anchors.fill: parent
                        source: "qrc:/img/polygan.png"
                    }


                    Rectangle{
                        id:colorboundingbox
                        width: parent.width * 0.08
                        height: parent.height * 0.45
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.15
                        color: "transparent"
                        border.color: "transparent"
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.08

                        property bool isActivecolorboundingbox: false


                        Image {
                            id: colorboundingboximg
                            anchors.fill: parent
                            source: colorboundingbox.isActivecolorboundingbox ? "qrc:/img/icons8-brush-100.png": "qrc:/img/icons8-brush-stroke-100.png"

                        }

                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                colorboundingbox.opacity = 0.5
                            }
                            onReleased: {
                                colorboundingbox.opacity = 1.0
//                                colorboundingbox.isActivecolorboundingbox = !colorboundingbox.isActivecolorboundingbox
                            }

                        }

                        ColorChooser2 {
                            id: colorChooser2
                            anchors.centerIn: parent
                            visible: colorboundingbox.isActivecolorboundingbox
                        }



                    }

                    Rectangle{
                    id:zoominobj
                    width: parent.width * 0.12
                    height: parent.height * 0.4
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.15
                    color: "transparent"
                    border.color: "transparent"
                    anchors.left: colorboundingbox.right
                    anchors.leftMargin: parent.width * 0.12

                    property bool isActivezoominobj: false


                    Image {
                        id: zoominobjimg
                        anchors.fill: parent
                        source: zoominobj.isActivezoominobj ? "qrc:/img/zoominobjon.png"
                                                                            : "qrc:/img/zoominobj.png"

                    }

                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            zoominobj.opacity=0.5
                        }

                        onReleased: {
                            zoominobj.opacity=1.0
                            zoominobj.isActivezoominobj = !zoominobj.isActivezoominobj



                        }

                    }

                    }



                    Rectangle{
                        id:numobjinboundingbox
                        width: parent.width * 0.12
                        height: width
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.12
                        color: "transparent"
                        border.color: "transparent"
                        anchors.left: zoominobj.right
                        anchors.leftMargin: parent.width * 0.12

                        Image {
                            id: numobjinboundingboximg
                            anchors.fill: parent
                            source: "qrc:/img/value.png"
                        }

                    }


                }



                Rectangle{
                    id:lblnumberofobj
                    color: "transparent"
                    width: parent.width * 0.2
                    height: parent.height * 0.085
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.05
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.09
                    radius: 5

                    Image {
                        id: lblnumberofobjimg
                        anchors.fill: parent
                        source: "qrc:/img/lable.png"
                    }
                    Text {
                        id: lblnumberofobjtxt
                        text: qsTr("Num OBJ")
                        anchors.centerIn: parent
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true
                    }
                }


                Rectangle{
                    id:lblnumberofobjvalue
                    color: "transparent"
                    width: parent.width * 0.1
                    height: width
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.03
                    anchors.left: lblnumberofobj.right
                    anchors.leftMargin: parent.width * 0.03
                    radius: 5

                    Image {
                        id: lblnumberofobjvalueimg
                        anchors.fill: parent
                        source: "qrc:/img/value.png"
                    }
                    Text {
                        id: lblnumberofobjvaluetxt
                        text: qsTr("25")
                        anchors.centerIn: parent
                        color: "#4B4B4D"
                        font.pixelSize: parent.width *0.45
                        font.bold: true
                    }
                }





                }

                Rectangle{
                    id:rectlogs
                    width: rectmenu.width * 0.73
                    height: rectmenu.height * 0.96
                    radius: 5
                    color: "transparent"
                    border.color: "transparent"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    visible: false


                    Text {
                        id: lbllogstxt
                        text: qsTr("Logs")
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.415
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.13
                        color: "White"
                        font.pixelSize: parent.width *0.04
                        font.bold: true
                    }

                    Rectangle{
                        id:rectborderlogs
                        color: "transparent"
                        width: parent.width * 0.8
                        height: parent.height * 0.22
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.44
                       anchors.horizontalCenter: parent.horizontalCenter
                        radius: 5

                        Image {
                            id: rectborderlogsimg
                            anchors.fill: parent
                            source: "qrc:/img/polygan.png"
                        }



                        Rectangle{
                            id:logobj
                            width: parent.width * 0.16
                            height: parent.height * 0.65
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.15
                            color: "transparent"
                            border.color: "transparent"
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width * 0.08

                            property bool isActivelogobj: false



                            Image {
                                id:logobjimg
                                anchors.fill: parent
                                source: logobj.isActivelogobj ? "qrc:/img/objdetectionlogon.png": "qrc:/img/objdetectionlog.png"
                            }

                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    logobj.opacity = 0.5
                                }
                                onReleased: {
                                    logobj.opacity = 1.0
                                    logobj.isActivelogobj = !logobj.isActivelogobj
                                }

                            }


                        }

                        Rectangle{
                            id:logalr
                            width: parent.width * 0.16
                            height: parent.height * 0.65
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.15
                            color: "transparent"
                            border.color: "transparent"
                            anchors.left: logobj.right
                            anchors.leftMargin: parent.width * 0.12


                            Image {
                                id: logalrimg
                                anchors.fill: parent
                                source: "qrc:/img/logalarm.png"
                            }

                        }


                    }

                }

                }




                Rectangle{
                    id:rectgimbal
                    width: rectmenu.width * 0.73
                    height: rectmenu.height * 0.96
                    radius: 5
                    color: "black"
                    border.color: "grey"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    visible: false


                    Rectangle{
                        id:rectframesetting
                        width: rectmenu.width * 0.73
                        height: rectmenu.height * 0.96
                        radius: 5
                        color: "black"
                        border.color: "grey"
                        anchors.right: parent.right
                        anchors.top: parent.top
                        visible: false

                        Rectangle {
                            id: back
                            width: parent.width * 0.08
                            height: width
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.005
                            anchors.right: parent.right
                            anchors.rightMargin: parent.width * 0.005
                            opacity: 1.0
                            rotation: 180


                            Image {
                                id: backimg
                                source: "qrc:/img/icons8-next-100 (1).png"
                                anchors.fill: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: {
                                    back.opacity=0.5

                                }

                                onReleased: {
                                    back.opacity=1.0
                                    recttools.visible = true
                                    rectframesetting.visible = false
                                    screenpanaroma.visible = false
                                    screenRectangle.visible = true
                                }
                            }
                        }


                        Rectangle{

                            id:settinframe
                            width: parent.width * 0.6
                            height: parent.height *0.3
                            color: "transparent"
                            border.color: "gray"
                           anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            Rectangle{
                                id:lblframes
                                color: "transparent"
                                width: parent.width * 0.28
                                height: parent.height * 0.28
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width * 0.05
                                radius: 5

                                Image {
                                    id: lblsettinframeimg
                                    anchors.fill: parent
                                    source: "qrc:/img/lable.png"
                                }
                                Text {
                                    id: lblsettinframetxt
                                    text: qsTr("Frames")
                                    anchors.centerIn: parent
                                    color: "White"
                                    font.pixelSize: parent.width *0.2
                                    font.bold: true
                                }
                            }

                            Rectangle{
                                id:recttxtfieldsettinframe
                                width: parent.width * 0.3
                                height: parent.height *0.3
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width *0.497
                               anchors.verticalCenter: parent.verticalCenter
                                radius: 3
                                color: "transparent"
                                border.color: "white"

                                TextField {
                                    anchors.fill: parent
                                    font.pixelSize: parent.width *0.15
                                    text: "100"
                                    placeholderText: "100"
                                }
                            }


                            Rectangle{
                                id:plussettinframe
                                width: parent.width * 0.09
                                height: width
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width *0.84
                                anchors.top: parent.top
                                anchors.topMargin: parent.height *0.38
                                radius: 3
                                color: "transparent"

                                Image {
                                    id: plusimgsettinframe
                                    source: "qrc:/img/plus.png"
                                    anchors.fill: parent
                                }
                            }

                            Rectangle{
                                id:minussettinframe
                                width: parent.width * 0.09
                                height: width
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width *0.36
                                anchors.top: parent.top
                                anchors.topMargin: parent.height *0.38
                                radius: 3
                                color: "transparent"

                                Image {
                                    id: minusimgsettinframe
                                    source: "qrc:/img/minus.png"
                                    anchors.fill: parent
                                }
                            }


                            Rectangle{
                                id:btnstartsettinframe
                                color: "transparent"
                                width: parent.width * 0.31
                                height: parent.height * 0.21
                                anchors.top: recttxtfieldsettinframe.bottom
                                anchors.topMargin: parent.height *0.035
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width *0.49
                                radius: 5


                                Image {
                                    id: btnsettinframeimg
                                    anchors.fill: parent
                                    source: "qrc:/img/btn.png"
                                }
                                Text {
                                    id:settinframetxt
                                    text: qsTr("Start")
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: "White"
                                    font.pixelSize: parent.width *0.18
                                    font.bold: true

                                }
                            }


                        }










                    }

                    Rectangle{
                        id:recttools
                        width: rectmenu.width * 0.73
                        height: rectmenu.height * 0.96
                        radius: 5
                        color: "black"
                        border.color: "grey"
                        anchors.right: parent.right
                        anchors.top: parent.top
                        visible: true


                    Text {
                        id: lbltoolstxt
                        text: qsTr("Tools")
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.2
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.13
                        color: "White"
                        font.pixelSize: parent.width *0.04
                        font.bold: true
                    }

                    Rectangle{
                        id:recttools1border
                        color: "transparent"
                        width: parent.width * 0.8
                        height: parent.height * 0.22
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.22
                        anchors.horizontalCenter: parent.horizontalCenter
                        radius: 5

                        Image {
                            id: recttools1borderimg
                            anchors.fill: parent
                            source: "qrc:/img/polygan.png"
                        }


                        Rectangle{
                            id:laser
                            width: parent.width * 0.14
                            height: parent.height * 0.4
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.16
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width *0.08

                            Image {
                                id: laserimg
                                source: "qrc:/img/icons8-laser-beam-100.png"

                                anchors.fill: parent
                            }


                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    laser.opacity=0.5
                                }

                                onReleased: {
                                    laser.opacity=1.0


                                }

                            }

                        }

                        Rectangle{
                            id:panaroma
                            width: parent.width * 0.14
                            height: parent.height * 0.4
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.16
                            anchors.left: laser.right
                            anchors.leftMargin: parent.width * 0.075
                            opacity: 1.0



                            Image {
                                id: resetimg
                                source: "qrc:/img/icons8-panaroma-100.png"
                                anchors.fill: parent
                            }

                            MouseArea{
                                anchors.fill: parent

                                onPressed: {
                                    panaroma.opacity=0.5

                                }
                                onReleased: {
                                    panaroma.opacity=1.0
                                    screenRectangle.visible = false
                                    screenpanaroma.visible = true
                                    rectframesetting.visible = true
                                    recttools.visible = false


                                }
                            }
                        }

                        Rectangle {
                            id: fullscreen
                            width: parent.width * 0.14
                            height: parent.height * 0.4
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.16
                            anchors.left: panaroma.right
                            anchors.leftMargin: parent.width * 0.075
                            opacity: 1.0

                            Image {
                                id: fullscreenimg
                                source: "qrc:/img/icons8-fullscreen-100.png"
                                anchors.fill: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: {
                                    fullscreen.opacity=0.5
                                }

                                onReleased: {
                                    fullscreen.opacity=1.0
                                    fullscreenback.visible = true
                                    previewComponent.visible = false
                                    rectmenu.visible = false
                                    isFullScreen = true // فعال کردن حالت تمام‌صفحه
                                }
                            }
                        }



                        Rectangle{
                            id:record
                            width: parent.width * 0.14
                            height: parent.height * 0.4
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.16
                            anchors.left: fullscreen.right
                            anchors.leftMargin: parent.width *0.075
                            opacity: 1.0

                            Image {
                                id: recordimg
                                source: "qrc:/img/icons8-camera-100.png"
                                anchors.fill: parent
                            }


                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    record.opacity=0.5
                                }
                                onReleased: {
                                    record.opacity=1.0
                                }
                            }




                        }









                    }

                    Text {
                        id: lbltools2txt
                        text: qsTr("Tools")
                        anchors.top: recttools1border.bottom
                        anchors.topMargin: parent.height * 0.2
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.13
                        color: "White"
                        font.pixelSize: parent.width *0.04
                        font.bold: true
                    }

                    Rectangle{
                        id:recttools2border
                        color: "transparent"
                        width: parent.width * 0.8
                        height: parent.height * 0.22
                        anchors.top: recttools1border.bottom
                        anchors.topMargin: parent.height *0.22
                        anchors.horizontalCenter: parent.horizontalCenter
                        radius: 5

                        Image {
                            id: recttools2borderimg
                            anchors.fill: parent
                            source: "qrc:/img/polygan.png"
                        }


                        Rectangle{
                            id:snapshot
                            width: parent.width * 0.14
                            height: parent.height * 0.4
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.16
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width *0.08
                            opacity: 1.0

                            Image {
                                id: snapshotimg
                                source: "qrc:/img/icons8-camera-100(1).png"
                                anchors.fill: parent
                            }


                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    snapshot.opacity=0.5
                                }
                                onReleased: {
                                    snapshot.opacity=1.0
                                }
                            }

                        }



                        Rectangle{
                            id:shutdowncamera
                            width: parent.width * 0.14
                            height: parent.height * 0.4
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.16
                            anchors.left: snapshot.right
                            anchors.leftMargin: parent.width * 0.075
                            opacity: 1.0

                            Image {
                                id: shutdowncameraimg
                                source: "qrc:/img/icons8-shutdown-100.png"
                                anchors.fill: parent
                            }


                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    shutdowncamera.opacity=0.5
                                }
                                onReleased: {
                                    shutdowncamera.opacity=1.0
                                    screenpic.visible = !screenpic.visible

                                }
                            }

                        }

                        Rectangle{
                            id:reset
                            width: parent.width * 0.14
                            height: parent.height * 0.4
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.16
                            anchors.left: shutdowncamera.right
                            anchors.leftMargin: parent.width *0.075
                            opacity: 1.0

                            Image {
                                id: panaromaimg
                                anchors.fill: parent
                                source: "qrc:/img/icons8-reset-100.png"

                            }


                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    reset.opacity=0.5
                                }
                                onReleased: {
                                    reset.opacity=1.0
                                }
                            }

                        }

                        Rectangle{
                            id:user
                            width: parent.width * 0.14
                          height: parent.height * 0.4
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.16
                            anchors.left: reset.right
                            anchors.leftMargin: parent.width *0.075
                            opacity: 1.0

                            Image {
                                id: userimg
                                source: "qrc:/img/icons8-user-100.png"
                                anchors.fill: parent
                            }


                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    user.opacity=0.5
                                }
                                onReleased: {
                                    user.opacity=1.0
                                }
                            }

                        }


                    }

                }

                }


                Rectangle{
                    id:rectalarm
                    width: rectmenu.width * 0.73
                    height: rectmenu.height * 0.96
                    radius: 5
                    color: "transparent"
                    border.color: "grey"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    visible: false


                    Text {
                        id: lblalarmtxt
                        text: qsTr("Alarm")
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.28
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.13
                        color: "White"
                        font.pixelSize: parent.width *0.04
                        font.bold: true
                    }

                    Rectangle{
                        id:rectalarmborder
                        color: "transparent"
                        width: parent.width * 0.8
                        height: parent.height * 0.22
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.3
                        anchors.horizontalCenter: parent.horizontalCenter
                        radius: 5

                        Image {
                            id: rectalarmborderimg
                            anchors.fill: parent
                            source: "qrc:/img/polygan.png"
                        }


                        Rectangle {
                            id: musicsetting
                            width: parent.width * 0.085
                            height: parent.height * 0.45
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height * 0.15
                            color: "transparent"
                            border.color: "transparent"
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width * 0.08

                            Image {
                                id: musicsettingimg
                                anchors.fill: parent
                                source: "qrc:/img/musicsetting.png"
                            }

                            // MouseArea برای باز کردن دیالوگ انتخاب فایل
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    fileDialogsound.open()
                                }
                                onPressed: {
                                musicsetting.opacity = 0.5
                                }
                                onReleased: {
                                musicsetting.opacity= 1.0
                                }

                            }

                        }




                        Rectangle{
                            id:musicenable
                            width: parent.width * 0.1
                            height: parent.height * 0.55
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.15
                            color: "transparent"
                            border.color: "transparent"
                            anchors.left: musicsetting.right
                            anchors.leftMargin: parent.width * 0.12


                            Image {
                                id: musicenableimg
                                anchors.fill: parent
                                source: "qrc:/img/icons8-shutdown-100.png"
                            }

                        }





                    }


                    Rectangle{

                        id:settingalarm
                        width: parent.width * 0.6
                        height: parent.height *0.3
                        color: "transparent"
                        border.color: "gray"
                        anchors.top: rectalarmborder.bottom
                        anchors.topMargin: parent.height *0.06
                        anchors.horizontalCenter: parent.horizontalCenter

                        Rectangle{
                            id:lblnumberofobjinalarm
                            color: "transparent"
                            width: parent.width * 0.28
                            height: parent.height * 0.28
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width * 0.05
                            radius: 5

                            Image {
                                id: lblnumberofobjinalarmimg
                                anchors.fill: parent
                                source: "qrc:/img/lable.png"
                            }
                            Text {
                                id: lblnumberofobjinalarmtxt
                                text: qsTr("Num OBJ")
                                anchors.centerIn: parent
                                color: "White"
                                font.pixelSize: parent.width *0.2
                                font.bold: true
                            }
                        }

                        Rectangle{
                            id:recttxtfieldnumobj
                            width: parent.width * 0.3
                            height: parent.height *0.3
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width *0.497
                           anchors.verticalCenter: parent.verticalCenter
                            radius: 3
                            color: "transparent"
                            border.color: "white"

                            TextField {
                                anchors.fill: parent
                                font.pixelSize: parent.width *0.15
                                text: "100"
                                placeholderText: "100"
                            }
                        }


                        Rectangle{
                            id:plus
                            width: parent.width * 0.09
                            height: width
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width *0.84
                            anchors.top: parent.top
                            anchors.topMargin: parent.height *0.38
                            radius: 3
                            color: "transparent"

                            Image {
                                id: plusimg
                                source: "qrc:/img/plus.png"
                                anchors.fill: parent
                            }
                        }

                        Rectangle{
                            id:minus
                            width: parent.width * 0.09
                            height: width
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width *0.36
                            anchors.top: parent.top
                            anchors.topMargin: parent.height *0.38
                            radius: 3
                            color: "transparent"

                            Image {
                                id: minusimg
                                source: "qrc:/img/minus.png"
                                anchors.fill: parent
                            }
                        }


                        Rectangle{
                            id:btnsendalarm
                            color: "transparent"
                            width: parent.width * 0.31
                            height: parent.height * 0.21
                            anchors.top: recttxtfieldnumobj.bottom
                            anchors.topMargin: parent.height *0.035
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width *0.49
                            radius: 5


                            Image {
                                id: btnsendalarmimg
                                anchors.fill: parent
                                source: "qrc:/img/btn.png"
                            }
                            Text {
                                id:btnsendalarmtxt
                                text: qsTr("SET")
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: "White"
                                font.pixelSize: parent.width *0.18
                                font.bold: true

                            }
                        }


                    }
                }


                Rectangle{
                    id:rectvideo
                    width: rectmenu.width * 0.73
                    height: rectmenu.height * 0.96
                    radius: 5
                    color: "transparent"
                    border.color: "grey"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    visible: false


                    Rectangle{
                        id:previewvideo
                        width: parent.width* 0.55
                        height: width
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width *0.05
                        anchors.top: parent.top
                        anchors.topMargin: parent.height *0.05
                        color: "transparent"
                        border.color: "White"
                        Rectangle{
                            id:fullscreenvideo
                            width: parent.width *0.2
                            height: parent.height * 0.2
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: parent.height *0.05
                            anchors.right: parent.right
                            anchors.rightMargin: parent.width * 0.05

                            Image{
                            anchors.fill: parent
                            source: "qrc:/img/icons8-fullscreen-100.png"

                            }

                        }

                    }


//                    Button {
//                        text: "انتخاب ویدیو"
//                        Layout.alignment: Qt.AlignHCenter
//                        onClicked: fileDialog.open()

//                        background: Rectangle {
//                            color: "#4a86e8"
//                            radius: 5
//                        }
//                        contentItem: Text {
//                            text: parent.text
//                            color: "white"
//                            horizontalAlignment: Text.AlignHCenter
//                            verticalAlignment: Text.AlignVCenter
//                        }
//                    }

                    Rectangle{
                        id:selectbtn
                        width: parent.width * 0.21
                        height: parent.height *0.1
                        color: "transparent"
                        radius: 3
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.05
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.09
                        opacity: 1.0

                        Image {
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }

                        Text {
                            id: selectbtntxt
                            text: qsTr("Select")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.18
                            font.bold: true

                        }
                        MouseArea{
                            anchors.fill: parent
                            onPressed: {
                                selectbtn.opacity=0.5
                            }
                            onClicked: {
                                fileDialog.open()
                            }
                            onReleased: {
                            selectbtn.opacity=1.0
                            }
                        }
                    }


                    Rectangle{
                        id:previewbtn
                        width: parent.width * 0.21
                        height: parent.height *0.1
                        color: "transparent"
                        radius: 3
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height *0.05
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.33

                        Image {
                            anchors.fill: parent
                            source: "qrc:/img/btn.png"
                        }

                        Text {
                            id: previewbtntxt
                            text: qsTr("Preview")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "White"
                            font.pixelSize: parent.width *0.18
                            font.bold: true

                        }

                    }

                  Rectangle{
                  id:recordwithobj
                  width: parent.width * 0.12
                  height: parent.height *0.1
                  color: "transparent"
                  radius: 3
                  anchors.bottom: parent.bottom
                  anchors.bottomMargin: parent.height *0.05
                  anchors.left: previewbtn.right
                  anchors.leftMargin: parent.width * 0.065

                  Image {
                      anchors.fill: parent
                      source: "qrc:/img/recordwithobj.png"
                  }

                  }

                  Rectangle{
                  id:snapwithobj
                  width: parent.width * 0.12
                  height: parent.height *0.1
                  color: "transparent"
                  radius: 3
                  anchors.bottom: parent.bottom
                  anchors.bottomMargin: parent.height *0.05
                  anchors.left: recordwithobj.right
                  anchors.leftMargin: parent.width * 0.065

                  Image {
                      anchors.fill: parent
                      source: "qrc:/img/snapshotlog.png"
                  }

                  }
                }

                Rectangle{
                id:rectnetwork
                width: rectmenu.width * 0.73
                height: rectmenu.height * 0.96
                radius: 5
                color: "transparent"
                border.color: "grey"
                anchors.right: parent.right
                anchors.top: parent.top
                visible: false

                Text {
                    id: lblnetworktxt
                    text: qsTr("Network")
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.215
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.13
                    color: "White"
                    font.pixelSize: parent.width *0.04
                    font.bold: true
                }


                Rectangle{
                    id:rectnetworkborder
                    color: "transparent"
                    width: parent.width * 0.8
                    height: parent.height * 0.22
                    anchors.top: parent.top
                    anchors.topMargin: parent.height *0.24
                   anchors.horizontalCenter: parent.horizontalCenter
                    radius: 5

                    Image {
                        id: rectnetworkborderimg
                        anchors.fill: parent
                        source: "qrc:/img/polygan.png"
                    }


                    Rectangle{
                    id:videolog
                    width: parent.width * 0.16
                    height: parent.height * 0.65
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.15
                    color: "transparent"
                    border.color: "transparent"
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.08


                    Image {
                        id: videologimg
                        anchors.fill: parent
                        source: "qrc:/img/logrecord.png"
                    }

                    }

                    Rectangle{
                    id:objlog
                    width: parent.width * 0.16
                    height: parent.height * 0.65
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.15
                    color: "transparent"
                    border.color: "transparent"
                    anchors.left: videolog.right
                    anchors.leftMargin: parent.width * 0.12

                    Image {
                        id: objlogimg
                        anchors.fill: parent
                        source: "qrc:/img/loginfo.png"
                    }

                    }
                }


                Text {
                    id: ipaddress
                    text: qsTr("IP Address:")
                    font.pixelSize: parent.width * 0.05
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width *0.03
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.3
                    color: "white"
                }

                Rectangle{
                    id:ip1
                    width: parent.width * 0.09
                    height: parent.height *0.01
                    color: "transparent"
                    anchors.left: ipaddress.right
                    anchors.leftMargin: parent.width *0.03
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.29

                    Image {
                        id: ip1img
                        source: "qrc:/img/lineip.png"
                        anchors.fill: parent
                    }
                }

                Rectangle{
                    id:ip2
                    width: parent.width * 0.09
                    height: parent.height *0.01
                    color: "transparent"
                    anchors.left: ip1.right
                    anchors.leftMargin: parent.width *0.024
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.29

                    Image {
                        id: ip2img
                        source: "qrc:/img/lineip.png"
                        anchors.fill: parent
                    }
                }

                Rectangle{
                    id:ip3
                    width: parent.width * 0.09
                    height: parent.height *0.01
                    color: "transparent"
                    anchors.left: ip2.right
                    anchors.leftMargin: parent.width *0.024
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.29

                    Image {
                        id: ip3img
                        source: "qrc:/img/lineip.png"
                        anchors.fill: parent
                    }
                }

                Rectangle{
                    id:ip4
                    width: parent.width * 0.09
                    height: parent.height *0.01
                    color: "transparent"
                    anchors.left: ip3.right
                    anchors.leftMargin: parent.width *0.024
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height *0.29

                    Image {
                        id: ip4img
                        source: "qrc:/img/lineip.png"
                        anchors.fill: parent
                    }
                }

                Rectangle{
                    id:btnsendnetwork
                    width: parent.width * 0.25
                    height: parent.height * 0.08
                    color: "transparent"
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width *0.05
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.15

                    Image {
                        anchors.fill: parent
                        source: "qrc:/img/btn.png"
                    }

                    Text {
                        id:btnsendnetworktxt
                        text: qsTr("Send")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "White"
                        font.pixelSize: parent.width *0.18
                        font.bold: true
                    }
                }

                }
            }
        }



        Preview{
            id: previewComponent
            width: parent.width * 0.24
            height: parent.height *0.67
        }


    }
}
