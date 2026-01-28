using System;
using System.Net;
using System.Threading;
using LocalChat.Chat;

namespace LocalChat
{
    sealed class Program
    {
        public static int LocalPort;
        public static int RemotePort;
        public static IPAddress Ip;
        public static string Name = "";

        private static void Main(string[] args)
        {
            Ip = IPAddress.Parse("192.168.1.255");

            Console.Write("Enter your name: ");
            Name = Console.ReadLine();

            Console.Write("Enter port to recieve messages: ");
            LocalPort = 26262;

            Console.Write("Enter port to send messages: ");
            RemotePort = 26262;

            Thread thread = new(Reciever.ReceiveMessage);
            thread.Start();

            Sender.SendMessage();

            Console.ReadLine();
        }
    }
}
