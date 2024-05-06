namespace ConsoleApp6
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Student student1 = new Student("AAA", 10, "S1");

            //Console.WriteLine(student1.name);
            //Console.WriteLine(student1.age);
            //Console.WriteLine(student1.school);

            student1.PrintName();
            student1.PrintAge();
            student1.PrintSchool();
        }
    }
}