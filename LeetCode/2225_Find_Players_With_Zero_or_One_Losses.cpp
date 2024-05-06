#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<vector<int>> findWinners(vector<vector<int>>& matches)
    {
        vector<vector<int>> winner_loser (2, vector<int> ());
        vector<vector<int>> players;
        int index = 0;
        for(vector<int> match: matches)
        {
            int flag1 = 0, flag2 = 0;
            for(int i = 0; i < players.size(); i++)
            {
                if(match[0] == players[i][0]) flag1 = 1;
                
                if(match[1] == players[i][0])
                {
                    flag2 = 1;
                    players[i][1]++;
                }

                if(flag1 == 1 && flag2 == 1) break;
            }
            if(flag1 == 0)
            {
                players.push_back(vector<int> ());
                players[index].push_back(match[0]);
                players[index].push_back(0);
                index++;
            }
            if(flag2 == 0)
            {
                players.push_back(vector<int> ());
                players[index].push_back(match[1]);
                players[index].push_back(1);
                index++;
            }
        }

        for(vector<int> player: players)
        {
            if(player[1] == 0) winner_loser[0].push_back(player[0]);
            if(player[1] == 1) winner_loser[1].push_back(player[0]);
        }
        sort(winner_loser[0].begin(), winner_loser[0].end());
        sort(winner_loser[1].begin(), winner_loser[1].end());
        return winner_loser;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(vector<int> nums: vec)
        {
            for(int num: nums) cout << num << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> matches = {{1,3},{2,3},{3,6},{5,6},{5,7},{4,5},{4,8},{4,9},{10,4},{10,9}};
    Solution S;

    S.show_2d_vector(S.findWinners(matches));

    return 0;
}