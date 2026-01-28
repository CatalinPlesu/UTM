#include <iostream>
#include <string>
#include <random>

using namespace std;

class Matrix{
	int **p, row, col;
	string err;
	public:
	Matrix();
	Matrix(int r);
	Matrix(int r, int c);
	int Get(int r, int c);
	void Set(int r, int c, int n);
	void Print();
	void Alloc();
	void Random();
	Matrix operator+(const Matrix&) const;  
	Matrix operator-(const Matrix&) const;  
	Matrix operator*(const Matrix&) const;  
	Matrix operator*(const int&) const;  

		 
};

void Matrix::Alloc(){
	this->p = new int*[this->row];
	for(int i = 0; i < this->row; i++)
		this->p[i] = new int[this->col]; 
}

void Matrix::Random(){
    random_device rd; // obtain a random number from hardware
    mt19937 gen(rd()); // seed the generator
    uniform_int_distribution<> distr(0, 10); // define the range

	for (int i = 0; i < this->row; i++)
		for (int j = 0; j < this->col; j++)
			this->p[i][j] = distr(gen);
}

Matrix::Matrix() : row(0), col(0), err("") {
	Alloc();
}

Matrix::Matrix(int r){
	this->row = r;
	this->col = r;
	this->err = "";
	Alloc();
}

Matrix::Matrix(int r, int c){
	this->row = r;
	this->col = c;
	this->err = "";
	this->p = new int*[r];
	for(int i = 0; i < r; i++)
		this->p[i] = new int[r]; 
}

int Matrix::Get(int r, int c){
	return this->p[r][c];		
}
void Matrix::Set(int r, int c, int n){
	this->p[r][c] = n;		
}

Matrix Matrix::operator+ (const Matrix& c) const
{
	Matrix result(this->row, this->col);
	if ( this->row != c.row || this->col != c.col ){
		result.err = "Incompatible size";
		cout << result.err << endl;
		return result;
	}

	for (int i = 0; i < this->row; i++)
		for (int j = 0; j < this->col; j++)
			result.p[i][j] = this->p[i][j] + c.p[i][j];

	return result;
}

Matrix Matrix::operator- (const Matrix& c) const
{
	Matrix result(this->row, this->col);
	if ( this->row != c.row || this->col != c.col ){
		result.err = "Incompatible size";
		cout << result.err << endl;
		return result;
	}

	for (int i = 0; i < this->row; i++)
		for (int j = 0; j < this->col; j++)
			result.p[i][j] = this->p[i][j] - c.p[i][j];

	return result;
}
Matrix Matrix::operator* (const Matrix& c) const
{
	Matrix result(this->row, c.col);
	if ( this->col != c.row ){
		result.err = "Incompatible size";
		cout << result.err << endl;
		return result;
	}

    for(int i=0; i< this->row; i++){
            for(int j=0; j < c.col; j++){
                int sum =0;
                for(int k=0; k < c.row; k++){
                    sum += (this->p[i][k] * c.p[k][j]);
                }
                result.p[i][j] = sum;
            }
        }

	return result;
}

Matrix Matrix::operator* (const int& c) const
{
	Matrix result(this->row, this->col);

	cout << this->row << this->col << endl;
	for (int i = 0; i < this->row; i++)
		for (int j = 0; j < this->col; j++)
			 result.p[i][j] = this->p[i][j] * c;

	return result;
}
void Matrix::Print(){
	for (int i = 0; i < this->row; i++){
		for (int j = 0; j < this->col; j++)
			 cout << " " << this->p[i][j] << " ";
		cout << endl;
	}
}

int main(){
	Matrix m1;
	Matrix m2(5);
	Matrix m3(5, 5);
	m2.Random();
	m3.Random();
	m2.Set(1,2,0);
	m3.Set(1,2,0);
	cout << "m2" << endl;
	m2.Print();
	cout << "m3" << endl;
	m3.Print();
	cout << m3.Get(1,2) << endl;
	m1 = m2 + m3;
	cout << "m1" << endl;
	m1.Print();
	m1 = m1 - m2;
	cout << "m1" << endl;
	m1.Print();
	Matrix a(2,3), b(3,4);
	a.Random();
	b.Random();
	cout << "a" << endl;
	a.Print();
	cout << "b" << endl;
	b.Print();
	Matrix c;
	c = a * b;
	cout << "c" << endl;
	c.Print();
	c = c * 2;
	cout << "c" << endl;
	c.Print();
	return 0;
}
