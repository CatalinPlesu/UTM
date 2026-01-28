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
          private bool _running;
          private bool _is_connected;

          public ClientSocket()
          {
               _clientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
               _running = true;
               _is_connected = false;
          }

          public void Connect(string remoteIP, int remotePort)
          {
               IPAddress ipAddress = IPAddress.Parse(remoteIP);
               IPEndPoint remoteEndPoint = new IPEndPoint(ipAddress, remotePort);
               try
               {
                    _clientSocket.Connect(remoteEndPoint);
                    Console.WriteLine($"Connected to {remoteEndPoint.Address}");
                    Console.Write("\nWrite messages, and press enter.: ");
                    _is_connected = true;

               }
               catch (Exception ex)
               {
                    Console.WriteLine($"Error connecting: {ex.Message}");
               }
          }

          public void SendLoop()
          {
               if(!_is_connected)
               {
                    return;
               }
               Thread receiveThread = new Thread(() => receiveLoop());
               receiveThread.Start();
               while (true)
               {
                    try
                    {
                         string text = Console.ReadLine() ?? "";

                         byte[] bytesData = Encoding.UTF8.GetBytes(text);
                         _clientSocket.Send(bytesData);

                    }
                    catch(Exception ex)
                    {
                         Console.WriteLine($"Error sending: {ex.Message}");
                    }
               }
          }

          public void receiveLoop()
          {
               while(_running){
                    byte[] bytesResponse = new byte[1024];
                    int bytesReceived = _clientSocket.Receive(bytesResponse);
                    string response = Encoding.ASCII.GetString(bytesResponse, 0, bytesReceived);
                    Console.WriteLine(response);
               }
          }

          public void CloseClientSocket()
          {
               _running = false;
               _clientSocket.Shutdown(SocketShutdown.Both);
               _clientSocket.Close();
               Console.Write("\nDisconnected!");
          }
     }
}
