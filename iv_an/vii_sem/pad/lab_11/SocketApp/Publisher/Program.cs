using Newtonsoft.Json;
using System;
using System.Text;
using Util;

namespace Publisher
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Publisher App:");

            var publisherSocket = new PublisherSocket();
            publisherSocket.Connect(Config.BROKER_IP, Config.BROKER_PORT);

            if (publisherSocket.IsConnected)
            {
                while (true)
                {
                    var payload = new Payload();

                    Console.WriteLine("Enter the article: ");
                    payload.Article = Console.ReadLine().ToLower();
                    
                    Console.WriteLine("Enter the article topic: ");
                    payload.Topic = Console.ReadLine().ToLower();

                    var payloadStr = JsonConvert.SerializeObject(payload);
                    byte[] data = Encoding.UTF8.GetBytes(payloadStr);

                    publisherSocket.Send(data);
                }

            }

            Console.ReadLine();
        }
    }
}
