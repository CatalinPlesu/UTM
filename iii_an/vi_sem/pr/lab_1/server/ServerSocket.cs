using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Sockets;
using System.Threading;

namespace Server
{
     public class ServerWorker
     {
          private Dictionary<String, Socket> _clients;
          private Queue<String> _messages;

          public ServerWorker()
          {
               _clients = new Dictionary<string, Socket>();
               _messages = new Queue<string>();
          }

          public void AddClient(Socket client)
          {
               lock(_clients)
               {
                    _clients.Add(client.RemoteEndPoint.ToString(), client);
               }
          }
          
          public void RemoveClient(string client)
          {
               lock(_clients)
               {
                    _clients.Remove(client);
               }
          }
          public void SendMessage(string message)
          {
               lock(_messages)
               {
                    _messages.Enqueue(message);
               }
          }
          public void ConsumeQueueLoop()
          {
               while(true)
               {
                    while(_messages.Count != 0)
                    {
                         var message = _messages.Dequeue();
                         foreach(var client in _clients)
                         {
                              byte[] bytesData = Encoding.UTF8.GetBytes(message);
                              client.Value.Send(bytesData);
                         }
                    }
                    Thread.Sleep(1000);
               }
          }
     }
     public class ServerSocket
     {
          private readonly Socket     _serverSocket;
          private readonly IPEndPoint _serverEndPoint;
          private ServerWorker _serverWorker;

          public ServerSocket(String ip, int port)
          {
               IPAddress ipAddress = IPAddress.Parse(ip);

               _serverSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

               _serverEndPoint = new IPEndPoint(ipAddress, port);

               _serverWorker = new ServerWorker();
          }

          public void StartWorkerThread()
          {
               Thread workerThread = new Thread(() => _serverWorker.ConsumeQueueLoop());
               workerThread.Start();
          }

          public void BindAndListen(int queueLimit)
          {
               try
               {
                    _serverSocket.Bind(_serverEndPoint);
                    _serverSocket.Listen(queueLimit);
                    Console.WriteLine($"Listening on {_serverEndPoint.Address}:{_serverEndPoint.Port}");
               }
               catch(Exception ex)
               {
                    Console.WriteLine($"Error binding and listening: {ex.Message}");
               }
          }

          public void AcceptAndReceive()
          {
               while (true)
               {
                    Socket? client;

                    client = acceptClient();

                    if (client != null)
                    {
                         _serverWorker.AddClient(client);
                         Thread clientThread = new Thread(() => receiveLoop(client));
                         clientThread.Start();
                    }
               }
               
          }

          private Socket? acceptClient()
          {
               Socket? client = null;
               try
               {
                    client = _serverSocket.Accept();
                    Console.WriteLine($"Client {client.RemoteEndPoint} accepted!");
               }
               catch (Exception ex)
               {
                    Console.WriteLine($"Error accepting client: {ex.Message}");
               }
               return client;
          }

          private void receiveLoop(Socket client)
          {
               while (true)
               {
                    try
                    {
                         byte[] buffer = new byte[1024];
                         int bytesCount = client.Receive(buffer);

                         if (bytesCount == 0)
                         {
                              CloseClientSocket(client);
                              return;
                         }

                         string text = Encoding.UTF8.GetString(buffer, 0, bytesCount);

                         string message = $"{client.RemoteEndPoint}\tmessage: {text}";
                         Console.WriteLine(message);

                         _serverWorker.SendMessage(message);
                    }
                    catch (Exception ex)
                    {
                         Console.WriteLine($"Exception: {ex.Message}");
                         CloseClientSocket(client);
                    }
               }
          }

          public void CloseClientSocket(Socket client)
          {
               _serverWorker.RemoveClient(client.RemoteEndPoint.ToString());
               Console.WriteLine($"Client {client.RemoteEndPoint} disconnected!");
               client.Shutdown(SocketShutdown.Both);
               client.Close();
          }
     }
}
