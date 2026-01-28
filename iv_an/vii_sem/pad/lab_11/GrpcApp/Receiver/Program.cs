using Grpc.Net.Client;
using GrpcApp;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Hosting.Server.Features;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Receiver
{
    public class Program
    {
        public static void Main(string[] args)
        {
            AppContext.SetSwitch("System.Net.Http.SocketsHttpHandler.Http2UnencryptedSupport", true);
            var host = WebHost.CreateDefaultBuilder(args).UseStartup<Startup>().UseUrls("http://127.0.0.1:0").Build();

            host.Start();

            Subscribe(host);

            Console.WriteLine("Press enter to exit.");
            Console.ReadLine();

        }

        private static void Subscribe(IWebHost host)
        {
            var channel = GrpcChannel.ForAddress("http://127.0.0.1:5001");
            var client = new Subscriber.SubscriberClient(channel);

            var address = host.ServerFeatures.Get<IServerAddressesFeature>().Addresses.First();
            Console.WriteLine("Subscriber listening at " + address);

            Console.WriteLine("Enter the topic:");
            var topic = Console.ReadLine().ToLower();

            var request = new SubscriberRequest() { Topic = topic, Address = address };

            try
            {
                var reply = client.Subscribe(request);
                Console.WriteLine("Subscribed reply: " + reply.IsSuccess);
            }
            catch (Exception e)
            {
                Console.WriteLine("Error subscribing: " + e.Message);
            }
        }
    }
}
