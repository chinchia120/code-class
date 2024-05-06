#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int timeRequiredToBuy(vector<int>& tickets, int k)
    {   
        int sum = 0, cnt = 0;
        for(int i = 0; i < tickets.size(); i++)
        {
            if(tickets[i] > tickets[k]) sum += tickets[k];
            else sum += tickets[i];

            if(i > k && tickets[i] >= tickets[k]) cnt++;
        }
        return sum-cnt;
    }
};

int main(int argc, char **argv)
{
    vector<int> tickets = {15,66,3,47,71,27,54,43,97,34,94,33,54,26,15,52,20,71,88,42,50,6,66,88,36,99,27,82,7,72};
    int k = 18;
    Solution S;

    cout << S.timeRequiredToBuy(tickets, k);

    return 0;
}