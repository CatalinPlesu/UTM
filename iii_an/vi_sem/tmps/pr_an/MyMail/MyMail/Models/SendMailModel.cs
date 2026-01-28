using System.ComponentModel.DataAnnotations;
using MyMail.MailClient;

namespace MyMail.Models
{
    public class SendMailModel
    {

        [Display(Name = "Recipient Name")]
        public string RecipientName { get; set; }

        [Display(Name = "Recipient Email")]
        public string RecipientEmail { get; set; }

        [Display(Name = "Subject")]
        public string Subject { get; set; }

        public string Body { get; set; }
        public List<IFormFile> Attachment { get; set; }

        public static Mail ToMail(SendMailModel model)
        {
            Mail mail = new Mail()
            {
                RecipientName = model.RecipientName,
                RecipientEmail = model.RecipientEmail,
                Subject = model.Subject,
                Body = model.Body,
                AttachmentPaths = new List<string>()
            };

            foreach (var attachment in model.Attachment)
            {
                string fileName = Path.GetFileName(attachment.FileName);
                string filePath = Path.Combine("D:\\Docs\\UTM Folder\\Anul 3\\TMPS\\Proiect Curs\\MyMail\\temp\\", fileName);

                using (var stream = System.IO.File.Create(filePath))
                {
                    attachment.CopyTo(stream);
                    mail.AttachmentPaths.Add(filePath);
                }

            }
            return mail;
        }
    }
}
