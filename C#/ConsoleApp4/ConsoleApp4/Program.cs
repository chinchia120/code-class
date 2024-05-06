namespace ConsoleApp4
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Video video1 = new Video("Movie1", "AAA", "education");
            Video video2 = new Video("Movie2", "BBB", "entertainment");

            //Console.WriteLine(video1.type);
            //Console.WriteLine(video2.type);
            Console.WriteLine(Video.video_cnt);
            Console.WriteLine(video1.get_video_cnt);
        }
    }
}