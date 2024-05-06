using System;

namespace Animal
{
    internal class Person
    {
        public double height;
        public int age;
        public string name = "";

        public void SayHi()
        {
            Console.WriteLine("Helle, " + name);
        }

        public bool IsAdult()
        {
            if(age >= 18)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public int Add(int a, int b)
        {
            return a + b;
        }
    }
}


