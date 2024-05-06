#include <iostream>
using namespace std;

class Solution
{
public:
    bool isLongPressedName(string name, string typed)
    {
        if(typed.length() < name.length()) return false;

        if(name.length() == typed.length() && name == typed) return true;
        else if (name.length() == typed.length() && name != typed) return false;

        name.push_back((int)name[name.size()-1]+1);
        typed.push_back((int)typed[typed.size()-1]+1);

        while(1)
        {   
            char tmp_name = name[0], tmp_typed = typed[0];
            int cnt_name = 0, cnt_typed = 0; 

            for(int i = 0; i < name.length(); i++)
            {   
                if(tmp_name == name[i])
                {
                    cnt_name++;
                }
                else
                {
                    for(int j = 0; j < cnt_name; j++) name.erase(name.begin()+0);
                    break;
                }
            }

            for(int i = 0; i < typed.length(); i++)
            {
                if(tmp_typed == typed[i])
                {
                    cnt_typed++;
                }
                else
                {
                    for(int j = 0; j < cnt_typed; j++) typed.erase(typed.begin()+0);
                    break;
                }
            }

            if(tmp_typed == tmp_name && cnt_typed >= cnt_name)
            {
                tmp_name = name[0];
                tmp_typed = typed[0];
                cnt_name = 0;
                cnt_typed = 0;
            }
            else
            {
                return false;
            }

            if(name.length() == 0) break;

            if(name == typed) return true;
        }
        return true;
    }
};

int main(int argc, char **argv)
{
    string name = "vtkgn", typed = "vttkgnn"; 
    Solution S;

    cout << S.isLongPressedName(name, typed);

    return 0;
}