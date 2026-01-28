using System;
using MailKit.Net.Smtp;
using MailKit;
using MimeKit;

namespace MailClient
{
    class Program
    {
        public static class Configuration
        {
            public static string ServerName { get; set; } = "gmail.com";
            public static int SmtpPort { get; set; } = 587;
            public static int Pop3Port { get; set; } = 995;
            public static int ImapPort { get; set; } = 993;
            public static string Username { get; set; } = "";
            public static string Password { get; set; } = "";
        }

        static void Main(string[] args)
        {
            Connect.Execute();
            Login.Execute();
            MainMenu.Execute();
        }
    }
}
