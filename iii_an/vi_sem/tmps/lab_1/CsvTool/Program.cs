using System;
using System.Collections.Generic;

namespace DesignPatterns.Builder_Prototype
{
    public interface ICsvBuilder
    {
        void Reset();
        void AddRow(params string[] values);
        void AddColumn(params string[] values);
        Csv GetCsv();
    }
    
    public class CsvBuilder : ICsvBuilder
    {
        private Csv _csv = new Csv();

        public CsvBuilder()
        {
            this.Reset();
        }
        
        public void Reset()
        {
            this._csv = new Csv();
        }
        
        public void AddRow(params string[] values)
        {
            var row = new List<String>();
            foreach(string value in values)
            {
                row.Add(value);
            }
            this._csv.Add(row);
        }

        public void AddColumn(params string[] values)
        {
            this._csv.AddColumn(values);
        }
        
        public Csv GetCsv()
        {
            Csv result = this._csv;

            this.Reset();

            return result;
        }
    }
    
    public class Csv
    {
        private List<List<String>> _rows = new List<List<String>>();
        
        public void Add(List<String> row)
        {
            this._rows.Add(row);
        }

        public void AddColumn(params string[] values)
        {
            int count = 0;
            foreach(string value in values)
            {
                count += 1;
            }
            if (count != _rows.Count)
            {
                Console.WriteLine("Error: Incompatible column");
                return;
            }
            count = 0;
            foreach(string value in values)
            {
                _rows[count].Add(value);
                count += 1;
            }
        }
        
        public void ListRows()
        {

            for (int i = 0; i < this._rows.Count; i++)
            {
                for (int j = 0; j < this._rows[i].Count; j++)
                {
                    if (j != 0)
                    {
                        Console.Write(", ");
                    }
                    Console.Write(this._rows[i][j]);
                }
                Console.WriteLine();
            }
        }

        public Csv Clone()
        {
            Csv clonedCsv = new Csv();
            foreach (var row in _rows)
            {
                List<string> clonedRow = new List<string>(row);
                clonedCsv.Add(clonedRow);
            }
            return clonedCsv;
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            CsvBuilder csvBulder = new CsvBuilder();

            csvBulder.AddRow("Name", "Age", "Gender");
            csvBulder.AddRow("Alice", "30", "Female");
            csvBulder.AddRow("Bob", "25", "Male");
            csvBulder.AddRow("Charlie", "40", "Male");
            csvBulder.AddColumn("Income", "10", "20", "30");
            csvBulder.AddColumn("Income", "10", "20");
            Csv csv = csvBulder.GetCsv();

            Csv csv_clone = csv.Clone();
            var list = new List<string>();
            list.Add("Alice");
            list.Add("30");
            list.Add("Female");
            list.Add("40");
            csv_clone.Add(list  );

            csv.ListRows();
            csv_clone.ListRows();
        }
    }
}