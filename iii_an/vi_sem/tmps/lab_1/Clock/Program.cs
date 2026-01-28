using System;
using System.Threading;

namespace DesignPatterns.Singleton
{
    public sealed class GlobalClock
    {
        private GlobalClock() { }
        private int _hours;
        private int _minutes;
        private int _seconds;

        private static GlobalClock _instance;

        public static GlobalClock GetInstance()
        {
            if (_instance == null)
            {
                _instance = new GlobalClock();
            }
            return _instance;
        }

        public void SetTime(int h, int m, int s)
        {
            this._hours = h;
            this._minutes = m;
            this._seconds = s;
        }

        public void Run()
        {
            while(true)
            {
                this._seconds+=1;
                if(this._seconds > 59) {
                    this._seconds -= 60;
                    this._minutes += 1;
                }
                if(this._minutes > 59)
                {
                    this._minutes -= 60;
                    this._hours += 1;
                }
                if(this._hours > 23)
                {
                    this._hours -= 24;
                }
                Console.WriteLine($"{this._hours}:{this._minutes}:{this._seconds}");
                Thread.Sleep(1000);
            }
        }
        
    }

    class Program
    {
        static void Main(string[] args)
        {
            // The client code.
            GlobalClock s1 = GlobalClock.GetInstance();
            GlobalClock s2 = GlobalClock.GetInstance();

            if (s1 == s2)
            {
                Console.WriteLine("Singleton works, both variables contain the same instance.");
            }
            else
            {
                Console.WriteLine("Singleton failed, variables contain different instances.");
            }
            s1.SetTime(DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            s2.Run();
        }
    }
}