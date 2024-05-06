#include <stdio.h>
#include <string.h>

#define num 5

int main(){
    struct stuData{
        char id[9];
        int score;
    }
    
    struct stuData p[num];
    int sum = 0, avg;

    strcpy(p[0].id, "S9903501");
    p[0].score = 75;

    strcpy(p[1].id, "S9903502");
    p[1].score = 53;

    strcpy(p[2].id, "S9903503");
    p[1].score = 57;

    strcpy(p[3].id, "S9903504");
    p[1].score = 93;

    strcpy(p[4].id, "S9903505");
    p[1].score = 23;

    for(int i = 0; i < num; i++){
        sum += p[i].score;
    }
    avg = sum / num;

    printf("average score = %d\n", avg);

    return 0;
}