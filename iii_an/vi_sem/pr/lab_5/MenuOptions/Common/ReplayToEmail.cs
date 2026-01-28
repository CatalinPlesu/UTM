using System;
using System.IO;
using System.Text;
using MailKit;
using MailKit.Net.Imap;
using MailKit.Net.Pop3;
using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;

namespace MailClient
{
    class ReplyToEmail
    {
        public static void Run(object client, int mailNumber)
        {
            var isImap = client is ImapClient;

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
            Console.Clear();
            // Connect to the email server
            using (var smtpClient = new SmtpClient())
            {
                smtpClient.Connect("smtp." + Program.Configuration.ServerName, Program.Configuration.SmtpPort, SecureSocketOptions.StartTls);
                smtpClient.Authenticate(Program.Configuration.Username, Program.Configuration.Password);

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
                smtpClient.Send(replyMessage);
                Console.WriteLine("Reply sent.");
            }
        }

    }
}
