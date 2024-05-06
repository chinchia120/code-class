#include <stdio.h>
#include <time.h>
#define CLK_TCK 1000 

int main(){
    double Run_Time;
    long Start, End;

    Start = clock();
    int sum = 0;
    for(int i = 0; i < 10; i++){
        sum += i;
    }
    End = clock();

    Run_Time = ((double)End - Start) / CLK_TCK;
    printf("Run_Time = %lf", Run_Time);
}