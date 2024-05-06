#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    char slowestKey(vector<int>& releaseTimes, string keysPressed)
    {
        int maxTime = releaseTimes[0], maxKey = (int)keysPressed[0];
        for(int i = 1; i < releaseTimes.size(); i++)
        {
            if((releaseTimes[i]-releaseTimes[i-1] > maxTime) || 
            (releaseTimes[i]-releaseTimes[i-1] == maxTime && (int)keysPressed[i] > maxKey)) 
            {
                maxTime = releaseTimes[i]-releaseTimes[i-1];
                maxKey = (int)keysPressed[i];
            }
        }
        return (char)maxKey;
    }
};

int main(int argc, char **argv)
{
    vector<int> releaseTimes = {1,2};
    string keysPressed = "ba";
    Solution S;

    cout << S.slowestKey(releaseTimes, keysPressed);

    return 0;
}