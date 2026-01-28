namespace Broker.Models
{
    public class Message
    {
        public string Article;
        public string Topic;
        public string PublisherName;

        public Message(string article, string topic, string publisherName)
        {
            Article = article;
            Topic = topic;
            PublisherName = publisherName;
        }
    }
}
