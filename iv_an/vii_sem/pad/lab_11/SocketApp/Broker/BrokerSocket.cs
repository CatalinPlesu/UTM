using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using Util;

namespace Broker
{
    class BrokerSocket
    {
        private Socket _socket;

        public BrokerSocket()
        {
            _socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        }

        public void Start(string ipAddress, int port)
        {
            _socket.Bind(new IPEndPoint(IPAddress.Parse(ipAddress), port));
            _socket.Listen(8);
            Accept();
        }

        private void Accept()
        {
            _socket.BeginAccept(AcceptedCallback, null);
        }

        private void AcceptedCallback(IAsyncResult result) 
        {
            ConnectionInfo connection = new ConnectionInfo();

            try
            {
                connection.Socket = _socket.EndAccept(result);
                connection.Address = connection.Socket.RemoteEndPoint.ToString();
                connection.Socket.BeginReceive(connection.Buffer, 0, connection.Buffer.Length, SocketFlags.None, ReceiveCallback, connection);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Could not accept the connection: {e.Message}");
            }
            finally
            {
                Accept();
            }
        }
        private void ReceiveCallback(IAsyncResult result) 
        {
            ConnectionInfo connection = result.AsyncState as ConnectionInfo;

            try
            {
                SocketError response;
                Socket senderSocket = connection.Socket;
                int buffSize = senderSocket.EndReceive(result, out response);

                if (response == SocketError.Success)
                {
                    byte[] payload = new byte[buffSize];
                    Array.Copy(connection.Buffer, payload, payload.Length);

                    PayloadHandler.Handle(payload, connection);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine($"Could not receive data: {e.Message}");
            }
            finally
            {
                try
                {
                    connection.Socket.BeginReceive(connection.Buffer, 0, connection.Buffer.Length, SocketFlags.None, ReceiveCallback, connection);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                    var address = connection.Socket.RemoteEndPoint.ToString();

                    ConnectionStorage.Remove(address);
                    connection.Socket.Close();               
                }
            }
        }

    }
}
