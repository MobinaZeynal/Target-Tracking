//#include <QGuiApplication>
//#include <QQmlApplicationEngine>
//#include <QQmlContext>
//#include <QDir>
//#include <QDebug>
//#include <QSound>

//#include "pythonbridge.h"
//#include "login.h"
//#include "command.h"


//int main(int argc, char *argv[])
//{
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

//    QGuiApplication app(argc, argv);

//    QDir::setCurrent(QCoreApplication::applicationDirPath());

//    QQmlApplicationEngine engine;
//    const QUrl url(QStringLiteral("qrc:/main.qml"));

//    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
//                     &app, [url](QObject *obj, const QUrl &objUrl) {
//        if (!obj && url == objUrl)
//            QCoreApplication::exit(-1);
//    }, Qt::QueuedConnection);

//    PythonBridge bridge;
//    Login login;

//    engine.rootContext()->setContextProperty("pythonBridge", &bridge);
//    engine.rootContext()->setContextProperty("login", &login);

//    qmlRegisterType<PythonBridge>("com.example.pythonbridge", 1, 0, "PythonBridge");

//    engine.addImportPath("C:/Users/Mobina/Desktop/newgui");
//    engine.rootContext()->setContextProperty("appDir", QCoreApplication::applicationDirPath());

//    qputenv("QT_QUICK_CONTROLS_CONF", QByteArray("qtquickcontrols2.conf"));

//    QString wavPath = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/release/videos/beep-1.wav");
//    engine.rootContext()->setContextProperty("beepSoundPath", "file:///" + wavPath);
//    QSound::play(wavPath);

//    qDebug() << "[INFO] Starting login process...";
//    if (!login.performLogin()) {
//        qDebug() << "[FAIL] Login failed!";
//        return -1;
//    }
//    qDebug() << "[SUCCESS] Login successful! Token:" << login.token();

//    engine.load(url);

//    Command *cmd = new Command(&login);

//       // برای تست
//       cmd->sendPtz(0, 0, 0, 30); // حرکت UP

//    return app.exec();
//}







#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QDebug>
#include <QSound>

#include "pythonbridge.h"
#include "login.h"
#include "command.h"
#include "keyboard.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    // تنظیم مسیر جاری به مسیر اجرای برنامه
    QDir::setCurrent(QCoreApplication::applicationDirPath());

    // Engine QML
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    // کلاس‌های bridge و login
    PythonBridge bridge;
    Login login;

    engine.rootContext()->setContextProperty("pythonBridge", &bridge);
    engine.rootContext()->setContextProperty("login", &login);

    qmlRegisterType<PythonBridge>("com.example.pythonbridge", 1, 0, "PythonBridge");

    engine.addImportPath("C:/Users/Mobina/Desktop/newgui");
    engine.rootContext()->setContextProperty("appDir", QCoreApplication::applicationDirPath());

    qputenv("QT_QUICK_CONTROLS_CONF", QByteArray("qtquickcontrols2.conf"));

    // پخش صدای beep
    QString wavPath = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/release/videos/beep-1.wav");
    engine.rootContext()->setContextProperty("beepSoundPath", "file:///" + wavPath);
    QSound::play(wavPath);

    // لاگین
    qDebug() << "[INFO] Starting login process...";
    if (!login.performLogin()) {
        qDebug() << "[FAIL] Login failed!";
        return -1;
    }
    qDebug() << "[SUCCESS] Login successful! Token:" << login.token();

    // بارگذاری QML
    engine.load(url);
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    // ایجاد Command
    Command *cmd = new Command(&login);

    // ایجاد Keyboard handler برای Arrow Keys
    Keyboard *keyboard = new Keyboard(cmd);
    app.installEventFilter(keyboard);  // فعال کردن event filter برای دریافت کلیدهای کیبورد

    qDebug() << "[INFO] PTZ Arrow key control ready. Use arrow keys to move camera.";

    return app.exec();
}
