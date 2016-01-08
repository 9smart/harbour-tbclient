#include "audiorecorder.h"
#include<QFile>
#include<QDebug>

AudioRecorder::AudioRecorder(QObject *parent) :
    QObject(parent)
{
    captureSource = new QAudioRecorder;
    recorder = new QMediaRecorder(captureSource->mediaObject());

    audioSettings.setCodec("audio/amr");
    audioSettings.setQuality(QMultimedia::HighQuality);
    recorder->setEncodingSettings(audioSettings);
    //recorder->setOutputLocation(QUrl::fromLocalFile("/home/nemo/Pictures/save/tbclient/audio/test.amr"));

    //qDebug() << QUrl::fromLocalFile("/home/nemo/Pictures/save/tbclient/audio/test.amr");
    //qDebug() << recorder->outputLocation();
    //recorder->record();

    connect(recorder, SIGNAL(error(QMediaRecorder::Error)), this, SIGNAL(errorChanged()));
    connect(recorder, SIGNAL(stateChanged(QMediaRecorder::State)), this, SIGNAL(stateChanged()));
    connect(recorder, SIGNAL(durationChanged(qint64)), this, SIGNAL(durationChanged()));
}

AudioRecorder::~AudioRecorder()
{
    captureSource->deleteLater();
    recorder->deleteLater();
}

AudioRecorder::State AudioRecorder::state() const
{
    return static_cast<State>(recorder->state());
}

AudioRecorder::Error AudioRecorder::error() const
{
    return static_cast<Error>(recorder->error());
}

QUrl AudioRecorder::outputLocation() const
{
    return recorder->outputLocation();
}

int AudioRecorder::duration() const
{
    return recorder->duration();
}

void AudioRecorder::setOutputLocation(const QUrl &location)
{
    recorder->setOutputLocation(QUrl(location.toString().remove("file://")));
    emit outputLocationChanged();
}

void AudioRecorder::record()
{
    recorder->record();
}

void AudioRecorder::stop()
{
    recorder->stop();
}
