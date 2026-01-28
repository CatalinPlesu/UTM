using System;
using System.Collections.Generic;
using Util.Models;

namespace BookApi.Repositories
{
    public interface IDbRepository<T> where T : DbDocument
    {
        List<T> GetAllRecords();
        T InsertRecord(T record);
        T GetRecordById(Guid id);

        //daca nu avem asa record, il cream. daca exista il actualizam
        void UpsertRecord(T record);
        void DeleteRecord(Guid id);
    }
}
