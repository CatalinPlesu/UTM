using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;

enum PieceType
{
    White_Pawn = 0,
    Black_Pawn,
    White_King,
    Black_King
}

interface IPiece {
    void Draw();
    void SetPosition(Point position);
}

class ChessPiece : IPiece {
    private Image sprite;
    private Point position;

    private PieceType type;

    public ChessPiece(Image sprite, Point position, PieceType type) {
        this.sprite = sprite;
        this.position = position;
        this.type = type;
    }

    public void Draw() {
        Console.WriteLine($"Drawing {this.type} piece at ({position.X},{position.Y})");
    }

    public void SetPosition(Point position) {
        this.position = position;
    }
}

class PieceFactory {
        static Image wp = Image.FromFile("white_pawn.png");
        static Image bp = Image.FromFile("black_pawn.png");
        static Image bk = Image.FromFile("black_king.png");
        static Image wk = Image.FromFile("white_king.png");
    public IPiece GetPiece(PieceType type, Point position) {
        Image sprite = wp;
        switch(type)
        {
            case PieceType.White_Pawn:
                sprite = wp;
            break;
            case PieceType.Black_Pawn:
                sprite = bp;
            break;
            case PieceType.White_King:
                sprite = wk;
            break;
            case PieceType.Black_King:
                sprite = bk;
            break;
            default:
                sprite = wp;
            break;
        }
        return new ChessPiece(sprite, position, type);
    }
}

// Client
class Client {
    static void Main(string[] args) {
        PieceFactory factory = new PieceFactory();

        IPiece whitePawn = factory.GetPiece(PieceType.White_Pawn, new Point(3, 2));
        IPiece blackKing = factory.GetPiece(PieceType.Black_King, new Point(3, 7));

        whitePawn.Draw();
        blackKing.Draw();

        Console.ReadKey();
    }
}
