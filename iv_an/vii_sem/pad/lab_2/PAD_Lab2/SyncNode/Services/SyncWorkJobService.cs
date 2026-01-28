using Microsoft.Extensions.Hosting;
using SyncNode.Settings;
using System;
using System.Collections.Concurrent;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Util.Models;
using Util.Utilities;

namespace SyncNode.Services
{
    public class SyncWorkJobService : IHostedService
    {
        private Timer _timer;

        private readonly ConcurrentDictionary<Guid, SyncEntity> _documents =
            new ConcurrentDictionary<Guid, SyncEntity>();
        private readonly IBookApiSettings _bookApiSettings;

        public SyncWorkJobService(IBookApiSettings bookApiSettings)
        {
            _bookApiSettings = bookApiSettings;
        }

        public void AddItem(SyncEntity entity)
        {
            SyncEntity document = null;
            bool isPresent = _documents.TryGetValue(entity.Id, out document);

            if (!isPresent || (isPresent && entity.LastChangedAt > document.LastChangedAt)) 
            {
                _documents[entity.Id] = entity;
            }
        }

        Task IHostedService.StartAsync(CancellationToken cancellationToken)
        {
            _timer = new Timer(DoSendWork, null, TimeSpan.Zero, TimeSpan.FromSeconds(20));

            return Task.CompletedTask;
        }

        Task IHostedService.StopAsync(CancellationToken cancellationToken)
        {
            _timer?.Change(Timeout.Infinite, 0);

            return Task.CompletedTask;
        }

        private void DoSendWork(object state)
        {
            foreach (var doc in _documents) 
            {
                SyncEntity entity = null;
                var isPresent = _documents.TryRemove(doc.Key, out entity);

                if (isPresent)
                {
                    var receivers = _bookApiSettings.Hosts.Where(x => !x.Contains(entity.Origin));

                    foreach (var receiver in receivers)
                    {
                        var url = $"{receiver}/{entity.ObjectType}/sync";

                        try
                        {
                            var result = HttpClientUtility.SendJson(entity.JsonData, url, entity.SyncType);

                            if (!result.IsSuccessStatusCode)
                            {
                                
                            }
                        }
                        catch (Exception e)
                        {
                             
                        }
                    }
                }
            }
        }
    }
}
