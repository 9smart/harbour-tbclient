import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Base"

Item {
    id: root;
    
    property alias imageList: imageArea.imageList;
    property alias audioFile: voiceArea.audioUrl;
    property alias audioDuration: voiceArea.duration;

    width: parent.width;
    height: 0;
    
    ImageArea {
        id: imageArea;
        visible: false;
    }

    VoiceArea {
        id: voiceArea;
        visible: false;
    }
    
    states: [
        State {
            name: "Image";
            PropertyChanges { target: root; height: 240; }
            PropertyChanges { target: imageArea; visible: true; }
        },
        State {
            name: "Voice";
            PropertyChanges { target: root; height: 240; }
            PropertyChanges { target: voiceArea; visible: true; }
        }
    ]

    onStateChanged: if (state != "Voice") audioWrapper.stop();
}
