using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace MyMail.MailClient.Entities
{
    public class Server
    {
        public string ServerName { get; set; }

        public int SmtpPort { get; set; } 

        public int Pop3Port { get; set; }

        public int ImapPort { get; set; }
    }
}
