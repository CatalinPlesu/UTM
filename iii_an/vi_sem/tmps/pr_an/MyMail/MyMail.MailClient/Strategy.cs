using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MyMail.MailClient.Entities;

namespace MyMail.MailClient
{
    public interface IMailClientStrategy
    {
        List<Mail> GetMailPage(int page, int pageSize);
        Mail GetMail(int id);
        Response DownloadMail(int id);
    }

    public class POP3MailClientStrategy : IMailClientStrategy
    {
        private GMailClient _client;

        public POP3MailClientStrategy(GMailClient client)
        {
            _client = client;
        }

        public List<Mail> GetMailPage(int page, int pageSize)
        {
            return _client.GetMailPage(page, pageSize);
        }

        public Mail GetMail(int id)
        {
            return _client.GetMail(id);
        }

        public Response DownloadMail(int id)
        {
            return _client.DownloadMail(id);
        }
    }

    public class IMAPMailClientStrategy : IMailClientStrategy
    {
        private GMailClient _client;

        public IMAPMailClientStrategy(GMailClient client)
        {
            _client = client;
        }

        public List<Mail> GetMailPage(int page, int pageSize)
        {
            return _client.GetMailPage(page, pageSize);
        }

        public Mail GetMail(int id)
        {
            return _client.GetMail(id);
        }

        public Response DownloadMail(int id)
        {
            return _client.DownloadMail(id);
        }
    }

}
