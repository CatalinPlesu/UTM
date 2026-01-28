using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

int PORT = 9876;
int Clinet_Port = System.DateTime.Now.Second % 55355 + 10000;

UdpClient udpClient = new UdpClient();
udpClient.Client.Bind(new IPEndPoint(IPAddress.Any, Clinet_Port));
Console.WriteLine($"Connected on {udpClient.Client.LocalEndPoint}");

var from = new IPEndPoint(0, 0);
var task = Task.Run(() =>
{
    while (true)
    {
        var recvBuffer = udpClient.Receive(ref from);
        Console.WriteLine(Encoding.UTF8.GetString(recvBuffer));
    }
});

var data = Encoding.UTF8.GetBytes("ABCD");
udpClient.Send(data, data.Length, "255.255.255.255", PORT);

task.Wait();