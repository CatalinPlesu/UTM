using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace Lab_2_UDP
{
    public class UDPChat
    {
        private Socket _multicastSocket;
        private int _port;
        private Socket _sender;
        private string _multicastIP;
        public UDPChat(string multicastIP,int port)
        {
            var ipEndpoint = new IPEndPoint(IPAddress.Any, port);
            _port = port;
            _multicastIP = multicastIP;

            _multicastSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);

            _multicastSocket.Bind(ipEndpoint);
            _multicastSocket.SetSocketOption(
                SocketOptionLevel.IP,
                SocketOptionName.AddMembership,
                new MulticastOption(IPAddress.Parse(multicastIP))
                );

            Console.WriteLine($"Client address: {_multicastSocket.AddressFamily}");

            _sender = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
            _sender.SetSocketOption(
                SocketOptionLevel.IP,
                SocketOptionName.AddMembership,
                new MulticastOption(IPAddress.Parse(multicastIP))
                );
        }

        public void StartReceiveLoop()
        {
            Thread thread = new Thread(new ThreadStart(receive));

            thread.Start();
        }

        public void SendTo(string ip, string text)
        {
            byte[] buffer = Encoding.UTF8.GetBytes(text);
            IPEndPoint receiveEndpoint = new IPEndPoint(IPAddress.Parse(ip), _port);
            _sender.SendTo(buffer, receiveEndpoint);
        }

        public void SendToGeneral(string text)
        {
            var multicastIP = IPAddress.Parse(_multicastIP);
            var multicastEndpoint = new IPEndPoint(multicastIP, _port);
            
            byte[] bytes = Encoding.UTF8.GetBytes(text);
            _sender.SendTo(bytes, multicastEndpoint);
        }

        public void receive()
        {
            while (true)
            {
                byte[] buffer = new byte[1024];
                EndPoint remoteSender = new IPEndPoint(IPAddress.Any, 0);

                _multicastSocket.ReceiveFrom(buffer,ref remoteSender);

                string text = Encoding.UTF8.GetString(buffer);

                Console.WriteLine($"Received from {remoteSender}: {text}");
            }
        }
    }
}