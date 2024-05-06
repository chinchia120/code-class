#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    int convertTime(string current, string correct)
    {   
        int h1 = stoi(current.substr(0, 2)), h2 = stoi(correct.substr(0, 2));
        int m1 = stoi(current.substr(3, 2)), m2 = stoi(correct.substr(3, 2));
        if(m2 < m1)
        {
            m2 += 60;
            h2 -= 1;
        }

        int cnt = 0;
        if(h1 != h2) cnt += h2-h1;
        if(m1 != m2)
        {
            int diff = m2 - m1;
            while(diff != 0)
            {
                if(diff >= 15) diff -= 15;
                else if(diff >= 5) diff -= 5;
                else diff -= 1;
                cnt++;
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    string current = "09:41", correct = "10:34";
    Solution S;

    cout << S.convertTime(current, correct);

    return 0;
}
