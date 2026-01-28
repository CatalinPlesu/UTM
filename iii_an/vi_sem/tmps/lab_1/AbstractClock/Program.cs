using System;

namespace DesignPatterns.AbstractFactory
{
    public interface IAbstractFactory
    {
        IAbstractClock CreateClock();

    }

    class Clock12FormatFactory : IAbstractFactory
    {
        public IAbstractClock CreateClock()
        {
            return new Clock12();
        }
    }

    class Clock24FormatFactory : IAbstractFactory
    {
        public IAbstractClock CreateClock()
        {
            return new Clock24();
        }
    }

    public interface IAbstractClock
    {
        public void SetTime(int h, int m, int s);
        public void Verify();
        public void Run();
    }

    class Clock12 : IAbstractClock
    {
        private int _hours;
        private int _minutes;
        private int _seconds;
        public void SetTime(int h, int m, int s)
        {
            this._hours = h;
            this._minutes = m;
            this._seconds = s;
            this.Verify();
        }
        public void Verify()
        {
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
        }
        public void Run()
        {
            while(true)
            {
                this._seconds+=1;
                string t = "am";
                if(this._hours > 12)
                {
                    t = "pm";
                    Console.Write(this._hours-12);
                }
                else{
                    Console.Write(this._hours);
                }
                Console.WriteLine($":{this._minutes}:{this._seconds}|{t}");
                Thread.Sleep(1000);
            }

        }
    }

    class Clock24 : IAbstractClock
    {
        private int _hours;
        private int _minutes;
        private int _seconds;
        public void SetTime(int h, int m, int s)
        {
            this._hours = h;
            this._minutes = m;
            this._seconds = s;
        }        
        public void Verify()
        {
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
        }
        public void Run()
        {
            while(true)
            {
                this._seconds+=1;
                Console.WriteLine($"{this._hours}:{this._minutes}:{this._seconds}");
                Thread.Sleep(1000);
            }
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            var clockFactory = new Clock12FormatFactory();
            var clock = clockFactory.CreateClock();
            clock.SetTime(DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            clock.Run();
        }
    }
}