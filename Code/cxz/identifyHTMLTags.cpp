#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <cctype>
#include <iostream>
#include <algorithm>
#include <string>
#include <vector>
#include <queue>
#include <set>
#include <map>
#include <sstream>
#include <cctype>
using namespace std;

int main(int argc,char** argv){
	if (argc<3) {
		puts("Arugment Error");
		return 0;
	}
	FILE* fin=fopen(argv[1],"r");
	FILE* fout=fopen(argv[2],"w");
	set<string> tags;
	tags.clear();
	char s[1000000];
	for (;fgets(s,1000000,fin);){
		for (int i=strlen(s)-1;i>=0;i--)
			if (s[i]>='A'&&s[i]<='Z')
				s[i]=s[i]+'a'-'A';
		for (char*p=s;;){
			char* q=strstr(s,"<");
			if (!q) break;
			p=strstr(q+1,">");
			if (!p) break;
			p[0]=0;
			if (strstr(q+1,"<")==0){
				if (q[1]=='/'){
					if (tags.find(q+2)!=tags.end()
						&&tags.find(q+1)==tags.end()){
						fprintf(fout,"%s\n",q+2);
						printf("%s\n",q+2);
						tags.insert(q+1);
					}
				}
				else {
					tags.insert(q+1);
				}
			}
		}
	}
	fclose(fin);
	fclose(fout);
}