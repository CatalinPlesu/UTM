#include <iostream>
#include <string>
using namespace std;

/* b) De creat clasa roata,  care conţine rază. Determinaţi constructorii şi metodele de acces.
 * Creaţi clasa automobil, care conţine roţi şi un câmp care reprezintă firma producătoare.
 * Creaţi o clasă derivată autocamion care se deosebeşte prin tonaj.
 * Determinaţi constructorii, destructorii şi alte funcţii necesare.
 */

class Roata{
		float raza;
	public:
		Roata(float r){this->raza = r;};
		float getR(){return this->raza;};
};                 


class Automobil{
	public:
		string firma;
		Roata roata;
		int roti;
		Automobil(string f, float r, int n) : roata(r) {
			this->firma = f;
			this->roti = n;
		};
	friend ostream& operator<< (ostream& os,Automobil a); 
	/* ~Automobil(){cout << "automobil distrus" << endl;}; */
};

ostream& operator<<(ostream& os, Automobil a){ 
os << a.firma << " <- firma; " << a.roata.getR() << " <- raza roti; " << a.roti << " <- roti;";
return os;
}

class Autocamion : public Automobil {
	public:
		float tonaj;
	Autocamion(string f, float r, int n, float t) : Automobil(f, r, n){
		this->tonaj = t;};
	friend ostream& operator<< (ostream& os,Autocamion a); 
	/* ~Autocamion(){cout << "Autocamion distrus" << endl;}; */
};

ostream& operator<<(ostream& os, Autocamion a){ 
os << a.firma << " <- firma; " << a.roata.getR() << " <- raza roti; " << a.roti << " <- roti; " << a.tonaj << " <- tonaj ";
return os;
}

int main(){
	Automobil masina("skoda", 20, 4);
	cout << masina << endl;
	Autocamion camion("camaz", 100, 6, 4.0);
	cout << camion << endl;
	return 0;
}
