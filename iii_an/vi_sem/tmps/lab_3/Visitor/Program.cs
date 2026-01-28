using System;
using System.Collections.Generic;

namespace DesignPatterns.Behavioural.Visitor
{
    public interface IProduct
    {
        void Accept(IVisitor visitor);
    }

    public class Clothing : IProduct
    {
        public decimal Price { get; set; }
        public string Brand { get; set; }
        public string Name { get; set; }
        
        public Clothing(){}

        public Clothing(decimal price, string brand, string name)
        {
            Price = price;
            Brand = brand;
            Name = name;
        }
        
        public void Accept(IVisitor visitor)
        {
            visitor.VisitClothing(this);
        }

        public string ExclusiveMethodOfClothing()
        {
            return "";
        }
    }

    public class Electronics : IProduct
    {
        public decimal Price { get; set; }
        public double Weight { get; set; }
        public double PowerConsumption { get; set; }
        public string Name { get; set; }
        
        public Electronics(){}

        public Electronics(decimal price, double weight, double powerConsumption, string name)
        {
            Price = price;
            Weight = weight;
            PowerConsumption = powerConsumption;
            Name = name;
            
        }
        
        public void Accept(IVisitor visitor)
        {
            visitor.VisitElectronics(this);
        }

        public string SpecialMethodOfElectronics()
        {
            return "";
        }
    }

    public class Furniture : IProduct
    {
        public decimal Price { get; set; }
        public double Width { get; set; }
        public double Height { get; set; }
        public double Depth { get; set; }
        public string Name { get; set; }
        
        public Furniture(){}

        public Furniture(decimal price, double width, double height, double depth, string name)
        {
            Price = price;
            Width = width;
            Height = height;
            Depth = depth;
            Name = name;
        }
        
        public void Accept(IVisitor visitor)
        {
            visitor.VisitFurniture(this);
        }
    }



    public interface IVisitor
    {
        void VisitClothing(Clothing element);

        void VisitElectronics(Electronics element);
        void VisitFurniture(Furniture element);
    }

    class WebVisitor : IVisitor
    {
        public void VisitClothing(Clothing element)
        {
            Console.WriteLine();
            Console.WriteLine("<div class='clothing'>");
            Console.WriteLine("    <p>Name: " + element.Name + "</p>");
            Console.WriteLine("    <p>Price: " + element.Price + "</p>");
            Console.WriteLine("    <p>Brand: " + element.Brand + "</p>");
            Console.WriteLine("</div>");
        }

        public void VisitElectronics(Electronics element)
        {
            Console.WriteLine();
            Console.WriteLine("<div class='electronics'>");
            Console.WriteLine("    <p>Name: " + element.Name + "</p>");
            Console.WriteLine("    <p>Price: " + element.Price + "</p>");
            Console.WriteLine("    <p>Weight: " + element.Weight + "</p>");
            Console.WriteLine("    <p>Power Consumption: " + element.PowerConsumption + "</p>");
            Console.WriteLine("</div>");
        }

        public void VisitFurniture(Furniture element)
        {
            Console.WriteLine();
            Console.WriteLine("<div class='furniture'>");
            Console.WriteLine("    <p>Name: " + element.Name + "</p>");
            Console.WriteLine("    <p>Price: " + element.Price + "</p>");
            Console.WriteLine("    <p>Width: " + element.Width + "</p>");
            Console.WriteLine("    <p>Height: " + element.Height + "</p>");
            Console.WriteLine("    <p>Depth: " + element.Depth + "</p>");
            Console.WriteLine("</div>");
        }
    }

    class JsonVisitor : IVisitor
    {
        public void VisitClothing(Clothing element)
        {
            Console.WriteLine("{");
            Console.WriteLine("\"type\": \"clothing\",");
            Console.WriteLine("\"name\": \"" + element.Name + "\",");
            Console.WriteLine("\"price\": \"" + element.Price + "\",");
            Console.WriteLine("\"brand\": \"" + element.Brand + "\"");
            Console.WriteLine("}");
        }

        public void VisitElectronics(Electronics element)
        {
            Console.WriteLine("{");
            Console.WriteLine("\"type\": \"electronics\",");
            Console.WriteLine("\"name\": \"" + element.Name + "\",");
            Console.WriteLine("\"price\": \"" + element.Price + "\",");
            Console.WriteLine("\"weight\": \"" + element.Weight + "\",");
            Console.WriteLine("\"power_consumption\": \"" + element.PowerConsumption + "\"");
            Console.WriteLine("}");
        }

        public void VisitFurniture(Furniture element)
        {
            Console.WriteLine("{");
            Console.WriteLine("\"type\": \"furniture\",");
            Console.WriteLine("\"name\": \"" + element.Name + "\",");
            Console.WriteLine("\"price\": \"" + element.Price + "\",");
            Console.WriteLine("\"width\": \"" + element.Width + "\",");
            Console.WriteLine("\"height\": \"" + element.Height + "\",");
            Console.WriteLine("\"depth\": \"" + element.Depth + "\"");
            Console.WriteLine("}");
        }
    }


    class CliVisitor : IVisitor
    {
        public void VisitClothing(Clothing element)
        {
            Console.WriteLine();
            Console.WriteLine("Clothing:");
            Console.WriteLine("Name: " + element.Name);
            Console.WriteLine("Price: " + element.Price);
            Console.WriteLine("Brand: " + element.Brand);
        }

        public void VisitElectronics(Electronics element)
        {
            Console.WriteLine();
            Console.WriteLine("Electronics:");
            Console.WriteLine("Name: " + element.Name);
            Console.WriteLine("Price: " + element.Price);
            Console.WriteLine("Weight: " + element.Weight);
            Console.WriteLine("Power Consumption: " + element.PowerConsumption);
        }

        public void VisitFurniture(Furniture element)
        {
            Console.WriteLine();
            Console.WriteLine("Furniture:");
            Console.WriteLine("Name: " + element.Name);
            Console.WriteLine("Price: " + element.Price);
            Console.WriteLine("Width: " + element.Width);
            Console.WriteLine("Height: " + element.Height);
            Console.WriteLine("Depth: " + element.Depth);
        }
    }

    public class Client
    {
        public static void ClientCode(List<IProduct> components, IVisitor visitor)
        {
            foreach (var component in components)
            {
                component.Accept(visitor);
            }
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            List<IProduct> components = new List<IProduct>
            {
                new Clothing(2000, "asics", "gel 9"),
                new Electronics(4500, 0.15, 0.4, "Pixel 6"),
                new Furniture(100, 0.5, 0.5, 0.5, "Cutie")
            };

            var visitor1 = new WebVisitor();
            Client.ClientCode(components,visitor1);

            Console.WriteLine();

            var visitor2 = new JsonVisitor();
            Client.ClientCode(components, visitor2);

            var visitor3 = new CliVisitor();
            Client.ClientCode(components, visitor3);
        }
    }
}