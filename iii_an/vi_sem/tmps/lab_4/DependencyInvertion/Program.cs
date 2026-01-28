using System;
using System.Collections.Generic;
using System.IO;

public interface ICSVFileReader
{
    List<List<string>> ReadCSVFile(string filePath);
}

public class CSVFileReader : ICSVFileReader
{
    public List<List<string>> ReadCSVFile(string filePath)
    {
        if (!File.Exists(filePath))
        {
            throw new FileNotFoundException("CSV file not found", filePath);
        }

        List<List<string>> csvData = new List<List<string>>();
        using (var reader = new StreamReader(filePath))
        {
            while (!reader.EndOfStream)
            {
                var line = reader.ReadLine();
                var values = line.Split(',');
                csvData.Add(new List<string>(values));
            }
        }
        return csvData;
    }
}

public class CSVTable
{
    private readonly List<List<string>> _csvTableData;

    public CSVTable(List<List<string>> csvTableData)
    {
        _csvTableData = csvTableData;
    }

    public void Print()
    {
        foreach (var row in _csvTableData)
        {
            foreach (var col in row)
            {
                Console.Write(col + " ");
            }
            Console.WriteLine();
        }
    }
}

public class CSVFilePrinter
{
    private readonly ICSVFileReader _csvFileReader;

    public CSVFilePrinter(ICSVFileReader csvFileReader)
    {
        _csvFileReader = csvFileReader;
    }

    public void PrintCSVFile(string filePath)
    {
        var csvData = new CSVTable(_csvFileReader.ReadCSVFile(filePath));
        csvData.Print();
    }
}

public class Program
{
    public static void Main(string[] args)
    {
        string currentDirectory = Directory.GetCurrentDirectory();
        string filePath = Path.Combine(currentDirectory, "data.csv");

        try
        {
            ICSVFileReader csvFileReader = new CSVFileReader();
            CSVFilePrinter csvFilePrinter = new CSVFilePrinter(csvFileReader);
            csvFilePrinter.PrintCSVFile(filePath);
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }
    }
}
