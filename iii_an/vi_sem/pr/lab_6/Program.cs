using System;
using NtpClient;

namespace test
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("Enter time zone (in format GMT+X or GMT-X): ");
            string input = Console.ReadLine();

            DateTime time = new DateTime();

            if (input.StartsWith("GMT+"))
            {
                int hours = int.Parse(input.Substring(4));
                time = GetNetworkTime().AddHours(hours);
            }
            else if (input.StartsWith("GMT-"))
            {
                int hours = int.Parse(input.Substring(4));
                time = GetNetworkTime().AddHours(-hours);
            }
            else
            {
                Console.WriteLine("Invalid input format!");
                Environment.Exit(0);
            }

            Console.WriteLine($"Exact time in {input}: {time}");
        }

        public static DateTime GetNetworkTime()
        {
            var connection = new NtpConnection("pool.ntp.org");
            var utcNow = connection.GetUtc(); 
            return utcNow;
        }
    }
}
