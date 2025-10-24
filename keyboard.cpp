#include "keyboard.h"
#include <QKeyEvent>

Keyboard::Keyboard(Command *cmd, QObject *parent)
    : QObject(parent), m_cmd(cmd)
{
    speed = 63; // سرعت پیش فرض

    ptzTimer = new QTimer(this);
    ptzTimer->setInterval(70);

    connect(ptzTimer, &QTimer::timeout, [=]() {
        if (currentActionId != -1 && m_cmd) {
            m_cmd->sendPtz(currentChannel, currentActionId, speed, speed);
        }
    });
}

void Keyboard::startAction(int actionId, int ch)
{
    currentActionId = actionId;
    currentChannel = ch;
    ptzTimer->start();
}

void Keyboard::stopAction()
{
    ptzTimer->stop();

    if (!m_cmd) {
        currentActionId = -1;
        return;
    }

    int stopActionId = 8; // default: pan/tilt stop

    if (currentActionId == 9 || currentActionId == 10) {
        stopActionId = 29;
    }
    else if (currentActionId == 11 || currentActionId == 12) {
        stopActionId = 30;
    }

    m_cmd->sendPtz(currentChannel, stopActionId, 0, 0);
    currentActionId = -1;
}




bool Keyboard::eventFilter(QObject *obj, QEvent *event)
{
    if (!m_cmd) return QObject::eventFilter(obj, event);

    if (event->type() == QEvent::KeyPress) {
        QKeyEvent *key = static_cast<QKeyEvent*>(event);
        if (key->isAutoRepeat()) return true;

        switch (key->key()) {
            // PTZ Move
            case Qt::Key_Up:           startAction(0, 0); return true; // Up RGB
            case Qt::Key_Down:         startAction(1, 0); return true; // Down RGB
            case Qt::Key_Left:         startAction(2, 0); return true; // Left RGB
            case Qt::Key_Right:        startAction(3, 0); return true; // Right RGB

            case Qt::Key_7:            startAction(4, 0); return true; // Upper Left RGB
            case Qt::Key_1:            startAction(5, 0); return true; // Lower Left RGB
            case Qt::Key_9:            startAction(6, 0); return true; // Upper Right RGB
            case Qt::Key_3:            startAction(7, 0); return true; // Lower Right RGB

            // Zoom RGB
            case Qt::Key_Q:            startAction(9, 0); return true;  // Zoom +
            case Qt::Key_W:            startAction(10, 0); return true; // Zoom -

            // Zoom IR
            case Qt::Key_E:            startAction(9, 1); return true;  // Zoom +
            case Qt::Key_R:            startAction(10, 1); return true; // Zoom -

            // Focus RGB
            case Qt::Key_A:            startAction(12, 0); return true; // Focus +
            case Qt::Key_S:            startAction(11, 0); return true; // Focus -

            // Focus IR
            case Qt::Key_D:            startAction(12, 1); return true; // Focus +
            case Qt::Key_F:            startAction(11, 1); return true; // Focus -

            default:
                return QObject::eventFilter(obj, event);
        }
    }

    if (event->type() == QEvent::KeyRelease) {
        QKeyEvent *key = static_cast<QKeyEvent*>(event);
        if (key->isAutoRepeat()) return true;

        switch (key->key()) {
            case Qt::Key_Up: case Qt::Key_Down: case Qt::Key_Left: case Qt::Key_Right:
            case Qt::Key_7: case Qt::Key_1: case Qt::Key_9: case Qt::Key_3:
            case Qt::Key_Q: case Qt::Key_W: case Qt::Key_E: case Qt::Key_R:
            case Qt::Key_A: case Qt::Key_S: case Qt::Key_D: case Qt::Key_F:
                stopAction();
                return true;
        }
    }

    return QObject::eventFilter(obj, event);
}














