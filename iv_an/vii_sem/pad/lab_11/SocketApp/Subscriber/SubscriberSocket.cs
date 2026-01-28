using Broker;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using Util;

namespace Subscriber
{
    public class SubscriberSocket
    {
        private Socket _socket;
        private string _topic;

        public SubscriberSocket(string topic)
        {
            _topic = topic;
            _socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        }

        public void Connect(string address, int port)
        {
            _socket.BeginConnect(new IPEndPoint(IPAddress.Parse(address), port), ConnectedCallback, null);
            Console.WriteLine("Waiting for connection...");
        }

        private void ConnectedCallback(IAsyncResult async)
        {
            if (_socket.Connected)
            {
                Console.WriteLine("Subcsriber connected to broker!");
                Subscribe();
                StartReceive();
            }
            else
            {
                Console.WriteLine("Error! Could not connect subscribe to broker.");
            }
        }

        private void Subscribe() 
        {
            var data = Encoding.UTF8.GetBytes("subscribe#" + _topic);
            Send(data);

        }

        private void Send(byte[] message)
        {
            try
            {
                _socket.Send(message);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error! Could not send data: {e.Message}");
            }
        }
        private void StartReceive()
        {
            ConnectionInfo connectionInfo = new ConnectionInfo();
            connectionInfo.Socket = _socket;

            _socket.BeginReceive(connectionInfo.Buffer, 0, connectionInfo.Buffer.Length, SocketFlags.None, ReceiveCallback, connectionInfo);

        }

        private void ReceiveCallback(IAsyncResult result)
        {
            ConnectionInfo connectionInfo = result.AsyncState as ConnectionInfo;

            try
            {
                SocketError errCode;
                int buffsize = _socket.EndReceive(result, out errCode);

                if (errCode == SocketError.Success) 
                {
                    byte[] payload = new byte[buffsize];
                    Array.Copy(connectionInfo.Buffer, payload, payload.Length);
                    PayloadHandler.Handle(payload);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Error! Could not receive data from broker! " + e.Message);
            }
            finally
            {
                try
                {
                    _socket.BeginReceive(connectionInfo.Buffer, 0, connectionInfo.Buffer.Length, SocketFlags.None, ReceiveCallback, connectionInfo);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                    connectionInfo.Socket.Close();
                }
            }
        }
    }
}
