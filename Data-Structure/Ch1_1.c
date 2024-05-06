#include <stdio.h>

int main(){
    int sum = 0, n = 100;

    for(int i = 0; i <= n; i++){
        sum += i;
    }
    printf("1 + 2 + 3 + ... + 100 = %d\n", sum);
    
    return 0;
}