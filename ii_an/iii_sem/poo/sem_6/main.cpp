// Să se creeze, o ierarhie de moştenire: animale - mamifere, reptile – ornitorinc.
// 	animale
// 	/		\
// mamifere	reptile
// 	\		/
// 	ornitorinc

#include <iostream>


class animal
{
	float health;
	float stamina;
	public:
	animal(float health = 100, float stamina = 100){
		setHelath(health);
		setStamina(stamina);
	};

	void setHelath(float x){this->health = x;};
	void setStamina(float x){this->stamina = x;};
	float getHelath(){return this->health;};
	float getStamina(){return this->stamina;};

};

class mamifer: public virtual animal
{
// pui vii
	int nrPui; 
	public:
	mamifer(int n = 0, float h = 100, float s = 100): animal(h, s){setNrPui(n);};
	void setNrPui(int nr){this->nrPui = nr;};
	int getNrPui(){return this->nrPui;};

	void puiNou(){
		this->nrPui++;
	};
};

class reptila: public virtual animal
{
// nasc oua
	int nrOua;

	public:
	reptila(int n = 0, float h = 100, float s = 100): animal(h, s){setNrOua(n);};
	void setNrOua(int nr){this->nrOua = nr;};
	int getNrOua(){return this->nrOua;};

	void ouNou(){
		nrOua++;
	};
};

class ornitorinc: public mamifer, public reptila
{
	public:
	ornitorinc(int p = 0, int o = 0, float h = 100, float s = 100): 
		mamifer(p),
		reptila(o),
		animal(h, s){};

	void ouNou(){
		this->setNrOua(this->getNrOua() + 1);
	};
	void puiNou(){
		this->setNrOua(this->getNrOua() - 1);
		this->setNrPui(this->getNrPui() + 1);
	};
};

int main()
{	

	ornitorinc perry(0, 0, 150, 300);
	perry.setHelath(200);
	perry.setStamina(400);
	perry.ouNou();
	perry.ouNou();
	std::cout << "ornitorincul Perry are :\n" <<
		perry.getNrPui() << " pui,\n" <<
		perry.getNrOua() << " oua,\n" <<
		perry.getHelath() << " health points,\n" <<
		perry.getStamina() << " stamina\n";
	
	std::cout << "\nUn pui a iesit din ou!!!\n";

	perry.puiNou();
	std::cout << "ornitorincul Perry are :\n" <<
		perry.getNrPui() << " pui,\n" <<
		perry.getNrOua() << " oua,\n" <<
		perry.getHelath() << " health points,\n" <<
		perry.getStamina() << " stamina\n";
	return 0;
}
