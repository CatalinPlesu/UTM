using Grpc.Core;
using GrpcApp;
using System.Threading.Tasks;
using System;

namespace Receiver.Services
{
    public class NotificationService : Notifier.NotifierBase
    {
        public override Task<NotifyReply> Notify(NotifyRequest notify, ServerCallContext callContext)
        {

            Console.WriteLine($"Received {notify.Article} from {notify.PublisherName}");

            return Task.FromResult(new NotifyReply()
            {
                IsSuccess = true,
            });
        }
    }
}
