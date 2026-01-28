using System;
using System.IO;
using MailKit.Net.Imap;
using MailKit.Net.Pop3;
using MailKit.Net.Smtp;
using MailKit.Security;

namespace MailClient
{
    class Login
    {
        public static void Execute()
        {
            bool loggedIn = false;
            while (!loggedIn)
            {
                Console.Clear();
                Console.WriteLine("Login");
                Console.WriteLine("-------------");
                Console.WriteLine("1. Use saved credentials");
                Console.WriteLine("2. Enter new credentials");
                Console.WriteLine("3. Exit program");
                Console.Write("Please select an option: ");
                string input = Console.ReadLine();

                switch (input)
                {
                    case "1":
                        if (LoadSavedCredentials())
                        {
                            LoginToServer();
                            loggedIn = true;
                        }
                        else
                        {
                            Console.WriteLine("Failed to log in with saved credentials.");
                        }
                        break;
                    case "2":
                        PromptNewCredentials();
                        SaveCredentialsToFile();
                        LoginToServer();
                        loggedIn = true;
                        break;
                    case "3":
                        Environment.Exit(0);
                        break;
                    default:
                        Console.WriteLine("Invalid input. Please try again.");
                        break;
                }
            }
        }

        private static bool LoadSavedCredentials()
        {
            if (File.Exists("credentials.txt"))
            {
                string[] lines = File.ReadAllLines("credentials.txt");
                if (lines.Length > 0)
                {
                    Console.Clear();
                    Console.WriteLine("Saved credentials:");
                    for (int i = 0; i < lines.Length; i++)
                    {
                        string[] credentials = lines[i].Split(':');
                        if (credentials.Length == 2)
                        {
                            Console.WriteLine($"{i + 1}. {credentials[0]}");
                        }
                    }

                    Console.Write("Please select a credential by number: ");
                    string input = Console.ReadLine();
                    int selectedIndex = 0;
                    if (int.TryParse(input, out selectedIndex) && selectedIndex > 0 && selectedIndex <= lines.Length)
                    {
                        string[] credentials = lines[selectedIndex - 1].Split(':');
                        if (credentials.Length == 2)
                        {
                            Program.Configuration.Username = credentials[0];
                            Program.Configuration.Password = credentials[1];
                            return true;
                        }
                    }
                }
            }
            return false;
        }

        private static void PromptNewCredentials()
        {
            Console.Write("Please enter your email address: ");
            Program.Configuration.Username = Console.ReadLine();
            Console.Write("Please enter your password: ");
            Program.Configuration.Password = Console.ReadLine();
        }

        private static void SaveCredentialsToFile()
        {
            using (StreamWriter sw = new StreamWriter("credentials.txt", true))
            {
                sw.WriteLine(Program.Configuration.Username + ":" + Program.Configuration.Password);
            }
        }

        private static void LoginToServer()
        {
            try
            {
                using (var smtp = new SmtpClient())
                {
                    // SMTP
                    smtp.Connect("smtp." + Program.Configuration.ServerName, Program.Configuration.SmtpPort, SecureSocketOptions.StartTlsWhenAvailable);
                    smtp.Authenticate(Program.Configuration.Username, Program.Configuration.Password);
                    Console.WriteLine("Logged in successfully to SMTP server");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failed to log in to SMTP server:");
                Console.WriteLine(ex.Message);
            }

            try
            {
                using (var pop3 = new Pop3Client())
                {
                    // POP3
                    pop3.Connect("pop." + Program.Configuration.ServerName, Program.Configuration.Pop3Port, SecureSocketOptions.Auto);
                    pop3.Authenticate(Program.Configuration.Username, Program.Configuration.Password);
                    Console.WriteLine("Logged in successfully to POP3 server");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failed to log in to POP3 server:");
                Console.WriteLine(ex.Message);
            }

            try
            {
                using (var imap = new ImapClient())
                {
                    // IMAP
                    imap.Connect("imap." + Program.Configuration.ServerName, Program.Configuration.ImapPort, SecureSocketOptions.Auto);
                    imap.Authenticate(Program.Configuration.Username, Program.Configuration.Password);
                    Console.WriteLine("Logged in successfully to IMAP server");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failed to log in to IMAP server:");
                Console.WriteLine(ex.Message);
            }
            Console.WriteLine("Press any key to try again...");
            Console.ReadKey();
        }
    }
}
