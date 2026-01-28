#include <iostream>
#include <cassert>
using namespace std;

long long pow(int num, int exp){
	int pow = 1;
	for (int i = 0; i < exp; i++)
		pow = pow * num;
	return pow;
}

int digits(float num)
{
	int digits = 0;
	while (num > 1){
		num /= 10;
		digits += 1;
	}
	return digits;
}

int integer(float num)
{   
	long long imax = pow(10, digits(num)); // limita
	long long diff = imax / 2;
	while (num - diff > 1 || num - diff < 0)
	{	
		if (num - diff < 0){
			imax /= 2;
			diff -= imax;
		}
		if (num - diff >= 1){
			if (imax > 1)
				imax /= 2;
			diff += imax;
		}
		if (imax == 0)
			break;
	}	
	return diff;	
}


float float_point(float num)
{
	return num - integer(num);
}

int main()
{

	printf("%f == %f\n", float_point(111.111), 0.111);
	printf("%f == %f\n", float_point(123111.1114), 0.1114);
	return 0;
}
