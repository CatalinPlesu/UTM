using Grpc.Net.Client;
using GrpcApp;
using System;
using System.Security.Policy;
using System.Threading.Tasks;

namespace Client
{
    internal class Program
    {
        static async Task Main(string[] args)
        {

            
            AppContext.SetSwitch("System.Net.Http.SocketsHttpHandler.Http2UnencryptedSupport", true);
            Console.WriteLine("Welcome to Publisher App!");

            var channel = GrpcChannel.ForAddress("http://127.0.0.1:5001");
            var client = new GrpcApp.Publisher.PublisherClient(channel);

            while (true)
            {
                Console.WriteLine("Article name:");
                var article = Console.ReadLine().ToLower();

                Console.WriteLine("Topic name:");
                var topic = Console.ReadLine().ToLower();   

                Console.WriteLine("Your name:");
                var publisher_name = Console.ReadLine().ToLower();

                var request = new PublishRequest() 
                { 
                    Article= article, 
                    Topic = topic, 
                    PublisherName=publisher_name 
                };

                try
                {
                    var reply = await client.PublishMessageAsync(request);
                    Console.WriteLine("Request status: " + reply.IsSuccess);
                }
                catch (Exception e)
                {

                    Console.WriteLine("Error posting the message! " + e);
                }
            }
        }
    }
}
