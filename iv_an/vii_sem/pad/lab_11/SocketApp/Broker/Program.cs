using System;
using System.Threading.Tasks;
using Util;

namespace Broker
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Broker App: ");

            BrokerSocket brokerSocket = new BrokerSocket();
            brokerSocket.Start(Config.BROKER_IP, Config.BROKER_PORT);

            var worker = new MessageWorker();

            Task.Factory.StartNew(worker.DoSendMessageWork, TaskCreationOptions.LongRunning);

            Console.ReadLine(); 
        }
    }
}
