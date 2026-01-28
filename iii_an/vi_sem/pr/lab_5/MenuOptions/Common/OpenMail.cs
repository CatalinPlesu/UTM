using System;
using System.IO;
using System.Text;
using MailKit;
using MailKit.Net.Imap;
using MailKit.Net.Pop3;
using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using System.Diagnostics;

namespace MailClient
{
    class OpenMail
    {
        public static void Run(object client, int mailNumber)
        {
            var isImap = client is ImapClient;

            MimeMessage message;

            if (isImap)
            {
                message = ((ImapClient)client).Inbox.GetMessage(mailNumber);
            }
            else
            {
                message = ((Pop3Client)client).GetMessage(mailNumber);
            }

            var messageText = GetMailText.Run(message);
            Console.WriteLine(messageText);

            // Set the current working directory as the email client folder
            var clientFolder = Path.Combine(Environment.CurrentDirectory, isImap ? "IMAP" : "POP3");
            Directory.CreateDirectory(clientFolder);

            // Save any attachments
            var attachments = message.Attachments.ToList();
            for (int i = 0; i < attachments.Count; i++)
            {
                var attachment = attachments[i];
                var fileName = attachment.ContentDisposition?.FileName ?? attachment.ContentType.Name;
                var filePath = Path.Combine(clientFolder, fileName);
                using (var stream = System.IO.File.Create(filePath))
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

                Console.WriteLine($"Attachment Downloaded: [{i}] {fileName} (Location: {filePath})");
            }

            // Ask user if they want to open an attachment
            while (true && message.Attachments.Count() != 0)
            {
                Console.Write("Do you want to open an attachment? (Y/N): ");
                var answer = Console.ReadKey(true).KeyChar;

                if (answer == 'N' || answer == 'n')
                {
                    break;
                }

                if (answer != 'Y' && answer != 'y')
                {
                    continue;
                }

                Console.Write("Enter the number of the attachment to open: ");
                int attachmentNumber;
                while (!int.TryParse(Console.ReadLine(), out attachmentNumber) ||
                    attachmentNumber < 0 || attachmentNumber >= attachments.Count)
                {
                    Console.Write($"Invalid attachment number. Enter a number between 0 and {attachments.Count - 1}: ");
                }

                var attachment = attachments[attachmentNumber];
                var fileName = attachment.ContentDisposition?.FileName ?? attachment.ContentType.Name;
                var filePath = Path.Combine(clientFolder, fileName);
                Process.Start(new ProcessStartInfo()
                {
                    FileName = filePath,
                    UseShellExecute = true
                });
            }

            Console.WriteLine("Press any key to continue...");
            Console.ReadKey(true);
        }

    }
}
