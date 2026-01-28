using Server;

ServerSocket server = new ServerSocket("127.0.0.1", 26262);

server.BindAndListen(15);
server.StartWorkerThread();
server.AcceptAndReceive();