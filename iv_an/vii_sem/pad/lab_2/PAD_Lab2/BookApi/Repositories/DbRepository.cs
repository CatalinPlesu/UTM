using BookApi.Settings;
using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Linq;
using Util.Models;

namespace BookApi.Repositories
{
    public class DbRepository<T> : IDbRepository<T> where T : DbDocument
    {
        private readonly IMongoDatabase _db;
        private readonly IMongoCollection<T> _collection;

        public DbRepository(IDbSettings db)
        {
            _db = new MongoClient(db.ConnectionString).GetDatabase(db.DatabaseName);

            string tableName = typeof(T).Name.ToLower();
            _collection = _db.GetCollection<T>(tableName);
        }
        public void DeleteRecord(Guid id)
        {
            _collection.DeleteOne(doc => doc.Id == id);
        }

        public List<T> GetAllRecords()
        {
            var records = _collection.Find(new BsonDocument()).ToList();
            return records;
        }

        public T GetRecordById(Guid id)
        {
            return _collection.Find(doc => doc.Id == id).FirstOrDefault();
        }

        public T InsertRecord(T record)
        {
            _collection.InsertOne(record);

            return record;
        }

        public void UpsertRecord(T record)
        {
            _collection.ReplaceOne(doc => doc.Id == record.Id, record, 
                new ReplaceOptions() { IsUpsert = true});
        }
    }
}
