import QtQuick 2.2
import Sailfish.Silica 1.0
import "Component"

MyPage {
    id: page;

    property url imageUrl;
    property int bheight;
    property int bwidth;

    title: qsTr("Image viewer");

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-directory-move-to"
            onClicked: {
                var path = tbsettings.imagePath + "/" + imageUrl.toString().split("/").pop();
                if (utility.saveCache(imageUrl, path)){
                    signalCenter.showMessage(qsTr("Image saved to %1").arg(path));
                } else {
                    utility.openURLDefault(imageUrl);
                }
            }
        }
    }*/

    Flickable {
        id: imageFlickable
        anchors.fill: parent
        contentWidth: imageContainer.width; contentHeight: imageContainer.height
        clip: true
        onHeightChanged: if (imagePreview.status === Image.Ready) imagePreview.fitToScreen()

        Item {
            id: imageContainer
            width: Math.max(imagePreview.width * imagePreview.scale, imageFlickable.width)
            height: Math.max(imagePreview.height * imagePreview.scale, imageFlickable.height)

            AnimatedImage {//Image {
                id: imagePreview

                property real prevScale

                function fitToScreen() {
                    var xwidth=bwidth*1000/bheight;
                    var xheight=1000;
                    scale = Math.min(imageFlickable.width / width, imageFlickable.height / height, 1)
                    pinchArea.minScale = scale
                    prevScale = scale
                    console.log(scale
                                +"---"+width+"---"+height
                                +"---"+bwidth+"---"+bheight
                                +"---"+imageFlickable.width+"---"+imageFlickable.height
                                +"---"+xwidth+"---"+xheight)
                }

                anchors.centerIn: parent
                fillMode: Image.PreserveAspectCrop;
                clip: false;
                //fillMode: Image.PreserveAspectFit
                cache: false
                asynchronous: true
                source: imageUrl
                width: bwidth;
                height:bheight;
                //scale: 1000/sourceSize.height
                //sourceSize.height: 1000;
                smooth: !imageFlickable.moving
                playing:true;
                onStatusChanged: {
                    if (status == Image.Ready) {
                        fitToScreen()
                        loadedAnimation.start();
                        //console.log("-----------"+imagePreview.frameCount)
                    }
                }

                NumberAnimation {
                    id: loadedAnimation
                    target: imagePreview
                    property: "opacity"
                    duration: 250
                    from: 0; to: 1
                    easing.type: Easing.InOutQuad
                }

                onScaleChanged: {
                    if ((width * scale) > imageFlickable.width) {
                        var xoff = (imageFlickable.width / 2 + imageFlickable.contentX) * scale / prevScale;
                        imageFlickable.contentX = xoff - imageFlickable.width / 2
                    }
                    if ((height * scale) > imageFlickable.height) {
                        var yoff = (imageFlickable.height / 2 + imageFlickable.contentY) * scale / prevScale;
                        imageFlickable.contentY = yoff - imageFlickable.height / 2
                    }
                    prevScale = scale
                }
            }
        }

        PinchArea {
            id: pinchArea

            property real minScale: 1.0
            property real maxScale: 3.0

            anchors.fill: parent
            enabled: imagePreview.status === Image.Ready
            pinch.target: imagePreview
            pinch.minimumScale: minScale * 0.5 // This is to create "bounce back effect"
            pinch.maximumScale: maxScale * 1.5 // when over zoomed

            onPinchFinished: {
                imageFlickable.returnToBounds()
                if (imagePreview.scale < pinchArea.minScale) {
                    bounceBackAnimation.to = pinchArea.minScale
                    bounceBackAnimation.start()
                }
                else if (imagePreview.scale > pinchArea.maxScale) {
                    bounceBackAnimation.to = pinchArea.maxScale
                    bounceBackAnimation.start()
                }
            }
            NumberAnimation {
                id: bounceBackAnimation
                target: imagePreview
                duration: 250
                property: "scale"
                from: imagePreview.scale
            }
        }
//        MouseArea {
//            id: mouseArea;
//            anchors.fill: parent;
//            enabled: imagePreview.status === Image.Ready;
//            onDoubleClicked: {
//                if (imagePreview.scale > pinchArea.minScale){
//                    bounceBackAnimation.to = pinchArea.minScale
//                    bounceBackAnimation.start()
//                } else {
//                    bounceBackAnimation.to = pinchArea.maxScale
//                    bounceBackAnimation.start()
//                }
//            }
//        }
    }

    Loader {
        anchors.centerIn: parent
        sourceComponent: {
            switch (imagePreview.status) {
            case Image.Loading:
                return loadingIndicator
            case Image.Error:
                return failedLoading
            default:
                return undefined
            }
        }

        Component {
            id: loadingIndicator

            Item {
                height: childrenRect.height
                width: page.width

                BusyIndicator {
                    id: imageLoadingIndicator
                    anchors.horizontalCenter: parent.horizontalCenter
                    running: true
                }

                Text {
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: imageLoadingIndicator.bottom; topMargin: constant.paddingLarge
                    }
                    font.pixelSize: constant.fontXSmall;
                    color: constant.colorLight;
                    text: qsTr("Loading image...%1").arg(Math.round(imagePreview.progress*100) + "%")
                }
            }
        }

        Component {
            id: failedLoading
            Text {
                font.pixelSize: constant.fontXSmall;
                text: qsTr("Error loading image")
                color: constant.colorLight;
            }
        }
    }

    VerticalScrollDecorator { flickable: imageFlickable }
    IconButton {
        anchors{
            right: page.right;
            rightMargin: Theme.paddingLarge;
            bottom: page.bottom;
            bottomMargin: Theme.paddingLarge;
        }
        width: Theme.iconSizeMedium+Theme.paddingMedium*2

        icon.source: "image://theme/icon-m-cloud-download"
        onClicked: {
            var path = tbsettings.imagePath + "/save/tbclient/" + imageUrl.toString().split("/").pop();
            if (utility.saveCache(imageUrl, path)){
                signalCenter.showMessage(qsTr("Image saved to %1").arg(path));
            } else {
                utility.openURLDefault(imageUrl);
            }
        }
    }
}
