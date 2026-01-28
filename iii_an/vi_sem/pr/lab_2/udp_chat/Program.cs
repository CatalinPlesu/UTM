using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace UDPApp
{
    
    public enum Udp_Command : byte
    {
        Connected = 1,
        PublicMessage,
        PrivateMessage,
        PrivateUsername,
        PublicAreYouHere,
        PublicCiao
    }

    class Chat
    {
        private static IPAddress remoteIPAddress = IPAddress.Parse("192.168.1.255");
        private static IPAddress localIPAdderss;
        private static int port = 10000;

        private static Dictionary<string, string> userIpDict = new Dictionary<string, string>();
        private static String username = "";
        private static byte mesasgeMode = (byte)Udp_Command.PublicMessage;

        [STAThread]
        static void Main(string[] args)
        {
            try
            {
                Thread tRec = new Thread(new ThreadStart(Receiver));
                tRec.Start();
                ReadUsername();


                Send(username, (byte)Udp_Command.Connected);

                while (true)
                {
                    string message = ReadInput();
                    if (message != "")
                    {
                      Send(Console.ReadLine(), mesasgeMode);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.ToString() + "\n  " + ex.Message);
            }
        }

        private static void Send(string datagram, byte command)
        {
            UdpClient sender = new UdpClient();

            IPEndPoint endPoint = new IPEndPoint(remoteIPAddress, port);

            try
            {
                byte[] datagramBytes = Encoding.UTF8.GetBytes(datagram);
                byte[] bytes = new byte[datagramBytes.Length + 1];
                bytes[0] = command;
                Array.Copy(datagramBytes, 0, bytes, 1, datagramBytes.Length);

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
            UdpClient receivingUdpClient = new UdpClient(port);

            IPEndPoint RemoteIpEndPoint = null;

            try
            {
                while (true)
                {
                    byte[] receiveBytes = receivingUdpClient.Receive(
                       ref RemoteIpEndPoint);

                    if (IsLocalIPAddress(RemoteIpEndPoint.Address.ToString()) || receiveBytes.Length <= 1)
                    {
                        continue;
                    }
                    
                    byte command = receiveBytes[0];
                    string returnData = Encoding.UTF8.GetString(receiveBytes, 1, receiveBytes.Length-1);
                    switch((Udp_Command)command)
                    {
                        case Udp_Command.Connected:
                            Console.WriteLine($"{returnData} jointed");
                            if (!userIpDict.ContainsKey(returnData))
                            {
                                userIpDict.Add(returnData, RemoteIpEndPoint.Address.ToString());
                            }
                            remoteIPAddress = RemoteIpEndPoint.Address;
                            Send(username, (byte)Udp_Command.PrivateUsername);
                            remoteIPAddress = IPAddress.Parse("192.168.1.255");
                            
                            break;
                        case Udp_Command.PublicMessage:
                        {
                            string key = userIpDict.FirstOrDefault(x => x.Value == RemoteIpEndPoint.Address.ToString()).Key;
                            if (key != null)
                            {
                                Console.WriteLine($"G:[{key}]: {returnData.ToString()}");
                            }
                            else
                            {
                                Console.WriteLine($"G:[{RemoteIpEndPoint.Address.ToString()}]: {returnData.ToString()}");
                            }
                            break;
                        }
                           
                        case Udp_Command.PrivateMessage:
                        {
                            string key = userIpDict.FirstOrDefault(x => x.Value == RemoteIpEndPoint.Address.ToString()).Key;
                            if (key != null)
                            {
                                Console.WriteLine($"P:[{key}]: {returnData.ToString()}");
                            }
                            else
                            {
                                Console.WriteLine($"P:[{RemoteIpEndPoint.Address.ToString()}]: {returnData.ToString()}");
                            }
                            break;
                        }
                        case Udp_Command.PrivateUsername:
                            Console.WriteLine($"{returnData} was here");
                            if (!userIpDict.ContainsKey(returnData))
                            {
                                userIpDict.Add(returnData, RemoteIpEndPoint.Address.ToString());
                            }
                            break;
                        case Udp_Command.PublicAreYouHere:
                            if (username == returnData)
                            {
                                remoteIPAddress = RemoteIpEndPoint.Address;
                                Send(username, (byte)Udp_Command.PrivateUsername);
                                remoteIPAddress = IPAddress.Parse("192.168.1.255");
                            }
                            break;
                        case Udp_Command.PublicCiao:
                        {
                            string key = userIpDict.FirstOrDefault(x => x.Value == RemoteIpEndPoint.Address.ToString()).Key;
                            if (key != null)
                            {
                               userIpDict.Remove(key);
                            }
                            break;
                        }
                        default:
                            Console.WriteLine("Unknown command");
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.ToString() + "\n  " + ex.Message);
            }
        }

        public static void ReadUsername()
        {
            string username = "";
            while (string.IsNullOrEmpty(username))
            {
                Console.Write("Enter your username: ");
                username = Console.ReadLine().Trim();
            }
            Send(username, (byte)Udp_Command.Connected);
        } 


        static string ReadInput()
        {
            string input = Console.ReadLine();


            if (input.StartsWith("/"))
            {
                if (input.Length == 1)
                {
                    // we want to send messages to general chat
                    Console.WriteLine("You typed /");
                    Console.WriteLine("General chat");
                    remoteIPAddress = IPAddress.Parse("192.168.1.255");
                    mesasgeMode = (byte)Udp_Command.PublicMessage;
                }
                else
                {
                    input = input.Substring(1);
                    switch(input)
                    {
                        case "ls":
                        {
                            Console.WriteLine("Known users:");
                            foreach (string key in userIpDict.Keys)
                            {
                                Console.WriteLine($"{key}: {userIpDict[key]}");
                            }
                            break;
                        }
                        case "quit":
                        {
                            Quit();
                            break;
                        }
                        default://search for given user
                        {
                            string  target_ip;
                            if (userIpDict.ContainsKey(input))
                            {
                                Console.WriteLine($"{input}'s IP is {userIpDict[input]}");
                                remoteIPAddress = IPAddress.Parse(userIpDict[input]);
                                mesasgeMode = (byte)Udp_Command.PrivateMessage;
                            }
                            else
                            {
                                Console.WriteLine("No such user");
                                Send(input, (byte)Udp_Command.PublicAreYouHere);
                            }
                            break;
                        }
                    }
                    
                }
                return "";
            }
            return input;
        }

        public static void Quit()
        {
            Send(username, (byte)Udp_Command.PublicCiao);
            Console.WriteLine("Disconnected from chat!");
            Environment.Exit(0);
        }

        public static bool IsLocalIPAddress(string ipaddress)
        {
            IPHostEntry hostEntry = Dns.GetHostEntry(Dns.GetHostName());
            IPAddress[] addresses = hostEntry.AddressList;

            foreach (IPAddress address in addresses)
            {
                if (address.AddressFamily == AddressFamily.InterNetwork)
                {
                    if (address.ToString() == ipaddress)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

    }
}