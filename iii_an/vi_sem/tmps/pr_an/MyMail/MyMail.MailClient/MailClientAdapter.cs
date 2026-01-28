using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MailClient;
using MailKit;
using MailKit.Net.Imap;
using MailKit.Net.Pop3;
using MailKit.Security;
using MimeKit;
using MyMail.MailClient.Entities;

namespace MyMail.MailClient
{
    public interface IMailClient
    {
        Response Connect();
        Response Authenticate();
        int GetMessageCount();
        MimeMessage GetMessage(int id);
        Response Disconnect();

    }

    public class ImapClientAdapter : IMailClient
    {
        private ImapClient _client;
        private static MailSettings _mailSettings = MailSettings.Instance;
        public ImapClientAdapter(ImapClient client)
        {
            _client = client;
        }

        public Response Connect()
        {
            try
            {
                _client.Connect("imap." + _mailSettings.server.ServerName, _mailSettings.server.ImapPort, SecureSocketOptions.SslOnConnect);
                return new Response { Status = true};
            }
            catch(Exception ex)
            {
                return new Response { Status = false, Message = "Imap connection failed" };
            }
        }
        public Response Authenticate()
        {
            try
            {
                _client.Authenticate(_mailSettings.user.Email, _mailSettings.user.Password);
                return new Response { Status = true };
            }
            catch (Exception ex)
            {
                return new Response { Status = false, Message = "Imap authentification failed" };
            }
        }
        public int GetMessageCount()
        {
            _client.Inbox.Open(FolderAccess.ReadOnly);
            return _client.Inbox.Count;
        }
        public MimeMessage GetMessage(int id)
        {
            try
            {
                _client.Inbox.Open(FolderAccess.ReadOnly);
                return _client.Inbox.GetMessage(id);
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public Response Disconnect()
        {
            try
            {
                _client.Disconnect(true);
                return new Response { Status = true };
            }
            catch (Exception ex)
            {
                _client.Authenticate(_mailSettings.user.Email, _mailSettings.user.Password);
                return new Response { Status = false, Message = "Imap disconnection failed" };
            }
        }
    }

    public class Pop3ClientAdapter : IMailClient
    {
        private Pop3Client _client;
        private static MailSettings _mailSettings = MailSettings.Instance;
        public Pop3ClientAdapter(Pop3Client client)
        {
            _client = client;
        }

        public Response Connect()
        {
            try
            {
                _client.Connect("pop." + _mailSettings.server.ServerName, _mailSettings.server.Pop3Port, true);
                return new Response { Status = true };
            }
            catch (Exception ex)
            {
                return new Response { Status = false, Message = "Pop3 connection failed" };
            }
        }
        public Response Authenticate()
        {
            try
            {
                _client.Authenticate(_mailSettings.user.Email, _mailSettings.user.Password);
                return new Response { Status = true };
            }
            catch (Exception ex)
            {
                return new Response { Status = false, Message = "Pop3 authentification failed" };
            }
        }
        public int GetMessageCount()
        {
            return _client.GetMessageCount();
        }
        public MimeMessage GetMessage(int id)
        {
            try
            {
                return _client.GetMessage(id);
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public Response Disconnect()
        {
            try
            {
                _client.Disconnect(true);
                return new Response { Status = true };
            }
            catch (Exception ex)
            {
                _client.Authenticate(_mailSettings.user.Email, _mailSettings.user.Password);
                return new Response { Status = false, Message = "Pop3 disconnection failed" };
            }
        }
    }
}
