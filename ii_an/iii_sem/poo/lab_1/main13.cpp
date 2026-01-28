/* 13. Să se creeze tipul abstract de date */
/* (structura) – monitor, care are denumirea firmei */
/* producătoare, dimensiunea în inch, numărul de */
/* culori şi rezoluţie. Să se definească funcţiile */
/* de setare, de modificare a datelor, de comparare */
/* a monitoarelor. Pentru crearea cîmpurilor */
/* textuale să se utilizeze operatorul new. Să se */
/* elibereze memoria. În main să se exemplifice */
/* căutarea monitorului potrivit după dimensiune şi */
/* alte caracteristici. */
#include <iostream>
#include <vector>
#include <cstring>
using namespace std;

struct monitor{
	char* firma;
	float diagonala;
	int culori;
	int rezolutia;
}monitor;

void citire_monitor(struct monitor* curent){
	cout << "denumirea firmei: ";
	char temp[255];
	cin >> temp;
	curent->firma = new char[strlen(temp)+1]; 
	strcpy(curent->firma, temp);
	cout << "diagonala (inch): ";
	cin >> curent->diagonala;
	cout << "numarul de culori: ";
	cin >> curent->culori;
	cout << "rezolutia px: ";
	cin >> curent->rezolutia;
}

struct monitor setare_monitor(const char *firma, int diag, int cul, int rez){
	struct monitor curent;
	curent.firma = new char[strlen(firma)+1]; 
	strcpy(curent.firma, firma);
	curent.diagonala = diag;
	curent.culori = cul;
	curent.rezolutia = rez;
	return curent;
}

void print_monitor(struct monitor curent){
	cout << "denumirea firmei: " << curent.firma << endl;
	cout << "diagonala (inch): " << curent.diagonala << endl;
	cout << "numarul de culori: " <<  curent.culori << endl;
	cout << "rezolutia px: " << curent.rezolutia << endl;
}

void modificare_monitor(struct monitor* curent){
	print_monitor(*curent);
	char c;
	cout << "schimbati denumirea firmei [N/y]: ";
	cin.get(c);
	cin.get(c);
	if ( c == 'y' ){
	char temp[255];
	cin >> temp;
	delete curent->firma;
	curent->firma = new char[strlen(temp)+1]; 
	strcpy(curent->firma, temp);
	}
	cout << "schimbati diagonala (inch) [N/y]: ";
	cin.get(c);
	cin.get(c);
	if ( c == 'y' ){
	cin >> curent->diagonala;
	}
	cout << "schimbati numarul de culori [N/y]: ";
	cin.get(c);
	cin.get(c);
	if ( c == 'y' ){
	cin >> curent->culori;
	}
	cout << "schimbati rezolutia px [N/y]: ";
	cin.get(c);
	cin.get(c);
	if ( c == 'y' ){
	cin >> curent->culori;
	}
}

void sterge_monitor(struct monitor &curent){
	delete curent.firma; 
}

int comparare_monitor(struct monitor m1, struct monitor m2, int n){
switch (n){
	case 1:
		if (m1.diagonala > m2.diagonala)
			return 1;
		else 
			return 0;
		break;
	case 2:
		if (m1.culori> m2.culori)
			return 1;
		else 
			return 0;
		break;
	case 3:
		if (m1.rezolutia > m2.rezolutia)
			return 1;
		else 
			return 0;
		break;
	}
	return 0;
}

int main(){
	vector<struct monitor> m;
	m.push_back(setare_monitor("catalin2",15,255,720));
	m.push_back(setare_monitor("catalin3",15,255,1080));
	m.push_back(setare_monitor("alex1",17,855,720));
	m.push_back(setare_monitor("vlardian",27,355,2720));

	for(int i=0; i < m.size(); i++){
		cout << endl;
		print_monitor(m[i]);
	}

	for(int i=0; i < m.size()-1; i++){
	cout << comparare_monitor(m[i], m[i+1], 1);
	cout << comparare_monitor(m[i], m[i+1], 2);
	cout << comparare_monitor(m[i], m[i+1], 3) << endl;
	}

	struct monitor potrivit;
	cout << "monitorul cautat:" << endl;
	citire_monitor(&potrivit);
	int n;
	cout << "criteriu de cautare diagonala/ culori/ rezolutie - [1/2/3]" << endl;
	cin >> n;
	
	float delta = 999999;
	int index = 0;
	for(int i=0; i < m.size(); i++){
		float temp;
		switch(n){
			case 1:
				temp = abs(potrivit.diagonala - m[i].diagonala);
				if (temp <= delta){
					delta = temp;
					index = i;
				}
				break;
			case 2:
				temp = abs(potrivit.culori - m[i].culori);
				if (temp <= delta){
					delta = temp;
					index = i;
				}
				break;
			case 3:
				temp = abs(potrivit.rezolutia - m[i].rezolutia);
				if (temp <= delta){
					delta = temp;
					index = i;
				}
				break;
		} 
	}
	print_monitor(m[index]);

	for(int i=0; i < m.size(); i++){
		sterge_monitor(m[i]);
	}
	m.clear();
	return 0;
}
