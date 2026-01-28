using System;
using System.Collections.Generic;

namespace DesignPatterns.ObserverState
{
    public interface IObserver
    {
        void Update(State state);
    }

    public interface ISubject
    {
        void Attach(IObserver observer);

        void Detach(IObserver observer);

        void Notify(State state);
    }

    public class Subject : ISubject
    {
        private List<IObserver> _observers = new List<IObserver>();

        public void Attach(IObserver observer)
        {
            Console.WriteLine("Subject: Attached an observer.");
            this._observers.Add(observer);
        }

        public void Detach(IObserver observer)
        {
            this._observers.Remove(observer);
            Console.WriteLine("Subject: Detached an observer.");
        }

        public void Notify(State state)
        {
            Console.WriteLine("Subject: Notifying observers...");

            foreach (var observer in _observers)
            {
                observer.Update(state);
            }
        }
    }

    class LoginObserver : IObserver
    {
        public void Update(State state)
        {
            if (state.GetType() == typeof(AuthenticatedState)) 
            {
                Console.WriteLine("LoginObserver: Reacted to the event.");
            }
        }
    }

    class LogoutObserver : IObserver
    {
        public void Update(State state)
        {
            if (state.GetType() == typeof(UnauthenticatedState)) 
            {
                Console.WriteLine("LogoutObserver: Reacted to the event.");
            }
        }
    }

    public class Context
    {
        private State _state = null;
        public Subject subject = new Subject();

        public Context(State state)
        {
            this.TransitionTo(state);
        }

        public void TransitionTo(State state)
        {
            Console.WriteLine($"Context: Transition to {state.GetType().Name}.");
            this._state = state;
            this._state.SetContext(this);
        }

        public void LoginRequest()
        {
            this._state.LoginHandle();
        }

        public void LogoutRequest()
        {
            this._state.LogoutHandle();
        }

        public void PayRequest()
        {
            this._state.PayHandle();
        }
    }

    public abstract class State
    {
        protected Context _context;

        public void SetContext(Context context)
        {
            this._context = context;
        }

        public abstract void LoginHandle(); 

        public abstract void LogoutHandle();

        public abstract void PayHandle();
    }

    class UnauthenticatedState : State
    {
        public override void LoginHandle()
        {
            Console.WriteLine("Login Success"); 
            this._context.TransitionTo(new AuthenticatedState());  
            this._context.subject.Notify(this);  
        }

        public override void LogoutHandle()
        {
            Console.WriteLine("Already unauthenticated"); 
        }

        public override void PayHandle()
        {
            Console.WriteLine("Can't pay, unauthenticated"); 
        }
    }

    class AuthenticatedState : State
    {
        public override void LoginHandle()
        {
            Console.WriteLine("Already authenticated"); 
        }

        public override void LogoutHandle()
        {
            Console.WriteLine("Logout Success"); 
            this._context.TransitionTo(new UnauthenticatedState());
            this._context.subject.Notify(this);  
    }

    public override void PayHandle()
    {
        Console.WriteLine("Payment Successful"); 
    }
}

class Program
{
    static void Main(string[] args)
    {
        var context = new Context(new UnauthenticatedState());

        var loginObserver = new LoginObserver();
        context.subject.Attach(loginObserver);

        IObserver logoutObserver = new LogoutObserver();
        context.subject.Attach(logoutObserver);

        context.LoginRequest();
        context.LoginRequest();
        context.PayRequest();
        context.LogoutRequest();
        context.LogoutRequest();
        context.PayRequest();
    }
}
}
