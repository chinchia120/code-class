#include <stdio.h>
#include <string.h>

struct Triangle{
    int length_A;
    int length_B;
    int length_C;

    int angle_x;
    int angle_y;
    int angle_z;
};

int main(){
    struct Triangle T;

    T.length_A = 3;
    T.length_B = 4;
    T.length_C = 5;

    T.angle_x = 37;
    T.angle_y = 53;
    T.angle_z = 90;    

    return 0;
}