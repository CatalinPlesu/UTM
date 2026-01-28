using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace Client
{
     internal class ClientSocket
     {
          readonly Socket _clientSocket;
          private int _remotePort;
          private IPEndPoint _sendEndpoint;
          private IPEndPoint _receiveEndpoint;

          private bool _global_chat;

          public ClientSocket()
          {
               _clientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
               _global_chat = true;
               _sendEndpoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 26262);
               _receiveEndpoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 26262);
          }


        public void Bind(string remoteIP, int remotePort)
        {
          _remotePort = remotePort;
            try
            {
               IPAddress ipAddress = IPAddress.Parse(remoteIP);
               IPEndPoint remoteEndPoint = new IPEndPoint(ipAddress, remotePort);

               _clientSocket.Bind(remoteEndPoint);
               Console.WriteLine($"Connected to {remoteEndPoint.Address}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error binding and listening: {ex.Message}");
            }
        }


          public void SendLoop()
          {
               Console.WriteLine("Commands:");
               Console.WriteLine(":s - specify ip to send messages");
               Console.WriteLine(":r - specify ip to receive messages from");
               Console.WriteLine(":g - select general channel");
               while (true)
               {
                    try
                    {
                         string text = Console.ReadLine() ?? "";
                         var result = ProcessCommand(text);
                         if(result == false)
                         {
                              text = Console.ReadLine() ?? "";
                         }

               
                         byte[] bytesData = Encoding.UTF8.GetBytes(text);
                         if(_global_chat == true)
                         {
                              _clientSocket.SendTo(bytesData, 0, bytesData.Length, SocketFlags.Broadcast, 
                                        new IPEndPoint(IPAddress.Parse("127.0.0.255"), 26262));
                         }
                         else
                         {
                              _clientSocket.SendTo(bytesData, 0, bytesData.Length, SocketFlags.None, _sendEndpoint);
                         }

                    }
                    catch(Exception ex)
                    {
                         Console.WriteLine($"Error sending: {ex.Message}");
                    }
               }
          }

          public bool ProcessCommand(string command)
          {
               if(String.Equals(command, ":s"))
               {
                    _global_chat = false;
                    Console.WriteLine("Enter the desired ip to send mesages to:");
                    string ip = Console.ReadLine() ?? "";
                    IPAddress ipAddress = IPAddress.Parse(ip);
                    _sendEndpoint = new IPEndPoint(ipAddress, _remotePort);
                    return true;
               }

               if(String.Equals(command, ":r"))
               {
                    _global_chat = false;
                    Console.WriteLine("Enter the desired ip to receive mesages from:");
                    string ip = Console.ReadLine() ?? "";
                    IPAddress ipAddress = IPAddress.Parse(ip);
                    _receiveEndpoint = new IPEndPoint(ipAddress, _remotePort);
                    return true;
               }

               if(String.Equals(command, ":g"))
               {
                    _global_chat = true;
                    return true;
               }

               return false;
          }

          public void receiveThread()
          {
               Thread receiveThread = new Thread(() => receiveLoop());
               receiveThread.Start();
          }
          private void receiveLoop()
          {
               EndPoint otherEndpoint = new IPEndPoint(IPAddress.Any, 0);
               byte[] bytesResponse = new byte[1024];
               while(true)
               {
                    int bytesReceived = 0;
                    if(_global_chat == false)
                    {
                         bytesReceived = _clientSocket.ReceiveFrom(bytesResponse, 0, bytesResponse.Length, SocketFlags.None,
                    ref otherEndpoint);
                         if (String.Equals(otherEndpoint.ToString(), _receiveEndpoint.ToString())){
                              Console.WriteLine("Message accepted");
                         }
                         else
                         {
                              Console.WriteLine(_receiveEndpoint);
                              Console.WriteLine("Message rejected");
                              continue;
                         }
                    }
                    else
                    {
                         bytesReceived = _clientSocket.Receive(bytesResponse);
                    }

                    string response = Encoding.ASCII.GetString(bytesResponse, 0, bytesReceived);
                    Console.WriteLine(response);
               }
          }
     }
}
