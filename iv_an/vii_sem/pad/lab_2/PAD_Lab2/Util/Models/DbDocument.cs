using MongoDB.Bson.Serialization.Attributes;
using System;

namespace Util.Models
{
    public abstract class DbDocument
    {
        [BsonId]
        public Guid Id { get; set; }
        public DateTime LastChangedAt { get; set; }

    }
}
