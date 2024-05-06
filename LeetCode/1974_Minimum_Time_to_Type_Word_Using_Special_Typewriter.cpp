#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

class Solution
{
public:
    int minTimeToType(string word)
    {
        int time = 0, prev = (int)'a';
        for(char ch: word)
        {
            time += min(abs((int)ch-prev), 26-abs((int)ch-prev));
            prev = (int)ch;
        }
        return time+word.size();
    }
};

int main(int argc, char **argv)
{
    string word = "zjpc";
    Solution S;

    cout << S.minTimeToType(word);

    return 0;
}