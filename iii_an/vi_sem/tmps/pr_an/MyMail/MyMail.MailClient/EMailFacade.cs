using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MailClient;
using MailKit.Net.Imap;
using MailKit.Net.Pop3;
using MailKit.Net.Smtp;
using MyMail.MailClient.Entities;

namespace MyMail.MailClient
{
    public class EmailFacade
    {
        private IMailClientStrategy _mailClientStrategy;
        private GMailClient _pop3GClient;
        private GMailClient _imapGClient;

        public EmailFacade()
        {
            var factory = new MailClientFactory();
            var pop3Client = factory.CreateMailClient(new Pop3Client());
            var imapClient = factory.CreateMailClient(new ImapClient());

            _pop3GClient = pop3Client;
            _imapGClient = imapClient;

            if (_pop3GClient != null)
            {
                _mailClientStrategy = new POP3MailClientStrategy(_pop3GClient);
            }
            else
            {
                _mailClientStrategy = new IMAPMailClientStrategy(_imapGClient);
            }
    
        }

        public Response Connect(Server server)
        {
            var serverConnect = new ServerConnect(server);
            return serverConnect.Check();
        }

        public Response Authenticate(User user)
        {
            var userConnect = new UserConnect(user);
            return userConnect.Check();
        }

        public Response Send(Mail mail)
        {
            return MySmtpClient.Send(mail);
        }

        public void SetMailRetrievalProtocol(Protocol protocol)
        {
            if (protocol == Protocol.Pop3)
            {
                _mailClientStrategy = new POP3MailClientStrategy(_pop3GClient);
            }
            else
            {
                _mailClientStrategy = new IMAPMailClientStrategy(_imapGClient);
            }
        }

        public List<Mail> GetMailPage(int page, int pageSize)
        {
            return _mailClientStrategy.GetMailPage(page, pageSize);
        }

        public Mail GetMail(int id)
        {
            return _mailClientStrategy.GetMail(id);
        }

        public Response DownloadMail(int id)
        {
            return _mailClientStrategy.DownloadMail(id);
        }
    }

}
