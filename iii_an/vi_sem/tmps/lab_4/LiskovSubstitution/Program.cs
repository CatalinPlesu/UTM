using System.IO;
using System.Security.Cryptography;
using System.Text;

public interface IFileReader
{
    string Read(string filePath);
}

public class TextFileReader : IFileReader
{
    public string Read(string filePath)
    {
        return File.ReadAllText(filePath);
    }
}
public class EncryptedTextFileReader : IFileReader
{
    public string Read(string filePath)
    {
        string encryptedContent = File.ReadAllText(filePath);
        string decryptedContent = Decrypt(encryptedContent, "encryption key");
        return decryptedContent;
    }

    private string Decrypt(string encryptedContent, string encryptionKey)
    {
        StringBuilder sb = new StringBuilder();
        foreach (char c in encryptedContent)
        {
            if (char.IsLetter(c))
            {
                char decryptedChar = (char)(c - 5);
                if (char.IsLower(c) && decryptedChar < 'a')
                {
                    decryptedChar = (char)(decryptedChar + 26);
                }
                else if (char.IsUpper(c) && decryptedChar < 'A')
                {
                    decryptedChar = (char)(decryptedChar + 26);
                }
                sb.Append(decryptedChar);
            }
            else
            {
                sb.Append(c);
            }
        }
        return sb.ToString();
    }

}

public interface IFileWriter
{
    void Write(string filePath, string content);
}

public class TextFileWriter : IFileWriter
{
    public void Write(string filePath, string content)
    {
        File.WriteAllText(filePath, content);
    }
}
public class EncryptedTextFileWriter : IFileWriter
{
    public void Write(string filePath, string content)
    {
        string encryptedContent = Encrypt(content, "encryption key");
        File.WriteAllText(filePath, encryptedContent);
    }

    private string Encrypt(string content, string encryptionKey)
    {
        StringBuilder encryptedContent = new StringBuilder(content.Length);

        foreach (char c in content)
        {
            // Shift the character by 5
            char encryptedChar = (char)(c + 5);

            // Add the encrypted character to the result
            encryptedContent.Append(encryptedChar);
        }

        return encryptedContent.ToString();
    }

}

public class FileProcessor
{
    private readonly IFileReader _fileReader;
    private readonly IFileWriter _fileWriter;

    public FileProcessor(IFileReader fileReader, IFileWriter fileWriter)
    {
        _fileReader = fileReader;
        _fileWriter = fileWriter;
    }

    public void ProcessFile(string inputFile, string outputFile)
    {
        string content = _fileReader.Read(inputFile);

        // Do some processing on the content...

        _fileWriter.Write(outputFile, content);
    }
}

public static class Program
{
    public static void Main()
    {
        string currentDirectory = Directory.GetCurrentDirectory();
        string inputFile = Path.Combine(currentDirectory, "input1.txt");
        string outputFileEnc = Path.Combine(currentDirectory, "output.enc.txt");
        string outputFil = Path.Combine(currentDirectory, "output.txt");

        IFileReader fileReader = new TextFileReader();
        IFileWriter fileWriter = new TextFileWriter();
        IFileReader encryptedFileReader = new EncryptedTextFileReader();
        IFileWriter encryptedFileWriter = new EncryptedTextFileWriter();

        FileProcessor fileProcessor = new FileProcessor(fileReader, encryptedFileWriter);
        FileProcessor fileProcessor2 = new FileProcessor(encryptedFileReader, fileWriter);

        // Process a regular text file
        fileProcessor.ProcessFile(inputFile, outputFileEnc);

        // Process an encrypted text file
        fileProcessor2.ProcessFile(outputFileEnc, outputFil);
    }
}