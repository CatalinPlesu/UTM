using System;
using MailClient;
using MailKit.Net.Imap;
using MailKit.Net.Pop3;
using MailKit.Net.Smtp;
using MailKit.Security;
using MyMail.MailClient.Entities;

namespace MyMail.MailClient
{
    // Abstract base class for handlers
    public abstract class Handler
    {
        protected Handler _nextHandler;
        protected object _client;
        private static MailSettings _mailSettings = MailSettings.Instance;

        public Handler(object client)
        {
            _client = client;
        }

        public void SetNextHandler(Handler nextHandler)
        {
            _nextHandler = nextHandler;
        }

        public abstract Response HandleRequest();
    }

    // Concrete SMTP handler
    public class SmtpConnect : Handler
    {
        private static MailSettings _mailSettings = MailSettings.Instance;
        public SmtpConnect(object client) : base(client)
        {
        }

        public override Response HandleRequest()
        {
            if (_client is SmtpClient smtp)
            {
                try
                {
                    // Perform SMTP logic here
                    smtp.Connect("smtp." + _mailSettings.server.ServerName, _mailSettings.server.SmtpPort, SecureSocketOptions.StartTls);
                    // If SMTP logic succeeds, pass the request to the next handler
                    if (_nextHandler != null)
                        return _nextHandler.HandleRequest();
                    else
                        return new Response { Status = true };
                }
                catch (Exception ex)
                {
                    // If SMTP logic fails, return failure response
                    return new Response { Status = false, Message = "SMTP connection failed" };
                }
            }
            else
            {
                // If the object type is not SmtpClient, continue to the next handler
                if (_nextHandler != null)
                    return _nextHandler.HandleRequest();
                else
                    return new Response { Status = true };
            }
        }
    }

    // Concrete POP3 handler
    public class Pop3Connect : Handler
    {
        private static MailSettings _mailSettings = MailSettings.Instance;
        public Pop3Connect(object client) : base(client)
        {
        }

        public override Response HandleRequest()
        {
            if (_client is Pop3Client pop3)
            {
                try
                {
                    // Perform POP3 logic here
                    pop3.Connect("pop." + _mailSettings.server.ServerName, _mailSettings.server.Pop3Port, SecureSocketOptions.Auto);
                    // If POP3 logic succeeds, pass the request to the next handler
                    if (_nextHandler != null)
                        return _nextHandler.HandleRequest();
                    else
                        return new Response { Status = true };
                }
                catch (Exception ex)
                {
                    // If POP3 logic fails, return failure response
                    return new Response { Status = false, Message = "POP3 connection failed" };
                }
            }
            else
            {
                // If the object type is not Pop3Client, continue to the next handler
                if (_nextHandler != null)
                    return _nextHandler.HandleRequest();
                else
                    return new Response { Status = true };
            }
        }
    }

    // Concrete IMAP handler
    public class ImapConnect : Handler
    {
        private static MailSettings _mailSettings = MailSettings.Instance;
        public ImapConnect(object client) : base(client)
        {
        }

        public override Response HandleRequest()
        {
            if (_client is ImapClient imap)
            {
                try
                {
                    // Perform IMAP logic here
                    imap.Connect("imap." + _mailSettings.server.ServerName, _mailSettings.server.ImapPort, SecureSocketOptions.SslOnConnect);
                    // If IMAP logic succeeds, pass the request to the next handler
                    if (_nextHandler != null)
                        return _nextHandler.HandleRequest();
                    else
                        return new Response { Status = true };
                }
                catch (Exception ex)
                {
                    // If IMAP logic fails, return failure response
                    return new Response { Status = false, Message = "IMAP connection failed" };
                }
            }
            else
            {
                // If the object type is not ImapClient, continue to the next handler
                if (_nextHandler != null)
                    return _nextHandler.HandleRequest();
                else
                    return new Response { Status = true };
            }
        }
    }

    // Concrete SMTP handler
    public class SmtpLogin : Handler
    {
        private static MailSettings _mailSettings = MailSettings.Instance;
        public SmtpLogin(object client) : base(client)
        {
        }

        public override Response HandleRequest()
        {
            if (_client is SmtpClient smtp)
            {
                try
                {
                    // Perform SMTP logic here
                    smtp.Authenticate(_mailSettings.user.Email, _mailSettings.user.Password);
                    // If SMTP logic succeeds, pass the request to the next handler
                    if (_nextHandler != null)
                        return _nextHandler.HandleRequest();
                    else
                        return new Response { Status = true };
                }
                catch (Exception ex)
                {
                    // If SMTP logic fails, return failure response
                    return new Response { Status = false, Message = "SMTP login failed"};
                }
            }
            else
            {
                // If the object type is not SmtpClient, continue to the next handler
                if (_nextHandler != null)
                    return _nextHandler.HandleRequest();
                else
                    return new Response { Status = true };
            }
        }
    }

    // Concrete POP3 handler
    public class Pop3Login : Handler
    {
        private static MailSettings _mailSettings = MailSettings.Instance;
        public Pop3Login(object client) : base(client)
        {
        }

        public override Response HandleRequest()
        {
            if (_client is Pop3Client pop3)
            {
                try
                {
                    // Perform POP3 logic here
                    pop3.Authenticate(_mailSettings.user.Email, _mailSettings.user.Password);
                    // If POP3 logic succeeds, pass the request to the next handler
                    if (_nextHandler != null)
                        return _nextHandler.HandleRequest();
                    else
                        return new Response { Status = true };
                }
                catch (Exception ex)
                {
                    // If POP3 logic fails, return failure response
                    return new Response { Status = false, Message = "POP3 login failed"};
                }
            }
            else
            {
                // If the object type is not Pop3Client, continue to the next handler
                if (_nextHandler != null)
                    return _nextHandler.HandleRequest();
                else
                    return new Response { Status = true };
            }
        }
    }

    // Concrete IMAP handler
    public class ImapLogin : Handler
    {
        private static MailSettings _mailSettings = MailSettings.Instance;
        public ImapLogin(object client) : base(client)
        {
        }

        public override Response HandleRequest()
        {
            if (_client is ImapClient imap)
            {
                try
                {
                    // Perform IMAP logic here
                    imap.Authenticate(_mailSettings.user.Email, _mailSettings.user.Password);
                    // If IMAP logic succeeds, pass the request to the next handler
                    if (_nextHandler != null)
                        return _nextHandler.HandleRequest();
                    else
                        return new Response { Status = true };
                }
                catch (Exception ex)
                {
                    // If IMAP logic fails, return failure response
                    return new Response { Status = false, Message = "IMAP login failed"};
                }
            }
            else
            {
                // If the object type is not ImapClient, continue to the next handler
                if (_nextHandler != null)
                    return _nextHandler.HandleRequest();
                else
                    return new Response { Status = true };
            }
        }
    }
}
