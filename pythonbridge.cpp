//CAMERA
#include "pythonbridge.h"
#include <QDebug>
#include <QCoreApplication>
#include <QDir>
#include <QImage>


PythonBridge::PythonBridge(QObject *parent) : QObject(parent)
{
    pythonProcess = new QProcess(this);

    connect(pythonProcess, &QProcess::readyReadStandardOutput,
            this, &PythonBridge::readPythonOutput);

    connect(pythonProcess, &QProcess::readyReadStandardError, [=]() {
        QByteArray error = pythonProcess->readAllStandardError();
        if (!error.isEmpty())
            qDebug() << "Python Error:" << QString::fromUtf8(error);
    });
}

void PythonBridge::startDetection()
{
    if (pythonProcess->state() != QProcess::NotRunning)
        return;

    QString scriptPath = "C:/Users/Mobina/Desktop/26/26.py";

    QString pythonExe = "python";

    pythonProcess->start(pythonExe, QStringList() << scriptPath);

    if (!pythonProcess->waitForStarted(3000))
        qDebug() << "Failed to start Python script";
    else
        qDebug() << "Python script started";
}

void PythonBridge::stopDetection()
{
    if (pythonProcess->state() != QProcess::NotRunning)
    {
        pythonProcess->kill();
        pythonProcess->waitForFinished();
        qDebug() << "Python script stopped";
    }
}

void PythonBridge::readPythonOutput()
{
    // append new bytes
    buffer.append(pythonProcess->readAllStandardOutput());

    while (true) {
        int newlineIndex = buffer.indexOf('\n');
        if (newlineIndex == -1) {
            break;
        }

        QByteArray header = buffer.left(newlineIndex);
        if (!header.startsWith("FRAME ")) {
            buffer = buffer.mid(newlineIndex + 1);
            continue;
        }

        bool ok = false;
        QByteArray sizePart = header.mid(strlen("FRAME "));
        int imgSize = sizePart.toInt(&ok);
        if (!ok || imgSize <= 0) {
            buffer = buffer.mid(newlineIndex + 1);
            continue;
        }

        int bytesAvailable = buffer.size() - (newlineIndex + 1);
        if (bytesAvailable < imgSize) {
            break;
        }

        QByteArray imgBytes = buffer.mid(newlineIndex + 1, imgSize);

        buffer = buffer.mid(newlineIndex + 1 + imgSize);

        QImage img;
        if (!img.loadFromData(reinterpret_cast<const uchar*>(imgBytes.constData()), imgBytes.size(), "JPG")) {
            qDebug() << "Failed to load image from data, size:" << imgBytes.size();
            continue;
        }

        QByteArray base64 = imgBytes.toBase64();
        QString dataUrl = QStringLiteral("data:image/jpeg;base64,") + QString::fromUtf8(base64);
        emit frameReady(dataUrl);

        // emit frameReadyImage(img);  // نیاز به تعریف سیگنال جدید با QImage دارد
    }
}

