#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<vector<int>> flipAndInvertImage(vector<vector<int>>& image)
    {   
        vector<vector<int>> img;
        for(int i = 0; i < image.size(); i++)
        {
            for(int j = 0; j < image[i].size(); j++)
            {
                if(j == 0) img.push_back(vector<int> ());
                if(image[i][image.size()-1-j] == 1) img[i].push_back(0);
                if(image[i][image.size()-1-j] == 0) img[i].push_back(1);
            }
        }
        return img;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(int i = 0; i < vec.size(); i++)
        {
            for(int j = 0; j < vec[i].size(); j++) cout << vec[i][j] << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> image = {{1, 1, 0}, {1, 0, 1}, {0, 0, 0}};
    Solution S;

    S.show_2d_vector(S.flipAndInvertImage(image));

    return 0;   
}