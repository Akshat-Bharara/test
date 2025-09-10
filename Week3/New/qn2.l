%{
#include <bits/stdc++.h>
using namespace std;

struct Entry {
    string name;
    string kind;       // "array" or "function"
    string dtype;      // array element type (int/float/...)
    int dimension;     // for arrays (numeric size), -1 otherwise
    string return_type; // for functions
    int param_count;   // for functions
};

vector<Entry> table;

/* helpers to add unique entries */
void add_array(const string &name, const string &type, int dim) {
    for (auto &e: table) if (e.name == name) return;
    table.push_back({name,"array",type,dim,"",0});
}
void add_function(const string &name, const string &ret_type, int params) {
    for (auto &e: table) if (e.name == name) return;
    table.push_back({name,"function","",-1,ret_type,params});
}

/* trim utility */
static inline string trim(const string &s) {
    size_t a = 0, b = s.size();
    while (a < b && isspace((unsigned char)s[a])) ++a;
    while (b > a && isspace((unsigned char)s[b-1])) --b;
    return s.substr(a, b-a);
}
%}
%%

(int|float|char|double)[ \t]+[a-zA-Z_][a-zA-Z0-9_]*[ \t]*\[[ \t]*[0-9]+[ \t]*\] {
    string s = yytext; /* e.g. "int arr[10]" */
    size_t sp = s.find_first_of(" \t");
    string type = trim(s.substr(0, sp));
    string rest = trim(s.substr(sp+1));
    size_t br = rest.find('[');
    string name = trim(rest.substr(0, br));
    size_t br2 = rest.find(']', br);
    string num = trim(rest.substr(br+1, br2 - br - 1));
    int dim = atoi(num.c_str());
    add_array(name, type, dim);
}

(int|float|char|double|void)[ \t]+[a-zA-Z_][a-zA-Z0-9_]*[ \t]*\([^\)]*\) {
    string s = yytext; 
    size_t sp = s.find_first_of(" \t");
    string ret = trim(s.substr(0, sp));
    string rest = trim(s.substr(sp+1));
    size_t par = rest.find('(');
    string name = trim(rest.substr(0, par));
    size_t par2 = rest.find(')', par);
    string params = trim(rest.substr(par+1, par2 - par - 1));
    int param_count = 0;
    if (params.empty() || params == "void") {
        param_count = 0;
    } else {
        param_count = 1;
        for (char c : params) {
            if (c == ',') ++param_count;
        }
    }
    add_function(name, ret, param_count);
}

[ \t\r\n]+    ;
.             ;
%%


int yywrap(){ return 1; }

int main(int argc, char **argv) {
    yylex();
    cout << "\nSymbol Table (arrays & functions):\n";
    cout << "Name\tKind\tType\tDimension\tReturnType\tParamCount\n";
    for (auto &e: table) {
        cout << e.name << '\t' << e.kind << '\t'
             << (e.kind=="array" ? e.dtype : "-") << '\t';
        if (e.kind == "array") cout << e.dimension << '\t' << "-\t" << 0 << '\n';
        else cout << "-\t" << e.return_type << '\t' << e.param_count << '\n';
    }
    return 0;
}
