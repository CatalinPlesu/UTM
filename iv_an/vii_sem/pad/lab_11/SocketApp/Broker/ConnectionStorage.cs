using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Util;

namespace Broker
{
    static class ConnectionStorage
    {
        private static List<ConnectionInfo> _connections;
        private static object _locker;

        static ConnectionStorage()
        {
            _connections = new List<ConnectionInfo>();
            _locker = new object();
        }

        public static void Add(ConnectionInfo connection)
        {
            lock (_locker)
            {
                _connections.Add(connection);
            }
        }

        public static void Remove(string address) 
        {
            lock(_locker) 
            {
                _connections.RemoveAll(x => x.Address == address);
            }
        }

        public static List<ConnectionInfo> GetConnectionsByTopic(string topic)
        {
            List<ConnectionInfo> filteredConnections;
            
            lock (_locker)
            {
                filteredConnections = _connections.Where(x => x.Topic == topic).ToList();
            }

            return filteredConnections;
        }
    }
}
