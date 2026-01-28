// Varianta 1
// - Creaţi clasa abstractă de bază Worker cu funcţia virtuală calcularea
// salariului. Creaţi clasele derivate StateWorker, HourlyWorker şi
// CommissionWorker, în care funcţia dată este predefinită.  
// 
// 	Worker(virtual calcularea salariului)
//			/			|			\
// StateWorker		HourlyWorker	CommissionWorker

#include <iostream>
#include <string>

class Worker{
	std::string name;
	std::string surname;

	public:

		Worker(std::string name, std::string surname) {
			setName(name);
			setSurname(surname);
		};
		void setName(std::string name){
			this->name = name;
		};
		void setSurname(std::string surname){
			this->surname = surname;
		};
		std::string getName(){return this->name;};
		std::string getSurname(){return this->surname;};

		virtual float calculate_salary() = 0;
};


class StateWorker: public Worker
{
		float salary;
	public:
		StateWorker(std::string name, std::string surname, float salary):
			Worker(name, surname)
	{setSalary(salary);};
		void setSalary(float salary)
			{this->salary = salary;};
		float getSalary()
		{return this->salary;};

		float calculate_salary(){return this->salary;};

		friend std::ostream& operator<< (std::ostream& os,StateWorker w); 
};

std::ostream& operator<<(std::ostream& cout, StateWorker w){ 
cout << "\nState Worker:\n" << "Prenume: " << w.getName() <<
	"\nNume: " << w.getSurname() <<
	"\nSalariu: " <<  w.getSalary() << " $\n";
return cout;
} 

class HourlyWorker: public Worker
{
	float hourly_salary;
	float worked_hours;

	public:

		HourlyWorker(std::string name, std::string surname, float salary, float hours = 0):
			Worker(name, surname)
		{setHourlySalary(salary);
			this->worked_hours=hours;};

		void setHourlySalary(float salary)
		{this->hourly_salary = salary;};
		float getHourlySalary()
		{return this->hourly_salary;};

		void work(float hours){this->worked_hours += hours;};
		float getWorkedHours()
		{return this->worked_hours;};

		float calculate_salary(){return this->hourly_salary * this->worked_hours;};
		float pay(){ 
			float salary = this->calculate_salary();
			this->worked_hours = 0;
			return salary;};

		friend std::ostream& operator<< (std::ostream& os,HourlyWorker w); 
};

std::ostream& operator<<(std::ostream& cout, HourlyWorker w){ 
cout << "\nHourly Worker:\n" << "Prenume: " << w.getName() <<
	"\nNume: " << w.getSurname() <<
	"\nSalariu pe ora: " <<  w.getHourlySalary() << " $" <<
	"\nOre lucrate: " << w.getWorkedHours() <<
	"\nSalariu total: " << w.calculate_salary() <<"$\n";
return cout;
}


class CommissionWorker: public Worker
{
	float comission;

	public:

		CommissionWorker(std::string name, std::string surname):
			Worker(name, surname)
	{this->comission = 0;};

		void give_job(float salary){this->comission += salary;};

		float calculate_salary(){return this->comission;};
		float pay(){ 
			float salary = this->calculate_salary();
			this->comission = 0;
			return salary;};

		friend std::ostream& operator<< (std::ostream& os, CommissionWorker w); 
};
std::ostream& operator<<(std::ostream& cout, CommissionWorker w){ 
cout << "\nCommission Worker:\n" << "Prenume: " << w.getName() <<
	"\nNume: " << w.getSurname() <<
	"\nSalariu total: " << w.calculate_salary() <<"$\n";
return cout;
}



// - În funcţia main determinaţi masivul de pointeri la clasa abstractă, cărei i se
// atribuie adresele obiectelor claselor derivate.
// 	
// 	array cu pointeri la worker-i
int main(){

	std::cout << " Wokring (¬‿¬) \n";

	int n = 10;
	Worker* w[n];
	for(int i = 0 ; i < n; i++) {
		if( i % 3 == 0){
			CommissionWorker *c =  new CommissionWorker("Joe", "Doe"); 
			c->give_job(1000*i);
			w[i] =  c;
		}
		else if( i % 5 == 0)
			w[i] = new HourlyWorker("Joe", "Doe", 10*i); 
		else
			w[i] = new StateWorker("Joe", "Doe", 10000*i); 
	}

	for(int i = 0 ; i < n; i++) {
		std::cout << "\n" << i << std::endl;
		if( i % 3 == 0){
			std::cout << " Commission Worker:\n" << "Prenume: " << w[i]->getName() <<
	"\nNume: " << w[i]->getSurname() <<
	"\nSalariu total: " << w[i]->calculate_salary() <<"$\n";

		}
		else if( i % 5 == 0){
	std::cout << "\nHourly Worker:\n" << "Prenume: " << w[i]->getName() <<
	"\nNume: " << w[i]->getSurname() <<
	"\nSalariu total: " << w[i]->calculate_salary() <<"$\n";
		}
		else{
	std::cout << "\nState Worker:\n" << "Prenume: " << w[i]->getName() <<
	"\nNume: " << w[i]->getSurname() <<
	"\nSalariu total: " << w[i]->calculate_salary() <<"$\n";
		}
	}

return 0;
}
