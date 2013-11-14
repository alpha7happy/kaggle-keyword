#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <string>
#include <vector>
#include <queue>
#include <set>
#include <map>
#include <sstream>
#include <cctype>
using namespace std;

#define lowbit(x) ((x)&(-(x)))
#define sqr(x) ((x)*(x))
#define PB push_back
#define MP make_pair

int nT,nW;
double ** tiwj;
double * ti;
double * wi;

FILE* ftitle;
FILE* fbody;
FILE* fcand;
FILE* fpred;

void loadPvector(char *filename,int &N,double* &p){
	vector<double> t;
	t.clear();
	FILE* fin=fopen(filename,"r");
	for (double pi;fscanf(fin,"%lf",&pi)==1;)
		t.PB(pi);
	N=t.size();
	p=new double[N];
	for (int i=0;i<N;i++){
		p[i]=t[i];
	}
	fclose(fin);
}

void loadPmatrix(char *filename,int &N,int &M,double** &p){
	p=new double*[N];
	for (int i=0;i<N;i++)
		p[i]=new double[M];
	ifstream fin (filename, ios::out | ios::binary);
	for (int i=0;i<N;i++)
		for (int j=0;j<M;j++){
			fin.read((char*)(&p[i][j] ), sizeof(double));
		}
	fin.close();
}

vector<pair<int,int> > parseFeature(char* s){
	vector<pair<int,int> > res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id,cnt=1;
		if (sscanf(p,"%d:%d",&id,&cnt)>=1)
			res.PB(MP(id,cnt));
	}
	return res;
}

char s[1000000];
vector<pair<int,int> > title,body,cand;

double predict(vector<pair<int,int> >body, int tid){
	double *tp=tiwj[tid];
	double res=0;
	for (int i=0;i<body.size();i++){
		res+=body[i].second*tp[body[i].first];
	}
	res+=ti[tid];
	return res;
}

int main(int argc,char** argv){
	if (argc!=8){
		puts("Argument Error");
		return 0;
	}
	srand(time(0));
	loadPvector(argv[1],nT,ti);
	loadPvector(argv[2],nW,wi);
	loadPmatrix(argv[3],nT,nW,tiwj);

	puts("Loading Finish");
	ftitle=fopen(argv[4],"r");
	fbody=fopen(argv[5],"r");
	fcand=fopen(argv[6],"r");
	fpred=fopen(argv[7],"w");

	int cnt=0;
	for (;fgets(s,1000000,fbody);) if (strlen(s)>1){

		cnt++;
		if (cnt%1000==0){
			printf("\rLoading %d",cnt);
			fflush(stdout);
		}
		body=parseFeature(s);
		fgets(s,1000000,fcand);
		cand=parseFeature(s);
		
		vector<pair<double,int> > pred;
		pred.clear();

		//for (int i=0;i<cand.size();i++)
			//pred.PB(MP(predict(body,cand[i].first),cand[i].first));
		for (int i=0;i<1000;i++)
			pred.PB(MP(predict(body,i),i));
		
		sort(pred.begin(),pred.end());
		reverse(pred.begin(),pred.end());
		for (int i=0;i<20;i++)
			fprintf(fpred,"%d:%.5f ",pred[i].second,pred[i].first);
		fprintf(fpred,"\n");
	}

	fclose(ftitle);
	fclose(fbody);
	fclose(fcand);
	fclose(fpred);

	return 0;
}