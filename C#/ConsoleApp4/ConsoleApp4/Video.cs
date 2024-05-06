using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp4
{
    internal class Video
    {
        public string title;
        public string author;
        public string type;
        public static int video_cnt = 0;

        public Video(string title, string author, string type)
        {
            this.title = title;
            this.author = author;
            this.type = type;
            video_cnt++;
        }

        public int get_video_cnt()
        {
            return video_cnt;
        }
    }
}
