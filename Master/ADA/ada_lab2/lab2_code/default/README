Structura directoriului

* docker-compose.yml - fişier care conţine instrucţiuni de setare a unui cluster virtual
* Dockerfile - fişier docker care conţine comenzile pentru crearea unei imagini de container cu dependenţele necesare
* ruby_computer.rb - fişier executabil rezultant în urma compilării codului din lab1_openmp.cpp prin executarea fişierului compile.sh în interiorul containerului
* ruby_server.rb - implementarea unui ciot al algoritmului de rezolvare a cripto-puzzle-ului cu paralelizare automată realizată cu ajutorul librăriei openmp
* start_cluster.sh - comenzi bash de pornire a unui cluster virtual
* stop_cluster.sh - comenzi bash de oprire a unui cluster virtual

Paşi de urmat
1) Deschideţi fereastra bash în directoriul curent
2) Executaţi în bash comanda ./start_cluster.sh. Aceasta va seta un cluster in care sunt 3 nod-uri rabbitmq, lab2_producer şi lab2_consumer
3) Executati docker-compose ps. Veţi obtine un rezultat asemănător cu cel de mai jos:
    Name                        Command               State                                                                 Ports                                                               
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
default-lab2_consumer-1   /usr/sbin/sshd -D                Up      0.0.0.0:49177->22/tcp,:::49177->22/tcp                                                                                            
default-lab2_producer-1   /usr/sbin/sshd -D                Up      0.0.0.0:49176->22/tcp,:::49176->22/tcp                                                                                            
rabbitmq                  docker-entrypoint.sh rabbi ...   Up      15671/tcp, 0.0.0.0:15672->15672/tcp,:::15672->15672/tcp, 15691/tcp, 15692/tcp, 25672/tcp, 4369/tcp, 5671/tcp,                     
                                                                   0.0.0.0:5672->5672/tcp,:::5672->5672/tcp

4) Executaţi un două ferestre bash următoarele comenzi:
Fereastra bash #1
> docker exec -it default-lab2_producer-1 ruby ruby_server.rb

Fereastra bash #2
> docker exec -it default-lab2_consumer-1 ruby ruby_computer.rb

5) In ferastra bash #1 vă va aparea următorul mesaj:
> Press Ctrl+C to exit
> Enter difficulty of puzzle from 1 to 8:

6) Introduceti  cifra 6. Veţi primi următorul mesaj:
> 6
> Computation in progress...
> Response to crypto-puzzle is: Hello World1439621


Dificultăţi:
Dacă după ce aţi executat comanda start_cluster.sh executaţi comanda "docker compose ps" şi obţineţi  în dreptul containerul rabbitmq statutul ”Exit 0” similar celui de mai jos

 eugen@Copenhagen  ~/Projects/UTM/ADA/2022/lab2/lab2_code/default  "docker compose ps"
         Name                        Command               State                    Ports                 
----------------------------------------------------------------------------------------------------------
default-lab2_consumer-1   /usr/sbin/sshd -D                Up       0.0.0.0:49178->22/tcp,:::49178->22/tcp
default-lab2_producer-1   /usr/sbin/sshd -D                Up       0.0.0.0:49179->22/tcp,:::49179->22/tcp
rabbitmq                  docker-entrypoint.sh rabbi ...   Exit 0   

Aveţi de a face cu setarile incorecte a permisiunilor pentru mapa rabbitmq-data/log.
Incercaţi să efectuaţi următoarea comandă
sudo chmod -R 777  rabbitmq-data/log

