#include <stdio.h>
#include <time.h>

int main(){
    double Run_Time;
    long Start, End;
    
    Start = time(NULL);
    int sum = 0;
    for(int i = 0; i < 10; i++){
        sum += i;
    }
    End = time(NULL);

    Run_Time = difftime(Start, End);
    printf("%lf\n", Run_Time);

    return 0;
}