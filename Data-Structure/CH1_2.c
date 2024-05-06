#include <stdio.h>
#define num 5

int main(){
    int sum = 0, avg;
    int score[num] = {75, 53, 80, 60, 87};

    for(int i = 0; i < num; i++){
        sum += score[i];
    }

    avg = sum / num;

    printf("average score = %d\n", avg); 

    return 0;
}