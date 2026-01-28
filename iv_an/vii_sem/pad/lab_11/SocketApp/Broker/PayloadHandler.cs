using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Util;
using Publisher;
using Newtonsoft.Json;

namespace Broker
{
    public class PayloadHandler
    {
        public static void Handle(byte[] payloadData, ConnectionInfo connectionInfo)
        {
            var payloadString = Encoding.UTF8.GetString(payloadData);

            if (payloadString.StartsWith("subscribe#")) 
            {   
                connectionInfo.Topic = payloadString.Split("subscribe#").LastOrDefault();
                ConnectionStorage.Add(connectionInfo);
            }
            else
            {
                Payload payload = JsonConvert.DeserializeObject<Payload>(payloadString);
                PayloadStorage.AddPayload(payload);
                Console.WriteLine($"{payload.Article} was posted on {payload.Topic} topic.");
            }
            
        }
    }
}
