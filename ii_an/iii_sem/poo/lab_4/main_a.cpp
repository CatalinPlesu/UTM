#include <iostream>
#include <string>

using namespace std;
/* а) De creat o ierarhie a claselor joc – joc sportiv – volei. 
 * Determinaţi constructorii,
 * destructorii,
 * operatorii de atribuire şi alte funcţii obligatorii. 
 */

class Joc{
public:
string nume;
int nrJucatori;
Joc(const string nume, int n){
	this->nume = nume;
	this->nrJucatori = n;
};
/* ~Joc(){cout << "~joc anihilated!" << endl;} */
void setName(string name){this->nume = name;};
};

class JocSportiv : public Joc{
	public:
	int scor_a, scor_b;
	JocSportiv(const string nume, int n) : Joc(nume, n){
		scor_a=0;
		scor_b=0;
	};
	/* ~JocSportiv(){cout << "~joc sportiv anihilated!" << endl;} */
	JocSportiv operator+= (int n){
		this->nrJucatori += n;
		return *this;
	};
	JocSportiv operator-- (){this->scor_b++; return *this;};
	JocSportiv operator++ (){this->scor_a++; return *this;};
};

class Volei : public JocSportiv{ 
	public:
	using JocSportiv::JocSportiv;
	/* ~Volei(){cout << "~volei anihilated!" << endl;} */
};

int main(){
	Volei v("volei", 5);
	cout << v.nume << " " << v.nrJucatori << endl;
	v.setName("de plaja");
	cout << v.nume << " " << v.nrJucatori << endl;
	Volei c("in cerc", 1);
	c += 15;
	cout << c.nume << " " << c.nrJucatori << endl;
	Volei b("Leova | Ialoveni", 4);
	--b;
	--b;
	++b;
	--b;
	cout << b.nume << "| jucatori : " << b.nrJucatori << endl;
	cout << b.scor_a<< " " << b.scor_b << endl;

	return 0;
}
