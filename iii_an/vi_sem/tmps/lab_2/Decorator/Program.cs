using System;

namespace DesignPatterns.Decorator
{
    public abstract class ApstractPiece
    {
        protected char file;
        protected int rank;
        public abstract bool MoveTo(char file, int rank);
        public abstract char GetFile();
        public abstract int GetRank();
        public abstract ApstractPiece GetBasePiece();
    }

    class Piece : ApstractPiece
    {
        public Piece(char initialFile, int initialRank)
        {
            this.file = initialFile;
            this.rank = initialRank;
        }
        public override bool MoveTo(char file, int rank)
        {
            string files = "abcdefgh";
            if(files.Contains(file.ToString()) && rank > 0 && rank < 9)
            {
                this.file = file;
                this.rank = rank;
                return true;
            }
            return false;
        }

        public override char GetFile()
        {
            return this.file;
        }
        public override int GetRank()
        {
            return this.rank;
        }

        public override ApstractPiece GetBasePiece()
        {
            return new Piece(this.file, this.rank);
        }
    }

    abstract class Decorator : ApstractPiece
    {
        protected ApstractPiece _component;

        public Decorator(ApstractPiece component)
        {
            this._component = component;
        }

        public void SetComponent(ApstractPiece component)
        {
            this._component = component;
        }

        public override ApstractPiece GetBasePiece()
        {
            return this._component.GetBasePiece();
        }

        public override bool MoveTo(char file, int rank)
        {
            if (this._component != null)
            {
                return this._component.MoveTo(file, rank);
            }
            else
            {
                return false;
            }
        }

        public override char GetFile()
        {
            return this._component.GetFile();
        }
        public override int GetRank()
        {
            return this._component.GetRank();
        }
    }

    class Pawn : Decorator
    {
        private bool firstmove;
        public Pawn(ApstractPiece comp) : base(comp)
        {
            this.firstmove = true;
        }
        public override bool MoveTo(char file, int rank)
        {
            string files = "abcdefgh";
            int index = files.IndexOf(this.GetFile());
            int len = index == 0 ? 2 : 3;
            index = index == 0 ? 0 : index -1;
            string subString = files.Substring(index, len);
            if((this.firstmove == true && Math.Abs(this.GetRank() - rank) <= 2 && this.GetFile() == file) ||
                (Math.Abs(this.GetRank() - rank) <= 1 && subString.Contains(file)))
            {
                string message = $"{this.GetType()} moved from {this.GetFile()}{this.GetRank()} to";
                if(base.MoveTo(file, rank)){
                    Console.WriteLine($"{message} {this.GetFile()}{this.GetRank()}");
                    return true;
                }
            }
            Console.WriteLine($"{this.GetType()} remained on {this.GetFile()}{this.GetRank()}");
            return false;
        }
        public override ApstractPiece GetBasePiece()
        {
            return this._component.GetBasePiece();
        }
    }

    class King : Decorator
    {
        public King(ApstractPiece comp) : base(comp)
        {
        }

        public override bool MoveTo(char file, int rank)
        {
            string files = "abcdefgh";
            int index = files.IndexOf(this.GetFile());
            int len = index == 0 ? 2 : 3;
            index = index == 0 ? 0 : index -1;
            string subString = files.Substring(index, len);
            if(Math.Abs(this.GetRank() - rank) <= 1 && subString.Contains(file))
            {
                string message = $"{this.GetType()} moved from {this.GetFile()}{this.GetRank()} to";
                if(base.MoveTo(file, rank)){
                    Console.WriteLine($"{message} {this.GetFile()}{this.GetRank()}");
                    return true;
                }
            }
            Console.WriteLine($"{this.GetType()} remained on {this.GetFile()}{this.GetRank()}");
            return false;
            
        }

        public override ApstractPiece GetBasePiece()
        {
            return this._component.GetBasePiece();
        }
    }
    
    public class Client
    {
        public void ClientCode(ApstractPiece component, char file, int rank)
        {
            component.MoveTo(file, rank);
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            Client client = new Client();

            var pawn = new Pawn(new Piece('d', 2));
            var king = new King(new Piece('d', 1));
            client.ClientCode(pawn, 'a', 2);
            client.ClientCode(pawn, 'd', 3);
            client.ClientCode(king, 'e', 2);

            ApstractPiece king2 =  new King(pawn.GetBasePiece());
            client.ClientCode(king2, 'c', 5);
        }
    }
}