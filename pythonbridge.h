//#ifndef PYTHONBRIDGE_H
//#define PYTHONBRIDGE_H

//#include <QObject>
//#include <QProcess>
//#include <QPixmap>

//class PythonBridge : public QObject
//{
//    Q_OBJECT
//public:
//    explicit PythonBridge(QObject *parent = nullptr);

//    Q_INVOKABLE void startDetection(const QString &videoPath);

//signals:
//    void frameReady(const QString &imagePath);
//    void boxesReady(const QVariantList &boxes);
//    void videoFinished();  // سیگنال جدید


//private slots:
//    void readPythonOutput();

//private:
//    QProcess *pythonProcess;
//    QByteArray buffer;  // برای ذخیره خروجی ناقص خط به خط
//};

//#endif // PYTHONBRIDGE_H








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
