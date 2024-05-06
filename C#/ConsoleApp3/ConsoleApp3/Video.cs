using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp3
{
    internal class Video
    {
        public string title;
        public string author;
        private string type;

        public Video(string title, string author, string type)
        {
            this.title = title;
            this.author = author;
            Type = type;
        }

        public string Type
        {
            get
            {
                return type;
            }
            set
            {
                if (value == "education" || value == "entertainment" || value == "music")
                {
                    type = value;
                }
                else
                {
                    type = "other";
                }
            }
        }
    }
}
