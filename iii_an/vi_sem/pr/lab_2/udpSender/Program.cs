using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

class Program
{
    static void Main(string[] args)
    {
        Socket s = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);

        IPAddress broadcast = IPAddress.Parse("192.168.1.255");
        int i = 0;
        while(true)
        {
            byte[] sendbuf = Encoding.ASCII.GetBytes(i.ToString());
            IPEndPoint ep = new IPEndPoint(broadcast, 26262);
            s.SendTo(sendbuf, ep);
            Console.WriteLine($"Message sent to the broadcast address {i}");
            System.Threading.Thread.Sleep(1000);
            i+=1;
        }
    }
}