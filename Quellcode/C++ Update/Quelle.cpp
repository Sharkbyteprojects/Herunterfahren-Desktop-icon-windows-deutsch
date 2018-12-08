#include <iostream>
#include <cstdlib>
using namespace std;
int main() {
	system("title Herunterfahren");
	cout << "\a" << "Moechten sie den PC wirklich Herunterfahren\?" << endl;
	system("PAUSE");
	system("shutdown -s -t 0000");
	return 0;
}