using Lab_2_UDP;

string multicastIP = "239.5.6.7";
int port = 5002;

UDPChat chat = new UDPChat(multicastIP, port);
Console.WriteLine("Input format: <IP>:<TEXT>");
Console.WriteLine("IP = 0 -> Multicast");
chat.StartReceiveLoop();
while(true)
{
    try
    {
        string input = Console.ReadLine() ?? "";
        var splited = input.Split(":");
        var toIP = splited[0];
        var text = splited[1];

        if (toIP == "0")
        {
            chat.SendToGeneral(text);
        }
        else
        {
            chat.SendTo(toIP, text);
        }
    }
    catch(Exception e)
    {
        Console.WriteLine($"Exception: {e.Message}");
    }
}
