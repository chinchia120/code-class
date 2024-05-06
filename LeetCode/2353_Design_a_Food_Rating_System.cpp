#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

class FoodRatings
{
private:
    vector<string> _foods;
    vector<string> _cuisines;
    vector<int> _ratings;

public:
    FoodRatings(vector<string>& foods, vector<string>& cuisines, vector<int>& ratings)
    {
        _foods = foods;
        _cuisines = cuisines;
        _ratings = ratings;
    }
    
    void changeRating(string food, int newRating)
    {   
        for(int i = 0; i < _foods.size(); i++)
        {
            if(_foods[i] == food)
            {
                _ratings.insert(_ratings.begin()+i, newRating);
                _ratings.erase(_ratings.begin()+i+1);
                break;
            }
        }
    }
    
    string highestRated(string cuisine)
    {   
        vector<string> foods;
        int max_rating = 0;
        for(int i = 0; i < _cuisines.size(); i++)
        {
            if(_cuisines[i] == cuisine) max_rating = max(max_rating, _ratings[i]);
        }

        for(int i = 0; i < _foods.size(); i++)
        {
            if(_cuisines[i] == cuisine && _ratings[i] == max_rating) foods.push_back(_foods[i]);
        }
        
        sort(foods.begin(), foods.end());

        return foods[0];
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{   
    vector<string> foods = {"kimchi", "miso", "sushi", "moussaka", "ramen", "bulgogi"};
    vector<string> cuisines = {"korean", "japanese", "japanese", "greek", "japanese", "korean"};
    vector<int> ratings = {9, 12, 8, 15, 14, 7};
    
    FoodRatings FoodRatings(foods, cuisines, ratings);
    FoodRatings.changeRating("sushi", 16);
    cout << FoodRatings.highestRated("japanese");
    
    return 0;
}