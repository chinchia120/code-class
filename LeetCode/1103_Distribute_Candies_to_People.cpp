#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> distributeCandies(int candies, int num_people)
    {
        vector<int> candy(num_people, 0);
        int index_people = 0, num_candy = 1;
        while(1)
        {   
            if(candies >= num_candy)
            {
                candy[index_people] += num_candy;
                candies -= num_candy;
                num_candy++;
            }
            else
            {   
                candy[index_people] += candies;
                break;
            }
            
            if(index_people == num_people-1) index_people = 0;
            else index_people++;
        }
        return candy;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    int candies = 7, num_people = 4;
    Solution S;

    S.show_1d_vector(S.distributeCandies(candies, num_people));

    return 0;
}