#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool isRectangleOverlap(vector<int>& rec1, vector<int>& rec2)
    {
        return (rec1[0] < rec2[2]) && (rec2[0] < rec1[2]) && (rec1[1] < rec2[3]) && (rec2[1] < rec1[3]);
    }
};

int main(int argc, char **argv)
{
    vector<int> rec1 = {0, 0, 2, 2}, rec2 = {1, 1, 3, 3};
    Solution S;

    cout << S.isRectangleOverlap(rec1, rec2);

    return 0;
}