using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace LocalChat.Chat
{
    public class Sender
    {
        public static void SendMessage()
        {
            using UdpClient sender = new();
            sender.ExclusiveAddressUse = false;
            IPEndPoint groupEP = new IPEndPoint(IPAddress.Any, Program.LocalPort);
            sender.Connect(groupEP); // Exceptuion 
            Console.WriteLine("To send message press Enter");
            while (true)
            {
                string message = Console.ReadLine();

                message = $"{Program.Name}: {message}";
                byte[] data = Encoding.UTF8.GetBytes(message);
                sender.Send(data, data.Length, new IPEndPoint(Program.Ip, Program.RemotePort));
            }
        }
    }
}
