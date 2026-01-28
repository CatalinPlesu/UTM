// Fișierul date.in conține informații despre notele a n studenți la unitățile de
// curs studiate în cadrul unui semestru. Să se elaboreze un program prin
// intermediul căruia să se realizeze următoarele operații:
// ⁃ Citirea datelor din fișier și afișarea acestora la consolă;
// ⁃ Determinarea studentului cu cea mai mare reușită;
// ⁃ Determinarea disciplinei pentru care studenții au cele mai înalte note;
// ⁃ Afișarea datelor despre studenți în ordine crescătoare a numelui;
// ⁃ Modificarea notei la disciplina selectată;
// ⁃ Afișarea datelor despre studenți în ordine descrescătoare a reușitei semestriale.
// 
// Întrebări de control:
// 1.  Ce paradigmă de programare ve-ți utiliza la rezolvarea acestei probleme ?
// Justificați alegerea.
// 2.  Rezolvați problema cu utilizarea paradigmelor de programare prezentate. Ce
// dificultăți întâmpinați la 
#include <string>
#include <iostream>
#include <fstream>
#include <vector>
using namespace std;

class Student {       
  public:             
    string name;  
    string surname;  
	vector<string> classes;
	vector<double> marks;
};
vector<Student> readFile(){

	vector<Student> students;

	ifstream file;
	file.open("date.in", ios::in);
    string word;
    char x ;
    word.clear();
  while ( ! file.eof() )
    {
        x = file.get();

        while ( x != ' ' )
        {
            word = word + x;
            x = file.get();
        }

            cout<< word <<endl;
            word.clear();

    }
	file.close();
	return students;
}

int main(int argc, char** argv) {
	vector<Student> students;

	readFile();
  return 0;
}
