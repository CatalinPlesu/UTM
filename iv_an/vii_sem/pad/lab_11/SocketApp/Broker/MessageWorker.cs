using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace Broker
{
    public class MessageWorker
    {
        private const int TIME_TO_SLEEP = 500;

        public void DoSendMessageWork()
        {
            while (true) 
            {
                while (!PayloadStorage.IsEmpty())
                {
                    var payload = PayloadStorage.GetNext();

                    if (payload != null)
                    {
                        var connections = ConnectionStorage.GetConnectionsByTopic(payload.Topic);

                        foreach ( var connection in connections )
                        {
                            var payloadString = JsonConvert.SerializeObject(payload);
                            byte[] data = Encoding.UTF8.GetBytes(payloadString);
                            connection.Socket.Send(data);
                        }
                    }
                }

                Thread.Sleep(TIME_TO_SLEEP);    
            }

        }
    }
}
