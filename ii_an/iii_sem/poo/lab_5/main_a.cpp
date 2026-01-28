// a) Să se creeze, o ierarhie de moştenire: student, colaborator - practicant.
// 
// studen		colaborator
// 	  \			  /
//	   participant

#include <iostream>

class Student
{
	float nota;
	public:
	Student(float nota = 0){setNota(nota);};
	void setNota(float nota){this->nota = nota;};
	float getNota(){return this->nota;};
};

class Colaborator
{
	float salariu;
	public:
	Colaborator(float salariu = 0){setSalariu(salariu);};
	void setSalariu(float salariu){this->salariu = salariu;};
	float getSalariu(){return this->salariu;};

};

class Participant: public Student, public Colaborator
{
	public:
	Participant(float nota = 0, float salariu = 0):
		Student(nota),
		Colaborator(salariu){};
};

int main()
{	
	std::cout << "running (^_<)\n";
	
	Student s1;
	Student s2(10);

	Colaborator c1;
	Colaborator c2(10000);

	Participant p1;
	Participant p2(10);
	Participant p3(8.5, 10000);

	std::cout << "student 2: " << s2.getNota() << std::endl;
	std::cout << "colaborator 1: " << c1.getSalariu() << std::endl;
	std::cout << "participant 3: " << " nota " << p3.getNota() << " salaru " <<
			p3 . getSalariu () << std::endl;

	return 0;
}
