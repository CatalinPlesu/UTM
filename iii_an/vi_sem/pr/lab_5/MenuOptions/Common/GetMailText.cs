using System;
using System.IO;
using System.Text;
using MailKit;
using MailKit.Net.Imap;
using MailKit.Security;
using MimeKit;

namespace MailClient
{
    class GetMailText
    {
        public static string Run(MimeMessage message)
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
    }
}
