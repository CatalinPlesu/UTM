using System;
using System.Collections.Generic;

namespace DesignPatterns.ChainOfResponsibility.Command
{
    public static class Globals
    {
        public static string Username = "";
        public static string Password = "";
        public static decimal Balance = 888;
    }

    public interface ICommand
    {
        bool Execute();
    }

    class LoginCommand : ICommand
    {
        private string _username = string.Empty;
        private string _password = string.Empty;

        public LoginCommand(string username, string password)
        {
            this._username = username;
            this._password = password;
        }

        public bool Execute()
        {
            if(this._username != null && this._password != null)
            {
                Globals.Username = this._username;
                Globals.Password = this._password;
                Console.WriteLine($"Loggend in successfully as {this._username}");
                return false;
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    class CheckAuthentificatedCommand : ICommand
    {
        public bool Execute()
        {
            if(Globals.Username != null && Globals.Password != null)
            {
                Console.WriteLine($"Loggend in as {Globals.Username}");
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    class PayCommand : ICommand
    {
        private decimal _amount;
        public PayCommand(decimal amount)
        {
            this._amount = amount;
        }
        public bool Execute()
        {
            if(Globals.Balance >= this._amount)
            {
                Globals.Balance -= this._amount;
                Console.WriteLine($"Remaining balance {Globals.Balance}");
                return true;
            }
            else
            {
                return false;
            }
        }
    }


    public interface IHandler
    {
        IHandler SetNext(IHandler handler);
        
        object Handle(object request);
    }

    abstract class AbstractHandler : IHandler
    {
        private IHandler _nextHandler;

        public IHandler SetNext(IHandler handler)
        {
            this._nextHandler = handler;
            
            return handler;
        }
        
        public virtual object Handle(object request)
        {
            if (this._nextHandler != null)
            {
                return this._nextHandler.Handle(request);
            }
            else
            {
                return null;
            }
        }
    }


    class LogInHandler : AbstractHandler
    {
        public override object Handle(object request)
        {
            if (request.GetType() == typeof(LoginCommand))
            {
                return ((LoginCommand)request).Execute();
            }
            else
            {
                return base.Handle(request);
            }
        }
    }
    
    class CheckAutentificatedHandler : AbstractHandler
    {
        public override object Handle(object request)
        {
            if (request.GetType() == typeof(CheckAuthentificatedCommand))
            {
                return ((CheckAuthentificatedCommand)request).Execute();
            }
            else
            {
                return base.Handle(request);
            }
        }
    }

    class PayHandler : AbstractHandler
    {
        public override object Handle(object request)
        {
            if (request.GetType() == typeof(PayCommand))
            {
                return ((PayCommand)request).Execute();
            }
            else
            {
                return base.Handle(request);
            }
        }
    }
    class Client
    {
        public static void ClientCode(AbstractHandler handler)
        {
            var login = new LoginCommand("catalin", "password");
            var authentificated = new CheckAuthentificatedCommand();
            var pay = new PayCommand(333);

            foreach (var command in new List<object> { login, authentificated, pay })
            {

                var result = handler.Handle(command);

                if (result != null)
                {
                    Console.WriteLine($"Client: executing {command.GetType()}");
                    Console.WriteLine($"{command.GetType()} executed with result {result}");
                }
                else
                {
                    // not this command
                }
            }
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // login chain
            var login = new LogInHandler();

            // payment chain
            var authentificated = new CheckAutentificatedHandler();
            var pay = new PayHandler();

            authentificated.SetNext(pay);
            var payChain = authentificated;

            Console.WriteLine("Login\n");
            Client.ClientCode(login);
            Console.WriteLine();

            Console.WriteLine("Pay\n");
            Client.ClientCode(pay);

            Console.WriteLine("Pay\n");
            Client.ClientCode(pay);

            Console.WriteLine("Pay\n");
            Client.ClientCode(pay);
        }
    }
}