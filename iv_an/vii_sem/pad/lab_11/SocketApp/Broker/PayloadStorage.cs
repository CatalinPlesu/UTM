using Publisher;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Text;

namespace Broker
{
    static class PayloadStorage
    {
        private static ConcurrentQueue<Payload> _payloadsQueue;

        static PayloadStorage()
        {
            _payloadsQueue = new ConcurrentQueue<Payload>();
        }
        public static void AddPayload(Payload payload) 
        {
            _payloadsQueue.Enqueue(payload);
        }

        public static Payload GetNext()
        {
            Payload payload = null;

            _payloadsQueue.TryDequeue(out payload);

            return payload;
        }

        public static bool IsEmpty()
        {
            return _payloadsQueue.IsEmpty;
        }
    }
}
