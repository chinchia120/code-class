#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int chalkReplacer(vector<int>& chalk, int k)
    {   
        int index = 0;
        while (1)
        {
            k -= chalk[index];
            if (k < 0) break;

            index++;
            if(index == chalk.size()) index = 0;
            if(k == 0) break;
        }
        return index;
    }
};