set<char> pdignore;
set<string> pdlabel;
set<string> pdtags;
bool pdinit=false;

void parseDocInit(string HTMLTagFileName,string TagsFileName){
	pdinit=true;
	pdignore.clear();
	pdlabel.clear();
	FILE* fin;
	fin=fopen(HTMLTagFileName.c_str(),"r");
	for (char s[1000];fscanf(fin,"%s",s)==1;)
		pdlabel.insert(s);
	fclose(fin);
	pdtags.clear();
	fin=fopen(TagsFileName.c_str(),"r");
	for (char s[1000];fscanf(fin,"%s%*d",s)==1;)
		pdtags.insert(s);
	fclose(fin);
}

string identify(string p){
	if (p.size()==0) return "";
	bool num=true;
	bool d=false;
	for (int i=0;i<p.size();i++)
		if (p[i]=='.') d=true;
	else 
		if (!isdigit(p[i])){
			num=false;
			break;
		}
	if (num) return d?"DOUBLE ":"INT ";
	return p+" ";
}

string parseDoc(char* s, bool istag=false){
	if (!pdinit){
		puts("parseDoc not initialized");
		return s;
	}
	int len=strlen(s);
	
	for (int i=0;i<len;i++)
		if (s[i]>='A'&&s[i]<='Z')
			s[i]=s[i]-'A'+'a';

	for (int i=0;i<len;i++)
		if (isalpha(s[i])||isdigit(s[i])) continue;
		else if (s[i]=='<'){
				s[i]=' ';
				string label="";
				int z;
				for (z=1;z<20;z++)
					if (s[i+z]=='>') break;
					else label=label+s[i+z];
				if (z<20){
					s[i+z]=' ';
					string plabel;
					if (label[0]=='/') plabel=label.substr(1);
					else plabel=label;
					if (pdlabel.find(plabel)!=pdlabel.end()){
						for (int j=1;j<z;j++)
							if (s[i+j]=='/') s[i+j]='E';
						else if (s[i+j]>='a'&&s[i+j]<='z') s[i+j]=s[i+j]-'a'+'A';
						else s[i+j]='E';
					}
				}
			}
		else if (s[i]!='-'&&s[i]!='#'&&s[i]!='+'&&s[i]!='.')
			s[i]=' ';
	
	string res="";
	for (char*p=strtok(s," ");p;p=strtok(NULL," ")){
		int pl=strlen(p);
		if (strstr(p,"-")==0&&strstr(p,"#")==0&&strstr(p,"+")==0&&strstr(p,".")==0)
			res+=identify(p);
		else {
			if (pdtags.find(p)!=pdtags.end()){
				res+=(string)p+" ";
			}
			else {
				bool num=true;
				int cd=0;
				for (int i=0;i<pl;i++)
					if (p[i]=='.') cd++;
				else if (!isdigit(p[i])) num=false;
				if (num&&cd==1) res+="DOUBLE ";
				else {
					string cur="";
					for (int i=0;i<pl;i++)
						if (isalpha(p[i])||isdigit(p[i]))
							cur+=p[i];
						else res+=identify(cur),cur="";
					res+=identify(cur);
				}
			}
		}
		if (!p) break;
	}
	return res;
}