using System;

namespace DesignPatterns.Adapter
{
    public interface IPlayer
    {
        string MakeMove();
    }

    class GameEngine
    {
        public string MakeBestMove(int depth)
        {
            return "d4";
        }
    }

    class GameEngineAdapter : IPlayer
    {
        private readonly GameEngine _adaptee;

        public GameEngineAdapter(GameEngine adaptee)
        {
            this._adaptee = adaptee;
        }

        public string MakeMove()
        {
            return this._adaptee.MakeBestMove(15);
        }
    }

    public class Player : IPlayer
    {
        public string MakeMove()
        {
            Console.WriteLine($"What is your move?");
            return Console.ReadLine() ?? "";
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            GameEngine adaptee = new GameEngine();
            IPlayer[] players = new IPlayer[2];
            var whitePlayer = players[0] = new GameEngineAdapter(adaptee);
            var blackPlayer = players[1] = new Player();

            bool GameNotFinised = true;
            int i = 0;
            while( GameNotFinised)
            {
                Console.WriteLine($"Player {i%2} {players[i%2].GetType()} have made the move: {players[i%2].MakeMove()}");
                i += 1;
            }
        }
    }
}