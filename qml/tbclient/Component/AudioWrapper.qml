import QtQuick 2.0
import QtMultimedia 5.0
import "../Base"
import com.yeatse.tbclient 1.0
import "../../js/Utils.js" as Utils

Item {
    id: root;
    property string mp3: ""

    // public api:
    property string currentMd5;
    property real volume: audio.volume;
    property int position: audio.position;
    property bool playing: audio.playbackState == Audio.PlayingState;
    property bool loading: audio.status == Audio.Loading;
    Downloader{
        id : downloader
    }
    function changeFile(filename){
        audio.stop();
        if (audio.status != Audio.Loading){
            audio.source = filename;
            audio.play();
        }
    }

    function playAudio(md5){
        if (audio.status === Audio.Loading){
            coldDown.pendingMd5 = md5;
            coldDown.target = audio;
        } else {
            if (currentMd5 === md5){
                if (audio.playing && !audio.paused){
                    audio.pause();
                } else {
                    audio.play();
                }
            } else {
                currentMd5 = md5;
                audio.stop();
                audio.source = Utils.getAudioUrl(md5);
                audio.play();
            }
        }
    }
    function playMp3Audio(tid,pid){
        if (audio.status === Audio.Loading){
            coldDown.pendingMd5 = pid;
            coldDown.target = audio;
        } else {
            if (currentMd5 === pid){
                if (audio.playing && !audio.paused){
                    audio.pause();
                } else {
                    audio.play();
                }
            } else {
                currentMd5 = pid;
                audio.stop();
                downloader.appendDownload(Utils.getMp3AudioUrl(tid,pid),"/tmp/"+tid+""+pid+".tmp");
                audio.source = "";
                root.mp3="file:///tmp/"+tid+""+pid+".tmp";
                tim.running=true

                //audio.source = root.mp3;
                //console.log(audio.source)
                //audio.play();
            }
        }
    }

    function stop(){
        audio.stop();
    }

    visible: false;

    Audio {
        id: audio;
    }
    Timer{
        id:tim
        interval: 500;
        repeat: true;
        running: false;
        onTriggered: {
            if(downloader.state==4){
                audio.source=""
                audio.source=root.mp3
                audio.play();
                tim.running=false;
            }
        }
    }

    Connections {
        id: coldDown;
        property string pendingMd5;
        target: null;
        onStatusChanged: {
            if (audio.status != Audio.Loading){
                coldDown.target = null;
                playAudio(coldDown.pendingMd5);
            }
        }
    }
}
