// command.cpp
#include "command.h"
#include <QJsonDocument>
#include <QDebug>

Command::Command(Login *login, QObject *parent)
    : QObject(parent), m_login(login)
{
}

void Command::sendPtz(int channelid, int actionid, int xspeed, int yspeed,
                      int presetid, int owner, int scanspeed,
                      int curisewaittimeminute, int curisewaittimesecond,
                      int curisepresetnum, int curisexstart,
                      int locSpeed, int locHorPos, int locVerPos)
{
    if (m_login->token().isEmpty()) {
        qDebug() << "[ERROR] Token empty. Login first.";
        return;
    }

    QJsonObject param;
    param["token"] = m_login->token();
    param["channelid"] = channelid;
    param["actionid"] = actionid;
    param["ptzxspeed"] = xspeed;
    param["ptzyspeed"] = yspeed;
    param["presetid"] = presetid;
    param["owner"] = owner;
    param["scanspeed"] = scanspeed;
    param["curisewaittimeminute"] = curisewaittimeminute;
    param["curisewaittimesecond"] = curisewaittimesecond;
    param["curisepresetnum"] = curisepresetnum;
    param["curisexstart"] = curisexstart;
    param["locSpeed"] = locSpeed;
    param["locHorPos"] = locHorPos;
    param["locVerPos"] = locVerPos;

    QJsonObject request;
    request["cmd"] = "ptzControl";
    request["param"] = param;

    m_login->sendCommand(request);

    qDebug() << "[PTZ] Action:" << actionid
             << "X speed:" << xspeed << "Y speed:" << yspeed;
}
