using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace Publisher
{
    class PublisherSocket
    {
        private Socket _socket;
        public bool IsConnected;

        public PublisherSocket()
        {
            _socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        }

        public void Connect(string ipAddress, int port)
        {
            /*Start connection in async mode*/
            _socket.BeginConnect(new IPEndPoint(IPAddress.Parse(ipAddress), port), ConnectedCallback, null);
            Thread.Sleep(2000);
        }

        private void ConnectedCallback(IAsyncResult result)
        {
            if (_socket.Connected)
            {
                Console.WriteLine("Sender connected to broker");
            }
            else
            {
                Console.WriteLine("Error! Could not connect sender to broker!");
            }

            IsConnected = _socket.Connected;
        }

        public void Send(byte[] data) 
        {
            try
            {
                _socket.Send(data);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error sending data: {e}");
            }
            
        }
    }
}
