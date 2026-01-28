#include <iostream>
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

float point(float num)
{
	long long fmax = pow(10, digits(num));
	if ( num < 0 )
		num *= -1;
	while (num > 1)
	{
	float temp = num;
	temp -= fmax;
		if (temp < 0)
		{
			fmax /= 2;
		}else{
			num = temp;
		}
	}
	return num;
}

int main()
{
	printf("%f\n", point(12345.123));
		
	return 0;
}
