/*
System.Console.Write("Enter number1 ==> ");
int num1 = System.Convert.ToInt32(System.Console.ReadLine());
System.Console.Write("Enter number2 ==> ");
int num2 = System.Convert.ToInt32(System.Console.ReadLine());
System.Console.WriteLine(num1 + num2);
*/

/*
int[] score = { 50, 60, 70, 30, 20, 90 };
string[] phone = new string[10];
phone[0] = "0123456789";
phone[1] = "0999999999";
for(int i = 0; i < 5; i++){
    System.Console.WriteLine(score[i]);
}
*/

/*
bool hungry = true;

if (hungry)
{
    System.Console.Write("eat\n");
}
*/

/*
System.Console.Write("enter a number ==> ");
double num1 = System.Convert.ToDouble(System.Console.ReadLine());

System.Console.Write("enter a operator ==> ");
string oper = System.Console.ReadLine();

System.Console.Write("enter a number ==> ");
double num2 = System.Convert.ToDouble(System.Console.ReadLine());

if(oper == "+")
{
    System.Console.WriteLine(num1 + num2);
}
else if(oper == "-")
{
    System.Console.WriteLine(num1 - num2);
}
else if (oper == "*")
{
    System.Console.WriteLine(num1 * num2);
}
else if (oper == "/")
{
    System.Console.WriteLine(num1 / num2);
}
else 
{
    System.Console.WriteLine("error");  
}
*/

/*
int num = 1;

while (num <= 100)
{
    System.Console.WriteLine(num);
    num++;
}

do
{
    System.Console.WriteLine(num);
    num++;
}
while (num <= 100);
*/

/*
int ans = 66, guess;
int cnt = 0, limit = 3;
bool win = false;

do
{
    System.Console.Write("enter a number ==> ");
    guess = System.Convert.ToInt32(System.Console.ReadLine());
    cnt++;

    if (guess > ans)
    {
        System.Console.Write("smaller\n");
    }
    else if (guess < ans)
    {
        System.Console.Write("bigger\n");
    }
    else
    {
        System.Console.Write("got the answer\n");
        win = true;
    }
}
while (guess != ans && cnt < limit);

if (!win)
{
    System.Console.Write("you lose\n");
}
*/

/*
int[] num = { 12, 23, 56, 87, 90, 23 };

for (int i = 0; i < num.Length; i++)
{
    System.Console.WriteLine(num[i]);
}
*/

/*
int[,] num = { 
    { 1, 2, 3 }, 
    { 4, 5, 6 }, 
    { 7, 8, 9 } 
};

int[,] num2 = new int[3, 4];

for(int i = 0; i < 3; i++)
{
    for(int j = 0; j < 3; j++)
    {
        System.Console.WriteLine(num[i, j]);
    }
}
*/

/*
using Animal;
using System;

Person person1 = new Person();

person1.height = 175.5;
person1.age = 42;
person1.name = "AAA";
person1.SayHi();
Console.WriteLine(person1.IsAdult());
Console.WriteLine(person1.Add(2, 3));

Person person2 = new Person();

person2.height = 176.5;
person2.age = 16;
person2.name = "BBB";
person2.SayHi();
Console.WriteLine(person2.IsAdult());

//System.Console.WriteLine(person1.name);
//System.Console.WriteLine(person2.name);
*/

using Animal;
using System;

namespace ConsoleApp1
{
    class Program
    {
        static void Main()
        {
            Console.WriteLine("Helle, World");
            Person person1 = new Person();
        }
    }
}



