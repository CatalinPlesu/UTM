using Client;

ClientSocket client = new ClientSocket();
Console.WriteLine("Enter your desired ip");
string ip = Console.ReadLine() ?? "127.0.0.1";
client.Bind(ip, 26262);
client.receiveThread();

client.SendLoop();