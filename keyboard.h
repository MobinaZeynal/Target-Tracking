//#ifndef KEYBOARD_H
//#define KEYBOARD_H

//#include <QObject>
//#include <QTimer>
//#include "command.h" // کلاس Command که sendPtz را دارد

//class Keyboard : public QObject
//{
//    Q_OBJECT
//public:
//    explicit Keyboard(Command *cmd, QObject *parent = nullptr);

//    bool eventFilter(QObject *obj, QEvent *event) override;

//    void setSpeed(int s) { speed = s; }
//    int getSpeed() const { return speed; }

//    void setChannel(int ch) { channel = ch; }
//    int getChannel() const { return channel; }

//private:
//    Command *m_cmd;
//    QTimer *ptzTimer;
//    int speed;
//    int channel = 0;        // کانال دوربین (RGB=0، IR=1)
//    int currentAction = -1; // 0=Up,1=Down,2=Left,3=Right
//};

//#endif // KEYBOARD_H





#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <QObject>
#include <QTimer>
#include "command.h"

class Keyboard : public QObject
{
    Q_OBJECT
public:
    explicit Keyboard(Command *cmd, QObject *parent = nullptr);

    bool eventFilter(QObject *obj, QEvent *event) override;

    void setSpeed(int s) { speed = s; }
    int getSpeed() const { return speed; }

private:
    void startAction(int actionId, int ch);
    void stopAction();

private:
    Command *m_cmd;
    QTimer *ptzTimer;
    int speed;
    int currentActionId = -1;
    int currentChannel = 0;
};

#endif // KEYBOARD_H
