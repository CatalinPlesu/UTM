using System.Net.Sockets;

namespace Util
{
    public class ConnectionInfo
    {
        private const int BUFF_SIZE = 1024;
        public Socket Socket { get; set; }
        public string Address { get; set; }
        public string Topic { get; set; }
        public byte[] Buffer { get; set; }

        public ConnectionInfo()
        {
            Buffer = new byte[BUFF_SIZE]; 
        }
    }
}
