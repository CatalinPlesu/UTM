// b) Să se creeze o clasă
// Set – mulţimea numerelor întregi, utilizînd memoria dinamică. Să se definească
// operatorii de lucru cu mulţimile: "+" – uniunea, "*" – intersecţia, "-"
// scăderea, ca funcţii prietene, iar "+=" – înserarea unui nou element în
// mulţime, "==" – comparare la egalitate, ş. a. ca metode ale clasei. Să se
// definească operatorii "<<" şi ">>". Să se definească funcţia de verificare a
// apartenenţei unui element la o mulţime.

#include <iostream>
#include <cstdarg>
using namespace std;

// mutlimea numerelor intregi
class Z{
private:
int *m;
int n;
friend Z operator+ (Z a, Z b); // uniunea ∪
friend Z operator* (Z a, Z b); // intersectia ∩
friend Z operator- (Z a, Z b); // scaderea 
// cout cin >> << 
friend ostream& operator << (ostream& os, Z z); 
friend istream& operator >>(istream& is, Z& z); 

public:
Z(int n);
Z(char x, int n, ...);
Z operator+= (int j); // inserarea unui element nou
int operator== (Z a); // egalitatea
// metodae de verificare a apartenentei
static int belongs(int n){return 1;};
static int belongs(long n){return 1;};
static int belongs(float n){return 0;};
static int belongs(double n){return 0;};
static int belongs(char n){return 0;};
};

Z::Z(int n){
	this->n = n;
	this->m = new int[n];	
}

Z::Z(char x, int n, ...){
	this->n = n;
	this->m = new int[n];	
    va_list valist;
    va_start(valist, n); //initialize valist for num number of arguments
    for (int i = 0; i < n; i++) { //access all the arguments assigned to valist
       this->m[i] = va_arg(valist, int);
    }
    va_end(valist); //clean memory reserved for valist
}

ostream& operator<<(ostream& os, Z z){ 
	for (int i = 0; i < z.n; i++)
		os << z.m[i] << " " ;
	return os;
}

istream& operator>>(istream& is, Z& z){ 
	cout<<"\nintroduceti " << z.n << " elementele ale multimii:"; 
	for (int i = 0; i < z.n; i++)
		is>> z.m[i];
	return is;
}

Z Z::operator+= (int j){
	n += 1;
	Z z(n);
	for (int i = 0; i < n-1; i++)
		z.m[i] = this->m[i];
	z.m[n-1] = j;
	this->m = new int[n];	
	for (int i = 0; i < n; i++)
		this->m[i] = z.m[i];
	return *this;
}

int Z::operator== (Z a){
	if (this->n != a.n)
		return 0;
	for (int i = 0; i < a.n; i++)
		if (this->m[i] != a.m[i])
			return 0;
	return 1;
}

Z operator+ (Z a, Z b){
	int n = a.n;
	int f = a.n + b.n;
	int *m = new int[f];
	for (int i = 0; i < a.n; i++)
		m[i] = a.m[i];
	for (int i = 0; i < b.n; i++){
		for (int j = 0; j < n; j++)
			if (b.m[i] == m[j])
				break;
			else if (j == n-1){
			m[n] = b.m[i];
			n++;}
	}
	Z z(n);
	for (int i = 0; i < n; i++)
		z.m[i] = m[i];
	return z;
}

Z operator* (Z a, Z b){
	int n = 0;
	int f = a.n + b.n;
	int *m = new int[f];
	for (int i = 0; i < a.n; i++)
		for (int j = 0; j < b.n; j++){
			if (a.m[i] == b.m[j]){
				m[n] = b.m[i];
				n++;
			}
	}
	Z z(n);
	for (int i = 0; i < n; i++)
		z.m[i] = m[i];
	return z;
}

Z operator- (Z a, Z b){
	int n = 0;
	int f = a.n;
	int *m = new int[f];
	for (int i = 0; i < a.n; i++)
		for (int j = 0; j < b.n; j++){
			if (a.m[i] == b.m[j]){
				break;
			}else if(j == b.n -1){
				m[n] = a.m[i];
				n++;
			}
	}
	Z z(n);
	for (int i = 0; i < n; i++)
		z.m[i] = m[i];
	return z;
}

int main(){

	/* Z z(5); */
	/* cin >> z; */
	/* cout << z << endl; */

	Z d('x', 4, 1, 2, 5, 6);
	cout << d << endl; 
	Z e('e', 3, 1, 2, 3);
	Z f('f', 3, 1, 2, 3);
	int a = e == d; 
	cout << a << endl;
	a = e == f;
	cout << a << endl;
	Z g = d + e;
	cout << "g " << g << endl;
	Z y('e', 3, 1, 4, 3);
	Z u('f', 3, 1, 2, 3);
	cout << y * u << endl; 
	y += 2;
	y += 9;
	cout << y - u << endl;
	d += -1;
	d += 19;
	cout << "d " << d << endl;
	cout << Z::belongs(1) << endl;
	cout << Z::belongs(1.0) << endl;
	cout << Z::belongs('x') << endl;
	return 0;
}
