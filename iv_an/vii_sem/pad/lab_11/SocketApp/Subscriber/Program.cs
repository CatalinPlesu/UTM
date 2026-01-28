using System;
using Util;

namespace Subscriber
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Subscriber App: ");

            Console.WriteLine("Enter the topic: ");
            var topic = Console.ReadLine().ToLower();

            var subscriberSocket = new SubscriberSocket(topic);

            subscriberSocket.Connect(Config.BROKER_IP, Config.BROKER_PORT);
            Console.ReadLine();
        }
    }
}
