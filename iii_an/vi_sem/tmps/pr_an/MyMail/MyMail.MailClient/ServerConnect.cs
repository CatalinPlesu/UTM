using System;
using System.IO;
using System.Reflection.Metadata;
using MailKit.Net.Imap;
using MailKit.Net.Pop3;
using MailKit.Net.Smtp;
using MailKit.Security;
using MyMail.MailClient;
using MyMail.MailClient.Entities;

namespace MailClient
{
    public class ServerConnect
    {
        private Handler _hander;
        private SmtpClient _smtpClient;
        private Pop3Client _pop3Client;
        private ImapClient _imapClient;
        private MailSettings _mailSettings = MailSettings.Instance;
        public ServerConnect(Server server)
        {
            _mailSettings.SetServer(server);

            _smtpClient = new SmtpClient();
            _pop3Client = new Pop3Client();
            _imapClient = new ImapClient();

            // Create Connect chain
            Handler smtpConnect = new SmtpConnect(_smtpClient);
            Handler pop3Connect = new Pop3Connect(_pop3Client);
            Handler imapConnect = new ImapConnect(_imapClient);

            // Set chain order
            smtpConnect.SetNextHandler(pop3Connect);
            pop3Connect.SetNextHandler(imapConnect);

            _hander = smtpConnect;
        }

        public Response Check()
        {
            return _hander.HandleRequest();
        }
    }
}

