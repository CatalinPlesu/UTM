using System;

namespace DesignPatterns.Facade
{
    public class ChessGame
    {
        protected GameEngine _gameEngine;
        
        protected Board _board;

        public ChessGame(GameEngine gameEngine, Board board)
        {
            this._gameEngine = gameEngine;
            this._board = board;
        }
        public bool TakePlayerInput()
        {
            Console.WriteLine("What is your move?");
            string move = Console.ReadLine();
            bool isValidMove = this._gameEngine.ValidateMove(move??"");
            if (!isValidMove)
            {
                Console.WriteLine("Invalid move!");
                return false;
            }
            string files = "abcdefgh";
            if(move != null)
            {
                int index = move.Length == 2 ? files.IndexOf(move[0]) : files.IndexOf(move[1]);
                int f1 = files.IndexOf(move[0]);
                int r1 = int.Parse(move[1].ToString());
                int f2 = files.IndexOf(move[2]);
                int r2 = int.Parse(move[3].ToString());
                this._board.Move(f1, 8-r1, f2, 8-r2);
                this._gameEngine.MakeBestMove(this._board, 'b');
                this._board.Display();
            }
            return true;
        }
    }
    public class GameEngine
    {
        public bool ValidateMove(string move)
        {
            return true;
        }

        public string MakeBestMove(Board board, char color)
        {
            return "d4";
        }
    }
    
    public class Board
    {
        private char [,] _board;
        
        public Board()
        {
            this._board = new char [8,8]
            {
                { 'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R' },
                { 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P' },
                { ' ', '.', ' ', '.', ' ', '.', ' ', '.' },
                { '.', ' ', '.', ' ', '.', ' ', '.', ' ' },
                { ' ', '.', ' ', '.', ' ', '.', ' ', '.' },
                { '.', ' ', '.', ' ', '.', ' ', '.', ' ' },
                { 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p' },
                { 'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r' }
            };
        }
        public void Move(int file, int rank, int file_to, int rank_to)
        {
            this._board[rank_to, file_to] = this._board[rank, file];
            this._board[rank, file] = ' ';
        }

        public void Display()
        {
            Console.Clear();
            for (int row = 0; row < 8; row++)
            {
                for (int col = 0; col < 8; col++)
                {
                    Console.Write(this._board[row, col] + " ");
                }
                Console.WriteLine();
            }
        }
    }


    class Client
    {
        public static void ClientCode(ChessGame ChessGame)
        {
            while(ChessGame.TakePlayerInput())
            {
                
            }
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            GameEngine GameEngine = new GameEngine();
            Board Board = new Board();
            ChessGame ChessGame = new ChessGame(GameEngine, Board);
            Client.ClientCode(ChessGame);
        }
    }
}