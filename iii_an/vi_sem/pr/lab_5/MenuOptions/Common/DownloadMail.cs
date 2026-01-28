using System;
using System.IO;
using System.Linq;
using System.Text;
using MailKit;
using MailKit.Net.Imap;
using MailKit.Net.Pop3;
using MailKit.Security;
using MimeKit;

namespace MailClient
{
    class DownloadMail
    {
        public static void Run(object client, int mailNumber)
        {
            Console.WriteLine("download started");

            MimeMessage message;

            if (client is ImapClient)
            {
                message = ((ImapClient)client).Inbox.GetMessage(mailNumber);
            }
            else if (client is Pop3Client)
            {
                message = ((Pop3Client)client).GetMessage(mailNumber);
            }
            else
            {
                throw new ArgumentException("Invalid email client type");
            }

            var messageText = GetMailText.Run(message);

            var senderAddress = message.From.Mailboxes.FirstOrDefault()?.Address ?? "unknown";
            var directoryPath = Path.Combine(Environment.CurrentDirectory, "Downloads", senderAddress);
            Directory.CreateDirectory(directoryPath);

            var textFileName = $"{message.Subject}.txt";
            var textFilePath = Path.Combine(directoryPath, textFileName);
            using (var stream = System.IO.File.CreateText(textFilePath))
            {
                stream.Write(messageText);
            }

            foreach (var attachment in message.Attachments)
            {
                var fileName = attachment.ContentDisposition?.FileName ?? attachment.ContentType.Name;
                var filePath = Path.Combine(directoryPath, fileName);

                using (var stream = File.Create(filePath))
                {
                    if (attachment is MessagePart)
                    {
                        var part = (MessagePart)attachment;
                        part.Message.WriteTo(stream);
                    }
                    else
                    {
                        var part = (MimePart)attachment;
                        part.Content.DecodeTo(stream);
                    }
                }

                Console.WriteLine($"Attachment '{fileName}' downloaded to '{directoryPath}'.");
            }

            Console.WriteLine("Download Finished");
            Console.WriteLine("Press any key to continue...");
            Console.ReadKey();
        }
    }
}
