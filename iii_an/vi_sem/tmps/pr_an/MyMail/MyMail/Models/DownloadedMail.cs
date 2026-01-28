using System.ComponentModel.DataAnnotations;
using MyMail.MailClient;

namespace MyMail.Models
{
    public class DownloadedMail
    {
        public int Id { get; set; } 
        public string SenderName { get; set; }
        public string SenderEmail { get; set; }
        public string RecipientName { get; set; }

        public string RecipientEmail { get; set; }

        public string Subject { get; set; }
        public string Body { get; set; }

        public static DownloadedMail FromMail(Mail mail)
        {
            return new DownloadedMail
            {
                Id = mail.Id,
                SenderEmail = mail.SenderEmail,
                SenderName = mail.SenderName,
                Body = mail.Body,
                Subject = mail.Subject
            };
        }
    }
}
