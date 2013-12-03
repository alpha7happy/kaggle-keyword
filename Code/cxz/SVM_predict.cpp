#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <iostream>
#include <algorithm>
#include <string>
#include <vector>
#include <queue>
#include <set>
#include <map>
#include <sstream>
#include <cctype>
#include <fstream>
using namespace std;

#define lowbit(x) ((x)&(-(x)))
#define sqr(x) ((x)*(x))
#define PB push_back
#define MP make_pair

vector<vector<pair<double,int> > > pred;
int Ntag;

vector<pair<int,int> > parseFeature(char* s){
	vector<pair<int,int> > res;
	res.clear();
	for (char* p=strtok(s," ");p;p=strtok(NULL," ")){
		int id,cnt;
		if (sscanf(p,"%d:%d",&id,&cnt)==2)
			if (id!=-1)
				res.PB(MP(id,cnt));
	}
	return res;
}

char s[1000000];
int main(int argc,char** argv){
	if (argc!=5){
		puts("Argument Error");
		return 0;
	}
	FILE* ffeature=fopen(argv[1],"r");
	string svmdir=argv[2];
	int Ntag=atoi(argv[3]);
	FILE* fpred=fopen(argv[4],"w");
	
	pred.clear();
	FILE* ffeatureout=fopen((svmdir+"Test.Feature").c_str(),"w");
	for (;fgets(s,100000,ffeature);){
		fprintf(ffeatureout,"%d %s",0,s);
	}
	fclose(ffeatureout);

	int cnt=0;
	
	for (int i=0;i<Ntag;i++){
		printf("\rRunning SVM_predict on Tag %d",i);
		fflush(stdout);
		char cmd[1000];
		sprintf(cmd,"Tools/SVMlight/svm_classify %sTest.Feature %s%d.model %s%d.predict> %s%d.predlog"
			,svmdir.c_str(),svmdir.c_str(),i,svmdir.c_str(),i,svmdir.c_str(),i);
		system(cmd);
		char filename[1000];
		sprintf(filename,"%s%d.predict",svmdir.c_str(),i);
		FILE* ftpred=fopen(filename,"r");
		double score;
		int z=0;
		for (;fscanf(ftpred,"%lf",&score)==1;z++){
			if (i==0){
				vector<pair<double,int> >tpred;
				tpred.clear();
				pred.PB(tpred);
			}
			pred[z].PB(MP(score,i));
		}
		fclose(ftpred);
	}
	printf("\rSVM_Predict Finished                     \n");
	for (int i=0;i<pred.size();i++){
		sort(pred[i].begin(),pred[i].end());
		reverse(pred[i].begin(),pred[i].end());
		for (int j=0;j<Ntag;j++)
			fprintf(fpred,"%d:%.5f ",pred[i][j].second,pred[i][j].first);
		fprintf(fpred,"\n");
	}
	fclose(fpred);
	puts("SVM Prediction Generated");
	return 0;
}