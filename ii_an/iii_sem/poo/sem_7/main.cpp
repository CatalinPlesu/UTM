/* Problema celor n regine(dame) Se cere sa se genereze toate posibilitatile de */
/* asezare a n dame pe o tabla de sah de dimensiune n*n, astfel in cat sa nu se */
/* ‘atace’ reciproc. Dupa cum stim, rezolvarea problemei difera de generarea */
/* permutarilor doar printr-o singura metoda : e_valid(). Atunci, vom redefini */
/* aceasta metoda din clasa permut, pentru a putea obtine solutia dorita */

/* De facut */
/* 1. clasa permut si rezolvare */
/* 2. in clasa permut generam matricile n*n */
/* 3. in clasa rezolvare definim metoda e_valid() */

#include <iostream>
#include <algorithm> 
#include <vector>
#include <cmath>    
using namespace std;

class Permut
{
	public:
	int n;
	vector<vector<int>> permutari;

	Permut(int n){this->n = n;};

	void Permutari()
	{

	vector<int> x(2*n, 0);
		 for (int i = 0; i < 2*this->n; i+=2) {
			 x[i] = i/2;
			 x[i+1] = i/2;
		}

		do {
			permutari.push_back(x);
		} while (std::next_permutation(x.begin(), x.end()));

	};

	void print()
	{
	cout << "Coordonatele doamnelor" << endl;
		for (int i = 0; i < permutari.size(); i++) {
			for (int j = 0; j < this->n; j+=2){
				cout << "("<< permutari[i][j] << "; ";
				cout << permutari[i][j+1] << "), ";
			}
			cout << endl;
		}
	};

	void matrice(vector<int> cord)
	{
		vector<vector<int>> mat(this->n, vector<int>(this->n, 0));
		for (int i = 0; i < cord.size(); i+=2){
			mat[cord[i]][cord[i+1]] = 8;
		}

		for (int i = 0; i < mat.size(); i++)
		{
			for (int j = 0; j < mat[i].size(); j++)
			{
				cout << mat[i][j] << " ";
			}
			cout << endl;
		}

	};

	void deseneaza(vector<vector<int>> sol){
		for (int i = 0; i < sol.size(); i++)
		{
			cout << "solutia " << i << ": " << endl;
			matrice(sol[i]);
		}
	}
};

class Rezolvare: public Permut
{
	public:
	vector<vector<int>> solutii;
	vector<vector<vector<int>>> puncte;
	Rezolvare(int n) : Permut(n)
	{
		Permutari();
		e_valid();	
	};

	void e_valid()
	{
		for (int i = 0; i < permutari.size(); i++) {
			int add = 1;
			for (int j = 0; j < 2*(this->n-1); j+=2){
				for (int z = j+2; z < 2*this->n; z+=2){
					if (permutari[i][j] == permutari[i][z] || permutari[i][j+1] == permutari[i][z+1])
						add = 0;
					if (abs( permutari[i][j] - permutari[i][z]) == abs(permutari[i][j+1] - permutari[i][z+1]))
						add = 0;
				}
			}

		if (add){
		solutii.push_back(permutari[i]);
		}
		}
		curatare();

	};

	void curatare(){
		for (int i = 0; i < this->solutii.size(); i++)
		{
			vector<vector<int>> puncte;
			for (int j = 0; j < 2* this->n; j+=2){
				vector<int> punct(2, 0);
				punct[0] = solutii[i][j];
				punct[1] = solutii[i][j+1];
				puncte.push_back(punct);
			}
			this->puncte.push_back(puncte);
		}

		for (int i = 0; i < this->puncte.size(); i++){
			sort(this->puncte[i].begin(), this->puncte[i].end());
		}

		vector<vector<int>> solutii;
		for(int i = 0; i < this->puncte.size(); i++){
			vector<int> solutie;
			for(int j = 0; j < this->puncte[0].size(); j++)
			{
				solutie.push_back(puncte[i][j][0]);
				solutie.push_back(puncte[i][j][1]);
			}
			solutii.push_back(solutie);
		}
		vector<vector<int>> myVec;
		myVec = solutii;
		sort(myVec.begin(), myVec.end());
		myVec.erase(unique(myVec.begin(), myVec.end()), myVec.end());
		this->solutii = myVec;


	};

	void print_s()
	{
	cout << "Coordonatele doamnelor" << endl;
		for (int i = 0; i < solutii.size(); i++) {
			for (int j = 0; j < 2*this->n; j+=2){
				cout << "("<< solutii[i][j] << "; ";
				cout << solutii[i][j+1] << "), ";
			}
			cout << endl;
		}
	};

};



int main()
{
	/* Permut p(5); */
	/* cout << p.n << endl; */
	/* p.Permutari(); */
	/* p.print(); */

	Rezolvare r(4);
	cout << r.n << endl;
	r.e_valid();
	cout << "slutii optime" << endl;
	/* r.print_s(); */
	/* r.print(); */
	/* r.matrice(r.solutii[0]); */
	r.deseneaza(r.solutii);

	return 0;
}
