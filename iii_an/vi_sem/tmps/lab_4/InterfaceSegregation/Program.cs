using System;
using System.Collections.Generic;
using System.IO;

namespace InterfaceSegregation
{
    public interface IFileReader
    {
        string ReadAllText(string path);
        byte[] ReadAllBytes(string path);
    }

    public class FileReader : IFileReader
    {
        public string ReadAllText(string path)
        {
            try
            {
                string contents = File.ReadAllText(path);
                Console.WriteLine($"File {path} read successfully.");
                return contents;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error reading file {path}:\n{ex.Message}");
                return string.Empty;
            }
        }

        public byte[] ReadAllBytes(string path)
        {
            try
            {
                byte[] bytes = File.ReadAllBytes(path);
                Console.WriteLine($"File {path} read successfully.");
                return bytes;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error reading file {path}: {ex.Message}");
                return new byte[0];
            }
        }
    }

    public interface IFileWriter
    {
        void WriteAllText(string path, string contents);
        void WriteAllBytes(string path, byte[] bytes);
    }

    public class FileWriter : IFileWriter
    {
        public void WriteAllText(string path, string contents)
        {
            try
            {
                File.WriteAllText(path, contents);
                Console.WriteLine($"File {path} written successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error writing file {path}: {ex.Message}");
            }
        }

        public void WriteAllBytes(string path, byte[] bytes)
        {
            try
            {
                File.WriteAllBytes(path, bytes);
                Console.WriteLine($"File {path} written successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error writing file {path}: {ex.Message}");
            }
        }
    }

    public interface IFileDeleter
    {
        void Delete(string path);
    }

    public class FileDeleter : IFileDeleter
    {
        public void Delete(string path)
        {
            try
            {
                File.Delete(path);
                Console.WriteLine($"File {path} deleted successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error deleting file {path}: {ex.Message}");
            }
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            string currentDirectory = Directory.GetCurrentDirectory();
            string fileInPath = Path.Combine(currentDirectory, "fin.txt");
            string fileOutPath = Path.Combine(currentDirectory, "fout.txt");
            string fileDelPath = Path.Combine(currentDirectory, "fdel.txt");

            IFileReader fileReader = new FileReader();
            string fileContents = fileReader.ReadAllText(fileInPath);
            Console.WriteLine(fileContents);

            IFileWriter fileWriter = new FileWriter();
            fileWriter.WriteAllText(fileOutPath, "Hello, world!");

            IFileDeleter fileDeleter = new FileDeleter();
            fileDeleter.Delete(fileOutPath);
        }
    }
}
