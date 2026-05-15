#include <iostream>
#include <string>
#include <algorithm>

using namespace std;

class Solution {
    public:
        bool canBeEqual(string s1, string s2) {
            string tmp1 = s1, tmp2 = s2;

            if (CheckString(s1, s2))
            {
                return true;
            }
            
            swap(s1[0], s1[2]);
            if (CheckString(s1, s2))
            {
                return true;
            }

            swap(s1[1], s1[3]);
            if (CheckString(s1, s2))
            {
                return true;
            }

            swap(tmp1[1], tmp1[3]);
            if (CheckString(tmp1, tmp2))
            {
                return true;
            }

            return false;
        }

        bool CheckString (string s1, string s2) {
            return s1 == s2;
        }
};