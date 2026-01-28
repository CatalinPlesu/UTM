using System;
using System.Collections.Generic;
using System.IO;

namespace OpenClosePrinciple
{
    public interface IFileReader
    {
        List<string> Read(string filePath);
    }

    public class TextFileReader : IFileReader
    {
        public virtual List<string> Read(string filePath)
        {
            try
            {
                var lines = File.ReadAllLines(filePath);
                return new List<string>(lines);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error reading text file: {ex.Message}");
                return null;
            }
        }
    }

    public class CsvFileReader : TextFileReader
    {
        public override List<string> Read(string filePath)
        {
            try
            {
                var lines = File.ReadAllLines(filePath);
                var data = new List<string>();
                foreach (var line in lines)
                {
                    var fields = line.Split(',');
                    data.Add(string.Join(",", fields));
                }
                return data;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error reading CSV file: {ex.Message}");
                return null;
            }
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            var textFileReader = new TextFileReader();
            var csvFileReader = new CsvFileReader();

            string currentDirectory = Directory.GetCurrentDirectory();
            string textFilePath = Path.Combine(currentDirectory, "f.txt");
            string csvFilePath = Path.Combine(currentDirectory, "f.csv");

            var textLines = textFileReader.Read(textFilePath);
            if (textLines != null)
            {
                Console.WriteLine("Text file contents:");
                foreach (var line in textLines)
                {
                    Console.WriteLine(line);
                }
            }

            var csvData = csvFileReader.Read(csvFilePath);
            if (csvData != null)
            {
                Console.WriteLine("CSV file contents:");
                foreach (var fieldList in csvData)
                {
                    foreach (var field in fieldList)
                    {
                        Console.Write(field);
                    }
                    Console.WriteLine();
                }
            }
        }
    }
}
