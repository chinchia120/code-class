class Solution
{
public:
    vector<int> luckyNumbers (vector<vector<int>>& matrix)
    {
        vector<int> minRows, maxCols = matrix[0];
        for(int i = 0; i < matrix.size(); i++)
        {
            int minRow = INT32_MAX;
            for(int num: matrix[i]) minRow = min(minRow, num);
            minRows.push_back(minRow);
        }
        for(int i = 1; i < matrix.size(); i++)
        {
            for(int j = 0; j < matrix[i].size(); j++) maxCols[j] = max(maxCols[j], matrix[i][j]);
        }
        
        vector<int> luckyNumber;
        for(int minRow: minRows)
        {
            for(int maxCol: maxCols)
            {
                if(minRow == maxCol)
                {
                    luckyNumber.push_back(minRow);
                    return luckyNumber;
                }
            }
        }
        return luckyNumber;
    }
};