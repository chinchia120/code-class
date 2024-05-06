#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minOperations(vector<string>& logs)
    {
        int cnt = 0;
        for(string str: logs)
        {   
            if(str[0] != '.') cnt++;
            else if(str == "./") continue;
            else if(str == "../") if(cnt != 0) cnt--;
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<string> logs = {"d1/","d2/","./","d3/","../","d31/"};
    Solution S;

    cout << S.minOperations(logs);

    return 0;
}