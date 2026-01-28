#include <iostream>
#include <string>
using namespace std;

class ApartamentOdaie
{
	class Camera
	{
		float suprafata;
		public:
		Camera(float suprafata){this->suprafata = suprafata;};
		void setSuprafata(float suprafata){this->suprafata = suprafata;};
		float getSuprafata(){return this->suprafata;};
	};
	int etaj;
	public:
	Camera odaie;
	Camera bucatarie;
	ApartamentOdaie(float, float, int);
	ApartamentOdaie();
	int getEtaj(){return this->etaj;};
	void setEtaj(int e){this->etaj = e;};

	friend ostream& operator<< (ostream& os, ApartamentOdaie a); 
};

ostream& operator<<(ostream& os, ApartamentOdaie a){ 
cout << "suprafata odaie: " << a.odaie.getSuprafata() << "; suprafata bucatarie: "
	<< a.bucatarie.getSuprafata() << "; etajul: " << a.getEtaj();
return os;
}

ApartamentOdaie::ApartamentOdaie(float s1, float s2, int e):
	odaie(s1),
	bucatarie(s2)
{
 this->etaj = e;
}

ApartamentOdaie::ApartamentOdaie():
	odaie(-1),
	bucatarie(-1)
{
 this->etaj = -1;
}

class ApartamentOdaieAdresa: public ApartamentOdaie
{
		string adresa;
	public:
		ApartamentOdaieAdresa(string, float, float, int);
		ApartamentOdaieAdresa();

		void setAdresa(string a){this->adresa = a;};
		string getAdresa(){return this->adresa;};

	friend ostream& operator<< (ostream& os, ApartamentOdaieAdresa a); 
};

ostream& operator<<(ostream& os, ApartamentOdaieAdresa a){ 
cout << "adresa: " << a.getAdresa() << "; suprafata odaie: " << a.odaie.getSuprafata() << "; suprafata bucatarie: "
	<< a.bucatarie.getSuprafata() << "; etajul: " << a.getEtaj();
return os;
}

ApartamentOdaieAdresa::ApartamentOdaieAdresa(string a, float s1, float s2, int e):
	ApartamentOdaie(s1, s2, e)
{
 this->adresa = a;
}

ApartamentOdaieAdresa::ApartamentOdaieAdresa():
	ApartamentOdaie()
{
 this->adresa = "caminul nr.2";
}

int main()
{
	cout << "running T_T" << endl;

	ApartamentOdaie a(11, 22, 32);
	ApartamentOdaieAdresa b("liv 12", 22, 22, 1);
	cout << a << endl;
	cout << b << endl;
	return 0;
}
