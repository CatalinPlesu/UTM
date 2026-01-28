using System;
using System.IO;
using MailKit.Net.Imap;
using MailKit.Net.Pop3;
using MailKit.Net.Smtp;
using MailKit.Security;
using MyMail.MailClient;
using MyMail.MailClient.Entities;

namespace MailClient
{
    public class UserConnect
    {
        private Handler _hander;
        private SmtpClient _smtpClient;
        private Pop3Client _pop3Client;
        private ImapClient _imapClient;
        private MailSettings _mailSettings = MailSettings.Instance;
        public UserConnect(User user)
        {
            _mailSettings.SetUser(user);

            _smtpClient = new SmtpClient();
            _pop3Client = new Pop3Client();
            _imapClient = new ImapClient();

            // Create Connect chain
            Handler smtpConnect = new SmtpConnect(_smtpClient);
            Handler pop3Connect = new Pop3Connect(_pop3Client);
            Handler imapConnect = new ImapConnect(_imapClient);

            // Create Login chain
            Handler smtpLogin = new SmtpLogin(_smtpClient);
            Handler pop3Login = new Pop3Login(_pop3Client);
            Handler imapLogin = new ImapLogin(_imapClient);

            // Set chain order for Connect
            smtpConnect.SetNextHandler(smtpLogin);
            smtpLogin.SetNextHandler(pop3Connect);
            pop3Connect.SetNextHandler(pop3Login);
            pop3Login.SetNextHandler(imapConnect);
            imapConnect.SetNextHandler(imapLogin);

            _hander = smtpConnect;
        }

        public Response Check()
        {
            return _hander.HandleRequest();
        }
    }
}