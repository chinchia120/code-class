#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>
using namespace std;

class RandomizedSet
{
public:
    vector<int> nums;
    RandomizedSet()
    {
        
    }
    
    bool insert(int val)
    {   
        for(int num: nums)
        {
            if(num == val) return false;
        }
        nums.push_back(val);
        return true;
    }
    
    bool remove(int val)
    {
        for(int i = 0; i < nums.size(); i++)
        {
            if(nums[i] == val)
            {
                nums.erase(nums.begin()+i);
                return true;
            }
        }
        return false;
    }
    
    int getRandom()
    {   
        return nums[rand()%nums.size()];
    }
};

int main(int argc, char **argv)
{
    RandomizedSet _RandomizedSet;
    cout << _RandomizedSet.insert(1) << " ";
    cout << _RandomizedSet.insert(10) << " ";
    cout << _RandomizedSet.insert(20) << " ";
    cout << _RandomizedSet.insert(30) << " ";
    cout << _RandomizedSet.getRandom() << " ";
    cout << _RandomizedSet.getRandom() << " ";
    cout << _RandomizedSet.getRandom() << endl;

    return 0;
}