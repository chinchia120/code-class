#include <stdio.h>
#include <string.h>

int main(){
    struct stuData{
        char id[9];
        int score;
    };

    struct stuData p1;

    strcpy(p1.id, "S9903501");
    p1.score = 75;

    printf("student_ID = %s\n", p1.id);
    printf("student_score = %d\n",p1.score);

    return 0;
}