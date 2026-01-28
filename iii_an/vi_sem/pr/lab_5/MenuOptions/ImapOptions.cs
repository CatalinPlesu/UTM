using System;
using System.IO;
using System.Text;
using MailKit;
using MailKit.Net.Imap;
using MailKit.Security;
using MimeKit;

namespace MailClient
{
    class ImapOptions
    {
        public static void Execute()
        {
            const int page_size = 10;

            using (var client = new ImapClient())
            {
                try
                {
                    client.Connect("imap." + Program.Configuration.ServerName, Program.Configuration.ImapPort, SecureSocketOptions.SslOnConnect);
                    client.Authenticate(Program.Configuration.Username, Program.Configuration.Password);
                    client.Inbox.Open(FolderAccess.ReadOnly);

                    int messageCount = client.Inbox.Count;
                    int start = Math.Max(0, messageCount - page_size);

                    while (true)
                    {
                        Console.Clear();
                        Console.WriteLine("Recent messages:");
                        for (int i = messageCount - 1; i >= start; i--)
                        {
                            var message = client.Inbox.GetMessage(i);
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
                                var message = client.Inbox.GetMessage(mailNumber);

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
    }
}
