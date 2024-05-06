#include <iostream>
using namespace std;


/* Definition for singly-linked list. */
struct ListNode
{
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

class Solution
{
public:
    ListNode* deleteDuplicates(ListNode* head)
    {   
        if(head == NULL || head->next == NULL) return head;

        ListNode *pre = head;
        ListNode *nex = head->next;
        
        while(nex)
        {
            if(pre->val == nex->val)
            {
                ListNode *tmp = nex;
                pre->next = nex->next;
            }
            else
            {
                pre = nex;
            }
            nex = nex->next;
        }
        return head;
    }
};

int main(int atgc, char **argv)
{
    ListNode *head = new ListNode(1);
    Solution S;

    S.deleteDuplicates(head);

    return 0;
}