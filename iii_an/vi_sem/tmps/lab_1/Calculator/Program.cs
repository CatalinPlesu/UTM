using System;

namespace DesignPatterns.FactoryMethod
{
    abstract class Creator
    {
        public abstract INumber FactoryMethod(float Real, float Imaginary = 0);
    }
    class RealNumberCreator : Creator
    {
        public override INumber FactoryMethod(float Real, float Imaginary = 0)
        {
            var real = new RealNumber();
            real.Real = Real;
            return real;
        }
    }

    class ImaginaryNumberCreator : Creator
    {
        public override INumber FactoryMethod(float Real, float Imaginary = 0)
        {
            var imaginary = new InaginaryNumber();
            imaginary.Real = Real;
            imaginary.Imaginary = Imaginary;
            return imaginary;
        }
    }

    public interface INumber
    {
        float Real {get; set;}
        float Imaginary {get; set;}
        
        void Add(INumber number);
        void Substract(INumber number);

        void Print();
    }

    class RealNumber : INumber
    {
        public float Real {get; set;}
        public float Imaginary {get; set;}
        
        public void Add(INumber number)
        {
            this.Real += number.Real;
        }
        public void Substract(INumber number)
        {
            this.Real -= number.Real;
        }

        public void Print()
        {
            Console.WriteLine(this.Real);
        }
    }

    class InaginaryNumber : INumber
    {
        public float Real {get; set;}
        public float Imaginary {get; set;}
        
        public void Add(INumber number)
        {
            this.Real += number.Real;
            this.Imaginary += number.Imaginary;
        }
        public void Substract(INumber number)
        {
            this.Real -= number.Real;
            this.Imaginary -= number.Imaginary;
        }

        public void Print()
        {
            Console.Write(this.Real);
            if(this.Imaginary > 0){
                Console.Write("+");
            }
            Console.Write(this.Imaginary);
            Console.WriteLine("i");
        }
    }


    class Program
    {
        static void Main(string[] args)
        {
            Creator realCreator = new RealNumberCreator();
            Creator imaginaryCreator = new ImaginaryNumberCreator();
            INumber a = realCreator.FactoryMethod(5);
            INumber b = realCreator.FactoryMethod(-2);
            a.Add(b);
            a.Print();

            INumber c = imaginaryCreator.FactoryMethod(1, 1);
            INumber d = imaginaryCreator.FactoryMethod(2, -3);
            c.Substract(d);
            c.Print();
            c.Add(a);
            c.Print();
        }
    }
}