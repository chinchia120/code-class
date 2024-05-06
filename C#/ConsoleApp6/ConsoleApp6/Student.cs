using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp6
{
    internal class Student : Person
    {
        public string school;

        public Student(string name, int age, string school)
        {
            this.name = name;
            this.age = age;
            this.school = school;
        }

        public void PrintSchool()
        {
            Console.WriteLine(this.school);
        }
    }
}
