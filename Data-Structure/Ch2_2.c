#include <stdio.h>

void func2(int, int[], int);

int main(){
    int array[10];

    func2(5, array, 10);

    return 0;
}

void func2(int x, int arr[], int n){
    const int k = 10;
    
    for(int i = 0; i < n; i++){
        *(arr + i) = i * x * k;
    }
}