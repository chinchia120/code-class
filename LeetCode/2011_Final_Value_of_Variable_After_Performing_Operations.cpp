#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int finalValueAfterOperations(vector<string>& operations)
    {
        int cnt = 0;
        for(string operation: operations)
        {
            if(operation[1] == '+') cnt++;
            if(operation[1] == '-') cnt--;
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<string> operations = {"X++","++X","--X","X--"};
    Solution S;

    cout << S.finalValueAfterOperations(operations);

    return 0;
}