#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    int furthestDistanceFromOrigin(string moves)
    {
        int cntR = 0, cntL = 0, cntS = 0;
        for (char move: moves)
        {
            if (move == 'R') cntR++;
            if (move == 'L') cntL++;
            if (move == '_') cntS++;
        }

        if (cntL > cntR) return cntL-cntR+cntS;
        if (cntR > cntL) return cntR-cntL+cntS;
        return cntS;
    }
};