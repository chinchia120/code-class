#include <iostream>
using namespace std;

int main() {
	//question 1
	float x,y;
	cin>>x>>y;
	if(x==0 && y==0){
		cout<<"���I"<<endl;
	}else if(x==0){
		cout<<"�by�b"<<endl;
	}else if(y==0){
		cout<<"�bx�b"<<endl; 
	}else if(x>0 && y>0){
		cout<<"�Ĥ@�H��"<<endl;
	}else if(x<0 && y>0){
		cout<<"�ĤG�H��"<<endl;
	}else if(x<0 && y<0){
		cout<<"�ĤT�H��"<<endl;
	}else if(x>0 && y<0){
		cout<<"�ĥ|�H��"<<endl;
	}
    return 0;
}

