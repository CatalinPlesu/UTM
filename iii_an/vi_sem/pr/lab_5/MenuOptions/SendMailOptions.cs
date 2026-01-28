using System;
using System.Collections.Generic;
using System.IO;
using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;

namespace MailClient
{
    class SendMailOptions
    {
        public static void Execute()
        {
            Console.WriteLine("Enter your name:");
            string senderName = Console.ReadLine();

            Console.WriteLine("Enter the recipient's name:");
            string recipientName = Console.ReadLine();

            Console.WriteLine("Enter the recipient's email address:");
            string recipientEmail = Console.ReadLine();

            Console.WriteLine("Enter the subject:");
            string subject = Console.ReadLine();

            var bodyBuilder = new BodyBuilder();
            Console.WriteLine("Do you want to add text to the body? (y/n)");
            string answer = Console.ReadLine().ToLower();
            while (answer == "y")
            {
                Console.WriteLine("Enter a line of text:");
                string line = Console.ReadLine();
                bodyBuilder.TextBody += line + "\n";
                Console.WriteLine("Do you want to add more text to the body? (y/n)");
                answer = Console.ReadLine().ToLower();
            }

            var attachments = new List<MimePart>(); // Use MimePart instead of Attachment

            Console.WriteLine("Do you want to attach a file? (y/n)");
            answer = Console.ReadLine().ToLower();
            while (answer == "y")
            {
                Console.WriteLine("Enter the path to the file:");
                string filePath = Console.ReadLine();
                if (File.Exists(filePath))
                {
                    // Create the stream here
                    var stream = File.OpenRead(filePath);

                    try
                    {
                        var attachment = new MimePart(new ContentType("application", "octet-stream"))
                        {
                            Content = new MimeContent(stream),
                            ContentDisposition = new ContentDisposition(ContentDisposition.Attachment),
                            FileName = Path.GetFileName(filePath) // Get the file name from the path
                        };
                        attachments.Add(attachment);
                        Console.WriteLine($"Attached file: {filePath}");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error attaching file: {ex.Message}");
                    }
                }
                else
                {
                    Console.WriteLine($"File not found: {filePath}");
                }
                Console.WriteLine("Do you want to attach another file? (y/n)");
                answer = Console.ReadLine().ToLower();
            }

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(senderName, Program.Configuration.Username));
            message.To.Add(new MailboxAddress(recipientName, recipientEmail));
            message.Subject = subject;

            // Add the attachments to the message body
            var multipart = new Multipart("mixed");
            foreach (var attachment in attachments)
            {
                multipart.Add(attachment);
            }
            multipart.Add(bodyBuilder.ToMessageBody());
            message.Body = multipart;

            using (var client = new SmtpClient())
            {
                client.Connect("smtp." + Program.Configuration.ServerName, Program.Configuration.SmtpPort, SecureSocketOptions.StartTls);
                client.Authenticate(Program.Configuration.Username, Program.Configuration.Password);
                try
                {
                    client.Send(message);

                    Console.WriteLine("Message sent successfully!");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error sending message: {ex.Message}");
                }
                client.Disconnect(true);
            }
        }
    }
}