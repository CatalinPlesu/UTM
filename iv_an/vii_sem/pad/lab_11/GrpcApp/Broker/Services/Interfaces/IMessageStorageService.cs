using Broker.Models;

namespace Broker.Services.Interfaces
{
    public interface IMessageStorageService
    {
        void Add(Message message);
        Message GetNextMessage();
        bool IsEmpty();
    }
}
