using System;
using System.Collections.Generic;
using System.IO;

public interface ICsvReader
{
    List<List<string>> ReadCsv(string filePath);
}

public interface ICsvWriter
{
    void WriteCsv(string filePath, List<List<string>> rows);
}

public class CsvReader : ICsvReader
{
    public List<List<string>> ReadCsv(string filePath)
    {
        List<List<string>> rows = new List<List<string>>();
        using (var reader = new StreamReader(filePath))
        {
            while (!reader.EndOfStream)
            {
                string line = reader.ReadLine();
                string[] row = line.Split(',');
                rows.Add(new List<string>(row));
            }
        }
        return rows;
    }
}

public class CsvWriter : ICsvWriter
{
    public void WriteCsv(string filePath, List<List<string>> rows)
    {
        using (var writer = new StreamWriter(filePath))
        {
            foreach (List<string> row in rows)
            {
                writer.WriteLine(string.Join(",", row));
            }
        }
    }
}

class Program
{
    static void Main(string[] args)
    {
        string currentDirectory = Directory.GetCurrentDirectory();
        string inputFilePath = Path.Combine(currentDirectory, "in.csv");
        string outputFilePath = Path.Combine(currentDirectory, "out.csv");

        ICsvReader csvReader = new CsvReader();
        List<List<string>> rows = csvReader.ReadCsv(inputFilePath);

        ICsvWriter csvWriter = new CsvWriter();
        csvWriter.WriteCsv(outputFilePath, rows);
    }
}
