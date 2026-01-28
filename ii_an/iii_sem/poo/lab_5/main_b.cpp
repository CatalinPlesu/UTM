// b) Să se creeze, o ierarhie de moştenire: om - student, colaborator - practicant.
// 
//			om
//		   /  \
//	student	   colaborator
//		\		/
//  	participant

#include <iostream>

class Om
{
	float health;
	float stamina;
	float mana;

	public:
	Om(float health = 100, float stamina = 100, float mana = 100){
		setHelath(health);
		setStamina(stamina);
		setMana(mana);
	};

	void setHelath(float x){this->health = x;};
	void setStamina(float x){this->stamina = x;};
	void setMana(float x){this->mana = x;};
	float getHelath(){return this->health;};
	float getStamina(){return this->stamina;};
	float getMana(){return this->mana;};

};

class Student: public virtual Om
{
	float nota;
	 
	public:
	Student(float nota = 0): Om(){setNota(nota);};
	void setNota(float nota){this->nota = nota;};
	float getNota(){return this->nota;};
};

class Colaborator: public virtual Om
{
	float salariu;

	public:
	Colaborator(float salariu = 0): Om(){setSalariu(salariu);};
	void setSalariu(float salariu){this->salariu = salariu;};
	float getSalariu(){return this->salariu;};

};

class Participant: public Student, public Colaborator
{
	public:
	Participant(float nota = 0, float salariu = 0):
		Om(),
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
	std::cout << "participant 3: " << " health " << p3.getHelath() << " stamina " <<
		p3.getStamina() << " mana " << p3.getMana() << std::endl;

	return 0;
}
