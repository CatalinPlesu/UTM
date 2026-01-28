using System;

namespace MailClient
{
    class MainMenu
    {
        public static void Execute()
        {
            while (true)
            {
                Console.Clear();
                Console.WriteLine("Mail Client Main Menu");
                Console.WriteLine("---------------------");
                Console.WriteLine("1. Get mails with POP3");
                Console.WriteLine("2. Get mails with IMAP");
                Console.WriteLine("3. Send mail");
                Console.WriteLine("4. Exit program");
                Console.Write("Please select an option: ");

                string input = Console.ReadLine();

                switch (input)
                {
                    case "1":
                        Pop3Options.Execute();
                        break;
                    case "2":
                        ImapOptions.Execute();
                        break;
                    case "3":
                        SendMailOptions.Execute();
                        break;
                    case "4":
                        Environment.Exit(0);
                        break;
                    default:
                        Console.WriteLine("Invalid input. Please try again.");
                        break;
                }
            }
        }
    }
}
