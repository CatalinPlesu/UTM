using Broker.Models;
using Broker.Services.Interfaces;
using Grpc.Core;
using GrpcApp;
using System;
using System.Threading.Tasks;

namespace Broker.Services
{
    public class PublisherService : Publisher.PublisherBase
    {
        private readonly IMessageStorageService _messageStorage;
        public PublisherService(IMessageStorageService messageStorage)
        {
            _messageStorage= messageStorage;
        }

        public override Task<PublishReply> PublishMessage(PublishRequest publishRequest, ServerCallContext callContext) {

            Console.WriteLine(publishRequest.PublisherName + " posted " + publishRequest.Article + " article on " + publishRequest.Topic + " topic");

            var message = new Message(publishRequest.Article, publishRequest.Topic, publishRequest.PublisherName);

            _messageStorage.Add(message);

            return Task.FromResult(new PublishReply()
            {
                IsSuccess = true,
            });
        }
    }
}
