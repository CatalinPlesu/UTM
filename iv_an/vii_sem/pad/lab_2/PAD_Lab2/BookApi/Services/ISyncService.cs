using System.Net.Http;
using Util.Models;

namespace BookApi.Services
{
    public interface ISyncService<T> where T : DbDocument
    {
        HttpResponseMessage Upsert(T record);
        HttpResponseMessage Delete(T record);
    }
}
