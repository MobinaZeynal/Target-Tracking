#include "keyboard.h"
#include <QKeyEvent>

Keyboard::Keyboard(Command *cmd, QObject *parent)
    : QObject(parent), m_cmd(cmd)
{
    speed = 63; // سرعت پیش فرض
    ptzTimer = new QTimer(this);
    ptzTimer->setInterval(50); // هر 50 میلی‌ثانیه فرمان PTZ ارسال شود برای روانی بهتر

    connect(ptzTimer, &QTimer::timeout, [=]() {
        if (m_cmd && currentAction != -1) {
            switch (currentAction) {
                case 0: m_cmd->sendPtz(channel, 0, 0, speed); break; // Up
                case 1: m_cmd->sendPtz(channel, 1, 0, speed); break; // Down
                case 2: m_cmd->sendPtz(channel, 2, speed, 0); break; // Left
                case 3: m_cmd->sendPtz(channel, 3, speed, 0); break; // Right
            }
        }
    });
}

bool Keyboard::eventFilter(QObject *obj, QEvent *event)
{
    if (!m_cmd) return QObject::eventFilter(obj, event);

    if (event->type() == QEvent::KeyPress) {
        QKeyEvent *key = static_cast<QKeyEvent*>(event);

        if (key->isAutoRepeat()) return true; // نادیده گرفتن تکرار خودکار سیستم

        switch (key->key()) {
            case Qt::Key_Up: currentAction=0; ptzTimer->start(); break;
            case Qt::Key_Down: currentAction=1; ptzTimer->start(); break;
            case Qt::Key_Left: currentAction=2; ptzTimer->start(); break;
            case Qt::Key_Right: currentAction=3; ptzTimer->start(); break;
            default: return QObject::eventFilter(obj, event);
        }
        return true;
    }

    if (event->type() == QEvent::KeyRelease) {
        QKeyEvent *key = static_cast<QKeyEvent*>(event);

        if (key->isAutoRepeat()) return true;

        switch (key->key()) {
            case Qt::Key_Up:
            case Qt::Key_Down:
            case Qt::Key_Left:
            case Qt::Key_Right:
                ptzTimer->stop();
                currentAction = -1;
                m_cmd->sendPtz(channel, 8, 0, 0); // Stop PTZ
                break;
            default:
                return QObject::eventFilter(obj, event);
        }
        return true;
    }

    return QObject::eventFilter(obj, event);
}
