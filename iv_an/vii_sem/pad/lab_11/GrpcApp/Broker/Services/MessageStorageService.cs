using Broker.Models;
using Broker.Services.Interfaces;
using System.Collections.Concurrent;

namespace Broker.Services
{
    class MessageStorageService : IMessageStorageService
    {
        private readonly ConcurrentQueue<Message> _messages;

        public MessageStorageService()
        {
           _messages = new ConcurrentQueue<Message>();
        }

        public void Add(Message message)
        {
            _messages.Enqueue(message);
        }

        public Message GetNextMessage()
        {
            Message message;
            _messages.TryDequeue(out message);
            return message;
        }

        public bool IsEmpty()
        {
            return _messages.IsEmpty;
        }
    }
}
