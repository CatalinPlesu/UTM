using System;
using System.Text;
using MailKit.Net.Pop3;
using MimeKit;
using MailKit.Net.Smtp;
using MailKit.Security;
using MailKit;

namespace MailClient
{
    class Pop3Options
    {
        public static void Execute()
        {
            const int page_size = 10;

            using (var client = new Pop3Client())
            {
                try
                {
                    client.Connect("pop." + Program.Configuration.ServerName, Program.Configuration.Pop3Port, true);
                    client.Authenticate(Program.Configuration.Username, Program.Configuration.Password);

                    int messageCount = client.GetMessageCount();
                    int start = Math.Max(0, messageCount - page_size);

                    while (true)
                    {
                        Console.Clear();
                        Console.WriteLine("Recent messages:");
                        for (int i = messageCount - 1; i >= start; i--)
                        {
                            var message = client.GetMessage(i);
                            Console.WriteLine("[{0}] {1} [{2}]", i, message.Subject, message.Date.ToString("dd.MM.yyyy HH:mm:ss"));
                        }

                        Console.WriteLine("\nMenu options:");
                        Console.WriteLine("d - download");
                        Console.WriteLine("o - open");
                        Console.WriteLine("r - reply");
                        Console.WriteLine("n - next 10 items");
                        Console.WriteLine("q - quit");

                        Console.Write("\nOption: ");
                        string option = Console.ReadLine();
                        if (option.ToLower() == "q")
                        {
                            break;
                        }
                        else if (option.ToLower() == "d" || option.ToLower() == "o" || option.ToLower() == "r")
                        {
                            Console.Write("Mail number: ");
                            int mailNumber;
                            if (int.TryParse(Console.ReadLine(), out mailNumber) && mailNumber >= start && mailNumber < messageCount)
                            {
                                var message = client.GetMessage(mailNumber);

                                switch (option.ToLower())
                                {
                                    case "d":
                                        Console.WriteLine("Downloading...");
                                        DownloadMail.Run(client, mailNumber);
                                        break;
                                    case "o":
                                        Console.WriteLine("Opening...");
                                        OpenMail.Run(client, mailNumber);
                                        break;
                                    case "r":
                                        Console.WriteLine("Replying...");
                                        ReplyToEmail.Run(client, mailNumber);
                                        break;
                                }
                            }
                            else
                            {
                                Console.WriteLine("Invalid mail number.");
                            }
                        }
                        else if (option.ToLower() == "n")
                        {
                            start = Math.Max(0, start - page_size);
                            messageCount = Math.Max(0, messageCount - page_size);
                            continue;
                        }
                        else
                        {
                            Console.WriteLine("Invalid option.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error retrieving messages: {0}", ex.Message);
                }
                finally
                {
                    client.Disconnect(true);
                }
            }
        }

        
        private static void OpenMailx(Pop3Client client, int mailNumber)
        {
            var message = client.GetMessage(mailNumber);

            var messageText = GetMailText.Run(message);
            Console.WriteLine(messageText);

            // Set the current working directory as the POP3 folder
            var pop3Folder = Path.Combine(Environment.CurrentDirectory, "POP3");
            Directory.CreateDirectory(pop3Folder);

            // Save any attachments
            foreach (var attachment in message.Attachments)
            {
                var fileName = attachment.ContentDisposition?.FileName ?? attachment.ContentType.Name;
                var filePath = Path.Combine(pop3Folder, fileName);
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

                Console.WriteLine($"Attachment Downloaded: {fileName} (Location: {filePath})");
            }

            Console.WriteLine("Press any key to continue...");
            Console.ReadKey(true);
        }

        public static string GetMailTextx(MimeMessage message)
        {
            var builder = new StringBuilder();
            
            builder.AppendLine($"From: {message.From}");
            builder.AppendLine($"To: {message.To}");
            builder.AppendLine($"Cc: {message.Cc}");
            builder.AppendLine($"Subject: {message.Subject}");

            builder.AppendLine($"Text: {message.TextBody}");
            
            // Save any attachments
            foreach (var attachment in message.Attachments)
            {
                var fileName = attachment.ContentDisposition?.FileName ?? attachment.ContentType.Name;
                var attachmentText = $"Attachment: {fileName} (Size: {attachment.ContentDisposition?.Size ?? 0})";
                builder.AppendLine(attachmentText);
            }
            
            return builder.ToString();
        }

        public static void ReplyToEmailx(Pop3Client pop_client, int mailNumber)
        {
            var message = pop_client.GetMessage(mailNumber);
            Console.Clear();
            // Connect to the email server
            using (var client = new SmtpClient())
            {
                client.Connect("smtp." + Program.Configuration.ServerName, Program.Configuration.SmtpPort, SecureSocketOptions.StartTls);
                client.Authenticate(Program.Configuration.Username, Program.Configuration.Password);

                // Extract the recipient email address from the original message
                var recipient = message.To.Mailboxes.FirstOrDefault();
                if (recipient == null)
                {
                    Console.WriteLine("Could not find recipient email address in the original message.");
                    return;
                }
                string recipientName = recipient.Name;
                string recipientEmail = recipient.Address;

                // Extract the sender email address from the original message
                var sender = message.From.Mailboxes.FirstOrDefault();
                if (sender == null)
                {
                    Console.WriteLine("Could not find sender email address in the original message.");
                    return;
                }
                string senderName = sender.Name;
                string senderEmail = sender.Address;

                // Create a new email message in reply to the original message
                var replyMessage = new MimeMessage();
                replyMessage.From.Add(new MailboxAddress(recipientName, Program.Configuration.Username));
                replyMessage.To.Add(new MailboxAddress(senderName, senderEmail));
                replyMessage.Subject = $"Re: {message.Subject}";
                replyMessage.InReplyTo = message.MessageId;

                // Prompt the user for the reply message body
                Console.WriteLine("Enter your reply:");
                var body = Console.ReadLine();

                // Add the reply message body to the email message
                var builder = new BodyBuilder();
                builder.TextBody = body;
                replyMessage.Body = builder.ToMessageBody();

                // Send the email message
                client.Send(replyMessage);
                Console.WriteLine("Reply sent.");
            }
        }


    }
}
