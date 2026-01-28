using Broker.Services.Interfaces;
using Grpc.Core;
using GrpcApp;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace Broker.Services
{
    public class SenderWorker : IHostedService
    {
        private Timer _timer;
        private const int _timeToWait = 2000;
        private readonly IConnectionStorageServices _connectionStorage;
        private readonly IMessageStorageService _messageStorage;

        public SenderWorker(IServiceScopeFactory serviceScopeFactory)
        {
            using (var scope = serviceScopeFactory.CreateScope())
            {
                _connectionStorage = scope.ServiceProvider.GetRequiredService<IConnectionStorageServices>();
                _messageStorage = scope.ServiceProvider.GetRequiredService<IMessageStorageService>();
            }
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            _timer = new Timer(DoSendWork, null, 0, _timeToWait);
            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            _timer.Change(Timeout.Infinite, 0);
            return Task.CompletedTask;
        }

        private void DoSendWork(object state)
        {
            while (!_messageStorage.IsEmpty())
            {
                var message = _messageStorage.GetNextMessage();

                if (message != null) 
                {
                    var connections = _connectionStorage.GetConnectionsByTopic(message.Topic);

                    foreach (var connection in connections) 
                    {
                        var client = new Notifier.NotifierClient(connection.grpcChannel);
                        var request = new NotifyRequest() { Article = message.Article, PublisherName = message.PublisherName };

                        try
                        {
                            var reply = client.Notify(request);
                            Console.WriteLine($"Notified subscriber {connection.Address} with {message.Article} {message.PublisherName}. Response is {reply.IsSuccess}");

                        }
                        catch (RpcException exception)
                        {
                            if (exception.StatusCode == StatusCode.Internal)
                            {
                                _connectionStorage.Remove(connection.Address);
                            }

                            Console.WriteLine($"Error notifying subscriber {connection.Address} : {exception.Message}");
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine($"Error notifying subscriber {connection.Address} : {e.Message}");
                        }
                   }
                }
            }
        }
    }
}
