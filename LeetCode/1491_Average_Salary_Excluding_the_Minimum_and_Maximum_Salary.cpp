class Solution {
public:
    double average(vector<int>& salary)
    {   
        sort(salary.begin(), salary.end());
        salary.erase(salary.begin());
        salary.pop_back();

        double sum = 0;
        for(int num: salary) sum += num/1000;
        return sum*1000/salary.size();
    }
};