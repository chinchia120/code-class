#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minNumberOfHours(int initialEnergy, int initialExperience, vector<int>& energy, vector<int>& experience)
    {
        int trainEne = 0, trainExp = 0, train = 0, nowEne = initialEnergy, nowExp = initialExperience;
        for(int i = 0; i < energy.size(); i++)
        {
            if(nowEne <= energy[i])
            {
                trainEne = energy[i]-nowEne+1;
                nowEne += trainEne;
                train += trainEne;
            }

            if(nowExp <= experience[i])
            {
                trainExp = experience[i]-nowExp+1;
                nowExp += trainExp;
                train += trainExp;
            }

            nowEne -= energy[i];
            nowExp += experience[i];
        }
        return train;
    }
};

int main(int argc, char **argv)
{
    int initialEnergy = 94, initialExperience = 70;
    vector<int> energy = {58,47,100,71,47,6,92,82,35,16,50,15,42,5,2,45,22}, experience = {77,83,99,76,75,66,58,84,44,98,70,41,48,7,10,61,28};
    Solution S;

    cout << S.minNumberOfHours(initialEnergy, initialExperience, energy, experience);

    return 0;
}