import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: pageHeader

    property alias title: headerText.text
    property alias _titleItem: headerText
    property alias wrapMode: headerText.wrapMode
    property alias extraContent: extraContentPlaceholder
    property string description
    property Item page
    property real leftMargin: Theme.horizontalPageMargin
    property real rightMargin: Theme.horizontalPageMargin
    property Item _descriptionLabel
    property real _preferredHeight: page && page.isLandscape ? Theme.itemSizeSmall : Theme.itemSizeLarge

    onDescriptionChanged: {
        if (description.length > 0 && !_descriptionLabel) {
            var component = Qt.createComponent(Qt.resolvedUrl("private/PageHeaderDescription.qml"))
            if (component.status == Component.Ready) {
                _descriptionLabel = component.createObject(pageHeader)
            } else {
                console.warn("PageHeaderDescription.qml instantiation failed " + component.errorString())
            }
        }
    }

    width: parent ? parent.width : Screen.width
    // set height that keeps the first line of text aligned with the page indicator
    height: Math.max(_preferredHeight, headerText.y + headerText.height + (_descriptionLabel ? _descriptionLabel.height : 0) + Theme.paddingMedium)

    Label {
        id: headerText
        // Don't allow the label to extend over the page stack indicator
        width: Math.min(implicitWidth, parent.width - leftMargin - rightMargin)
        truncationMode: TruncationMode.Fade
        color: Theme.highlightColor
        y: _preferredHeight/2 - height/2
        anchors {
            right: parent.right
            rightMargin: pageHeader.rightMargin
        }
        font {
            pixelSize: Theme.fontSizeLarge
            family: myfont.name
        }
    }
    Item {
        id: extraContentPlaceholder
        anchors {
            left: parent.left
            leftMargin: pageHeader.leftMargin
            right: headerText.left
            verticalCenter: parent.verticalCenter
        }
    }
}
