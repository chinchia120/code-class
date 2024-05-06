using System;

namespace ConsoleApp2
{
    internal class Program
    {
        static void Main()
        {
            Person person1 = new Person(175.5, 42, "AAA");
            Person person2 = new Person(176.5, 16, "BBB");

            Console.WriteLine(person1.name);
            Console.WriteLine(person2.name);

            Console.WriteLine(person1.age);
            Console.WriteLine(person2.age);

            Console.WriteLine(person1.height);
            Console.WriteLine(person2.height);
        }
    }
}