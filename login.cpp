#include "login.h"
#include <QDataStream>
#include <QJsonDocument>
#include <QDebug>

Login::Login(QObject *parent)
    : QObject(parent), m_messageId(0), m_loginEncAlgorithm(0)
{
    m_heartbeatTimer = new QTimer(this);
    connect(m_heartbeatTimer, &QTimer::timeout, [this]() {
        if (!m_token.isEmpty()) {
            QJsonObject obj;
            obj.insert("cmd", "userOnlineHeart");
            QJsonObject param;
            param.insert("token", m_token);
            obj.insert("param", param);
            sendJson(obj);
            qDebug() << "[INFO] Heartbeat sent";
        }
    });
}

bool Login::connectToCamera(const QString &ip, quint16 port)
{
    qDebug() << "[INFO] Connecting to camera at" << ip << ":" << port;
    m_socket.connectToHost(ip, port);
    if (!m_socket.waitForConnected(5000)) {
        qDebug() << "[FAIL] Connection failed!";
        return false;
    }
    qDebug() << "[INFO] Connected to camera";
    return true;
}

quint32 Login::crc32(const QByteArray &data)
{
    quint32 crc = 0xFFFFFFFF;
    for (uchar b : data) {
        crc ^= b;
        for (int i = 0; i < 8; i++)
            crc = (crc >> 1) ^ (0xEDB88320 * (crc & 1));
    }
    return crc ^ 0xFFFFFFFF;
}

QByteArray Login::buildMessage(quint32 msgType, const QByteArray &jsonData)
{
    m_messageId++;
    QByteArray packet;
    QDataStream stream(&packet, QIODevice::WriteOnly);
    stream.setByteOrder(QDataStream::LittleEndian);

    stream << (quint32)0xA5A5A5A5;
    stream << m_messageId;
    stream << (quint8)msgType;
    stream << (quint8)0x00;
    stream << (quint16)0x0000;
    stream << (quint32)jsonData.size();

    packet.append(jsonData);

    quint32 crc = crc32(packet);
    packet.append(reinterpret_cast<const char*>(&crc), sizeof(crc));

    return packet;
}


void Login::sendJson(const QJsonObject &obj)
{
    QJsonDocument doc(obj);
    QByteArray jsonBytes = doc.toJson(QJsonDocument::Compact);
    QByteArray msg = buildMessage(1, jsonBytes);

    m_socket.write(msg);
    m_socket.flush();
}

QJsonObject Login::readJsonResponse(int timeoutMs)
{
    QByteArray data;
    int waited = 0;
    const int step = 50; // هر بار 50ms صبر می‌کنیم
    while (waited < timeoutMs) {
        if (m_socket.waitForReadyRead(step)) {
            data.append(m_socket.readAll());
            if (data.size() >= 16) {
                quint32 jsonLen;
                memcpy(&jsonLen, data.data() + 12, 4);
                if (data.size() >= 16 + (int)jsonLen) {
                    QByteArray jsonBytes = data.mid(16, jsonLen);
                    QJsonDocument doc = QJsonDocument::fromJson(jsonBytes);
                    return doc.object();
                }
            }
        }
        waited += step;
    }
    qDebug() << "[FAIL] No complete response from camera!";
    return {};
}



bool Login::getSalt(const QString &username)
{
    QJsonObject param;
    param.insert("username", username);

    QJsonObject obj;
    obj.insert("cmd", "userSaltGet");
    obj.insert("param", param);

    sendJson(obj);

    QJsonObject resp = readJsonResponse();
    if (!resp.contains("param")) {
        qDebug() << "[FAIL] Failed to get salt!";
        return false;
    }

    QJsonObject p = resp["param"].toObject();
    m_salt = p["salt"].toString();
    m_loginEncAlgorithm = p["loginEnc"].toInt();
    qDebug() << "[INFO] Salt received:" << m_salt << "Algorithm:" << m_loginEncAlgorithm;
    return true;
}

bool Login::login(const QString &username, const QString &password)
{
    QByteArray hash;
    if (m_loginEncAlgorithm == 0) {
        hash = QCryptographicHash::hash((password + m_salt).toUtf8(), QCryptographicHash::Md5).toHex();
    } else {
        qDebug() << "[FAIL] Unknown encryption algorithm!";
        return false;
    }

    QJsonObject loginParam;
    loginParam.insert("username", username);
    loginParam.insert("password", QString(hash));

    QJsonObject loginObj;
    loginObj.insert("cmd", "userLogin");
    loginObj.insert("param", loginParam);

    sendJson(loginObj);

    QJsonObject resp = readJsonResponse();
    if (!resp.contains("param")) {
        qDebug() << "[FAIL] Login response invalid!";
        return false;
    }

    QJsonObject param = resp["param"].toObject();
    if (param["ackvalue"].toInt() == 100) {
        m_token = param["token"].toString();
        qDebug() << "[SUCCESS] Login successful! Token:" << m_token;
        return true;
    }

    qDebug() << "[FAIL] Login failed! Ack:" << param["ackvalue"].toInt();
    return false;
}

bool Login::performLogin(const QString &username, const QString &password)
{
    if (!connectToCamera()) return false;
    if (!getSalt(username)) return false;
    if (!login(username, password)) return false;
    startHeartbeat();
    return true;
}

void Login::startHeartbeat(int intervalMs)
{
    m_heartbeatTimer->start(intervalMs);
}

bool Login::sendCommand(const QJsonObject &obj)
{
    if (!m_socket.isOpen()) return false;
    sendJson(obj);
    return true;
}
