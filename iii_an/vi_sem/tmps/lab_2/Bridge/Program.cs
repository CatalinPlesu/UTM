public abstract class ChessPiece
{
    protected IColor color;
    protected char file;
    protected int rank;

    public ChessPiece(IColor color, char file, int rank)
    {
        this.color = color;
        this.file = file;
        this.rank = rank;
    }

    public virtual void Display()
    {
        this.color.Fill();
        Console.WriteLine(this.GetType());
        Console.WriteLine($"Position: {file}{rank}");
    }

    public virtual void Move(char file, int rank)
    {
        Console.WriteLine(this.GetType());
        this.file = file;
        this.rank = rank;
        Console.WriteLine($"Moved to {file}{rank}.");
    }
}

public interface IColor
{
    void Fill();
}

public class WhiteColor : IColor
{
    public void Fill()
    {
        Console.Write("White ");
    }
}

public class BlackColor : IColor
{
    public void Fill()
    {
        Console.Write("Black ");
    }
}

public class Pawn : ChessPiece
{
    public Pawn(IColor color, char file, int rank) : base(color, file, rank) {}
}

public class Rook : ChessPiece
{
    public Rook(IColor color, char file, int rank) : base(color, file, rank) {}
}

public class Knight : ChessPiece
{
    public Knight(IColor color, char file, int rank) : base(color, file, rank) {}
}

public class Bishop : ChessPiece
{
    public Bishop(IColor color, char file, int rank) : base(color, file, rank) {}
}

public class Queen : ChessPiece
{
    public Queen(IColor color, char file, int rank) : base(color, file, rank) {}
}

public class King : ChessPiece
{
    public King(IColor color, char file, int rank) : base(color, file, rank) {}
}

class Program
{
    static void Main(string[] args)
    {
        IColor whiteColor = new WhiteColor();
        IColor blackColor = new BlackColor();

        ChessPiece whitePawn = new Pawn(whiteColor, 'e', 2);
        ChessPiece blackRook = new Rook(blackColor, 'a', 8);

        whitePawn.Display();
        blackRook.Display();

        whitePawn.Move('e', 4);
        whitePawn.Display();
    }
}
