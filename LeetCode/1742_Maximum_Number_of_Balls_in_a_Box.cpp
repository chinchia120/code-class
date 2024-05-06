#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    int countBalls(int lowLimit, int highLimit)
    {
        vector<int> box (46, 0);
        int maxball = 0;
        for(int i = lowLimit; i <= highLimit; i++)
        {
            string str = to_string(i);
            int sum = 0;
            for(char ch: str) sum += ch-'0';
            box[sum-1]++;
            maxball = max(maxball, box[sum-1]);
        }
        return maxball;
    }
};

int main(int argc, char **argv)
{
    int lowLimit = 1, highLimit = 10;
    Solution S;

    cout << S.countBalls(lowLimit, highLimit);

    return 0;
}