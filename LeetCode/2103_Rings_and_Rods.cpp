#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countPoints(string rings)
    {   
        vector<vector<int>> idRGB (10, vector<int> (3, 0));
        for(int i = 0; i < rings.length(); i+=2)
        {   
            int tmp = 0;
            if(rings[i] == 'R') tmp = 0;
            if(rings[i] == 'G') tmp = 1;
            if(rings[i] == 'B') tmp = 2;
            idRGB[rings[i+1]-'0'][tmp]++;
        }
        //show_2d_vector(idRGB);
        
        int cnt = 0;
        for(vector<int> id: idRGB)
        {
            if(id[0] > 0 && id[1] > 0 && id[2] > 0) cnt++;
        }
        return cnt;
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
    string rings = "B0R0G0R9R0B0G0";
    Solution S;

    cout << S.countPoints(rings);

    return 0;
}