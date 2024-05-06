#include <stdio.h>

int main()
{
    int Sum = 0;
    for(int i = 0, counter=0; i < 100; i++)
    {
        Sum = Sum + i;
        counter++;
        printf("%d\t%d\n", counter, Sum);
    }
}