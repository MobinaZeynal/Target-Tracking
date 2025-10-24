#ifndef LOGIN_H
#define LOGIN_H

#include <QObject>
#include <QTcpSocket>
#include <QJsonObject>
#include <QCryptographicHash>
#include <QTimer>

class Login : public QObject
{
    Q_OBJECT
public:
    explicit Login(QObject *parent = nullptr);

    bool connectToCamera(const QString &ip = "192.168.1.64", quint16 port = 39020);

    bool getSalt(const QString &username = "admin");

    bool login(const QString &username = "admin", const QString &password = "Abc.12345");

    bool performLogin(const QString &username = "admin", const QString &password = "Abc.12345");

    void startHeartbeat(int intervalMs = 3000);

    bool sendCommand(const QJsonObject &obj);

    QString token() const { return m_token; }

private:
    QTcpSocket m_socket;
    quint32 m_messageId;
    quint32 crc32(const QByteArray &data);
    QByteArray buildMessage(quint32 msgType, const QByteArray &jsonData);
    void sendJson(const QJsonObject &obj);
    QJsonObject readJsonResponse(int timeoutMs = 5000);

    QString m_salt;
    int m_loginEncAlgorithm;
    QString m_token;
    QTimer *m_heartbeatTimer;
};

#endif // LOGIN_H
