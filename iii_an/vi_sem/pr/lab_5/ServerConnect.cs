using System;
using System.IO;
using MailKit.Net.Imap;
using MailKit.Net.Pop3;
using MailKit.Net.Smtp;
using MailKit.Security;

namespace MailClient
{
    public static class Connect
    {
        public static void Execute()
        {
            bool server_selected = false;
            while (!server_selected)
            {
                Console.Clear();
                Console.WriteLine("Connection");
                Console.WriteLine("----------------");
                Console.WriteLine("1. Use default server");
                Console.WriteLine("2. Input new server");
                Console.WriteLine("3. Use server from list");
                Console.WriteLine("4. Go back to main menu");
                Console.Write("Please select an option: ");
                string input = Console.ReadLine();

                switch (input)
                {
                    case "1":
                        Program.Configuration.ServerName = "gmail.com";
                        Program.Configuration.SmtpPort = 587;
                        Program.Configuration.Pop3Port = 995;
                        Program.Configuration.ImapPort = 993;
                        Console.WriteLine("Using default server: gmail.com");
                        break;
                    case "2":
                        Console.Write("Server name: ");
                        Program.Configuration.ServerName = Console.ReadLine();
                        Console.Write("SMTP Port: ");
                        Program.Configuration.SmtpPort = int.Parse(Console.ReadLine());
                        Console.Write("POP3 Port: ");
                        Program.Configuration.Pop3Port = int.Parse(Console.ReadLine());
                        Console.Write("IMAP Port: ");
                        Program.Configuration.ImapPort = int.Parse(Console.ReadLine());

                        using (StreamWriter writer = File.AppendText("servers.txt"))
                        {
                            writer.WriteLine($"{Program.Configuration.ServerName}:{Program.Configuration.SmtpPort}:{Program.Configuration.Pop3Port}:{Program.Configuration.ImapPort}");
                        }
                        Console.WriteLine("Server saved to file.");
                        break;
                    case "3":
                        Console.WriteLine("Server list:");
                        Console.WriteLine("-------------");
                        if (File.Exists("servers.txt"))
                        {
                            int count = 1;
                            foreach (string line in File.ReadAllLines("servers.txt"))
                            {
                                Console.WriteLine($"{count}. {line}");
                                count++;
                            }
                            Console.Write("Select a server from the list: ");
                            int selection = int.Parse(Console.ReadLine());
                            string server = File.ReadAllLines("servers.txt")[selection - 1];
                            string[] parts = server.Split(':');
                            Program.Configuration.ServerName = parts[0];
                            Program.Configuration.SmtpPort = int.Parse(parts[1]);
                            Program.Configuration.Pop3Port = int.Parse(parts[2]);
                            Program.Configuration.ImapPort = int.Parse(parts[3]);
                            Console.WriteLine($"Server set to: {Program.Configuration.ServerName}:{Program.Configuration.SmtpPort}");
                        }
                        else
                        {
                            Console.WriteLine("No servers found.");
                        }
                        break;
                    case "4":
                        Environment.Exit(0);
                        break;
                    default:
                        Console.WriteLine("Invalid input. Please try again.");
                        Console.WriteLine("Press any key to continue...");
                        Console.ReadKey();
                        break;
                }

                // Try connecting to the SMTP, POP3, and IMAP servers
                try
                {
                    using (var smtpClient = new SmtpClient())
                    {
                        smtpClient.Connect("smtp." + Program.Configuration.ServerName, Program.Configuration.SmtpPort, SecureSocketOptions.StartTls);
                        Console.WriteLine("SMTP connection successful!");
                    }

                    using (var pop3Client = new Pop3Client())
                    {
                        pop3Client.Connect("pop." +  Program.Configuration.ServerName, Program.Configuration.Pop3Port, SecureSocketOptions.Auto);
                        Console.WriteLine("POP3 connection successful!");
                    }

                    using (var imapClient = new ImapClient())
                    {
                        imapClient.Connect("imap." + Program.Configuration.ServerName, Program.Configuration.ImapPort, SecureSocketOptions.SslOnConnect);
                        Console.WriteLine("IMAP connection successful!");
                    }
                    server_selected = true;
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Failed to connect to server: {ex.Message}");
                }
                Console.WriteLine("Press any key to try again...");
                Console.ReadKey();
            }
        }
    }
}

