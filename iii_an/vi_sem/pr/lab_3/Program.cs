using System;
using DnsClient;
using System.Net;

class Program
{
    static void Main(string[] args)
    {
        LookupClient dnsClient = new LookupClient();
        string dnsServer = null;
        
        while (true)
        {
            Console.WriteLine("Menu:");
            Console.WriteLine("1. Search by IP or name");
            Console.WriteLine("2. Select another DNS server");
                //Google 	        8.8.8.8 	8.8.4.4
                //Control D 	    76.76.2.0 	76.76.10.0
                //Quad9 	        9.9.9.9 	149.112.112.112
                //OpenDNS Home 	    208.67.222.222 	208.67.220.220
                //Cloudflare 	    1.1.1.1 	1.0.0.1
                //CleanBrowsing 	185.228.168.9 	185.228.169.9
                //Alternate DNS 	76.76.19.19 	76.223.122.150
                //AdGuard DNS 	    94.140.14.14 	94.140.15.15
            Console.WriteLine("3. Quit");

            Console.Write("Enter your choice: ");
            string choice = Console.ReadLine();

            switch (choice)
            {
                case "1":
                Console.Write("Enter the IP or name to search: ");
                string query = Console.ReadLine();

                if (dnsServer != null)
                {
                    dnsClient = new LookupClient(IPAddress.Parse(dnsServer));
                }

                IPAddress ipAddress;
                if (IPAddress.TryParse(query, out ipAddress))
                {
                    Console.WriteLine("IP detected");
                    var result = dnsClient.QueryReverse(IPAddress.Parse(ipAddress.ToString()));
                    var records = result.Answers;
                    if (records.Count > 0)
                    {
                        Console.WriteLine($"Found {records.Count} records:");
                        foreach (var record in records)
                        {
                            Console.WriteLine(record);
                        }
                    }
                    else
                    {
                        Console.WriteLine("No records found.");
                    }
                }
                else
                {
                    Console.WriteLine("maybe domain");
                    var result = dnsClient.Query(query, QueryType.A);
                    var records = result.Answers;

                    if (records.Count > 0)
                    {
                        Console.WriteLine($"Found {records.Count} records:");
                        foreach (var record in records)
                        {
                            Console.WriteLine(record);
                        }
                    }
                    else
                    {
                        Console.WriteLine("No records found.");
                    }
                }

                break;

                case "2":
                    Console.Write("Enter the DNS server IP: ");
                    dnsServer = Console.ReadLine();
                    try
                    {
                        var dnsServerName = dnsClient.GetHostName(IPAddress.Parse(dnsServer));
                        if(dnsServerName.Length > 0)
                        {
                            Console.WriteLine($"you have connected to '{dnsServerName}'");
                        }
                        else
                        {
                            Console.WriteLine("Invalid dns adress, or some kind of problem");
                        }
                    }
                    catch
                    {
                        Console.WriteLine("Error!!!");
                    }
                    
                    break;

                case "3":
                    return;

                default:
                    Console.WriteLine("Invalid choice.");
                    break;
            }

            Console.WriteLine();
        }
    }
}
