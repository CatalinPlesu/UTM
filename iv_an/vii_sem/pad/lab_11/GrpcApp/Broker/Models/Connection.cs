using Grpc.Net.Client;

namespace Broker.Models
{
    public class Connection
    {
        public Connection(string topic, string address)
        {
            Topic = topic;
            Address = address;
            grpcChannel = GrpcChannel.ForAddress(address);
        }
        public string Topic { get; }
        public string Address { get; }

        public GrpcChannel grpcChannel { get; }
    }
}
