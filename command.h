// command.h
#pragma once
#include <QObject>
#include <QJsonObject>
#include "login.h"

class Command : public QObject {
    Q_OBJECT
public:
    explicit Command(Login *login, QObject *parent = nullptr);

    void sendPtz(int channelid, int actionid, int xspeed = 0, int yspeed = 0,
                 int presetid = 0, int owner = 0, int scanspeed = 0,
                 int curisewaittimeminute = 0, int curisewaittimesecond = 0,
                 int curisepresetnum = 0, int curisexstart = 0,
                 int locSpeed = 0, int locHorPos = 0, int locVerPos = 0);

private:
    Login *m_login;
};
