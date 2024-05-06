#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int isWinner(vector<int>& player1, vector<int>& player2)
    {
        int score1 = 0, score2 = 0;
        for(int i = 0; i < player1.size(); i++)
        {
            if(i == 0)
            {
                score1 += player1[i];

                score2 += player2[i];
            }
            else if(i == 1)
            {
                if(player1[0] == 10) score1 += player1[i]*2;
                else score1 += player1[i];

                if(player2[0] == 10) score2 += player2[i]*2;
                else score2 += player2[i];
            }
            else
            {
                if(CheckDouble(player1[i-1], player1[i-2])) score1 += player1[i]*2;
                else score1 += player1[i];

                if(CheckDouble(player2[i-1], player2[i-2])) score2 += player2[i]*2;
                else score2 += player2[i];
            }
        }
        return (score1 > score2)? 1: (score1 < score2)? 2: 0;
    }

    bool CheckDouble(int prev1, int prev2)
    {
        if(prev1 == 10 || prev2 == 10) return true;
        else return false;
    }
};