
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Base"
import "../../js/TabGroup.js" as Engine

Item {
    id: root
    property Item currentTab

    property list<Item> privateContents
    // Qt defect: cannot have list as default property
    default property alias privateContentsDefault: root.privateContents
    property bool platformAnimated: true

    onChildrenChanged: {
        //  [0] is containerHost
        if (children.length > 1)
            Engine.addTab(children[1])
    }

    onPrivateContentsChanged: {
        Engine.ensureContainers()
    }

    Component.onCompleted: {
        // Set first tabs as current if currentTab is not set by application
        if (currentTab == null && containerHost.children[0] && containerHost.children[0].children[0])
            currentTab = containerHost.children[0].children[0]
        priv.complete = true;
    }

    Item {
        id: containerHost
        objectName: "containerHost"
        anchors.fill: parent
    }

    Component {
        id: tabContainerComponent
        Item {
            id: tabContainerItem

            onChildrenChanged: {
                if (children.length == 0)
                    Engine.removeContainer(tabContainerItem)

                else if (children.length == 1) {
                    children[0].width = width
                    children[0].height = height
                    // tab content created. set the first tab as current (if not set before, and if
                    // child is added after TabGroup has completed)
                    if (priv.complete && root.currentTab == null)
                        root.currentTab = children[0]
                }
            }

            onWidthChanged: {
                if (children.length > 0)
                    children[0].width = width
            }

            onHeightChanged: {
                if (children.length > 0)
                    children[0].height = height
            }

            Component.onDestruction: {
                if (typeof(root) != "undefined" && !root.currentTab) {
                    // selected one deleted. try to activate the neighbour
                    var removedIndex = -1
                    for (var i = 0; i < containerHost.children.length; i++) {
                        if (containerHost.children[i] == tabContainerItem) {
                            removedIndex = i
                            break
                        }
                    }
                    var newIndex = -1
                    if (removedIndex != -1) {
                        if (removedIndex != containerHost.children.length - 1)
                            newIndex = removedIndex + 1
                        else if (removedIndex != 0)
                            newIndex = removedIndex - 1
                    }

                    if (newIndex != -1)
                        root.currentTab = containerHost.children[newIndex].children[0]
                    else
                        root.currentTab = null
                }
            }

            function incomingDone() {
                state = ""
                if (priv.incomingPage) {
                    // priv.incomingPage.status = PageStatus.Active
                    priv.incomingPage = null
                }
            }

            function outgoingDone() {
                if (priv.outgoingPage) {
                    // priv.outgoingPage.status = PageStatus.Inactive
                    priv.outgoingPage.visible = false
                    priv.outgoingPage = null
                }
                state = "Hidden"
            }

            width: parent ? parent.width : 0
            height: parent ? parent.height : 0
            state: "Hidden"

            states: [
                State { name: ""; PropertyChanges { target: tabContainerItem; opacity: 1.0 } },
                State { name: "Incoming"; PropertyChanges { target: tabContainerItem; opacity: 1.0 } },
                State { name: "Outgoing"; PropertyChanges { target: tabContainerItem; opacity: 0.0 } },
                State { name: "Hidden"; PropertyChanges { target: tabContainerItem; opacity: 0.0 } }
            ]

            transitions:  [
                Transition {
                    to: "Incoming"
                    SequentialAnimation {
                        PropertyAnimation { properties: "opacity"; easing.type: Easing.Linear; duration: 250 }
                        ScriptAction { script: incomingDone() }
                    }
                },
                Transition {
                    to: "Outgoing"
                    SequentialAnimation {
                        PropertyAnimation { properties: "opacity"; easing.type: Easing.Linear; duration: 250 }
                        ScriptAction { script: outgoingDone() }
                    }
                }
            ]
        }
    }

    QtObject {
        id: priv
        property bool reparenting: false
        property bool complete: false
        property Item currentTabContainer: root.currentTab ? root.currentTab.parent : null
        property Item incomingPage
        property Item outgoingPage
        property bool animate

        function disableAnimations() {
            animate = false

            // outgoingPage might have been found before the incomingPage changes the orientation
            if (outgoingPage)
                outgoingPage.parent.outgoingDone()
        }

        onCurrentTabContainerChanged: {
            animate = platformAnimated // updated on orientation change
            //screen.currentOrientationChanged.connect(priv.disableAnimations)
            for (var i = 0; i < containerHost.children.length; i++) {
                var tabContainer = containerHost.children[i]
                var isNewTab = (tabContainer == currentTabContainer)
                if (isNewTab) {
                    if (tabContainer.state != "") {
                        if (tabContainer.children[0].status != undefined) {
                            incomingPage = tabContainer.children[0]
                            // incomingPage.status = PageStatus.Activating // triggers the orientation change
                            incomingPage.visible = true
                            if (incomingPage == outgoingPage)
                                outgoingPage = null
                        }
                        if (animate)
                            tabContainer.state = "Incoming"
                        else
                            tabContainer.incomingDone()
                    }
                } else {
                    if (tabContainer.state != "Hidden") {
                        if (tabContainer.children.length > 0 && tabContainer.children[0].status != undefined) {
                            outgoingPage = tabContainer.children[0]
                            // outgoingPage.status = PageStatus.Deactivating
                            if (incomingPage == outgoingPage)
                                incomingPage = null
                        }
                        if (animate)
                            tabContainer.state = "Outgoing"
                        else
                            tabContainer.outgoingDone()
                    }
                }
            }
            //screen.currentOrientationChanged.disconnect(priv.disableAnimations)
        }
    }
}
