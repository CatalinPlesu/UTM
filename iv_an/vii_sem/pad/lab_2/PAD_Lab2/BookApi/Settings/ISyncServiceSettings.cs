namespace BookApi.Settings
{
    public interface ISyncServiceSettings
    {
        public string Host { get; set; }
        public string UpsertHttpMethod { get; set; }
        public string DeleteHttpMethod { get; set; }
    }
}
