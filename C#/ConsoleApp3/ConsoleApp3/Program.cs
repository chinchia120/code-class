using ConsoleApp3;
using System;

namespace ConsoleApp3
{
    internal class Program
    {
        static void Main()
        {
            Video video1 = new Video("Movie1", "AAA", "haha");
            Video video2 = new Video("Movie2", "BBB", "entertainment");

            Console.WriteLine(video1.Type);
        }
    }
}