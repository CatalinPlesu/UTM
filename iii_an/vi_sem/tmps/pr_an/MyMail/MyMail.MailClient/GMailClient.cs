using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MimeKit;
using MyMail.MailClient.Entities;

namespace MyMail.MailClient
{
    public class GMailClient
    {
        private IMailClient _client;
        private int finish;
        private List<MimeMessage> _mails;

        public GMailClient(IMailClient client)
        { 
            _mails = new List<MimeMessage>();
            _client = client;
            finish = -1;
        }

        private List<Mail> GetNextMails(int count)
        {
            _client.Connect();
            _client.Authenticate();
            
            if (finish < 0) 
            {
                finish = _client.GetMessageCount();
            }
            int start = finish - count;

            var mails = new List<Mail>();

            for (int i = finish; i >= start; i--)
            {
                var message = _client.GetMessage(i-1);
                var mail = Mail.FromMimeMessage(message);
                mail.Id = _mails.Count;
                mails.Add(mail);
                _mails.Add(message);
            }
            _client.Disconnect();

            finish = start;
            return mails;
        }

        public List<Mail> GetMailPage(int page, int pageSize)
        {
            int requiredMailsCount = (page - 1) * pageSize + pageSize;
            int availableMailsCount = _mails.Count;

            if(requiredMailsCount > availableMailsCount)
            {
                int neededMails = requiredMailsCount - availableMailsCount;
                GetNextMails(neededMails);
            }

            var mails = new List<Mail>();

            for (int i = (page - 1) * pageSize; i < requiredMailsCount; i++)
            {
                mails.Add(Mail.FromMimeMessage(_mails[i]));
            }
            
            return mails;
        }


        public Mail GetMail(int id)
        {
            var message = _mails[id];
            return Mail.FromMimeMessage(message);
        }

        public Response DownloadMail(int id)
        {
            try
            {
                var message = _mails[id];

                var senderEmail = message.From.FirstOrDefault()?.ToString();
                var subject = message.Subject;

                var sanitizedSender = SanitizeFileName(senderEmail);
                var sanitizedSubject = SanitizeFileName(subject);

                var folderPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments),
                    "DownloadedMails", $"({sanitizedSender})[{sanitizedSubject}]");

                Directory.CreateDirectory(folderPath);

                var savePath = Path.Combine(folderPath, $"{sanitizedSubject}.eml");

                using (var stream = File.Create(savePath))
                {
                    message.WriteTo(stream);
                }

                var attachmentsFolder = Path.Combine(folderPath, "Attachments");
                Directory.CreateDirectory(attachmentsFolder);

                foreach (var attachment in message.Attachments)
                {
                    var attachmentFileName = SanitizeFileName(attachment.ContentDisposition?.FileName ?? attachment.ContentType.Name);
                    var attachmentSavePath = Path.Combine(attachmentsFolder, attachmentFileName);

                    using (var stream = File.Create(attachmentSavePath))
                    {
                        if (attachment is MimePart mimePart)
                            mimePart.Content.DecodeTo(stream);
                    }
                }
                return new Response { Status = true };
            }
            catch
            (Exception ex)
            {
                return new Response { Status = false, Message = "Couldn't download mail" };
            }
        }
        private static string SanitizeFileName(string fileName)
        {
            var invalidChars = new string(Path.GetInvalidFileNameChars()) + new string(Path.GetInvalidPathChars());
            var sanitizedFileName = string.Join("_", fileName.Split(invalidChars.ToCharArray()));
            return sanitizedFileName;
        }
    }
}
