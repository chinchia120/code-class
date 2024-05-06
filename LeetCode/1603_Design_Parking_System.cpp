#include <iostream>
using namespace std;

class ParkingSystem
{
public:
    int _big, _mediumm, _small;
    ParkingSystem(int big, int medium, int small)
    {
        _big = big;
        _mediumm = medium;
        _small = small;
    }
    
    bool addCar(int carType)
    {
        if(carType == 1)
        {
            _big--;
            return (_big >= 0) ? true : false;   
        }

        if(carType == 2)
        {
            _mediumm--;
            return (_mediumm >= 0) ? true : false;   
        }

        if(carType == 3)
        {
            _small--;
            return (_small >= 0) ? true : false;   
        }
        return false;
    }
};

int main(int atgc, char **argv)
{
    int big = 1, medium = 1, small = 0;
    ParkingSystem parkingsystem(big, medium, small);

    cout << parkingsystem.addCar(1) << endl;
    cout << parkingsystem.addCar(2) << endl;
    cout << parkingsystem.addCar(3) << endl;
    cout << parkingsystem.addCar(1) << endl;

    return 0;
}