using System.Net;
using System.Net.Sockets;
using System.Text;

namespace labexemplu
{
    public class UdpChat
    {
        private Socket _multicastSocket;
        private Socket _sender;
        private string _multicastIP;
        private int _multicastPort;

        public UdpChat(string multicastIP, int multicastPort)
        {
            IPEndPoint ipEP = new IPEndPoint(IPAddress.Any, multicastPort);
            _multicastPort = multicastPort;
            _multicastIP = multicastIP;

            _multicastSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);

            _multicastSocket.Bind(ipEP);
            _multicastSocket.SetSocketOption(SocketOptionLevel.IP,
                SocketOptionName.AddMembership,
                new MulticastOption(IPAddress.Parse(multicastIP)));

            _sender = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
            _sender.SetSocketOption(SocketOptionLevel.IP,
                SocketOptionName.AddMembership,
                new MulticastOption(IPAddress.Parse(multicastIP)));

            Console.WriteLine($"User address: {_multicastSocket.LocalEndPoint}");
        }

        public void SendToGeneral(string text)
        {
            byte[] buffer = Encoding.ASCII.GetBytes(text);
            IPAddress multicastIP = IPAddress.Parse(_multicastIP);
            EndPoint multicastEP = new IPEndPoint(multicastIP, _multicastPort);

            _sender.SendTo(buffer, multicastEP);
        }

        public void SendTo(string ip, string text)
        {
            byte[] buffer = Encoding.ASCII.GetBytes(text);
            EndPoint receiverEndPoint = new IPEndPoint(IPAddress.Parse(ip), _multicastPort);

            _sender.SendTo(buffer, receiverEndPoint);
        }

        public void StartReceiveLoop()
        {
            Task.Run(() =>
            {
                ReceiveMessage();
            });
        }

        private void ReceiveMessage()
        {
            while (true)
            {
                byte[] buffer = new byte[1024];
                EndPoint remoteSender = new IPEndPoint(IPAddress.Any, 0);

                _multicastSocket.ReceiveFrom(buffer, ref remoteSender);
                Console.WriteLine($"From {remoteSender}: {Encoding.ASCII.GetString(buffer)}");
            }
        }
    }
}