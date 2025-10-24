//CAMERA
#pragma once
#include <QObject>
#include <QProcess>
#include <QString>

class PythonBridge : public QObject
{
    Q_OBJECT
public:
    explicit PythonBridge(QObject *parent = nullptr);

    Q_INVOKABLE void startDetection();
    Q_INVOKABLE void stopDetection();

signals:
    void frameReady(const QString &framePath);

private slots:
    void readPythonOutput();

private:
    QProcess *pythonProcess;
    QByteArray buffer;
};
