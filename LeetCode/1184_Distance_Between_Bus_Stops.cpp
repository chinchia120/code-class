#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int distanceBetweenBusStops(vector<int>& distance, int start, int destination)
    {   
        if(start > destination)
        {
            int tmp = start;
            start = destination;
            destination = tmp;
        }

        int clockwise = 0, total = 0;
        for(int i = 0; i < distance.size(); i++)
        {
            if(i >= start && i < destination) clockwise += distance[i];
            total += distance[i];
        }
        return min(clockwise, total-clockwise);
    }
};

int main(int argc, char **argv)
{
    vector<int> distance = {1,2,3,4};
    int start = 0, destination = 3;
    Solution S;

    cout << S.distanceBetweenBusStops(distance, start, destination);

    return 0;
}