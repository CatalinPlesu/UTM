using System;
using System.Collections.Generic;
using System.IO;
using System.Xml.Linq;
using MailClient;
using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using MyMail.MailClient;
using MyMail.MailClient.Entities;
using Org.BouncyCastle.Tls;

namespace MyMail.MailClient
{
    public static class MySmtpClient
    {
        private static MailSettings _mailSettings = MailSettings.Instance;
            public static Response Send(Mail mail)
        {
            var bodyBuilder = new BodyBuilder();
            bodyBuilder.TextBody = mail.Body;

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(_mailSettings.user.Alias, _mailSettings.user.Email));
            message.To.Add(new MailboxAddress(mail.RecipientName, mail.RecipientEmail));
            message.Subject = mail.Subject;

            // Create a copy of the attachments collection

            var attachments = new List<MimePart>();

            foreach (var item in mail.AttachmentPaths)
            {
                var stream = File.OpenRead(item);
                //using (var stream = model.Attachment.OpenReadStream())

                var mimePart = new MimePart(new MimeKit.ContentType("application", "octet-stream"))
                {
                    Content = new MimeContent(stream),
                    ContentDisposition = new ContentDisposition(ContentDisposition.Attachment),
                    FileName = Path.GetFileName(item)
                };

                attachments.Add(mimePart);
            }
            

            // Add the attachments to the message body
            var multipart = new Multipart("mixed");
            foreach (var attachment in attachments)
            {
                multipart.Add(attachment);
            }
            multipart.Add(bodyBuilder.ToMessageBody());
            message.Body = multipart;

            using (SmtpClient client = new SmtpClient())
            {
                try
                {
                    client.Connect(("smtp." + _mailSettings.server.ServerName), _mailSettings.server.SmtpPort, SecureSocketOptions.StartTls);
                    client.Authenticate(_mailSettings.user.Email, _mailSettings.user.Password);
                    client.Send(message);

           

                    return new Response { Status = true };
                }
                catch (Exception ex)
                {
                    return new Response { Status = true, Message = "Couldn't send mail" };
                }
            }
        }

    }
}