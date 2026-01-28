using Client;

ClientSocket client = new ClientSocket();
Console.CancelKeyPress += new ConsoleCancelEventHandler(QuitHandler);
void QuitHandler(object sender, ConsoleCancelEventArgs e)
{
     e.Cancel = true;
     client.CloseClientSocket();
     Environment.Exit(0);
}

client.Connect("127.0.0.1", 26262);

client.SendLoop();