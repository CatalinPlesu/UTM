using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace LocalChat.Chat
{
    public class Reciever
    {
        public static void ReceiveMessage()
        {
            using UdpClient receiver = new(Program.LocalPort);
            receiver.ExclusiveAddressUse = false;
            IPEndPoint groupEP = new IPEndPoint(IPAddress.Any, Program.RemotePort);
            receiver.Connect(groupEP); // Exceptuion 
            IPEndPoint ip = null;
            while (true)
            {
                var result = receiver.Receive(ref ip);
                var message = Encoding.UTF8.GetString(result);
                Console.WriteLine(message);
            }
        }
    }
}
