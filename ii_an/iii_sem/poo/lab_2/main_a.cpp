#include <iostream>
#include <string>
using namespace std;

class Date{
private:
	int day, month, year;
public:
	Date();
	Date(int a, int b, int c);
	Date (Date const &c);
	int Day();
	int Month();
	int Year();
	void SetDay(int a);
	void SetMonth(int a);
	void SetYear(int a);
	void Afisare1();
	void Afisare2();
};

Date::Date(){
	day=month=year=0;}

Date::Date (int a, int b, int c){
	day=a;
	if (day > 31)
		day -= 31;
	if (day < 1)
		day += 31;
	month=b;
	if (month < 1)
		month += 12;
	year=c;}

Date::Date (Date const &c){
	day=c.day; month=c.month; year=c.year;}

int Date::Day(){
	return this->day;}

int Date::Month(){
	return this->month; }

int Date::Year(){
	return this->year; }

void Date::Afisare1() {
	cout << day << "." << month << "." << year << endl;
}
void Date::Afisare2() {
	string  months[12] = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }; cout<<day<<"." <<month <<"." <<year<<endl;
	cout << day << " " << months[month-1] << " " << year << endl;
}

void Date::SetDay(int a){
	this->day = a;}

void Date::SetMonth(int a){
	this->day = a;}

void Date::SetYear(int a){
	this->day = a;}

int main(){
	Date date1, date2(25 , 9, 2021), date3(date2);
	date2.SetDay(24);
	cout << "date1 = ";
	date1.Afisare1();
	cout << "date2 = ";   
	date2.Afisare2();
	cout << date2.Day() << date2.Month() << date2.Year() << endl;

	return 0;
}
