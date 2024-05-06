#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int numRookCaptures(vector<vector<char>>& board)
    {
        int cnt = 0;
        for(int i = 0; i < board.size(); i++)
        {
            for(int j = 0; j < board[i].size(); j++)
            {
                if(board[i][j] == 'R')
                {
                    for(int k = j; k >= 0; k--)
                    {
                        if(board[i][k] == 'p')
                        {
                            cnt++;
                            break;
                        }
                        
                        if(board[i][k] == 'B') break;
                    }

                    for(int k = j; k < board[i].size(); k++)
                    {
                        if(board[i][k] == 'p')
                        {
                            cnt++;
                            break;
                        }
                        
                        if(board[i][k] == 'B') break;
                    }

                    for(int k = i; k >= 0; k--)
                    {
                        if(board[k][j] == 'p')
                        {
                            cnt++;
                            break;
                        }
                        
                        if(board[k][j] == 'B') break;
                    }

                    for(int k = i; k < board.size(); k++)
                    {
                        if(board[k][j] == 'p')
                        {
                            cnt++;
                            break;
                        }
                        
                        if(board[k][j] == 'B') break;
                    }
                }
            }
        }
        return cnt;
    }

    void show_2d_vector(vector<vector<char>> vec)
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
    vector<vector<char>> board = {{".",".",".",".",".",".",".","."},{".",".",".","p",".",".",".","."},{".",".",".","R",".",".",".","p"},{".",".",".",".",".",".",".","."},{".",".",".",".",".",".",".","."},{".",".",".","p",".",".",".","."},{".",".",".",".",".",".",".","."},{".",".",".",".",".",".",".","."}};
    Solution S;

    cout << S.numRookCaptures(board);

    return 0;
}