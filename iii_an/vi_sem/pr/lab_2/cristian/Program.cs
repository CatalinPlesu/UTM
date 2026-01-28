using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace UDPApp
{
    class Chat
    {
        private static IPAddress remoteIPAddress;
        private static int remotePort;
        private static int localPort;

        [STAThread]
        static void Main(string[] args)
        {
            try
            {
                
                Console.WriteLine("Enter local port");
                localPort = Convert.ToInt16(Console.ReadLine());

                Console.WriteLine("Enter remote port");
                remotePort = Convert.ToInt16(Console.ReadLine());

                Console.WriteLine("Enter IP endpoint");
                remoteIPAddress = IPAddress.Parse(Console.ReadLine());
          
                Thread tRec = new Thread(new ThreadStart(Receiver));
                tRec.Start();

                while (true)
                {
                    Send(Console.ReadLine());
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.ToString() + "\n  " + ex.Message);
            }
        }

        private static void Send(string datagram)
        {
            UdpClient sender = new UdpClient();

            IPEndPoint endPoint = new IPEndPoint(remoteIPAddress, remotePort);

            try
            {
                byte[] bytes = Encoding.UTF8.GetBytes(datagram);

                sender.Send(bytes, bytes.Length, endPoint);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.ToString() + "\n  " + ex.Message);
            }
            finally
            {
                sender.Close();
            }
        }

        public static void Receiver()
        {
            UdpClient receivingUdpClient = new UdpClient(localPort);

            IPEndPoint RemoteIpEndPoint = null;

            try
            {
                Console.WriteLine(
                   "\n-----------*******Chat*******-----------");

                while (true)
                {
                    byte[] receiveBytes = receivingUdpClient.Receive(
                       ref RemoteIpEndPoint);

                    string returnData = Encoding.UTF8.GetString(receiveBytes);
                    Console.WriteLine(" --> " + returnData.ToString());
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.ToString() + "\n  " + ex.Message);
            }
        }
    }
}