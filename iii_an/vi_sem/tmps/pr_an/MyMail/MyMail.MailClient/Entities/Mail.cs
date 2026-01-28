using MimeKit;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace MyMail.MailClient
{
    public class Mail
    {
        public int Id { get; set; }
        public string SenderName { get; set; }
        public string SenderEmail { get; set; }

        public string RecipientName { get; set; }

        public string RecipientEmail { get; set; }

        public string Subject { get; set; }
        public string Body { get; set; }

        public List<string> AttachmentPaths { get; set; }
        public List<MimePart> AttachmenMime { get; set; }

        public static Mail FromMimeMessage(MimeMessage message)
        {
            return new Mail
            {
                SenderName = message.From.FirstOrDefault()?.Name,
                SenderEmail = message.From.FirstOrDefault()?.ToString(),
                RecipientName = message.To.FirstOrDefault()?.Name,
                RecipientEmail = message.To.FirstOrDefault()?.ToString(),
                Subject = message.Subject,
                Body = message.TextBody,
                AttachmenMime = message.Attachments.OfType<MimePart>().ToList()
            };
        }
    }

    public enum Protocol
    {
        Smtp,
        Pop3,
        Imap
    }
}