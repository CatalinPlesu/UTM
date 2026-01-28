using Broker.Models;
using Grpc.Core;
using GrpcApp;
using System.Threading.Tasks;
using System;
using Broker.Services.Interfaces;

namespace Broker.Services
{
    public class SubscriberService : Subscriber.SubscriberBase
    {
        private readonly IConnectionStorageServices _connections;

        public SubscriberService(IConnectionStorageServices connections)
        {
            _connections = connections;
        }

        public override Task<SubscriberReply> Subscribe(SubscriberRequest subscriberRequest, ServerCallContext callContext)
        {
            Console.WriteLine($"Trying to subscribe to {subscriberRequest.Address} {subscriberRequest.Topic}");

            try
            {
                var connection = new Connection(subscriberRequest.Topic, subscriberRequest.Address);

                _connections.Add(connection);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Could not add the new connection {subscriberRequest.Address} {subscriberRequest.Topic} : {e.Message}");
            }
            

            Console.WriteLine($"New client {subscriberRequest.Address} subscribed to:{subscriberRequest.Topic}");

            return Task.FromResult(new SubscriberReply()
            {
                IsSuccess = true,
            });
        }
    }
}
