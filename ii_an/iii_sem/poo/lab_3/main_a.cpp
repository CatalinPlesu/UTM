// Varianta 1
// а) Să se creeze o clasă de numere întregi. Să se definească operatorii "++" şi
// "+", ca metode ale clasei, iar operatorii "- -" şi "-" ca funcţii prietene.
// Operatorii trebuie să permită efectuarea operaţiilor atît cu variabilele clasei
// date, cît şi cu variabilele întregi de tip predefinit.  

#include <iostream>
using namespace std;

class Integer{
	int num;
	public:
	Integer(int num = 0){this->num = num;};
	Integer operator+ (Integer b);
	Integer operator+ (int b);
	Integer operator++ ();
	private:
	friend ostream& operator<< (ostream& os,Integer i) ; 
	friend Integer operator- (Integer a,Integer b);
	friend int operator- (int a,Integer b);
	friend Integer operator- (Integer a,int b);
	friend Integer operator-- (Integer a);

};

ostream& operator<<(ostream& os, Integer i){ 
os <<i.num;
return os;
}

Integer Integer::operator+ (Integer b){
	Integer x;
	x.num = num + b.num;
	return x;
}

Integer Integer::operator+ (int b){
	Integer x;
	x.num = num + b;
	return x;
}

Integer Integer::operator++ (){
	Integer x;
	x.num = num + 1;
	return x;
}

Integer operator- (Integer a, Integer b){
	Integer x;
	x.num = a.num - b.num;
	return x;
}

int operator- (int a, Integer b){
	int x;
	x = a - b.num;
	return x;
}

Integer operator- (Integer a, int b){
	Integer x;
	x.num = a.num - b;
	return x;
}

Integer operator-- (Integer a){
	Integer x;
	x.num = a.num - 1;
	return x;
}


int main(){
	Integer x(5);	
	Integer a(11);
	cout << x << endl;
	x = x + x;
	cout << x << endl;
	cout << ++++x <<endl;
	cout << x + 11 <<endl;
	cout << x << endl;
	cout << a - x << endl;
	cout << --a << endl;
	cout << a - 5;
	return 0;
}
